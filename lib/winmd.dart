/// A [WinMD] parser based on the [ECMA-335] standard.
///
/// This library enables low-level introspection of `.winmd` files, which
/// describe Windows APIs in a language-independent format. Originally designed
/// for the Windows Runtime (WinRT), the format is now also used for metadata
/// associated with:
/// - **Win32 APIs** (via [win32metadata])
/// - **Windows Driver Kit (WDK)** APIs (via [wdkmetadata])
///
/// The primary use case for this library is to build Dart projections of native
/// Windows APIs, such as the [win32] package.
///
/// See also:
/// - [MetadataReader]
/// - [MetadataIndex]
/// - [MetadataLookup]
/// - [MetadataWriter]
/// - [WindowsMetadataLoader]
/// - [mdmerge]
///
/// [ECMA-335]: https://ecma-international.org/wp-content/uploads/ECMA-335_6th_edition_june_2012.pdf
/// [wdkmetadata]: https://github.com/microsoft/wdkmetadata
/// [win32]: https://pub.dev/packages/win32
/// [win32metadata]: https://github.com/microsoft/win32metadata
/// [WinMD]: https://learn.microsoft.com/en-us/uwp/winrt-cref/winmd-files
///
/// @docImport 'mdmerge.dart';
/// @docImport 'src/reader/metadata_index.dart';
/// @docImport 'src/reader/metadata_lookup.dart';
/// @docImport 'src/reader/metadata_reader.dart';
/// @docImport 'windows_metadata.dart';
/// @docImport 'writer.dart';
library;

export 'src/attribute_arg.dart';
export 'src/attributes.dart';
export 'src/bindings.dart'
    show
        CallingConvention,
        ELEMENT_TYPE_ARRAY,
        ELEMENT_TYPE_BOOLEAN,
        ELEMENT_TYPE_BYREF,
        ELEMENT_TYPE_CHAR,
        ELEMENT_TYPE_CLASS,
        ELEMENT_TYPE_CMOD_OPT,
        ELEMENT_TYPE_CMOD_REQD,
        ELEMENT_TYPE_ENUM,
        ELEMENT_TYPE_FIELD,
        ELEMENT_TYPE_FNPTR,
        ELEMENT_TYPE_GENERICINST,
        ELEMENT_TYPE_I,
        ELEMENT_TYPE_I1,
        ELEMENT_TYPE_I2,
        ELEMENT_TYPE_I4,
        ELEMENT_TYPE_I8,
        ELEMENT_TYPE_MAX,
        ELEMENT_TYPE_MVAR,
        ELEMENT_TYPE_OBJECT,
        ELEMENT_TYPE_PROPERTY,
        ELEMENT_TYPE_PTR,
        ELEMENT_TYPE_R4,
        ELEMENT_TYPE_R8,
        ELEMENT_TYPE_SENTINEL,
        ELEMENT_TYPE_STRING,
        ELEMENT_TYPE_SZARRAY,
        ELEMENT_TYPE_TYPEDBYREF,
        ELEMENT_TYPE_U,
        ELEMENT_TYPE_U1,
        ELEMENT_TYPE_U2,
        ELEMENT_TYPE_U4,
        ELEMENT_TYPE_U8,
        ELEMENT_TYPE_VALUETYPE,
        ELEMENT_TYPE_VAR,
        ELEMENT_TYPE_VOID,
        ElementType,
        NATIVE_TYPE_ARRAY,
        NATIVE_TYPE_BOOLEAN,
        NATIVE_TYPE_FUNC,
        NATIVE_TYPE_I1,
        NATIVE_TYPE_I2,
        NATIVE_TYPE_I4,
        NATIVE_TYPE_I8,
        NATIVE_TYPE_INT,
        NATIVE_TYPE_LPSTR,
        NATIVE_TYPE_LPWSTR,
        NATIVE_TYPE_MAX,
        NATIVE_TYPE_R4,
        NATIVE_TYPE_R8,
        NATIVE_TYPE_U1,
        NATIVE_TYPE_U2,
        NATIVE_TYPE_U4,
        NATIVE_TYPE_U8,
        NATIVE_TYPE_UINT,
        NativeType;
