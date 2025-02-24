// ignore_for_file: avoid_positional_boolean_parameters
// ignore_for_file: constant_identifier_names, non_constant_identifier_names
// ignore_for_file: unused_import

import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import '../exception.dart';
import '../guid.dart';
import '../macros.dart';
import '../structs.dart';
import '../types.dart';
import 'iunknown.dart';

final IID_IMetaDataAssemblyImport = Guid.fromComponents(
  0xee62470b,
  0xe94b,
  0x424e,
  Uint8List.fromList(const [0x9b, 0x7c, 0x2f, 0x0, 0xc9, 0x24, 0x9f, 0x93]),
);

class IMetaDataAssemblyImport extends IUnknown {
  IMetaDataAssemblyImport(super.ptr)
    : _vtable = ptr.value.cast<IMetaDataAssemblyImportVtbl>().ref;

  final IMetaDataAssemblyImportVtbl _vtable;
  late final _GetAssemblyPropsFn =
      _vtable.GetAssemblyProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Pointer>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<ASSEMBLYMETADATA>,
          Pointer<Uint32>,
        )
      >();
  late final _GetAssemblyRefPropsFn =
      _vtable.GetAssemblyRefProps.asFunction<
        int Function(
          VTablePointer,
          int,
          Pointer<Pointer>,
          Pointer<Uint32>,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<ASSEMBLYMETADATA>,
          Pointer<Pointer>,
          Pointer<Uint32>,
          Pointer<Uint32>,
        )
      >();
  late final _GetFilePropsFn =
      _vtable.GetFileProps.asFunction<
        int Function(
          VTablePointer,
          int,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Pointer>,
          Pointer<Uint32>,
          Pointer<Uint32>,
        )
      >();
  late final _GetExportedTypePropsFn =
      _vtable.GetExportedTypeProps.asFunction<
        int Function(
          VTablePointer,
          int,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
        )
      >();
  late final _GetManifestResourcePropsFn =
      _vtable.GetManifestResourceProps.asFunction<
        int Function(
          VTablePointer,
          int,
          PWSTR,
          int,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
          Pointer<Uint32>,
        )
      >();
  late final _EnumAssemblyRefsFn =
      _vtable.EnumAssemblyRefs.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumFilesFn =
      _vtable.EnumFiles.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumExportedTypesFn =
      _vtable.EnumExportedTypes.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _EnumManifestResourcesFn =
      _vtable.EnumManifestResources.asFunction<
        int Function(
          VTablePointer,
          Pointer<Pointer>,
          Pointer<Uint32>,
          int,
          Pointer<Uint32>,
        )
      >();
  late final _GetAssemblyFromScopeFn =
      _vtable.GetAssemblyFromScope.asFunction<
        int Function(VTablePointer, Pointer<Uint32>)
      >();
  late final _FindExportedTypeByNameFn =
      _vtable.FindExportedTypeByName.asFunction<
        int Function(VTablePointer, PCWSTR, int, Pointer<Uint32>)
      >();
  late final _FindManifestResourceByNameFn =
      _vtable.FindManifestResourceByName.asFunction<
        int Function(VTablePointer, PCWSTR, Pointer<Uint32>)
      >();
  late final _CloseEnumFn =
      _vtable.CloseEnum.asFunction<void Function(VTablePointer, Pointer)>();
  late final _FindAssembliesByNameFn =
      _vtable.FindAssembliesByName.asFunction<
        int Function(
          VTablePointer,
          PCWSTR,
          PCWSTR,
          PCWSTR,
          Pointer<VTablePointer>,
          int,
          Pointer<Uint32>,
        )
      >();

  @pragma('vm:prefer-inline')
  void getAssemblyProps(
    int mda,
    Pointer<Pointer> ppbPublicKey,
    Pointer<Uint32> pcbPublicKey,
    Pointer<Uint32> pulHashAlgId,
    PWSTR? szName,
    int cchName,
    Pointer<Uint32> pchName,
    Pointer<ASSEMBLYMETADATA> pMetaData,
    Pointer<Uint32> pdwAssemblyFlags,
  ) {
    final hr$ = HRESULT(
      _GetAssemblyPropsFn(
        ptr,
        mda,
        ppbPublicKey,
        pcbPublicKey,
        pulHashAlgId,
        szName ?? nullptr,
        cchName,
        pchName,
        pMetaData,
        pdwAssemblyFlags,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getAssemblyRefProps(
    int mdar,
    Pointer<Pointer> ppbPublicKeyOrToken,
    Pointer<Uint32> pcbPublicKeyOrToken,
    PWSTR? szName,
    int cchName,
    Pointer<Uint32> pchName,
    Pointer<ASSEMBLYMETADATA> pMetaData,
    Pointer<Pointer> ppbHashValue,
    Pointer<Uint32> pcbHashValue,
    Pointer<Uint32> pdwAssemblyRefFlags,
  ) {
    final hr$ = HRESULT(
      _GetAssemblyRefPropsFn(
        ptr,
        mdar,
        ppbPublicKeyOrToken,
        pcbPublicKeyOrToken,
        szName ?? nullptr,
        cchName,
        pchName,
        pMetaData,
        ppbHashValue,
        pcbHashValue,
        pdwAssemblyRefFlags,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getFileProps(
    int mdf,
    PWSTR? szName,
    int cchName,
    Pointer<Uint32> pchName,
    Pointer<Pointer> ppbHashValue,
    Pointer<Uint32> pcbHashValue,
    Pointer<Uint32> pdwFileFlags,
  ) {
    final hr$ = HRESULT(
      _GetFilePropsFn(
        ptr,
        mdf,
        szName ?? nullptr,
        cchName,
        pchName,
        ppbHashValue,
        pcbHashValue,
        pdwFileFlags,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getExportedTypeProps(
    int mdct,
    PWSTR? szName,
    int cchName,
    Pointer<Uint32> pchName,
    Pointer<Uint32> ptkImplementation,
    Pointer<Uint32> ptkTypeDef,
    Pointer<Uint32> pdwExportedTypeFlags,
  ) {
    final hr$ = HRESULT(
      _GetExportedTypePropsFn(
        ptr,
        mdct,
        szName ?? nullptr,
        cchName,
        pchName,
        ptkImplementation,
        ptkTypeDef,
        pdwExportedTypeFlags,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getManifestResourceProps(
    int mdmr,
    PWSTR? szName,
    int cchName,
    Pointer<Uint32> pchName,
    Pointer<Uint32> ptkImplementation,
    Pointer<Uint32> pdwOffset,
    Pointer<Uint32> pdwResourceFlags,
  ) {
    final hr$ = HRESULT(
      _GetManifestResourcePropsFn(
        ptr,
        mdmr,
        szName ?? nullptr,
        cchName,
        pchName,
        ptkImplementation,
        pdwOffset,
        pdwResourceFlags,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumAssemblyRefs(
    Pointer<Pointer> phEnum,
    Pointer<Uint32> rAssemblyRefs,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumAssemblyRefsFn(ptr, phEnum, rAssemblyRefs, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumFiles(
    Pointer<Pointer> phEnum,
    Pointer<Uint32> rFiles,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(_EnumFilesFn(ptr, phEnum, rFiles, cMax, pcTokens));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumExportedTypes(
    Pointer<Pointer> phEnum,
    Pointer<Uint32> rExportedTypes,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumExportedTypesFn(ptr, phEnum, rExportedTypes, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void enumManifestResources(
    Pointer<Pointer> phEnum,
    Pointer<Uint32> rManifestResources,
    int cMax,
    Pointer<Uint32> pcTokens,
  ) {
    final hr$ = HRESULT(
      _EnumManifestResourcesFn(ptr, phEnum, rManifestResources, cMax, pcTokens),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void getAssemblyFromScope(Pointer<Uint32> ptkAssembly) {
    final hr$ = HRESULT(_GetAssemblyFromScopeFn(ptr, ptkAssembly));
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void findExportedTypeByName(
    PCWSTR szName,
    int mdtExportedType,
    Pointer<Uint32> ptkExportedType,
  ) {
    final hr$ = HRESULT(
      _FindExportedTypeByNameFn(ptr, szName, mdtExportedType, ptkExportedType),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void findManifestResourceByName(
    PCWSTR szName,
    Pointer<Uint32> ptkManifestResource,
  ) {
    final hr$ = HRESULT(
      _FindManifestResourceByNameFn(ptr, szName, ptkManifestResource),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @pragma('vm:prefer-inline')
  void closeEnum(Pointer hEnum) => _CloseEnumFn(ptr, hEnum);

  @pragma('vm:prefer-inline')
  void findAssembliesByName(
    PCWSTR szAppBase,
    PCWSTR szPrivateBin,
    PCWSTR szAssemblyName,
    Pointer<VTablePointer> ppIUnk,
    int cMax,
    Pointer<Uint32> pcAssemblies,
  ) {
    final hr$ = HRESULT(
      _FindAssembliesByNameFn(
        ptr,
        szAppBase,
        szPrivateBin,
        szAssemblyName,
        ppIUnk,
        cMax,
        pcAssemblies,
      ),
    );
    if (FAILED(hr$)) throw WindowsException(hr$);
  }

  @override
  String toString() => 'IMetaDataAssemblyImport(ptr: $ptr)';
}

base class IMetaDataAssemblyImportVtbl extends Struct {
  external IUnknownVtbl base$;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mda,
        Pointer<Pointer> ppbPublicKey,
        Pointer<Uint32> pcbPublicKey,
        Pointer<Uint32> pulHashAlgId,
        PWSTR szName,
        Uint32 cchName,
        Pointer<Uint32> pchName,
        Pointer<ASSEMBLYMETADATA> pMetaData,
        Pointer<Uint32> pdwAssemblyFlags,
      )
    >
  >
  GetAssemblyProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mdar,
        Pointer<Pointer> ppbPublicKeyOrToken,
        Pointer<Uint32> pcbPublicKeyOrToken,
        PWSTR szName,
        Uint32 cchName,
        Pointer<Uint32> pchName,
        Pointer<ASSEMBLYMETADATA> pMetaData,
        Pointer<Pointer> ppbHashValue,
        Pointer<Uint32> pcbHashValue,
        Pointer<Uint32> pdwAssemblyRefFlags,
      )
    >
  >
  GetAssemblyRefProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mdf,
        PWSTR szName,
        Uint32 cchName,
        Pointer<Uint32> pchName,
        Pointer<Pointer> ppbHashValue,
        Pointer<Uint32> pcbHashValue,
        Pointer<Uint32> pdwFileFlags,
      )
    >
  >
  GetFileProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mdct,
        PWSTR szName,
        Uint32 cchName,
        Pointer<Uint32> pchName,
        Pointer<Uint32> ptkImplementation,
        Pointer<Uint32> ptkTypeDef,
        Pointer<Uint32> pdwExportedTypeFlags,
      )
    >
  >
  GetExportedTypeProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Uint32 mdmr,
        PWSTR szName,
        Uint32 cchName,
        Pointer<Uint32> pchName,
        Pointer<Uint32> ptkImplementation,
        Pointer<Uint32> pdwOffset,
        Pointer<Uint32> pdwResourceFlags,
      )
    >
  >
  GetManifestResourceProps;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Pointer<Uint32> rAssemblyRefs,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumAssemblyRefs;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Pointer<Uint32> rFiles,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumFiles;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Pointer<Uint32> rExportedTypes,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumExportedTypes;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        Pointer<Pointer> phEnum,
        Pointer<Uint32> rManifestResources,
        Uint32 cMax,
        Pointer<Uint32> pcTokens,
      )
    >
  >
  EnumManifestResources;
  external Pointer<
    NativeFunction<
      Int32 Function(VTablePointer this$, Pointer<Uint32> ptkAssembly)
    >
  >
  GetAssemblyFromScope;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        PCWSTR szName,
        Uint32 mdtExportedType,
        Pointer<Uint32> ptkExportedType,
      )
    >
  >
  FindExportedTypeByName;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        PCWSTR szName,
        Pointer<Uint32> ptkManifestResource,
      )
    >
  >
  FindManifestResourceByName;
  external Pointer<
    NativeFunction<Void Function(VTablePointer this$, Pointer hEnum)>
  >
  CloseEnum;
  external Pointer<
    NativeFunction<
      Int32 Function(
        VTablePointer this$,
        PCWSTR szAppBase,
        PCWSTR szPrivateBin,
        PCWSTR szAssemblyName,
        Pointer<VTablePointer> ppIUnk,
        Uint32 cMax,
        Pointer<Uint32> pcAssemblies,
      )
    >
  >
  FindAssembliesByName;
}
