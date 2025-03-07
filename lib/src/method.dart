import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'mixins/mixins.dart';
import 'models/models.dart';
import 'module_ref.dart';
import 'parameter.dart';
import 'pinvokemap.dart';
import 'scope.dart';
import 'token_object.dart';
import 'type_aliases.dart';
import 'type_def.dart';
import 'type_identifier.dart';
import 'win32/win32.dart';

/// A method.
class Method extends TokenObject
    with
        CustomAttributesMixin,
        GenericParamsMixin,
        SupportedArchitecturesMixin {
  Method(
    super.scope,
    super.token,
    this._parentToken,
    this.name,
    this._attributes,
    this.signatureBlob,
    this.relativeVirtualAddress,
    this.implFlags,
  ) {
    _parseParameterNames();
    _parseSignatureBlob();
  }

  /// Creates a method object from a provided token.
  factory Method.fromToken(Scope scope, int token) {
    assert(
      TokenType.fromToken(token) == TokenType.methodDef,
      'Token $token is not a MethodDef token',
    );

    return using((arena) {
      final ptkClass = arena<mdTypeDef>();
      final szMethod = arena<WCHAR>(stringBufferSize).cast<Utf16>();
      final pchMethod = arena<ULONG>();
      final pdwAttr = arena<DWORD>();
      final ppvSigBlob = arena<PCCOR_SIGNATURE>();
      final pcbSigBlob = arena<ULONG>();
      final pulCodeRVA = arena<ULONG>();
      final pdwImplFlags = arena<DWORD>();

      scope.reader.getMethodProps(
        token,
        ptkClass,
        szMethod,
        stringBufferSize,
        pchMethod,
        pdwAttr,
        ppvSigBlob,
        pcbSigBlob,
        pulCodeRVA,
        pdwImplFlags,
      );

      final signature = ppvSigBlob.value.asTypedList(pcbSigBlob.value);
      return Method(
        scope,
        token,
        ptkClass.value,
        szMethod.toDartString(),
        pdwAttr.value,
        signature,
        pulCodeRVA.value,
        pdwImplFlags.value,
      );
    });
  }

  /// Any implementation flags defined by the method metadata.
  int implFlags;

  /// The name of the method.
  String name;

  /// The parameters defined by the method.
  List<Parameter> parameters = <Parameter>[];

  int relativeVirtualAddress;

  /// The value returned by the method.
  late Parameter returnType;

  /// The raw signature blob as defined in §II.23.2.1 (MethodDefSig) of
  /// ECMA-335.
  Uint8List signatureBlob;

  int _attributes;
  int _parentToken;

  /// The method's parent type.
  TypeDef get parent => scope.findTypeDefByToken(_parentToken)!;

  /// Returns information about the method's visibility / accessibility to other
  /// types.
  MemberAccess get memberAccess =>
      MemberAccess.values[_attributes & mdMemberAccessMask];

  /// Returns true if the member is defined as part of the type rather than as a
  /// member of an instance.
  bool get isStatic => _attributes & mdStatic == mdStatic;

  /// Returns true if the method cannot be overridden.
  bool get isFinal => _attributes & mdFinal == mdFinal;

  /// Returns true if the method can be overridden.
  bool get isVirtual => _attributes & mdVirtual == mdVirtual;

  /// Returns true if the method hides by name and signature, rather than just
  /// by name.
  bool get isHideBySig => _attributes & mdHideBySig == mdHideBySig;

  /// Returns information about the vtable layout of this method.
  ///
  /// If `ReuseSlot`, the slot used for this method in the virtual table be
  /// reused. This is the default. If `NewSlot`, the method always gets a new
  /// slot in the virtual table.
  VtableLayout get vTableLayout => switch (_attributes & mdVtableLayoutMask) {
    mdNewSlot => VtableLayout.newSlot,
    _ => VtableLayout.reuseSlot,
  };

  /// Returns true if the method can be overridden by the same types to which it
  /// is visible.
  bool get isCheckAccessOnOverride =>
      _attributes & mdCheckAccessOnOverride == mdCheckAccessOnOverride;

  /// Returns true if the method is not implemented.
  bool get isAbstract => _attributes & mdAbstract == mdAbstract;

  /// Returns true if the method is special; its name describes how.
  bool get isSpecialName => _attributes & mdSpecialName == mdSpecialName;

  /// Returns true if the method implementation is forwarded using PInvoke.
  bool get isPinvokeImpl => _attributes & mdPinvokeImpl == mdPinvokeImpl;

  /// Returns true if the method is a managed method exported to unmanaged code.
  bool get isUnmanagedExport =>
      _attributes & mdUnmanagedExport == mdUnmanagedExport;

  /// Returns true if the common language runtime should check the encoding of
  /// the method name.
  bool get isRTSpecialName => _attributes & mdSpecialName == mdSpecialName;

  /// Returns the P/Invoke mapping representation for this object.
  PinvokeMap get pinvokeMap => PinvokeMap.fromToken(scope, token);

  /// Implementation features for the method.
  MethodImplementationFeatures get implFeatures =>
      MethodImplementationFeatures(implFlags);

  /// Returns true if the method is a property getter
  bool get isGetProperty => isSpecialName && name.startsWith('get_');

  /// Returns true if the method is a property setter
  bool get isSetProperty => isSpecialName && name.startsWith('put_');

  /// Returns true if the method is a property getter or setter.
  bool get isProperty => isGetProperty | isSetProperty;

  /// Returns the module that contains the method.
  ModuleRef get module => using((arena) {
    final pdwMappingFlags = arena<DWORD>();
    final szImportName = arena<WCHAR>(stringBufferSize).cast<Utf16>();
    final pchImportName = arena<ULONG>();
    final ptkImportDLL = arena<mdModuleRef>();
    reader.getPinvokeMap(
      token,
      pdwMappingFlags,
      szImportName,
      stringBufferSize,
      pchImportName,
      ptkImportDLL,
    );
    return ModuleRef.fromToken(scope, ptkImportDLL.value);
  });

  /// Returns true if the method contains generic parameters.
  bool get hasGenericParameters => signatureBlob[0] & 0x10 == 0x10;

  /// Returns flags relating to the method calling convention.
  String get callingConvention {
    final retVal = StringBuffer();
    final cc = signatureBlob[0];

    retVal.write('default ');
    if (cc & 0x05 == 0x05) retVal.write('vararg ');
    if (cc & 0x10 == 0x10) retVal.write('generic ');
    if (cc & 0x20 == 0x20) retVal.write('instance ');
    if (cc & 0x40 == 0x40) retVal.write('explicit ');

    return retVal.toString();
  }

  /// Parses the parameters and return type for this method from the
  /// [signatureBlob], which is of type `MethodDefSig` (or `PropertySig`, if the
  /// method is a property getter). This is documented in §II.23.2.1 and
  /// §II.23.2.5 respectively.
  void _parseSignatureBlob() {
    // Win32 properties are declared as such, but are represented as
    // MethodDefSig objects
    if (isGetProperty && signatureBlob[0] != 0x20) {
      _parseGetPropertySig();
    } else {
      _parseMethodDefSig();
    }
  }

  /// Parse a property from the signature blob. Properties have the following
  /// format: [type | paramCount | customMod | type | param]
  ///
  /// `PropertySig` is defined in §II.23.2.5.
  void _parseGetPropertySig() {
    // Type should begin at index 2
    final typeIdentifier =
        TypeTuple.fromSignature(signatureBlob.sublist(2), scope).typeIdentifier;
    returnType = Parameter.fromTypeIdentifier(scope, token, typeIdentifier);
  }

  /// Parses the parameters and return type for this method from the
  /// [signatureBlob], which is of type `MethodDefSig`. This is documented in
  /// §II.23.2.1.
  ///
  /// This is of format:
  ///   [callConv | genParamCount | paramCount | retType | param...]
  void _parseMethodDefSig() {
    var paramsIndex = 0;

    // Strip off the header and the paramCount. We know the number and names of
    // the parameters already; we're simply mapping them to types here.
    var blobPtr = hasGenericParameters ? 3 : 2;

    // Windows Runtime emits a zero-th parameter for the return type. So move
    // that to the returnType and parse a type from the signature.
    if (parameters.isNotEmpty && parameters.first.sequence == 0) {
      // Parse return type
      returnType = parameters.first;
      parameters = parameters.sublist(1);
      final returnTypeTuple = TypeTuple.fromSignature(
        signatureBlob.sublist(blobPtr),
        scope,
      );
      returnType.typeIdentifier = returnTypeTuple.typeIdentifier;
      blobPtr += returnTypeTuple.offsetLength;
    } else {
      // In Win32 metadata, EnumParams does not return a zero-th parameter even
      // if there is a return type. So we create a new returnType for it.
      final returnTypeTuple = TypeTuple.fromSignature(
        signatureBlob.sublist(blobPtr),
        scope,
      );
      returnType = Parameter.fromTypeIdentifier(
        scope,
        token,
        returnTypeTuple.typeIdentifier,
      );
      blobPtr += returnTypeTuple.offsetLength;
    }

    // Parse through the params section of MethodDefSig, and map each recovered
    // type to the corresponding parameter.
    while (paramsIndex < parameters.length) {
      final signature = signatureBlob.sublist(blobPtr);
      final runtimeType = TypeTuple.fromSignature(signature, scope);
      blobPtr += runtimeType.offsetLength;

      if (runtimeType.typeIdentifier.baseType == BaseType.simpleArrayType) {
        _parseSimpleArray(
          runtimeType,
          paramsIndex,
          parameters[paramsIndex].isOutParam
              ? _ArrayPassingStyle.fill
              : _ArrayPassingStyle.pass,
        );
        paramsIndex++; // we've added two parameters here
      } else if (runtimeType.typeIdentifier.baseType ==
              BaseType.referenceTypeModifier &&
          runtimeType.typeIdentifier.typeArg?.baseType ==
              BaseType.simpleArrayType) {
        _parseSimpleArray(runtimeType, paramsIndex, _ArrayPassingStyle.receive);
        paramsIndex++; // we've added two parameters here
      } else {
        parameters[paramsIndex].typeIdentifier = runtimeType.typeIdentifier;
      }
      paramsIndex++;
    }
  }

  void _parseParameterNames() => using((arena) {
    final phEnum = arena<HCORENUM>();
    final rParams = arena<mdParamDef>();
    final pcTokens = arena<ULONG>();
    while (true) {
      try {
        reader.enumParams(phEnum, token, rParams, 1, pcTokens);
        if (pcTokens.value == 0) break;
        final parameterToken = rParams.value;
        final parameter = Parameter.fromToken(scope, parameterToken);
        parameters.add(parameter);
      } on WindowsException {
        break;
      }
    }
    reader.closeEnum(phEnum.value);
  });

  // Various projections do smart things to mask this into a single array
  // value. We're not that clever yet, so we project it in its raw state, which
  // means a little work here to ensure that it comes out right.
  void _parseSimpleArray(
    TypeTuple typeTuple,
    int paramsIndex,
    _ArrayPassingStyle arrayPassingStyle,
  ) {
    final Parameter(:name, :attributes) = parameters[paramsIndex];
    parameters[paramsIndex].name = '__${name}Size';

    if (arrayPassingStyle == _ArrayPassingStyle.receive) {
      parameters[paramsIndex].typeIdentifier = parameters[paramsIndex]
          .typeIdentifier
          .copyWith(
            baseType: BaseType.pointerTypeModifier,
            typeArg: const TypeIdentifier(BaseType.uint32Type),
          );
    } else {
      parameters[paramsIndex].typeIdentifier = const TypeIdentifier(
        BaseType.uint32Type,
      );
      if (arrayPassingStyle == _ArrayPassingStyle.fill) {
        // In FillArray style, the arraySize parameter must be an [in] parameter
        parameters[paramsIndex].attributes = pdIn;
      }
    }

    parameters.insert(
      paramsIndex + 1,
      Parameter.fromVoid(scope, token)..attributes = attributes,
    );
    parameters[paramsIndex + 1].name = name;
    parameters[paramsIndex + 1].typeIdentifier = typeTuple.typeIdentifier;
  }

  @override
  String toString() {
    final params = parameters
        .map((param) => '${param.typeIdentifier} ${param.name}')
        .join(', ');
    return '${returnType.typeIdentifier} $name($params)';
  }
}

