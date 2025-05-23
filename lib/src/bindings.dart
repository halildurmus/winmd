// ignore_for_file: camel_case_extensions, camel_case_types
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:ffi';

import 'package:ffi/ffi.dart';

typedef BYTE = Uint8;
typedef DWORD = Uint32;
typedef HANDLE = IntPtr;
typedef HRESULT = Int32;
typedef PWSTR = Pointer<Utf16>;

const IMAGE_DOS_SIGNATURE = 23117;
const IMAGE_NT_SIGNATURE = 17744;

const S_OK = 0;

Pointer<GUID> get FOLDERID_LocalAppData {
  final guid = malloc<GUID>();
  guid.ref
    ..Data1 = 0xF1B32785
    ..Data2 = 0x6FBA
    ..Data3 = 0x4FCF
    ..Data4[0] = 0x9D
    ..Data4[1] = 0x55
    ..Data4[2] = 0x7B
    ..Data4[3] = 0x8E
    ..Data4[4] = 0x7F
    ..Data4[5] = 0x15
    ..Data4[6] = 0x70
    ..Data4[7] = 0x91;
  return guid;
}

/// Represents the calling convention used in method signatures, as defined by
/// ECMA-335.
///
/// Calling conventions specify how arguments are passed to methods, how the
/// return value is retrieved, and how the method invocation is represented in
/// metadata.
extension type const CallingConvention(int _) implements int {
  /// Indicates a default calling convention.
  static const DEFAULT = CallingConvention(0x00);

  /// Indicates the `C` calling convention.
  ///
  /// Parameters are pushed from right to left and the caller cleans the stack.
  static const C = CallingConvention(0x01);

  /// Indicates the `stdcall` calling convention.
  ///
  /// Parameters are pushed from right to left and the callee cleans the stack.
  static const STDCALL = CallingConvention(0x02);

  /// Indicates the `thiscall` calling convention.
  ///
  /// Used for calling C++ instance methods; `this` is passed in ECX.
  static const THISCALL = CallingConvention(0x03);

  /// Indicates the `fastcall` calling convention.
  ///
  /// Arguments are passed via registers when possible.
  static const FASTCALL = CallingConvention(0x04);

  /// Indicates that the method takes a variable number of parameters.
  static const VARARG = CallingConvention(0x05);

  /// Indicates that the call is to a field.
  static const FIELD = CallingConvention(0x06);

  /// Indicates that the call is to a local method.
  static const LOCAL_SIG = CallingConvention(0x07);

  /// Indicates that the call is to a property.
  static const PROPERTY = CallingConvention(0x08);

  /// Indicates a generic method instantiation.
  static const GENERICINST = CallingConvention(0x0a);

  /// Indicates a generic method signature with an explicit number of type
  /// arguments.
  static const GENERIC = CallingConvention(0x10);

  /// Indicates that the top bit describes a `this` parameter.
  static const HASTHIS = CallingConvention(0x20);

  /// Indicates that a `this` parameter is explicitly described in the
  /// signature.
  static const EXPLICITTHIS = CallingConvention(0x40);

  /// Whether this instance has all the bit fields specified in [other].
  bool has(CallingConvention other) => this & other == other;

  CallingConvention operator |(CallingConvention other) =>
      CallingConvention(_ | other._);
}

/// Specifies a common language runtime Type, a type modifier, or information
/// about a type in a metadata type signature.
extension type const ElementType(int _) implements int {}

///	Used internally.
const ELEMENT_TYPE_END = ElementType(0);

/// A void type.
const ELEMENT_TYPE_VOID = ElementType(1);

/// A boolean type.
const ELEMENT_TYPE_BOOLEAN = ElementType(2);

/// A character type.
const ELEMENT_TYPE_CHAR = ElementType(3);

/// A signed 1-byte integer.
const ELEMENT_TYPE_I1 = ElementType(4);

/// An unsigned 1-byte integer.
const ELEMENT_TYPE_U1 = ElementType(5);

/// A signed 2-byte integer.
const ELEMENT_TYPE_I2 = ElementType(6);

/// An unsigned 2-byte integer.
const ELEMENT_TYPE_U2 = ElementType(7);

/// A signed 4-byte integer.
const ELEMENT_TYPE_I4 = ElementType(8);

/// An unsigned 4-byte integer.
const ELEMENT_TYPE_U4 = ElementType(9);

/// A signed 8-byte integer.
const ELEMENT_TYPE_I8 = ElementType(10);