export 'src/compressed_integer.dart';
export 'src/culture.dart';
export 'src/exception.dart';
export 'src/guid.dart';
export 'src/logger.dart';
export 'src/marshalling_descriptor.dart';
export 'src/member_ref_signature.dart';
export 'src/metadata_type.dart';
export 'src/metadata_value.dart';
export 'src/method_signature.dart';
export 'src/property_sig.dart';
export 'src/reader/blob.dart';
export 'src/reader/codes.dart'
    hide
        CodedIndexCompanion,
        CustomAttributeTypeCompanion,
        HasConstantCompanion,
        HasCustomAttributeCompanion,
        HasDeclSecurityCompanion,
        HasFieldMarshalCompanion,
        HasSemanticsCompanion,
        ImplementationCompanion,
        MemberForwardedCompanion,
        MemberRefParentCompanion,
        MethodDefOrRefCompanion,
        ResolutionScopeCompanion,
        TypeDefOrRefCompanion,
        TypeOrMethodDefCompanion;
export 'src/reader/has_custom_attributes.dart';
export 'src/reader/heap/blob.dart';
export 'src/reader/heap/guid.dart';
export 'src/reader/heap/metadata_heap.dart';
export 'src/reader/heap/string.dart';
export 'src/reader/heap/user_string.dart';
export 'src/reader/metadata_index.dart';
export 'src/reader/metadata_lookup.dart';
export 'src/reader/metadata_reader.dart';
export 'src/reader/metadata_table.dart';
export 'src/reader/row.dart' hide RowCompanion;
export 'src/reader/table/assembly.dart' hide AssemblyCompanion;
export 'src/reader/table/assembly_os.dart' hide AssemblyOSCompanion;
export 'src/reader/table/assembly_processor.dart'
    hide AssemblyProcessorCompanion;
export 'src/reader/table/assembly_ref.dart' hide AssemblyRefCompanion;
export 'src/reader/table/assembly_ref_os.dart' hide AssemblyRefOSCompanion;
export 'src/reader/table/assembly_ref_processor.dart'
    hide AssemblyRefProcessorCompanion;
export 'src/reader/table/class_layout.dart' hide ClassLayoutCompanion;
export 'src/reader/table/constant.dart' hide ConstantCompanion;
export 'src/reader/table/custom_attribute.dart' hide CustomAttributeCompanion;
export 'src/reader/table/decl_security.dart' hide DeclSecurityCompanion;
export 'src/reader/table/event.dart' hide EventCompanion;
export 'src/reader/table/event_map.dart' hide EventMapCompanion;
export 'src/reader/table/exported_type.dart' hide ExportedTypeCompanion;
export 'src/reader/table/field.dart' hide FieldCompanion;
export 'src/reader/table/field_layout.dart' hide FieldLayoutCompanion;
export 'src/reader/table/field_marshal.dart' hide FieldMarshalCompanion;
export 'src/reader/table/field_rva.dart' hide FieldRVACompanion;
export 'src/reader/table/file.dart' hide FileCompanion;
export 'src/reader/table/generic_param.dart' hide GenericParamCompanion;
export 'src/reader/table/generic_param_constraint.dart'
    hide GenericParamConstraintCompanion;
export 'src/reader/table/impl_map.dart' hide ImplMapCompanion;
export 'src/reader/table/interface_impl.dart' hide InterfaceImplCompanion;
export 'src/reader/table/manifest_resource.dart' hide ManifestResourceCompanion;
export 'src/reader/table/member_ref.dart' hide MemberRefCompanion;
export 'src/reader/table/method_def.dart' hide MethodDefCompanion;
export 'src/reader/table/method_impl.dart' hide MethodImplCompanion;
export 'src/reader/table/method_semantics.dart' hide MethodSemanticsCompanion;
export 'src/reader/table/method_spec.dart' hide MethodSpecCompanion;
export 'src/reader/table/module.dart' hide ModuleCompanion;
export 'src/reader/table/module_ref.dart' hide ModuleRefCompanion;
export 'src/reader/table/nested_class.dart' hide NestedClassCompanion;
export 'src/reader/table/param.dart' hide ParamCompanion;
export 'src/reader/table/property.dart' hide PropertyCompanion;
export 'src/reader/table/property_map.dart' hide PropertyMapCompanion;
export 'src/reader/table/stand_alone_sig.dart' hide StandAloneSigCompanion;
export 'src/reader/table/type_def.dart' hide TypeDefCompanion;
export 'src/reader/table/type_ref.dart' hide TypeRefCompanion;
export 'src/reader/table/type_spec.dart' hide TypeSpecCompanion;
export 'src/reader/table_stream.dart';
export 'src/reader/type_category.dart';
export 'src/stand_alone_signature.dart';
export 'src/type_name.dart';