/// Contains values that describe method implementation features.
class MethodImplementationFeatures {
  const MethodImplementationFeatures(this._implFlags);

  final int _implFlags;

  /// Returns information about the code type used in implementing the method.
  CodeType get codeType => CodeType.values[_implFlags & miCodeTypeMask];

  /// Returns true if the method implementation is managed.
  bool get isManaged => _implFlags & miManagedMask == miManaged;

  /// Returns true if the method is defined. This flag is used primarily in
  /// merge scenarios.
  bool get isForwardRef => _implFlags & miForwardRef == miForwardRef;

  /// Returns true if the method signature cannot be mangled for an HRESULT
  /// conversion.
  bool get isPreserveSig => _implFlags & miPreserveSig == miPreserveSig;

  /// Returns true if the method is single-threaded through its body.
  bool get isSynchronized => _implFlags & miSynchronized == miSynchronized;

  /// Returns true if the method cannot be inlined.
  bool get isNoInlining => _implFlags & miNoInlining == miNoInlining;

  /// Returns true if the method should be inlined if possible.
  bool get isAggressiveInlining =>
      _implFlags & miAggressiveInlining == miAggressiveInlining;

  /// Returns true if the method should not be optimized.
  bool get isNoOptimization =>
      _implFlags & miNoOptimization == miNoOptimization;
}

/// Represents the various array-passing styles in WinRT.
///
/// See
/// <https://learn.microsoft.com/uwp/winrt-cref/winrt-type-system#array-parameters>.
enum _ArrayPassingStyle {
  /// Used when the caller provides an array for the method to fill, up to a
  /// maximum array size.
  ///
  /// In this style, the array size parameter is an `in` parameter, while the
  /// array parameter is an `out` parameter.
  fill,

  /// Used when the caller provides an array to the method.
  ///
  /// In this style, the array size parameter and the array parameter are both
  /// `in` parameters.
  pass,

  /// Used when the caller receives an array that was allocated by the method.
  ///
  /// In this style, the array size parameter and the array parameter are both
  /// `out` parameters. Additionally, the array parameter is passed by
  /// reference (that is, `ArrayType**`, rather than `ArrayType*`).
  receive,
}