/// An unsigned 8-byte integer.
const ELEMENT_TYPE_U8 = ElementType(11);

/// A 4-byte floating point.
const ELEMENT_TYPE_R4 = ElementType(12);

/// An 8-byte floating point.
const ELEMENT_TYPE_R8 = ElementType(13);

/// A System.String type.
const ELEMENT_TYPE_STRING = ElementType(14);

/// A pointer type modifier.
const ELEMENT_TYPE_PTR = ElementType(15);

/// A reference type modifier.
const ELEMENT_TYPE_BYREF = ElementType(16);

/// A value type modifier.
const ELEMENT_TYPE_VALUETYPE = ElementType(17);

/// A class type modifier.
const ELEMENT_TYPE_CLASS = ElementType(18);

/// A class variable type modifier.
const ELEMENT_TYPE_VAR = ElementType(19);

/// A multi-dimensional array type modifier.
const ELEMENT_TYPE_ARRAY = ElementType(20);

/// A type modifier for generic types.
const ELEMENT_TYPE_GENERICINST = ElementType(21);

/// A typed reference.
const ELEMENT_TYPE_TYPEDBYREF = ElementType(22);

/// Size of a native integer.
const ELEMENT_TYPE_I = ElementType(24);

/// Size of an unsigned native integer.
const ELEMENT_TYPE_U = ElementType(25);

/// A pointer to a function.
const ELEMENT_TYPE_FNPTR = ElementType(27);

/// A System.Object type.
const ELEMENT_TYPE_OBJECT = ElementType(28);

/// A single-dimensional, zero lower-bound array type modifier.
const ELEMENT_TYPE_SZARRAY = ElementType(29);

/// A method variable type modifier.
const ELEMENT_TYPE_MVAR = ElementType(30);

/// A C language required modifier.
const ELEMENT_TYPE_CMOD_REQD = ElementType(31);

/// A C language optional modifier.
const ELEMENT_TYPE_CMOD_OPT = ElementType(32);

/// Used internally.
const ELEMENT_TYPE_INTERNAL = ElementType(33);

/// An invalid type.
const ELEMENT_TYPE_MAX = ElementType(34);

/// Used internally.
const ELEMENT_TYPE_MODIFIER = ElementType(64);

/// A type modifier that is a sentinel for a list of a variable number of
/// parameters.
const ELEMENT_TYPE_SENTINEL = ElementType(65);

/// Used internally.
const ELEMENT_TYPE_PINNED = ElementType(69);

/// Used in custom attributes to indicate a field.
const ELEMENT_TYPE_FIELD = ElementType(0x53);

/// Used in custom attributes to indicate a property.
const ELEMENT_TYPE_PROPERTY = ElementType(0x54);

/// Used in custom attributes to specify an enum.
const ELEMENT_TYPE_ENUM = ElementType(0x55);

extension type const IMAGE_DIRECTORY_ENTRY(int _) implements int {}

const IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR = IMAGE_DIRECTORY_ENTRY(14);

extension type const IMAGE_DLL_CHARACTERISTICS(int _) implements int {
  IMAGE_DLL_CHARACTERISTICS operator |(IMAGE_DLL_CHARACTERISTICS other) =>
      IMAGE_DLL_CHARACTERISTICS(_ | other._);
}

const IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE = IMAGE_DLL_CHARACTERISTICS(64);
const IMAGE_DLLCHARACTERISTICS_NX_COMPAT = IMAGE_DLL_CHARACTERISTICS(256);
const IMAGE_DLLCHARACTERISTICS_NO_SEH = IMAGE_DLL_CHARACTERISTICS(1024);

extension type const IMAGE_FILE_CHARACTERISTICS(int _) implements int {
  IMAGE_FILE_CHARACTERISTICS operator |(IMAGE_FILE_CHARACTERISTICS other) =>
      IMAGE_FILE_CHARACTERISTICS(_ | other._);
}

const IMAGE_FILE_EXECUTABLE_IMAGE = IMAGE_FILE_CHARACTERISTICS(2);
const IMAGE_FILE_32BIT_MACHINE = IMAGE_FILE_CHARACTERISTICS(256);
const IMAGE_FILE_DLL = IMAGE_FILE_CHARACTERISTICS(8192);

extension type const IMAGE_FILE_MACHINE(int _) implements int {}

const IMAGE_FILE_MACHINE_I386 = IMAGE_FILE_MACHINE(332);

