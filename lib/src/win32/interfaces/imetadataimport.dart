// ignore_for_file: avoid_positional_boolean_parameters
// ignore_for_file: constant_identifier_names, non_constant_identifier_names
// ignore_for_file: unused_import

import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import '../constants.dart';
import '../exception.dart';
import '../guid.dart';
import '../macros.dart';
import '../structs.dart';
import '../types.dart';
import 'iunknown.dart';

final IID_IMetaDataImport = Guid.fromComponents(
  0x7dac8207,
  0xd3ae,
  0x4c75,
  Uint8List.fromList(const [0x9b, 0x67, 0x92, 0x80, 0x1a, 0x49, 0x7d, 0x44]),
);

class IMetaDataImport extends IUnknown {
  IMetaDataImport(super.ptr)
    : _vtable = ptr.value.cast<IMetaDataImportVtbl>().ref;

  final IMetaDataImportVtbl _vtable;
  late final _CloseEnumFn =
      _vtable.CloseEnum.asFunction<void Function(VTablePointer, Pointer)>();
  late final _CountEnumFn =
      _vtable.CountEnum.asFunction<
        int Function(VTablePointer, Pointer, Pointer<Uint32>)
      >();
  late final _ResetEnumFn =
      _vtable.ResetEnum.asFunction<int Function(VTablePointer, Pointer, int)>();
  late final _EnumTypeDefsFn =
      _vtable.EnumTypeDefs.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumInterfaceImplsFn =
      _vtable.EnumInterfaceImpls.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumTypeRefsFn =
      _vtable.EnumTypeRefs.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _FindTypeDefByNameFn =
      _vtable.FindTypeDefByName.asFunction<
        int Function(VTablePointer, PCWSTR, int, Pointer<Uint32>)
      >();
  late final _GetScopePropsFn =
      _vtable.GetScopeProps.asFunction<
        int Function(VTablePointer, PWSTR, int, Pointer<Uint32>, Pointer<GUID>)
      >();
  late final _GetModuleFromScopeFn =
      _vtable.GetModuleFromScope.asFunction<
        int Function(VTablePointer, Pointer<Uint32>)
      >();
  late final _GetTypeDefPropsFn =
      _vtable.GetTypeDefProps.asFunction<
        int Function(
          VTablePointer,
          int,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
        )
      >();
  late final _GetInterfaceImplPropsFn =
      _vtable.GetInterfaceImplProps.asFunction<
        int Function(VTablePointer, int, Pointer<Uint32>, Pointer<Uint32>)
      >();
  late final _GetTypeRefPropsFn =
      _vtable.GetTypeRefProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          PWSTR,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _ResolveTypeRefFn =
      _vtable.ResolveTypeRef.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<GUID>,
          Pointer<VTablePointer>,
          Pointer<Uint32>,
        )
      >();
  late final _EnumMembersFn =
      _vtable.EnumMembers.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumMembersWithNameFn =
      _vtable.EnumMembersWithName.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          PCWSTR,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumMethodsFn =
      _vtable.EnumMethods.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumMethodsWithNameFn =
      _vtable.EnumMethodsWithName.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          PCWSTR,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumFieldsFn =
      _vtable.EnumFields.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumFieldsWithNameFn =
      _vtable.EnumFieldsWithName.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          PCWSTR,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumParamsFn =
      _vtable.EnumParams.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumMemberRefsFn =
      _vtable.EnumMemberRefs.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumMethodImplsFn =
      _vtable.EnumMethodImpls.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumPermissionSetsFn =
      _vtable.EnumPermissionSets.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          int,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _FindMemberFn =
      _vtable.FindMember.asFunction<
        int Function(
          VTablePointer,
          int,
          PCWSTR,
          Pointer<Uint8>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _FindMethodFn =
      _vtable.FindMethod.asFunction<
        int Function(
          VTablePointer,
          int,
          PCWSTR,
          Pointer<Uint8>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _FindFieldFn =
      _vtable.FindField.asFunction<
        int Function(
          VTablePointer,
          int,
          PCWSTR,
          Pointer<Uint8>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _FindMemberRefFn =
      _vtable.FindMemberRef.asFunction<
        int Function(
          VTablePointer,
          int,
          PCWSTR,
          Pointer<Uint8>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _GetMethodPropsFn =
      _vtable.GetMethodProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Pointer<Uint8>>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
        )
      >();
  late final _GetMemberRefPropsFn =
      _vtable.GetMemberRefProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Pointer<Uint8>>,
          Pointer<Uint32>,
        )
      >();
  late final _EnumPropertiesFn =
      _vtable.EnumProperties.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumEventsFn =
      _vtable.EnumEvents.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _GetEventPropsFn =
      _vtable.GetEventProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          PCWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumMethodSemanticsFn =
      _vtable.EnumMethodSemantics.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _GetMethodSemanticsFn =
      _vtable.GetMethodSemantics.asFunction<
        int Function(VTablePointer, int, int, Pointer<Uint32>)
      >();
  late final _GetClassLayoutFn =
      _vtable.GetClassLayout.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          Pointer<COR_FIELD_OFFSET>,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
        )
      >();
  late final _GetFieldMarshalFn =
      _vtable.GetFieldMarshal.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Pointer<Uint8>>,
          Pointer<Uint32>,
        )
      >();
  late final _GetRVAFn =
      _vtable.GetRVA.asFunction<
        int Function(VTablePointer, int, Pointer<Uint32>, Pointer<Uint32>)
      >();
  late final _GetPermissionSetPropsFn =
      _vtable.GetPermissionSetProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          Pointer<Pointer>,
          Pointer<Uint32>,
        )
      >();
  late final _GetSigFromTokenFn =
      _vtable.GetSigFromToken.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Pointer<Uint8>>,
          Pointer<Uint32>,
        )
      >();
  late final _GetModuleRefPropsFn =
      _vtable.GetModuleRefProps.asFunction<
        int Function(VTablePointer, int, PWSTR, int, Pointer<Uint32>)
      >();
  late final _EnumModuleRefsFn =
      _vtable.EnumModuleRefs.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _GetTypeSpecFromTokenFn =
      _vtable.GetTypeSpecFromToken.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Pointer<Uint8>>,
          Pointer<Uint32>,
        )
      >();
  late final _GetNameFromTokenFn =
      _vtable.GetNameFromToken.asFunction<
        int Function(VTablePointer, int, Pointer<Pointer<Int8>>)
      >();
  late final _EnumUnresolvedMethodsFn =
      _vtable.EnumUnresolvedMethods.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _GetUserStringFn =
      _vtable.GetUserString.asFunction<
        int Function(VTablePointer, int, PWSTR, int, Pointer<Uint32>)
      >();
  late final _GetPinvokeMapFn =
      _vtable.GetPinvokeMap.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
        )
      >();
  late final _EnumSignaturesFn =
      _vtable.EnumSignatures.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumTypeSpecsFn =
      _vtable.EnumTypeSpecs.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumUserStringsFn =
      _vtable.EnumUserStrings.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _GetParamForMethodIndexFn =
      _vtable.GetParamForMethodIndex.asFunction<
        int Function(VTablePointer, int, int, Pointer<Uint32>)
      >();
  late final _EnumCustomAttributesFn =
      _vtable.EnumCustomAttributes.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          int,
          int,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _GetCustomAttributePropsFn =
      _vtable.GetCustomAttributeProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Pointer>,
          Pointer<Uint32>,
        )
      >();
  late final _FindTypeRefFn =
      _vtable.FindTypeRef.asFunction<
        int Function(VTablePointer, int, PCWSTR, Pointer<Uint32>)
      >();
  late final _GetMemberPropsFn =
      _vtable.GetMemberProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Pointer<Uint8>>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Pointer>,
          Pointer<Uint32>,
        )
      >();
  late final _GetFieldPropsFn =
      _vtable.GetFieldProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Pointer<Uint8>>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Pointer>,
          Pointer<Uint32>,
        )
      >();
  late final _GetPropertyPropsFn =
      _vtable.GetPropertyProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          PCWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Pointer<Uint8>>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Pointer>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _GetParamPropsFn =
      _vtable.GetParamProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Pointer>,
          Pointer<Uint32>,
        )
      >();
  late final _GetCustomAttributeByNameFn =
      _vtable.GetCustomAttributeByName.asFunction<
        int Function(
          VTablePointer,
          int,
          PCWSTR,
          Pointer<Pointer>,
          Pointer<Uint32>,
        )
      >();
  late final _IsValidTokenFn =
      _vtable.IsValidToken.asFunction<int Function(VTablePointer, int)>();
  late final _GetNestedClassPropsFn =
      _vtable.GetNestedClassProps.asFunction<
        int Function(VTablePointer, int, Pointer<Uint32>)
      >();
  late final _GetNativeCallConvFromSigFn =
      _vtable.GetNativeCallConvFromSig.asFunction<
        int Function(VTablePointer, Pointer, int, Pointer<Uint32>)
      >();
  late final _IsGlobalFn =
      _vtable.IsGlobal.asFunction<
        int Function(VTablePointer, int, Pointer<Int32>)
      >();

  @pragma('vm:prefer-inline')
  void closeEnum(Pointer hEnum) => _CloseEnumFn(ptr, hEnum);

  @pragma('vm:prefer-inline')
  void countEnum(Pointer hEnum, Pointer<Uint32> pulCount) {
    final hr$ = HRESULT(_CountEnumFn(ptr, hEnum, pulCount));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void resetEnum(Pointer hEnum, int ulPos) {
    final hr$ = HRESULT(_ResetEnumFn(ptr, hEnum, ulPos));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumTypeDefs(
    Pointer<Pointer> phEnum,
    Pointer<Uint32> rTypeDefs,
    int cMax,
    Pointer<Uint32> pcTypeDefs,
  ) {
    final hr$ = HRESULT(
      _EnumTypeDefsFn(ptr, phEnum, rTypeDefs, cMax, pcTypeDefs),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumInterfaceImpls(
    Pointer<Pointer> phEnum,
    int td,
    Pointer<Uint32> rImpls,
    int cMax,
    Pointer<Uint32> pcImpls,
  ) {
    final hr$ = HRESULT(
      _EnumInterfaceImplsFn(ptr, phEnum, td, rImpls, cMax, pcImpls),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumTypeRefs(
    Pointer<Pointer> phEnum,
    Pointer<Uint32> rTypeRefs,
    int cMax,
    Pointer<Uint32> pcTypeRefs,
  ) {
    final hr$ = HRESULT(
      _EnumTypeRefsFn(ptr, phEnum, rTypeRefs, cMax, pcTypeRefs),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void findTypeDefByName(
    PCWSTR szTypeDef,
    int tkEnclosingClass,
    Pointer<Uint32> ptd,
  ) {
    final hr$ = HRESULT(
      _FindTypeDefByNameFn(ptr, szTypeDef, tkEnclosingClass, ptd),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getScopeProps(
    PWSTR? szName,
    int cchName,
    Pointer<Uint32> pchName,
    Pointer<GUID> pmvid,
  ) {
    final hr$ = HRESULT(
      _GetScopePropsFn(ptr, szName ?? nullptr, cchName, pchName, pmvid),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getModuleFromScope(Pointer<Uint32> pmd) {
    final hr$ = HRESULT(_GetModuleFromScopeFn(ptr, pmd));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getTypeDefProps(
    int td,
    PWSTR? szTypeDef,
    int cchTypeDef,
    Pointer<Uint32> pchTypeDef,
    Pointer<Uint32> pdwTypeDefFlags,
    Pointer<Uint32> ptkExtends,
  ) {
    final hr$ = HRESULT(
      _GetTypeDefPropsFn(
        ptr,
        td,
        szTypeDef ?? nullptr,
        cchTypeDef,
        pchTypeDef,
        pdwTypeDefFlags,
        ptkExtends,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getInterfaceImplProps(
    int iiImpl,
    Pointer<Uint32> pClass,
    Pointer<Uint32> ptkIface,
  ) {
    final hr$ = HRESULT(
      _GetInterfaceImplPropsFn(ptr, iiImpl, pClass, ptkIface),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getTypeRefProps(
    int tr,
    Pointer<Uint32> ptkResolutionScope,
    PWSTR? szName,
    int cchName,
    Pointer<Uint32> pchName,
  ) {
    final hr$ = HRESULT(
      _GetTypeRefPropsFn(
        ptr,
        tr,
        ptkResolutionScope,
        szName ?? nullptr,
        cchName,
        pchName,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void resolveTypeRef(
    int tr,
    Pointer<GUID> riid,
    Pointer<VTablePointer> ppIScope,
    Pointer<Uint32> ptd,
  ) {
    final hr$ = HRESULT(_ResolveTypeRefFn(ptr, tr, riid, ppIScope, ptd));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumMembers(
    Pointer<Pointer> phEnum,
    int cl,
    Pointer<Uint32> rMembers,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumMembersFn(ptr, phEnum, cl, rMembers, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumMembersWithName(
    Pointer<Pointer> phEnum,
    int cl,
    PCWSTR szName,
    Pointer<Uint32> rMembers,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumMembersWithNameFn(ptr, phEnum, cl, szName, rMembers, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumMethods(
    Pointer<Pointer> phEnum,
    int cl,
    Pointer<Uint32> rMethods,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumMethodsFn(ptr, phEnum, cl, rMethods, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumMethodsWithName(
    Pointer<Pointer> phEnum,
    int cl,
    PCWSTR szName,
    Pointer<Uint32> rMethods,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumMethodsWithNameFn(ptr, phEnum, cl, szName, rMethods, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumFields(
    Pointer<Pointer> phEnum,
    int cl,
    Pointer<Uint32> rFields,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumFieldsFn(ptr, phEnum, cl, rFields, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumFieldsWithName(
    Pointer<Pointer> phEnum,
    int cl,
    PCWSTR szName,
    Pointer<Uint32> rFields,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumFieldsWithNameFn(ptr, phEnum, cl, szName, rFields, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumParams(
    Pointer<Pointer> phEnum,
    int mb,
    Pointer<Uint32> rParams,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumParamsFn(ptr, phEnum, mb, rParams, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumMemberRefs(
    Pointer<Pointer> phEnum,
    int tkParent,
    Pointer<Uint32> rMemberRefs,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumMemberRefsFn(ptr, phEnum, tkParent, rMemberRefs, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumMethodImpls(
    Pointer<Pointer> phEnum,
    int td,
    Pointer<Uint32> rMethodBody,
    Pointer<Uint32> rMethodDecl,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumMethodImplsFn(
        ptr,
        phEnum,
        td,
        rMethodBody,
        rMethodDecl,
        cMax,
        pcTokens,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumPermissionSets(
    Pointer<Pointer> phEnum,
    int tk,
    int dwActions,
    Pointer<Uint32> rPermission,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumPermissionSetsFn(
        ptr,
        phEnum,
        tk,
        dwActions,
        rPermission,
        cMax,
        pcTokens,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void findMember(
    int td,
    PCWSTR szName,
    Pointer<Uint8> pvSigBlob,
    int cbSigBlob,
    Pointer<Uint32> pmb,
  ) {
    final hr$ = HRESULT(
      _FindMemberFn(ptr, td, szName, pvSigBlob, cbSigBlob, pmb),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void findMethod(
    int td,
    PCWSTR szName,
    Pointer<Uint8> pvSigBlob,
    int cbSigBlob,
    Pointer<Uint32> pmb,
  ) {
    final hr$ = HRESULT(
      _FindMethodFn(ptr, td, szName, pvSigBlob, cbSigBlob, pmb),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void findField(
    int td,
    PCWSTR szName,
    Pointer<Uint8> pvSigBlob,
    int cbSigBlob,
    Pointer<Uint32> pmb,
  ) {
    final hr$ = HRESULT(
      _FindFieldFn(ptr, td, szName, pvSigBlob, cbSigBlob, pmb),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void findMemberRef(
    int td,
    PCWSTR szName,
    Pointer<Uint8> pvSigBlob,
    int cbSigBlob,
    Pointer<Uint32> pmr,
  ) {
    final hr$ = HRESULT(
      _FindMemberRefFn(ptr, td, szName, pvSigBlob, cbSigBlob, pmr),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getMethodProps(
    int mb,
    Pointer<Uint32> pClass,
    PWSTR? szMethod,
    int cchMethod,
    Pointer<Uint32> pchMethod,
    Pointer<Uint32> pdwAttr,
    Pointer<Pointer<Uint8>> ppvSigBlob,
    Pointer<Uint32> pcbSigBlob,
    Pointer<Uint32> pulCodeRVA,
    Pointer<Uint32> pdwImplFlags,
  ) {
    final hr$ = HRESULT(
      _GetMethodPropsFn(
        ptr,
        mb,
        pClass,
        szMethod ?? nullptr,
        cchMethod,
        pchMethod,
        pdwAttr,
        ppvSigBlob,
        pcbSigBlob,
        pulCodeRVA,
        pdwImplFlags,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getMemberRefProps(
    int mr,
    Pointer<Uint32> ptk,
    PWSTR? szMember,
    int cchMember,
    Pointer<Uint32> pchMember,
    Pointer<Pointer<Uint8>> ppvSigBlob,
    Pointer<Uint32> pbSig,
  ) {
    final hr$ = HRESULT(
      _GetMemberRefPropsFn(
        ptr,
        mr,
        ptk,
        szMember ?? nullptr,
        cchMember,
        pchMember,
        ppvSigBlob,
        pbSig,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumProperties(
    Pointer<Pointer> phEnum,
    int td,
    Pointer<Uint32> rProperties,
    int cMax,
    Pointer<Uint32> pcProperties,
  ) {
    final hr$ = HRESULT(
      _EnumPropertiesFn(ptr, phEnum, td, rProperties, cMax, pcProperties),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumEvents(
    Pointer<Pointer> phEnum,
    int td,
    Pointer<Uint32> rEvents,
    int cMax,
    Pointer<Uint32> pcEvents,
  ) {
    final hr$ = HRESULT(
      _EnumEventsFn(ptr, phEnum, td, rEvents, cMax, pcEvents),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getEventProps(
    int ev,
    Pointer<Uint32> pClass,
    PCWSTR szEvent,
    int cchEvent,
    Pointer<Uint32> pchEvent,
    Pointer<Uint32> pdwEventFlags,
    Pointer<Uint32> ptkEventType,
    Pointer<Uint32> pmdAddOn,
    Pointer<Uint32> pmdRemoveOn,
    Pointer<Uint32> pmdFire,
    Pointer<Uint32> rmdOtherMethod,
    int cMax,
    Pointer<Uint32> pcOtherMethod,
  ) {
    final hr$ = HRESULT(
      _GetEventPropsFn(
        ptr,
        ev,
        pClass,
        szEvent,
        cchEvent,
        pchEvent,
        pdwEventFlags,
        ptkEventType,
        pmdAddOn,
        pmdRemoveOn,
        pmdFire,
        rmdOtherMethod,
        cMax,
        pcOtherMethod,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumMethodSemantics(
    Pointer<Pointer> phEnum,
    int mb,
    Pointer<Uint32> rEventProp,
    int cMax,
    Pointer<Uint32> pcEventProp,
  ) {
    final hr$ = HRESULT(
      _EnumMethodSemanticsFn(ptr, phEnum, mb, rEventProp, cMax, pcEventProp),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getMethodSemantics(
    int mb,
    int tkEventProp,
    Pointer<Uint32> pdwSemanticsFlags,
  ) {
    final hr$ = HRESULT(
      _GetMethodSemanticsFn(ptr, mb, tkEventProp, pdwSemanticsFlags),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getClassLayout(
    int td,
    Pointer<Uint32> pdwPackSize,
    Pointer<COR_FIELD_OFFSET> rFieldOffset,
    int cMax,
    Pointer<Uint32> pcFieldOffset,
    Pointer<Uint32> pulClassSize,
  ) {
    final hr$ = HRESULT(
      _GetClassLayoutFn(
        ptr,
        td,
        pdwPackSize,
        rFieldOffset,
        cMax,
        pcFieldOffset,
        pulClassSize,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getFieldMarshal(
    int tk,
    Pointer<Pointer<Uint8>> ppvNativeType,
    Pointer<Uint32> pcbNativeType,
  ) {
    final hr$ = HRESULT(
      _GetFieldMarshalFn(ptr, tk, ppvNativeType, pcbNativeType),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getRVA(
    int tk,
    Pointer<Uint32> pulCodeRVA,
    Pointer<Uint32> pdwImplFlags,
  ) {
    final hr$ = HRESULT(_GetRVAFn(ptr, tk, pulCodeRVA, pdwImplFlags));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getPermissionSetProps(
    int pm,
    Pointer<Uint32> pdwAction,
    Pointer<Pointer> ppvPermission,
    Pointer<Uint32> pcbPermission,
  ) {
    final hr$ = HRESULT(
      _GetPermissionSetPropsFn(
        ptr,
        pm,
        pdwAction,
        ppvPermission,
        pcbPermission,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getSigFromToken(
    int mdSig,
    Pointer<Pointer<Uint8>> ppvSig,
    Pointer<Uint32> pcbSig,
  ) {
    final hr$ = HRESULT(_GetSigFromTokenFn(ptr, mdSig, ppvSig, pcbSig));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getModuleRefProps(
    int mur,
    PWSTR? szName,
    int cchName,
    Pointer<Uint32> pchName,
  ) {
    final hr$ = HRESULT(
      _GetModuleRefPropsFn(ptr, mur, szName ?? nullptr, cchName, pchName),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumModuleRefs(
    Pointer<Pointer> phEnum,
    Pointer<Uint32> rModuleRefs,
    int cmax,
    Pointer<Uint32> pcModuleRefs,
  ) {
    final hr$ = HRESULT(
      _EnumModuleRefsFn(ptr, phEnum, rModuleRefs, cmax, pcModuleRefs),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getTypeSpecFromToken(
    int typespec,
    Pointer<Pointer<Uint8>> ppvSig,
    Pointer<Uint32> pcbSig,
  ) {
    final hr$ = HRESULT(_GetTypeSpecFromTokenFn(ptr, typespec, ppvSig, pcbSig));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getNameFromToken(int tk, Pointer<Pointer<Int8>> pszUtf8NamePtr) {
    final hr$ = HRESULT(_GetNameFromTokenFn(ptr, tk, pszUtf8NamePtr));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumUnresolvedMethods(
    Pointer<Pointer> phEnum,
    Pointer<Uint32> rMethods,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumUnresolvedMethodsFn(ptr, phEnum, rMethods, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getUserString(
    int stk,
    PWSTR? szString,
    int cchString,
    Pointer<Uint32> pchString,
  ) {
    final hr$ = HRESULT(
      _GetUserStringFn(ptr, stk, szString ?? nullptr, cchString, pchString),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getPinvokeMap(
    int tk,
    Pointer<Uint32> pdwMappingFlags,
    PWSTR? szImportName,
    int cchImportName,
    Pointer<Uint32> pchImportName,
    Pointer<Uint32> pmrImportDLL,
  ) {
    final hr$ = HRESULT(
      _GetPinvokeMapFn(
        ptr,
        tk,
        pdwMappingFlags,
        szImportName ?? nullptr,
        cchImportName,
        pchImportName,
        pmrImportDLL,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumSignatures(
    Pointer<Pointer> phEnum,
    Pointer<Uint32> rSignatures,
    int cmax,
    Pointer<Uint32> pcSignatures,
  ) {
    final hr$ = HRESULT(
      _EnumSignaturesFn(ptr, phEnum, rSignatures, cmax, pcSignatures),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumTypeSpecs(
    Pointer<Pointer> phEnum,
    Pointer<Uint32> rTypeSpecs,
    int cmax,
    Pointer<Uint32> pcTypeSpecs,
  ) {
    final hr$ = HRESULT(
      _EnumTypeSpecsFn(ptr, phEnum, rTypeSpecs, cmax, pcTypeSpecs),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumUserStrings(
    Pointer<Pointer> phEnum,
    Pointer<Uint32> rStrings,
    int cmax,
    Pointer<Uint32> pcStrings,
  ) {
    final hr$ = HRESULT(
      _EnumUserStringsFn(ptr, phEnum, rStrings, cmax, pcStrings),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getParamForMethodIndex(int md, int ulParamSeq, Pointer<Uint32> ppd) {
    final hr$ = HRESULT(_GetParamForMethodIndexFn(ptr, md, ulParamSeq, ppd));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumCustomAttributes(
    Pointer<Pointer> phEnum,
    int tk,
    int tkType,
    Pointer<Uint32> rCustomAttributes,
    int cMax,
    Pointer<Uint32> pcCustomAttributes,
  ) {
    final hr$ = HRESULT(
      _EnumCustomAttributesFn(
        ptr,
        phEnum,
        tk,
        tkType,
        rCustomAttributes,
        cMax,
        pcCustomAttributes,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getCustomAttributeProps(
    int cv,
    Pointer<Uint32> ptkObj,
    Pointer<Uint32> ptkType,
    Pointer<Pointer> ppBlob,
    Pointer<Uint32> pcbSize,
  ) {
    final hr$ = HRESULT(
      _GetCustomAttributePropsFn(ptr, cv, ptkObj, ptkType, ppBlob, pcbSize),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void findTypeRef(int tkResolutionScope, PCWSTR szName, Pointer<Uint32> ptr$) {
    final hr$ = HRESULT(_FindTypeRefFn(ptr, tkResolutionScope, szName, ptr$));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getMemberProps(
    int mb,
    Pointer<Uint32> pClass,
    PWSTR? szMember,
    int cchMember,
    Pointer<Uint32> pchMember,
    Pointer<Uint32> pdwAttr,
    Pointer<Pointer<Uint8>> ppvSigBlob,
    Pointer<Uint32> pcbSigBlob,
    Pointer<Uint32> pulCodeRVA,
    Pointer<Uint32> pdwImplFlags,
    Pointer<Uint32> pdwCPlusTypeFlag,
    Pointer<Pointer> ppValue,
    Pointer<Uint32> pcchValue,
  ) {
    final hr$ = HRESULT(
      _GetMemberPropsFn(
        ptr,
        mb,
        pClass,
        szMember ?? nullptr,
        cchMember,
        pchMember,
        pdwAttr,
        ppvSigBlob,
        pcbSigBlob,
        pulCodeRVA,
        pdwImplFlags,
        pdwCPlusTypeFlag,
        ppValue,
        pcchValue,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getFieldProps(
    int mb,
    Pointer<Uint32> pClass,
    PWSTR? szField,
    int cchField,
    Pointer<Uint32> pchField,
    Pointer<Uint32> pdwAttr,
    Pointer<Pointer<Uint8>> ppvSigBlob,
    Pointer<Uint32> pcbSigBlob,
    Pointer<Uint32> pdwCPlusTypeFlag,
    Pointer<Pointer> ppValue,
    Pointer<Uint32> pcchValue,
  ) {
    final hr$ = HRESULT(
      _GetFieldPropsFn(
        ptr,
        mb,
        pClass,
        szField ?? nullptr,
        cchField,
        pchField,
        pdwAttr,
        ppvSigBlob,
        pcbSigBlob,
        pdwCPlusTypeFlag,
        ppValue,
        pcchValue,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getPropertyProps(
    int prop,
    Pointer<Uint32> pClass,
    PCWSTR szProperty,
    int cchProperty,
    Pointer<Uint32> pchProperty,
    Pointer<Uint32> pdwPropFlags,
    Pointer<Pointer<Uint8>> ppvSig,
    Pointer<Uint32> pbSig,
    Pointer<Uint32> pdwCPlusTypeFlag,
    Pointer<Pointer> ppDefaultValue,
    Pointer<Uint32> pcchDefaultValue,
    Pointer<Uint32> pmdSetter,
    Pointer<Uint32> pmdGetter,
    Pointer<Uint32> rmdOtherMethod,
    int cMax,
    Pointer<Uint32> pcOtherMethod,
  ) {
    final hr$ = HRESULT(
      _GetPropertyPropsFn(
        ptr,
        prop,
        pClass,
        szProperty,
        cchProperty,
        pchProperty,
        pdwPropFlags,
        ppvSig,
        pbSig,
        pdwCPlusTypeFlag,
        ppDefaultValue,
        pcchDefaultValue,
        pmdSetter,
        pmdGetter,
        rmdOtherMethod,
        cMax,
        pcOtherMethod,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getParamProps(
    int tk,
    Pointer<Uint32> pmd,
    Pointer<Uint32> pulSequence,
    PWSTR? szName,
    int cchName,
    Pointer<Uint32> pchName,
    Pointer<Uint32> pdwAttr,
    Pointer<Uint32> pdwCPlusTypeFlag,
    Pointer<Pointer> ppValue,
    Pointer<Uint32> pcchValue,
  ) {
    final hr$ = HRESULT(
      _GetParamPropsFn(
        ptr,
        tk,
        pmd,
        pulSequence,
        szName ?? nullptr,
        cchName,
        pchName,
        pdwAttr,
        pdwCPlusTypeFlag,
        ppValue,
        pcchValue,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getCustomAttributeByName(
    int tkObj,
    PCWSTR szName,
    Pointer<Pointer> ppData,
    Pointer<Uint32> pcbData,
  ) {
    final hr$ = HRESULT(
      _GetCustomAttributeByNameFn(ptr, tkObj, szName, ppData, pcbData),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  bool isValidToken(int tk) => _IsValidTokenFn(ptr, tk) != FALSE;

  @pragma('vm:prefer-inline')
  void getNestedClassProps(
    int tdNestedClass,
    Pointer<Uint32> ptdEnclosingClass,
  ) {
    final hr$ = HRESULT(
      _GetNestedClassPropsFn(ptr, tdNestedClass, ptdEnclosingClass),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getNativeCallConvFromSig(
    Pointer pvSig,
    int cbSig,
    Pointer<Uint32> pCallConv,
  ) {
    final hr$ = HRESULT(
      _GetNativeCallConvFromSigFn(ptr, pvSig, cbSig, pCallConv),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void isGlobal(int pd, Pointer<Int32> pbGlobal) {
    final hr$ = HRESULT(_IsGlobalFn(ptr, pd, pbGlobal));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @override
  String toString() => 'IMetaDataImport(ptr: $ptr)';
}

base class IMetaDataImportVtbl extends Struct {
  external IUnknownVtbl base$;
  external Pointer<
    NativeFunction<Void Function(VTablePointer this$, Pointer hEnum)>
  >
  CloseEnum;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer hEnum,
        Pointer<Uint32> pulCount,
      )
    >
  >
  CountEnum;
  external Pointer<
    NativeFunction<
      Int32 Function(VTablePointer this$, Pointer hEnum, Uint32 ulPos)
    >
  >
  ResetEnum;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Pointer<Uint32> rTypeDefs,
        Uint32 cMax,
        Pointer<Uint32> pcTypeDefs,
      )
    >
  >
  EnumTypeDefs;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 td,
        Pointer<Uint32> rImpls,
        Uint32 cMax,
        Pointer<Uint32> pcImpls,
      )
    >
  >
  EnumInterfaceImpls;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Pointer<Uint32> rTypeRefs,
        Uint32 cMax,
        Pointer<Uint32> pcTypeRefs,
      )
    >
  >
  EnumTypeRefs;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        PCWSTR szTypeDef,
        Uint32 tkEnclosingClass,
        Pointer<Uint32> ptd,
      )
    >
  >
  FindTypeDefByName;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        PWSTR szName,
        Uint32 cchName,
        Pointer<Uint32> pchName,
        Pointer<GUID> pmvid,
      )
    >
  >
  GetScopeProps;
  external Pointer<
    NativeFunction<Int32 Function(VTablePointer this$, Pointer<Uint32> pmd)>
  >
  GetModuleFromScope;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 td,
        PWSTR szTypeDef,
        Uint32 cchTypeDef,
        Pointer<Uint32> pchTypeDef,
        Pointer<Uint32> pdwTypeDefFlags,
        Pointer<Uint32> ptkExtends,
      )
    >
  >
  GetTypeDefProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 iiImpl,
        Pointer<Uint32> pClass,
        Pointer<Uint32> ptkIface,
      )
    >
  >
  GetInterfaceImplProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 tr,
        Pointer<Uint32> ptkResolutionScope,
        PWSTR szName,
        Uint32 cchName,
        Pointer<Uint32> pchName,
      )
    >
  >
  GetTypeRefProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 tr,
        Pointer<GUID> riid,
        Pointer<VTablePointer> ppIScope,
        Pointer<Uint32> ptd,
      )
    >
  >
  ResolveTypeRef;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 cl,
        Pointer<Uint32> rMembers,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumMembers;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 cl,
        PCWSTR szName,
        Pointer<Uint32> rMembers,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumMembersWithName;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 cl,
        Pointer<Uint32> rMethods,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumMethods;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 cl,
        PCWSTR szName,
        Pointer<Uint32> rMethods,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumMethodsWithName;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 cl,
        Pointer<Uint32> rFields,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumFields;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 cl,
        PCWSTR szName,
        Pointer<Uint32> rFields,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumFieldsWithName;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 mb,
        Pointer<Uint32> rParams,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumParams;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 tkParent,
        Pointer<Uint32> rMemberRefs,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumMemberRefs;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 td,
        Pointer<Uint32> rMethodBody,
        Pointer<Uint32> rMethodDecl,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumMethodImpls;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 tk,
        Uint32 dwActions,
        Pointer<Uint32> rPermission,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumPermissionSets;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 td,
        PCWSTR szName,
        Pointer<Uint8> pvSigBlob,
        Uint32 cbSigBlob,
        Pointer<Uint32> pmb,
      )
    >
  >
  FindMember;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 td,
        PCWSTR szName,
        Pointer<Uint8> pvSigBlob,
        Uint32 cbSigBlob,
        Pointer<Uint32> pmb,
      )
    >
  >
  FindMethod;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 td,
        PCWSTR szName,
        Pointer<Uint8> pvSigBlob,
        Uint32 cbSigBlob,
        Pointer<Uint32> pmb,
      )
    >
  >
  FindField;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 td,
        PCWSTR szName,
        Pointer<Uint8> pvSigBlob,
        Uint32 cbSigBlob,
        Pointer<Uint32> pmr,
      )
    >
  >
  FindMemberRef;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mb,
        Pointer<Uint32> pClass,
        PWSTR szMethod,
        Uint32 cchMethod,
        Pointer<Uint32> pchMethod,
        Pointer<Uint32> pdwAttr,
        Pointer<Pointer<Uint8>> ppvSigBlob,
        Pointer<Uint32> pcbSigBlob,
        Pointer<Uint32> pulCodeRVA,
        Pointer<Uint32> pdwImplFlags,
      )
    >
  >
  GetMethodProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mr,
        Pointer<Uint32> ptk,
        PWSTR szMember,
        Uint32 cchMember,
        Pointer<Uint32> pchMember,
        Pointer<Pointer<Uint8>> ppvSigBlob,
        Pointer<Uint32> pbSig,
      )
    >
  >
  GetMemberRefProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 td,
        Pointer<Uint32> rProperties,
        Uint32 cMax,
        Pointer<Uint32> pcProperties,
      )
    >
  >
  EnumProperties;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 td,
        Pointer<Uint32> rEvents,
        Uint32 cMax,
        Pointer<Uint32> pcEvents,
      )
    >
  >
  EnumEvents;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 ev,
        Pointer<Uint32> pClass,
        PCWSTR szEvent,
        Uint32 cchEvent,
        Pointer<Uint32> pchEvent,
        Pointer<Uint32> pdwEventFlags,
        Pointer<Uint32> ptkEventType,
        Pointer<Uint32> pmdAddOn,
        Pointer<Uint32> pmdRemoveOn,
        Pointer<Uint32> pmdFire,
        Pointer<Uint32> rmdOtherMethod,
        Uint32 cMax,
        Pointer<Uint32> pcOtherMethod,
      )
    >
  >
  GetEventProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 mb,
        Pointer<Uint32> rEventProp,
        Uint32 cMax,
        Pointer<Uint32> pcEventProp,
      )
    >
  >
  EnumMethodSemantics;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mb,
        Uint32 tkEventProp,
        Pointer<Uint32> pdwSemanticsFlags,
      )
    >
  >
  GetMethodSemantics;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 td,
        Pointer<Uint32> pdwPackSize,
        Pointer<COR_FIELD_OFFSET> rFieldOffset,
        Uint32 cMax,
        Pointer<Uint32> pcFieldOffset,
        Pointer<Uint32> pulClassSize,
      )
    >
  >
  GetClassLayout;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 tk,
        Pointer<Pointer<Uint8>> ppvNativeType,
        Pointer<Uint32> pcbNativeType,
      )
    >
  >
  GetFieldMarshal;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 tk,
        Pointer<Uint32> pulCodeRVA,
        Pointer<Uint32> pdwImplFlags,
      )
    >
  >
  GetRVA;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 pm,
        Pointer<Uint32> pdwAction,
        Pointer<Pointer> ppvPermission,
        Pointer<Uint32> pcbPermission,
      )
    >
  >
  GetPermissionSetProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mdSig,
        Pointer<Pointer<Uint8>> ppvSig,
        Pointer<Uint32> pcbSig,
      )
    >
  >
  GetSigFromToken;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mur,
        PWSTR szName,
        Uint32 cchName,
        Pointer<Uint32> pchName,
      )
    >
  >
  GetModuleRefProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Pointer<Uint32> rModuleRefs,
        Uint32 cmax,
        Pointer<Uint32> pcModuleRefs,
      )
    >
  >
  EnumModuleRefs;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 typespec,
        Pointer<Pointer<Uint8>> ppvSig,
        Pointer<Uint32> pcbSig,
      )
    >
  >
  GetTypeSpecFromToken;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 tk,
        Pointer<Pointer<Int8>> pszUtf8NamePtr,
      )
    >
  >
  GetNameFromToken;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Pointer<Uint32> rMethods,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumUnresolvedMethods;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 stk,
        PWSTR szString,
        Uint32 cchString,
        Pointer<Uint32> pchString,
      )
    >
  >
  GetUserString;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 tk,
        Pointer<Uint32> pdwMappingFlags,
        PWSTR szImportName,
        Uint32 cchImportName,
        Pointer<Uint32> pchImportName,
        Pointer<Uint32> pmrImportDLL,
      )
    >
  >
  GetPinvokeMap;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Pointer<Uint32> rSignatures,
        Uint32 cmax,
        Pointer<Uint32> pcSignatures,
      )
    >
  >
  EnumSignatures;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Pointer<Uint32> rTypeSpecs,
        Uint32 cmax,
        Pointer<Uint32> pcTypeSpecs,
      )
    >
  >
  EnumTypeSpecs;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Pointer<Uint32> rStrings,
        Uint32 cmax,
        Pointer<Uint32> pcStrings,
      )
    >
  >
  EnumUserStrings;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 md,
        Uint32 ulParamSeq,
        Pointer<Uint32> ppd,
      )
    >
  >
  GetParamForMethodIndex;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Uint32 tk,
        Uint32 tkType,
        Pointer<Uint32> rCustomAttributes,
        Uint32 cMax,
        Pointer<Uint32> pcCustomAttributes,
      )
    >
  >
  EnumCustomAttributes;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 cv,
        Pointer<Uint32> ptkObj,
        Pointer<Uint32> ptkType,
        Pointer<Pointer> ppBlob,
        Pointer<Uint32> pcbSize,
      )
    >
  >
  GetCustomAttributeProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 tkResolutionScope,
        PCWSTR szName,
        Pointer<Uint32> ptr$,
      )
    >
  >
  FindTypeRef;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mb,
        Pointer<Uint32> pClass,
        PWSTR szMember,
        Uint32 cchMember,
        Pointer<Uint32> pchMember,
        Pointer<Uint32> pdwAttr,
        Pointer<Pointer<Uint8>> ppvSigBlob,
        Pointer<Uint32> pcbSigBlob,
        Pointer<Uint32> pulCodeRVA,
        Pointer<Uint32> pdwImplFlags,
        Pointer<Uint32> pdwCPlusTypeFlag,
        Pointer<Pointer> ppValue,
        Pointer<Uint32> pcchValue,
      )
    >
  >
  GetMemberProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mb,
        Pointer<Uint32> pClass,
        PWSTR szField,
        Uint32 cchField,
        Pointer<Uint32> pchField,
        Pointer<Uint32> pdwAttr,
        Pointer<Pointer<Uint8>> ppvSigBlob,
        Pointer<Uint32> pcbSigBlob,
        Pointer<Uint32> pdwCPlusTypeFlag,
        Pointer<Pointer> ppValue,
        Pointer<Uint32> pcchValue,
      )
    >
  >
  GetFieldProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 prop,
        Pointer<Uint32> pClass,
        PCWSTR szProperty,
        Uint32 cchProperty,
        Pointer<Uint32> pchProperty,
        Pointer<Uint32> pdwPropFlags,
        Pointer<Pointer<Uint8>> ppvSig,
        Pointer<Uint32> pbSig,
        Pointer<Uint32> pdwCPlusTypeFlag,
        Pointer<Pointer> ppDefaultValue,
        Pointer<Uint32> pcchDefaultValue,
        Pointer<Uint32> pmdSetter,
        Pointer<Uint32> pmdGetter,
        Pointer<Uint32> rmdOtherMethod,
        Uint32 cMax,
        Pointer<Uint32> pcOtherMethod,
      )
    >
  >
  GetPropertyProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 tk,
        Pointer<Uint32> pmd,
        Pointer<Uint32> pulSequence,
        PWSTR szName,
        Uint32 cchName,
        Pointer<Uint32> pchName,
        Pointer<Uint32> pdwAttr,
        Pointer<Uint32> pdwCPlusTypeFlag,
        Pointer<Pointer> ppValue,
        Pointer<Uint32> pcchValue,
      )
    >
  >
  GetParamProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 tkObj,
        PCWSTR szName,
        Pointer<Pointer> ppData,
        Pointer<Uint32> pcbData,
      )
    >
  >
  GetCustomAttributeByName;
  external Pointer<
    NativeFunction<BOOL Function(VTablePointer this$, Uint32 tk)>
  >
  IsValidToken;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 tdNestedClass,
        Pointer<Uint32> ptdEnclosingClass,
      )
    >
  >
  GetNestedClassProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer pvSig,
        Uint32 cbSig,
        Pointer<Uint32> pCallConv,
      )
    >
  >
  GetNativeCallConvFromSig;
  external Pointer<
    NativeFunction<
      Int32 Function(VTablePointer this$, Uint32 pd, Pointer<Int32> pbGlobal)
    >
  >
  IsGlobal;
}
