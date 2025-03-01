import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'assembly_ref.dart';
import 'class_layout.dart';
import 'event.dart';
import 'field.dart';
import 'interface_impl.dart';
import 'logger.dart';
import 'metadata_store.dart';
import 'method.dart';
import 'mixins/mixins.dart';
import 'models/models.dart';
import 'property.dart';
import 'scope.dart';
import 'token_object.dart';
import 'type_aliases.dart';
import 'type_identifier.dart';
import 'win32/win32.dart';

/// Represents a TypeDef in the Windows Metadata file
class TypeDef extends TokenObject
    with
        CustomAttributesMixin,
        GenericParamsMixin,
        SupportedArchitecturesMixin {
  /// Create a typedef.
  ///
  /// Typically, typedefs should be obtained from a [Scope] object rather
  /// than being created directly.
  TypeDef(
    super.scope, [
    super.token = 0,
    this.name = '',
    this._attributes = 0,
    this.baseTypeToken = 0,
    this.typeSpec,
  ]);

  /// Creates a typedef object from a provided token.
  factory TypeDef.fromToken(
    Scope scope,
    int token,
  ) => switch (TokenType.fromToken(token)) {
    TokenType.typeDef => TypeDef.fromTypeDefToken(scope, token),
    TokenType.typeRef => TypeDef.fromTypeRefToken(scope, token),
    TokenType.typeSpec => TypeDef.fromTypeSpecToken(scope, token),
    _ =>
      throw WinmdException('Unrecognized token 0x${token.toRadixString(16)}'),
  };

  /// Instantiate a typedef from a TypeDef token.
  factory TypeDef.fromTypeDefToken(Scope scope, int typeDefToken) {
    assert(
      TokenType.fromToken(typeDefToken) == TokenType.typeDef,
      'Token $typeDefToken is not a typeDef token',
    );
    return using((arena) {
      final szTypeDef = arena<WCHAR>(stringBufferSize).cast<Utf16>();
      final pchTypeDef = arena<ULONG>();
      final pdwTypeDefFlags = arena<DWORD>();
      final ptkExtends = arena<mdToken>();
      scope.reader.getTypeDefProps(
        typeDefToken,
        szTypeDef,
        stringBufferSize,
        pchTypeDef,
        pdwTypeDefFlags,
        ptkExtends,
      );
      return TypeDef(
        scope,
        typeDefToken,
        szTypeDef.toDartString(),
        pdwTypeDefFlags.value,
        ptkExtends.value,
      );
    });
  }

  /// Instantiate a typedef from a [typeRefToken].
  factory TypeDef.fromTypeRefToken(Scope scope, int typeRefToken) {
    assert(
      TokenType.fromToken(typeRefToken) == TokenType.typeRef,
      'Token $typeRefToken is not a typeRef token',
    );
    return using((arena) {
      final ptkResolutionScope = arena<mdToken>();
      final szName = arena<WCHAR>(stringBufferSize).cast<Utf16>();
      final pchName = arena<ULONG>();
      scope.reader.getTypeRefProps(
        typeRefToken,
        ptkResolutionScope,
        szName,
        stringBufferSize,
        pchName,
      );
      final typeName = szName.toDartString();
      final resolutionScopeToken = ptkResolutionScope.value;

      // Special case for WinRT base type.
      if (resolutionScopeToken == 0 && typeRefToken == 0x1_000_000) {
        return TypeDef(scope, 0, 'IInspectable');
      }

      // If it's the same scope, just look it up based on the returned name.
      if (resolutionScopeToken == scope.moduleToken) {
        return scope.findTypeDef(typeName) ?? TypeDef(scope, 0, typeName);
      }

      final tokenType = TokenType.fromToken(resolutionScopeToken);

      // Is it a nested type? If so, we find a type in the parent type that
      // matches its name, if one exists (which it presumably should).
      if (tokenType == TokenType.typeRef) {
        return _resolveNestedType(
          scope,
          resolutionScopeToken,
          typeRefToken,
          typeName,
        );
      }

      // Is it an AssemblyRef that is not part of .NET? If so, we need to load
      // the scope that contains it. Note that we are currently ignoring .NET
      // types, since they are intrinsics like System.ValueType. They're also
      // not loadable with `MetadataStore.findScope`, but that's moot.
      if (tokenType == TokenType.assemblyRef) {
        final AssemblyRef(:name) = AssemblyRef.fromToken(
          scope,
          resolutionScopeToken,
        );
        if (name != 'netstandard' && /* .NET */
            name != 'mscorlib' /* .NET Framework */ ) {
          final newScope = MetadataStore.findScope(typeName);
          final typeDef = newScope.findTypeDef(typeName);
          if (typeDef == null) {
            throw WinmdException(
              'Can\'t find type "$typeName" in the "${newScope.name}" scope.',
            );
          }

          return typeDef;
        }
      }

      // It might be a ModuleRef, so we'll just return the type name.
      return TypeDef(scope, 0, typeName);
    });
  }

  /// Instantiate a typedef from a TypeSpec token.
  factory TypeDef.fromTypeSpecToken(Scope scope, int typeSpecToken) {
    assert(
      TokenType.fromToken(typeSpecToken) == TokenType.typeSpec,
      'Token $typeSpecToken is not a typeSpec token',
    );
    return using((arena) {
      final ppvSig = arena<PCCOR_SIGNATURE>();
      final pcbSig = arena<ULONG>();
      scope.reader.getTypeSpecFromToken(typeSpecToken, ppvSig, pcbSig);
      final signature = ppvSig.value.asTypedList(pcbSig.value);
      final typeTuple = TypeTuple.fromSignature(signature, scope);
      return TypeDef(scope, typeSpecToken, '', 0, 0, typeTuple.typeIdentifier);
    });
  }

  final int baseTypeToken;
  final String name;
  final TypeIdentifier? typeSpec;
  final int _attributes;

  /// Enumerate all events contained within this type.
  late final events = _getEvents();

  /// Enumerate all fields contained within this type.
  late final fields = _getFields();

  /// Enumerate all interfaces that this type implements.
  late final interfaces = _getInterfaces();

  /// Enumerate all methods contained within this type.
  late final methods = _getMethods();

  /// Enumerate all properties contained within this type.
  late final properties = _getProperties();

  /// The token for the class within which this typedef is nested, if there is
  /// one.
  ///
  /// Returns `null` if there is no nested parent.
  late final _enclosingClassToken =
      isNested
          ? using((arena) {
            final ptdEnclosingClass = arena<mdTypeDef>();
            reader.getNestedClassProps(token, ptdEnclosingClass);
            return ptdEnclosingClass.value;
          })
          : null;

  static String _resolveTypeNameForTypeRef(Scope scope, int typeRefToken) {
    assert(
      TokenType.fromToken(typeRefToken) == TokenType.typeRef,
      'Token $typeRefToken is not a typeRef token',
    );

    return using((arena) {
      final ptkResolutionScope = arena<mdToken>();
      final szName = arena<WCHAR>(stringBufferSize).cast<Utf16>();
      final pchName = arena<ULONG>();
      scope.reader.getTypeRefProps(
        typeRefToken,
        ptkResolutionScope,
        szName,
        stringBufferSize,
        pchName,
      );
      return szName.toDartString();
    });
  }

  /// Resolves a nested type by iterating through all type definitions to find
  /// a match.
  ///
  /// This is used when a nested type belongs to a parent type with multiple
  /// versions across different platform architectures, and its resolution scope
  /// does not directly contain the type. It is common in Win32 for nested types
  /// to be part of such parent types.
  ///
  /// Throws a [WinmdException] if the matching nested type cannot be found.
  static TypeDef _resolveNestedTypeThroughIteration(
    Scope scope,
    int resolutionScopeToken,
    int typeRefToken,
    String typeName,
  ) {
    assert(
      TokenType.fromToken(typeRefToken) == TokenType.typeRef,
      'Token $typeRefToken is not a typeRef token',
    );
    return using((arena) {
      // Resolve the parent type's name.
      final parentTypeName = _resolveTypeNameForTypeRef(
        scope,
        resolutionScopeToken,
      );

      // Find the nested type that matches the given name and is enclosed in
      // the parent's token.
      final matchingType =
          scope.typeDefs
              .where(
                (t) =>
                    t.name == parentTypeName &&
                    scope.typeDefs.any(
                      (e) =>
                          e.name == typeName &&
                          e._enclosingClassToken == t.token,
                    ),
              )
              .firstOrNull;

      // Return the matching type if found.
      if (matchingType != null) return matchingType;

      // Throw an exception if no matching type is found.
      throw WinmdException('Cannot find matching typeDef for "$typeName"');
    });
  }

  /// Attempt to find a nested type using FindTypeDefByName.
  ///
  /// If this doesn't work, we then have to try a more labor-intensive approach.
  static TypeDef _resolveNestedType(
    Scope scope,
    int resolutionScopeToken,
    int typeRefToken,
    String typeName,
  ) {
    assert(
      TokenType.fromToken(typeRefToken) == TokenType.typeRef,
      'Token $typeRefToken is not a typeRef token',
    );

    return using((arena) {
      final szTypeDef = typeName.toNativeUtf16(allocator: arena);
      final ptd = arena<mdTypeDef>();
      try {
        scope.reader.findTypeDefByName(szTypeDef, resolutionScopeToken, ptd);
      } on WindowsException catch (e) {
        if (e.hr == CLDB_E_RECORD_NOTFOUND) {
          return _resolveNestedTypeThroughIteration(
            scope,
            resolutionScopeToken,
            typeRefToken,
            typeName,
          );
        }

        rethrow;
      }
      return TypeDef.fromToken(scope, ptd.value);
    });
  }

  TypeVisibility get typeVisibility =>
      TypeVisibility.values[_attributes & tdVisibilityMask];

  TypeLayout get typeLayout => switch (_attributes & tdLayoutMask) {
    tdAutoLayout => TypeLayout.auto,
    tdSequentialLayout => TypeLayout.sequential,
    tdExplicitLayout => TypeLayout.explicit,
    _ =>
      throw const WinmdException('Attribute missing type layout information'),
  };

  /// Whether the metadata for the object is represented as a class
  /// type.
  ///
  /// Note that structs, enums and delegates are also represented as classes in
  /// metadata. Use the [isClass], [isDelegate] or [isStruct] property to
  /// validate the kind of class.
  bool get representsAsClass => _attributes & tdClassSemanticsMask == tdClass;

  /// Returns trus if the type is an interface.
  bool get isInterface => _attributes & tdClassSemanticsMask == tdInterface;

  /// Whether this type may not be directly instantiated.
  bool get isAbstract => _attributes & tdAbstract == tdAbstract;

  /// Whether this type may not have derived types.
  bool get isSealed => _attributes & tdSealed == tdSealed;

  /// Whether the name of the item may have special significance to
  /// tools other than the CLI.
  bool get isSpecialName => _attributes & tdSpecialName == tdSpecialName;

  /// Whether the type is imported.
  bool get isImported => _attributes & tdImport == tdImport;

  /// Whether the fields of the type are to be serialized into a data
  /// stream.
  bool get isSerializable => _attributes & tdSerializable == tdSerializable;

  /// Whether the type is a Windows Runtime type.
  bool get isWindowsRuntime =>
      _attributes & tdWindowsRuntime == tdWindowsRuntime;

  /// Whether the name of the item has special significance to the CLI.
  bool get isRTSpecialName => _attributes & tdRTSpecialName == tdRTSpecialName;

  StringFormat get stringFormat => switch (_attributes & tdStringFormatMask) {
    tdAnsiClass => StringFormat.ansi,
    tdUnicodeClass => StringFormat.unicode,
    tdAutoClass => StringFormat.auto,
    tdCustomFormatClass => StringFormat.custom,
    _ =>
      throw const WinmdException('Attribute missing string format information'),
  };

  /// Whether the CLI need not initialize the type before a static method is
  /// called.
  bool get isBeforeFieldInit =>
      _attributes & tdBeforeFieldInit == tdBeforeFieldInit;

  /// Whether the type is exported, and a type forwarder.
  bool get isForwarder => _attributes & tdForwarder == tdForwarder;

  /// Whether the type is an attribute.
  bool get isAttribute =>
      representsAsClass && parent?.name == 'System.Attribute';

  /// Whether the type is a class.
  bool get isClass =>
      representsAsClass && !isAttribute && !isDelegate && !isEnum && !isStruct;

  /// Whether the type is a delegate.
  bool get isDelegate =>
      representsAsClass && parent?.name == 'System.MulticastDelegate';

  /// Whether the type is an enumeration.
  bool get isEnum => representsAsClass && parent?.name == 'System.Enum';

  /// Whether the type is a struct.
  bool get isStruct => representsAsClass && parent?.name == 'System.ValueType';

  /// Whether the type is a union.
  ///
  /// A union is a struct where every field begins at the zeroth offset; it is
  /// sized to the largest field. An example is the Win32 `INPUT` union, which
  /// can contain a keyboard, mouse or other hardware input type.
  bool get isUnion =>
      isStruct &&
      classLayout.fieldOffsets.length > 1 &&
      classLayout.fieldOffsets.every((fo) => fo.offset == 0);

  /// Retrieve class layout information.
  ///
  /// This includes the packing alignment, the minimum class size, and the field
  /// layout (e.g. for sparsely or overlapping structs).
  ClassLayout get classLayout => ClassLayout(scope, token);

  List<Event> _getEvents() {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return [];
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    final events = <Event>[];
    return using((arena) {
      final phEnum = arena<HCORENUM>();
      final rgEvents = arena<mdEvent>();
      final pcEvents = arena<ULONG>();
      while (true) {
        try {
          reader.enumEvents(phEnum, token, rgEvents, 1, pcEvents);
          if (pcEvents.value == 0) break;
          final eventToken = rgEvents.value;
          final event = Event.fromToken(scope, eventToken);
          events.add(event);
        } on WindowsException {
          break;
        }
      }
      reader.closeEnum(phEnum.value);
      return events;
    });
  }

  List<Field> _getFields() {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return [];
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    final fields = <Field>[];
    return using((arena) {
      final phEnum = arena<HCORENUM>();
      final rgFields = arena<mdFieldDef>();
      final pcTokens = arena<ULONG>();
      while (true) {
        try {
          reader.enumFields(phEnum, token, rgFields, 1, pcTokens);
          if (pcTokens.value == 0) break;
          final fieldToken = rgFields.value;
          final field = Field.fromToken(scope, fieldToken);
          fields.add(field);
        } on WindowsException {
          break;
        }
      }
      reader.closeEnum(phEnum.value);
      return fields;
    });
  }

  List<TypeDef> _getInterfaces() {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return [];
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    final interfaces = <TypeDef>[];
    return using((arena) {
      final phEnum = arena<HCORENUM>();
      final rImpls = arena<mdInterfaceImpl>();
      final pcImpls = arena<ULONG>();
      // The enumeration returns a collection of mdInterfaceImpl tokens for each
      // interface implemented by the specified TypeDef.
      while (true) {
        try {
          reader.enumInterfaceImpls(phEnum, token, rImpls, 1, pcImpls);
          if (pcImpls.value == 0) break;
          final interfaceImplToken = rImpls.value;
          final interfaceImpl = InterfaceImpl(scope, interfaceImplToken);
          interfaces.add(interfaceImpl.interface);
        } on WindowsException {
          break;
        }
      }
      reader.closeEnum(phEnum.value);
      return interfaces;
    });
  }

  /// Find the default interface for this type if it is a runtime class.
  TypeDef? get defaultInterface {
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );
    if (!isWindowsRuntime || !isClass) return null;

    return using((arena) {
      final phEnum = arena<HCORENUM>();
      final rImpls = arena<mdInterfaceImpl>();
      final pcImpls = arena<ULONG>();
      // The enumeration returns a collection of mdInterfaceImpl tokens for each
      // interface implemented by the specified TypeDef.
      while (true) {
        try {
          reader.enumInterfaceImpls(phEnum, token, rImpls, 1, pcImpls);
          if (pcImpls.value == 0) break;
          final interfaceImplToken = rImpls.value;
          final interfaceImpl = InterfaceImpl(scope, interfaceImplToken);
          if (interfaceImpl.isDefault) return interfaceImpl.interface;
        } on WindowsException {
          break;
        }
      }
      reader.closeEnum(phEnum.value);
      return null;
    });
  }

  List<Method> _getMethods() {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return [];
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    final methods = <Method>[];
    return using((arena) {
      final phEnum = arena<HCORENUM>();
      final rgMethods = arena<mdMethodDef>();
      final pcTokens = arena<ULONG>();
      while (true) {
        try {
          reader.enumMethods(phEnum, token, rgMethods, 1, pcTokens);
          if (pcTokens.value == 0) break;
          final methodToken = rgMethods.value;
          try {
            final method = Method.fromToken(scope, methodToken);
            methods.add(method);
          } on WindowsException catch (e) {
            if (e.hr == RO_E_METADATA_NAME_NOT_FOUND) {
              // If the method cannot be parsed due to missing references,
              // rather than abruptly exiting, proceed to the next one.
              winmdLogger.severe(
                'Could not parse the method with token '
                '0x${methodToken.toRadixString(16)} from $name:\n$e',
              );
            } else {
              rethrow;
            }
          }
        } on WindowsException {
          break;
        }
      }
      reader.closeEnum(phEnum.value);
      return methods;
    });
  }

  List<Property> _getProperties() {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return [];
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    final properties = <Property>[];
    return using((arena) {
      final phEnum = arena<HCORENUM>();
      final rgProperties = arena<mdProperty>();
      final pcProperties = arena<ULONG>();
      while (true) {
        try {
          reader.enumProperties(phEnum, token, rgProperties, 1, pcProperties);
          if (pcProperties.value == 0) break;
          final propertyToken = rgProperties.value;
          final property = Property.fromToken(scope, propertyToken);
          properties.add(property);
        } on WindowsException {
          break;
        }
      }
      reader.closeEnum(phEnum.value);
      return properties;
    });
  }

  /// Get a field matching the name, if one exists.
  ///
  /// Returns null if the field is not found.
  Field? findField(String fieldName) {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return null;
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    return using((arena) {
      final szName = fieldName.toNativeUtf16(allocator: arena);
      final ptkFieldDef = arena<mdFieldDef>();
      try {
        reader.findField(token, szName, nullptr, 0, ptkFieldDef);
      } on WindowsException catch (e) {
        if (e.hr == CLDB_E_RECORD_NOTFOUND) return null;
        rethrow;
      }
      return Field.fromToken(scope, ptkFieldDef.value);
    });
  }

  /// Get a method matching the name, if one exists.
  ///
  /// Returns null if the method is not found.
  Method? findMethod(String methodName) {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return null;
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    return using((arena) {
      final szName = methodName.toNativeUtf16(allocator: arena);
      final pmb = arena<mdMethodDef>();
      try {
        reader.findMethod(token, szName, nullptr, 0, pmb);
      } on WindowsException catch (e) {
        if (e.hr == CLDB_E_RECORD_NOTFOUND) return null;
        rethrow;
      }
      return Method.fromToken(scope, pmb.value);
    });
  }

  TypeDef? _parent;

  /// Gets the type referencing this type's superclass (the class this type
  /// inherits from).
  ///
  /// For nested types, the [enclosingClass] property may be of interest, which
  /// is the type in which the current type is embedded.
  TypeDef? get parent => _parent ??= _getParent();

  TypeDef? _getParent() {
    if (token == 0 || baseTypeToken == 0) return null;

    final tokenType = TokenType.fromToken(baseTypeToken);

    // Special case: COM/WinRT interfaces.
    if (tokenType == TokenType.typeRef && baseTypeToken == 0x1_000_000) {
      if (name.endsWith('IInspectable') || name.endsWith('IUnknown')) {
        return null;
      }

      return TypeDef(scope, 0, isWindowsRuntime ? 'IInspectable' : 'IUnknown');
    }

    return TypeDef.fromToken(scope, baseTypeToken);
  }

  /// Whether the type is nested in an enclosing class (e.g. a struct
  /// within a struct).
  bool get isNested =>
      typeVisibility == TypeVisibility.nestedPublic ||
      typeVisibility == TypeVisibility.nestedPrivate ||
      typeVisibility == TypeVisibility.nestedAssembly ||
      typeVisibility == TypeVisibility.nestedFamily ||
      typeVisibility == TypeVisibility.nestedFamilyAndAssembly ||
      typeVisibility == TypeVisibility.nestedFamilyOrAssembly;

  /// Returns the type that encloses the current type (if the type is nested).
  ///
  /// If the type is not nested, returns null. Use the [isNested] property to
  /// determine whether the type is nested. Alternatively, use the
  /// [typeVisibility] property to determine the visibility of the type,
  /// including whether it is nested.
  late final enclosingClass =
      _enclosingClassToken != null
          ? TypeDef.fromToken(scope, _enclosingClassToken)
          : null;

  /// Get the GUID for this type.
  ///
  /// Returns null if a GUID couldn't be found.
  String? get guid =>
      _getCustomGuidAttribute('Windows.Foundation.Metadata.GuidAttribute') ??
      _getCustomGuidAttribute(
        'Windows.Win32.Foundation.Metadata.GuidAttribute',
      );

  @override
  String toString() => name;

  /// Gets a named custom attribute that is stored as a GUID.
  String? _getCustomGuidAttribute(String guidAttributeName) => using((arena) {
    final ptrAttributeName = guidAttributeName.toNativeUtf16(allocator: arena);
    final ppData = arena<Pointer<BYTE>>();
    final pcbData = arena<ULONG>();

    try {
      reader.getCustomAttributeByName(token, ptrAttributeName, ppData, pcbData);
      final blob = ppData.value;
      if (pcbData.value > 0) {
        final returnValue = (blob + 2).cast<GUID>();
        return returnValue.ref.toString();
      }
    } on WindowsException {
      return null;
    }

    // If this fails or no data is returned, return a null value.
    return null;
  });
}