extension type const IMAGE_OPTIONAL_HEADER_MAGIC(int _) implements int {}

const IMAGE_NT_OPTIONAL_HDR32_MAGIC = IMAGE_OPTIONAL_HEADER_MAGIC(267);
const IMAGE_NT_OPTIONAL_HDR64_MAGIC = IMAGE_OPTIONAL_HEADER_MAGIC(523);

extension type const IMAGE_SECTION_CHARACTERISTICS(int _) implements int {}

extension type const IMAGE_SUBSYSTEM(int _) implements int {}

const IMAGE_SUBSYSTEM_WINDOWS_CUI = IMAGE_SUBSYSTEM(3);

/// Contains values that describe native unmanaged types.
extension type const NativeType(int _) implements int {}

/// A 4-byte Boolean value, where TRUE is non-zero and FALSE is zero.
const NATIVE_TYPE_BOOLEAN = NativeType(0x02);

/// A signed 8-bit integer value.
const NATIVE_TYPE_I1 = NativeType(0x03);

/// An unsigned 8-bit integer value.
const NATIVE_TYPE_U1 = NativeType(0x04);

/// A signed 16-bit integer value.
const NATIVE_TYPE_I2 = NativeType(0x05);

/// An unsigned 16-bit integer value.
const NATIVE_TYPE_U2 = NativeType(0x06);

/// A signed 32-bit integer value.
const NATIVE_TYPE_I4 = NativeType(0x07);

/// An unsigned 32-bit integer value.
const NATIVE_TYPE_U4 = NativeType(0x08);

/// A signed 64-bit integer value.
const NATIVE_TYPE_I8 = NativeType(0x09);

/// An unsigned 64-bit integer value.
const NATIVE_TYPE_U8 = NativeType(0x0a);

/// A 4-byte floating-point numeric value.
const NATIVE_TYPE_R4 = NativeType(0x0b);

/// An 8-byte floating-point numeric value.
const NATIVE_TYPE_R8 = NativeType(0x0c);

/// An LPSTR string value.
const NATIVE_TYPE_LPSTR = NativeType(0x14);

/// An LPWSTR string value.
const NATIVE_TYPE_LPWSTR = NativeType(0x15);

/// A native 16-bit signed integer value.
const NATIVE_TYPE_INT = NativeType(0x1f);

/// A native 16-bit unsigned integer value.
const NATIVE_TYPE_UINT = NativeType(0x20);

/// A function pointer.
const NATIVE_TYPE_FUNC = NativeType(0x26);

/// A reference to an array with members of an unspecified type.
const NATIVE_TYPE_ARRAY = NativeType(0x2a);

/// An invalid value.
const NATIVE_TYPE_MAX = NativeType(0x50);

@Packed(4)
final class GUID extends Struct {
  @Uint32()
  external int Data1;

  @Uint16()
  external int Data2;

  @Uint16()
  external int Data3;

  @Array(8)
  external Array<Uint8> Data4;
}

final class IMAGE_COR20_HEADER extends Struct {
  @Uint32()
  external int cb;

  @Uint16()
  external int MajorRuntimeVersion;

  @Uint16()
  external int MinorRuntimeVersion;

  external IMAGE_DATA_DIRECTORY MetaData;

  @Uint32()
  external int Flags;

  external IMAGE_COR20_HEADER_0 Anonymous;
  external IMAGE_DATA_DIRECTORY Resources;
  external IMAGE_DATA_DIRECTORY StrongNameSignature;
  external IMAGE_DATA_DIRECTORY CodeManagerTable;
  external IMAGE_DATA_DIRECTORY VTableFixups;
  external IMAGE_DATA_DIRECTORY ExportAddressTableJumps;
  external IMAGE_DATA_DIRECTORY ManagedNativeHeader;
}

sealed class IMAGE_COR20_HEADER_0 extends Union {
  @Uint32()
  external int EntryPointToken;

  @Uint32()
  external int EntryPointRVA;
}

extension IMAGE_COR20_HEADER_0_Extension on IMAGE_COR20_HEADER {
  int get EntryPointToken => Anonymous.EntryPointToken;
  set EntryPointToken(int value) => Anonymous.EntryPointToken = value;

  int get EntryPointRVA => Anonymous.EntryPointRVA;
  set EntryPointRVA(int value) => Anonymous.EntryPointRVA = value;
}

final class IMAGE_DATA_DIRECTORY extends Struct {
  @Uint32()
  external int VirtualAddress;

