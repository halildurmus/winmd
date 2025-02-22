import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart' hide TokenType;

import 'assembly_ref.dart';
import 'class_layout.dart';
import 'constants.dart';
import 'event.dart';
import 'field.dart';
import 'interface_impl.dart';
import 'metadata_store.dart';
import 'method.dart';
import 'mixins/mixins.dart';
import 'models/models.dart';
import 'property.dart';
import 'scope.dart';
import 'token_object.dart';
import 'type_aliases.dart';
import 'type_identifier.dart';

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

  /// Instantiate a typedef from a TypeRef token.
  ///
  /// Unless the TypeRef token is `IInspectable`, the COM parent interface for
  /// Windows Runtime classes, the TypeRef is used to obtain the host scope
  /// metadata file, from which the TypeDef can be found and returned.
  factory TypeDef.fromTypeRefToken(Scope scope, int typeRefToken) {
    assert(
      TokenType.fromToken(typeRefToken) == TokenType.typeRef,
      'Token $typeRefToken is not a typeRef token',
    );

    return using((arena) {
      final ptkResolutionScope = arena<mdToken>();
      final szName = arena<WCHAR>(stringBufferSize).cast<Utf16>();
      final pchName = arena<ULONG>();

      final reader = scope.reader;
      final hr = reader.getTypeRefProps(
        typeRefToken,
        ptkResolutionScope,
        szName,
        stringBufferSize,
        pchName,
      );
      if (FAILED(hr)) throw WindowsException(hr);

      final typeName = szName.toDartString();
      final resolutionScopeToken = ptkResolutionScope.value;

      // Special case for WinRT base type
      if (resolutionScopeToken == 0x00 && typeRefToken == 0x01000000) {
        return TypeDef(scope, 0, 'IInspectable');
      }

      // If it's the same scope, just look it up based on the returned name.
      if (resolutionScopeToken == scope.moduleToken) {
        return scope.findTypeDef(typeName) ?? TypeDef(scope, 0, typeName);
      }

      // Is it a nested type? If so, we find a type in the parent type that
      // matches its name, if one exists (which it presumably should).
      if (TokenType.fromToken(resolutionScopeToken) == TokenType.typeRef) {
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
      if (TokenType.fromToken(resolutionScopeToken) == TokenType.assemblyRef) {
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
              "Can't find type `$typeName` in the `${newScope.name}` scope.",
            );
          }

          return typeDef;
        }
      }

      // It might be a ModuleRef, so we'll just return the type name.
      return TypeDef(scope, 0, typeName);
    });
  }

  /// Creates a typedef object from a provided token.
  factory TypeDef.fromToken(
    Scope scope,
    int token,
  ) => switch (TokenType.fromToken(token)) {
    TokenType.typeRef => TypeDef.fromTypeRefToken(scope, token),
    TokenType.typeDef => TypeDef.fromTypeDefToken(scope, token),
    TokenType.typeSpec => TypeDef.fromTypeSpecToken(scope, token),
    _ => throw WinmdException('Unrecognized token ${token.toHexString(32)}'),
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

      final reader = scope.reader;
      final hr = reader.getTypeDefProps(
        typeDefToken,
        szTypeDef,
        stringBufferSize,
        pchTypeDef,
        pdwTypeDefFlags,
        ptkExtends,
      );
      if (FAILED(hr)) throw WindowsException(hr);
      return TypeDef(
        scope,
        typeDefToken,
        szTypeDef.toDartString(),
        pdwTypeDefFlags.value,
        ptkExtends.value,
      );
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

      final reader = scope.reader;
      final hr = reader.getTypeSpecFromToken(typeSpecToken, ppvSig, pcbSig);
      if (FAILED(hr)) throw WindowsException(hr);

      final signature = ppvSig.value.asTypedList(pcbSig.value);
      final typeTuple = TypeTuple.fromSignature(signature, scope);
      return TypeDef(scope, typeSpecToken, '', 0, 0, typeTuple.typeIdentifier);
    });
  }

  final int baseTypeToken;
  final String name;
  final TypeIdentifier? typeSpec;

  final int _attributes;

  late final List<Event> events = _getEvents();
  late final List<Field> fields = _getFields();
  late final List<TypeDef> interfaces = _getInterfaces();
  late final List<Method> methods = _getMethods();
  late final List<Property> properties = _getProperties();

  /// The token for the class within which this typedef is nested, if there is
  /// one.
  ///
  /// Returns `null` if there is no nested parent.
  late final _enclosingClassToken =
      isNested
          ? using((arena) {
            final ptdEnclosingClass = arena<mdTypeDef>();
            final hr = reader.getNestedClassProps(token, ptdEnclosingClass);
            if (FAILED(hr)) throw WindowsException(hr);
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
      final hr = scope.reader.getTypeRefProps(
        typeRefToken,
        ptkResolutionScope,
        szName,
        stringBufferSize,
        pchName,
      );
      if (FAILED(hr)) throw WindowsException(hr);
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
      final hr = scope.reader.findTypeDefByName(
        szTypeDef,
        resolutionScopeToken,
        ptd,
      );
      if (FAILED(hr)) {
        if (hr == CLDB_E_RECORD_NOTFOUND) {
          return _resolveNestedTypeThroughIteration(
            scope,
            resolutionScopeToken,
            typeRefToken,
            typeName,
          );
        }

        throw WindowsException(hr);
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

  /// Returns true if the metadata for the object is represented as a class
  /// type.
  ///
  /// Note that structs, enums and delegates are also represented as classes in
  /// metadata. Use the [isClass], [isStruct] or [isDelegate] property to
  /// validate the kind of class.
  bool get representsAsClass => _attributes & tdClassSemanticsMask == tdClass;

  /// Returns trus if the type is an interface.
  bool get isInterface => _attributes & tdClassSemanticsMask == tdInterface;

  /// Returns true if this type may not be directly instantiated.
  bool get isAbstract => _attributes & tdAbstract == tdAbstract;

  /// Returns true if this type may not have derived types.
  bool get isSealed => _attributes & tdSealed == tdSealed;

  /// Returns true if the name of the item may have special significance to
  /// tools other than the CLI.
  bool get isSpecialName => _attributes & tdSpecialName == tdSpecialName;

  /// Returns true if the type is imported.
  bool get isImported => _attributes & tdImport == tdImport;

  /// Returns true if the fields of the type are to be serialized into a data
  /// stream.
  bool get isSerializable => _attributes & tdSerializable == tdSerializable;

  /// Returns true if the type is a Windows Runtime type.
  bool get isWindowsRuntime =>
      _attributes & tdWindowsRuntime == tdWindowsRuntime;

  /// Returns true if the name of the item has special significance to the CLI.
  bool get isRTSpecialName => _attributes & tdRTSpecialName == tdRTSpecialName;

  StringFormat get stringFormat => switch (_attributes & tdStringFormatMask) {
    tdAnsiClass => StringFormat.ansi,
    tdUnicodeClass => StringFormat.unicode,
    tdAutoClass => StringFormat.auto,
    tdCustomFormatClass => StringFormat.custom,
    _ =>
      throw const WinmdException('Attribute missing string format information'),
  };

  /// Returns true if the CLI need not initialize the type before a static
  /// method is called.
  bool get isBeforeFieldInit =>
      _attributes & tdBeforeFieldInit == tdBeforeFieldInit;

  /// Returns true if the type is exported, and a type forwarder.
  bool get isForwarder => _attributes & tdForwarder == tdForwarder;

  /// Returns true if the type is a delegate.
  bool get isDelegate =>
      representsAsClass && parent?.name == 'System.MulticastDelegate';

  /// Returns true if the type is a class.
  bool get isClass => representsAsClass && !isDelegate && !isStruct && !isEnum;

  /// Returns true if the type is an enumeration.
  bool get isEnum => representsAsClass && parent?.name == 'System.Enum';

  /// Returns true if the type is a struct.
  bool get isStruct =>
      representsAsClass &&
      fields.isNotEmpty &&
      parent?.name == 'System.ValueType';

  /// Returns true if the type is a union.
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

  /// Enumerate all events contained within this type.
  List<Event> _getEvents() {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return [];
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    final events = <Event>[];
    using((arena) {
      final phEnum = arena<HCORENUM>();
      final rgEvents = arena<mdEvent>();
      final pcEvents = arena<ULONG>();

      var hr = reader.enumEvents(phEnum, token, rgEvents, 1, pcEvents);
      while (hr == S_OK) {
        final eventToken = rgEvents.value;
        final event = Event.fromToken(scope, eventToken);
        events.add(event);
        hr = reader.enumEvents(phEnum, token, rgEvents, 1, pcEvents);
      }
      reader.closeEnum(phEnum.value);
    });

    return events;
  }

  /// Enumerate all fields contained within this type.
  List<Field> _getFields() {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return [];
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    final fields = <Field>[];
    using((arena) {
      final phEnum = arena<HCORENUM>();
      final rgFields = arena<mdFieldDef>();
      final pcTokens = arena<ULONG>();

      var hr = reader.enumFields(phEnum, token, rgFields, 1, pcTokens);
      while (hr == S_OK) {
        final fieldToken = rgFields.value;
        final field = Field.fromToken(scope, fieldToken);
        fields.add(field);
        hr = reader.enumFields(phEnum, token, rgFields, 1, pcTokens);
      }
      reader.closeEnum(phEnum.value);
    });

    return fields;
  }

  /// Enumerate all interfaces that this type implements.
  List<TypeDef> _getInterfaces() {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return [];
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    final interfaces = <TypeDef>[];
    using((arena) {
      final phEnum = arena<HCORENUM>();
      final rImpls = arena<mdInterfaceImpl>();
      final pcImpls = arena<ULONG>();

      // The enumeration returns a collection of mdInterfaceImpl tokens for each
      // interface implemented by the specified TypeDef.
      var hr = reader.enumInterfaceImpls(phEnum, token, rImpls, 1, pcImpls);
      while (hr == S_OK) {
        final interfaceImplToken = rImpls.value;
        final interfaceImpl = InterfaceImpl(scope, interfaceImplToken);
        interfaces.add(interfaceImpl.interface);
        hr = reader.enumInterfaceImpls(phEnum, token, rImpls, 1, pcImpls);
      }
      reader.closeEnum(phEnum.value);
    });

    return interfaces;
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
      var hr = reader.enumInterfaceImpls(phEnum, token, rImpls, 1, pcImpls);
      while (hr == S_OK) {
        final interfaceImplToken = rImpls.value;
        final interfaceImpl = InterfaceImpl(scope, interfaceImplToken);
        if (interfaceImpl.isDefault) return interfaceImpl.interface;
        hr = reader.enumInterfaceImpls(phEnum, token, rImpls, 1, pcImpls);
      }
      reader.closeEnum(phEnum.value);
      return null;
    });
  }

  /// Enumerate all methods contained within this type.
  List<Method> _getMethods() {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return [];
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    final methods = <Method>[];

    using((arena) {
      final phEnum = arena<HCORENUM>();
      final rgMethods = arena<mdMethodDef>();
      final pcTokens = arena<ULONG>();

      var hr = reader.enumMethods(phEnum, token, rgMethods, 1, pcTokens);
      while (hr == S_OK) {
        final methodToken = rgMethods.value;

        try {
          final method = Method.fromToken(scope, methodToken);
          methods.add(method);
        } on WindowsException catch (e) {
          if (e.hr.toUnsigned(32) == RO_E_METADATA_NAME_NOT_FOUND) {
            // If the method cannot be parsed due to missing references, rather
            // than abruptly exiting, proceed to the next one
            print(
              'Could not parse the method with token $methodToken from $name:\n'
              '$e',
            );
          } else {
            rethrow;
          }
        }

        hr = reader.enumMethods(phEnum, token, rgMethods, 1, pcTokens);
      }
      reader.closeEnum(phEnum.value);
    });

    return methods;
  }

  /// Enumerate all properties contained within this type.
  List<Property> _getProperties() {
    if (TokenType.fromToken(token) == TokenType.typeSpec) return [];
    assert(
      TokenType.fromToken(token) == TokenType.typeDef,
      'Token $token is not a typeDef token',
    );

    final properties = <Property>[];
    using((arena) {
      final phEnum = arena<HCORENUM>();
      final rgProperties = arena<mdProperty>();
      final pcProperties = arena<ULONG>();

      var hr = reader.enumProperties(
        phEnum,
        token,
        rgProperties,
        1,
        pcProperties,
      );
      while (hr == S_OK) {
        final propertyToken = rgProperties.value;
        final property = Property.fromToken(scope, propertyToken);
        properties.add(property);
        hr = reader.enumMethods(phEnum, token, rgProperties, 1, pcProperties);
      }
      reader.closeEnum(phEnum.value);
    });

    return properties;
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

      final hr = reader.findField(token, szName, nullptr, 0, ptkFieldDef);
      if (FAILED(hr)) {
        if (hr == CLDB_E_RECORD_NOTFOUND) return null;

        throw COMException(hr);
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

      final hr = reader.findMethod(token, szName, nullptr, 0, pmb);
      if (FAILED(hr)) {
        if (hr == CLDB_E_RECORD_NOTFOUND) return null;

        throw COMException(hr);
      }

      return Method.fromToken(scope, pmb.value);
    });
  }

  /// Gets the type referencing this type's superclass (the class this type
  /// inherits from).
  ///
  /// For nested types, the [enclosingClass] property may be of interest, which
  /// is the type in which the current type is embedded.
  TypeDef? get parent =>
      (token == 0 || baseTypeToken == 0)
          ? null
          : TypeDef.fromToken(scope, baseTypeToken);

  /// Returns true if the type is nested in an enclosing class (e.g. a struct
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

  /// Gets a named custom attribute that is stored as a GUID.
  String? _getCustomGuidAttribute(String guidAttributeName) => using((arena) {
    final ptrAttributeName = guidAttributeName.toNativeUtf16(allocator: arena);
    final ppData = arena<Pointer<BYTE>>();
    final pcbData = arena<ULONG>();

    final hr = reader.getCustomAttributeByName(
      token,
      ptrAttributeName,
      ppData,
      pcbData,
    );
    if (SUCCEEDED(hr)) {
      final blob = ppData.value;
      if (pcbData.value > 0) {
        final returnValue = (blob + 2).cast<GUID>();
        return returnValue.ref.toString();
      }
    }

    // If this fails or no data is returned, return a null value.
    return null;
  });

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
}