  @Uint32()
  external int Size;
}

@Packed(2)
final class IMAGE_DOS_HEADER extends Struct {
  @Uint16()
  external int e_magic;

  @Uint16()
  external int e_cblp;

  @Uint16()
  external int e_cp;

  @Uint16()
  external int e_crlc;

  @Uint16()
  external int e_cparhdr;

  @Uint16()
  external int e_minalloc;

  @Uint16()
  external int e_maxalloc;

  @Uint16()
  external int e_ss;

  @Uint16()
  external int e_sp;

  @Uint16()
  external int e_csum;

  @Uint16()
  external int e_ip;

  @Uint16()
  external int e_cs;

  @Uint16()
  external int e_lfarlc;

  @Uint16()
  external int e_ovno;

  @Array(4)
  external Array<Uint16> e_res;

  @Uint16()
  external int e_oemid;

  @Uint16()
  external int e_oeminfo;

  @Array(10)
  external Array<Uint16> e_res2;

  @Int32()
  external int e_lfanew;
}

final class IMAGE_FILE_HEADER extends Struct {
  @Uint16()
  external int _Machine;

  @Uint16()
  external int NumberOfSections;

  @Uint32()
  external int TimeDateStamp;

  @Uint32()
  external int PointerToSymbolTable;

  @Uint32()
  external int NumberOfSymbols;

  @Uint16()
  external int SizeOfOptionalHeader;

  @Uint16()
  external int _Characteristics;

  IMAGE_FILE_MACHINE get Machine => IMAGE_FILE_MACHINE(_Machine);
  set Machine(IMAGE_FILE_MACHINE value) => _Machine = value;

  IMAGE_FILE_CHARACTERISTICS get Characteristics =>
      IMAGE_FILE_CHARACTERISTICS(_Characteristics);
  set Characteristics(IMAGE_FILE_CHARACTERISTICS value) =>
      _Characteristics = value;
}

final class IMAGE_OPTIONAL_HEADER32 extends Struct {
  @Uint16()
  external int _Magic;

  @Uint8()
  external int MajorLinkerVersion;

  @Uint8()
  external int MinorLinkerVersion;

  @Uint32()
  external int SizeOfCode;

  @Uint32()
  external int SizeOfInitializedData;

  @Uint32()
  external int SizeOfUninitializedData;

  @Uint32()
  external int AddressOfEntryPoint;

  @Uint32()
  external int BaseOfCode;

  @Uint32()
  external int BaseOfData;

  @Uint32()
  external int ImageBase;

  @Uint32()
  external int SectionAlignment;

  @Uint32()
  external int FileAlignment;

  @Uint16()
  external int MajorOperatingSystemVersion;

  @Uint16()
  external int MinorOperatingSystemVersion;

  @Uint16()
  external int MajorImageVersion;

  @Uint16()
  external int MinorImageVersion;

  @Uint16()
  external int MajorSubsystemVersion;

  @Uint16()
  external int MinorSubsystemVersion;

  @Uint32()
  external int Win32VersionValue;

  @Uint32()
  external int SizeOfImage;

  @Uint32()
  external int SizeOfHeaders;

  @Uint32()
  external int CheckSum;

  @Uint16()
  external int _Subsystem;

  @Uint16()
  external int _DllCharacteristics;

  @Uint32()
  external int SizeOfStackReserve;

  @Uint32()
  external int SizeOfStackCommit;

  @Uint32()
  external int SizeOfHeapReserve;

  @Uint32()
  external int SizeOfHeapCommit;

  @Uint32()
  external int LoaderFlags;

  @Uint32()
  external int NumberOfRvaAndSizes;

  @Array(16)
  external Array<IMAGE_DATA_DIRECTORY> DataDirectory;

  IMAGE_OPTIONAL_HEADER_MAGIC get Magic => IMAGE_OPTIONAL_HEADER_MAGIC(_Magic);
  set Magic(IMAGE_OPTIONAL_HEADER_MAGIC value) => _Magic = value;

  IMAGE_SUBSYSTEM get Subsystem => IMAGE_SUBSYSTEM(_Subsystem);
  set Subsystem(IMAGE_SUBSYSTEM value) => _Subsystem = value;

  IMAGE_DLL_CHARACTERISTICS get DllCharacteristics =>
      IMAGE_DLL_CHARACTERISTICS(_DllCharacteristics);
  set DllCharacteristics(IMAGE_DLL_CHARACTERISTICS value) =>
      _DllCharacteristics = value;
}

@Packed(4)
final class IMAGE_OPTIONAL_HEADER64 extends Struct {
  @Uint16()
  external int _Magic;

  @Uint8()
  external int MajorLinkerVersion;

  @Uint8()
  external int MinorLinkerVersion;

  @Uint32()
  external int SizeOfCode;

  @Uint32()
  external int SizeOfInitializedData;

  @Uint32()
  external int SizeOfUninitializedData;

  @Uint32()
  external int AddressOfEntryPoint;

  @Uint32()
  external int BaseOfCode;

  @Uint64()
  external int ImageBase;

  @Uint32()
  external int SectionAlignment;

  @Uint32()
  external int FileAlignment;

  @Uint16()
  external int MajorOperatingSystemVersion;

  @Uint16()
  external int MinorOperatingSystemVersion;

  @Uint16()
  external int MajorImageVersion;

  @Uint16()
  external int MinorImageVersion;

  @Uint16()
  external int MajorSubsystemVersion;

  @Uint16()
  external int MinorSubsystemVersion;

  @Uint32()
  external int Win32VersionValue;

  @Uint32()
  external int SizeOfImage;

  @Uint32()
  external int SizeOfHeaders;

  @Uint32()
  external int CheckSum;

  @Uint16()
  external int _Subsystem;

  @Uint16()
  external int _DllCharacteristics;

  @Uint64()
  external int SizeOfStackReserve;

  @Uint64()
  external int SizeOfStackCommit;

  @Uint64()
  external int SizeOfHeapReserve;

  @Uint64()
  external int SizeOfHeapCommit;

  @Uint32()
  external int LoaderFlags;

  @Uint32()
  external int NumberOfRvaAndSizes;

  @Array(16)
  external Array<IMAGE_DATA_DIRECTORY> DataDirectory;

  IMAGE_OPTIONAL_HEADER_MAGIC get Magic => IMAGE_OPTIONAL_HEADER_MAGIC(_Magic);
  set Magic(IMAGE_OPTIONAL_HEADER_MAGIC value) => _Magic = value;

  IMAGE_SUBSYSTEM get Subsystem => IMAGE_SUBSYSTEM(_Subsystem);
  set Subsystem(IMAGE_SUBSYSTEM value) => _Subsystem = value;

  IMAGE_DLL_CHARACTERISTICS get DllCharacteristics =>
      IMAGE_DLL_CHARACTERISTICS(_DllCharacteristics);
  set DllCharacteristics(IMAGE_DLL_CHARACTERISTICS value) =>
      _DllCharacteristics = value;
}

final class IMAGE_SECTION_HEADER extends Struct {
  @Array(8)
  external Array<Uint8> Name;

  external IMAGE_SECTION_HEADER_0 Misc;

  @Uint32()
  external int VirtualAddress;

  @Uint32()
  external int SizeOfRawData;

  @Uint32()
  external int PointerToRawData;

  @Uint32()
  external int PointerToRelocations;

  @Uint32()
  external int PointerToLinenumbers;

  @Uint16()
  external int NumberOfRelocations;

  @Uint16()
  external int NumberOfLinenumbers;

  @Uint32()
  external int _Characteristics;

  IMAGE_SECTION_CHARACTERISTICS get Characteristics =>
      IMAGE_SECTION_CHARACTERISTICS(_Characteristics);
  set Characteristics(IMAGE_SECTION_CHARACTERISTICS value) =>
      _Characteristics = value;
}

sealed class IMAGE_SECTION_HEADER_0 extends Union {
  @Uint32()
  external int PhysicalAddress;

  @Uint32()
  external int VirtualSize;
}

extension IMAGE_SECTION_HEADER_0_Extension on IMAGE_SECTION_HEADER {
  int get PhysicalAddress => Misc.PhysicalAddress;
  set PhysicalAddress(int value) => Misc.PhysicalAddress = value;

  int get VirtualSize => Misc.VirtualSize;
  set VirtualSize(int value) => Misc.VirtualSize = value;
}

@Native<HRESULT Function(Pointer<GUID>, DWORD, HANDLE, Pointer<PWSTR>)>(
  isLeaf: true,
)
external int SHGetKnownFolderPath(
  Pointer<GUID> rfid,
  int dwFlags,
  int hToken,
  Pointer<PWSTR> ppszPath,
);
