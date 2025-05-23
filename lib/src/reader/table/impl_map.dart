import 'package:meta/meta.dart';

import '../../attributes.dart';
import '../../common.dart';
import '../../exception.dart';
import '../codes.dart';
import '../metadata_index.dart';
import '../metadata_table.dart';
import '../row.dart';
import 'module_ref.dart';

/// Represents a row in the `ImplMap` metadata table.
///
/// The fields are populated by interpreting the binary metadata as specified in
/// ECMA-335 `§II.22.22`.
///
/// The `ImplMap` table has the following columns:
///  - **MappingFlags** (2-byte bitmask of PInvokeAttributes)
///  - **MemberForwarded** (MemberForwarded Coded Index)
///  - **ImportName** (String Heap Index)
///  - **ImportScope** (ModuleRef Table Index)
final class ImplMap extends Row {
  ImplMap(super.metadataIndex, super.readerIndex, super.index);

  @override
  MetadataTable get table => MetadataTable.implMap;

  @override
  int get token => (MetadataTableId.implMap << 24) | index;

  /// The flags describing how the unmanaged call should be performed.
  late final flags = PInvokeAttributes(readUint16(0));

  /// The character set used when marshaling strings for the unmanaged call.
  late final CharSet charSet = switch (flags & PInvokeAttributes.charSetMask) {
    PInvokeAttributes.charSetAnsi => CharSet.ansi,
    PInvokeAttributes.charSetUnicode => CharSet.unicode,
    PInvokeAttributes.charSetAuto => CharSet.auto,
    _ => CharSet.notSpecified,
  };

  /// The calling convention used by the unmanaged function.
  late final CallConv callConv = switch (flags &
      PInvokeAttributes.callConvMask) {
    PInvokeAttributes.callConvPlatformApi => CallConv.platformApi,
    PInvokeAttributes.callConvCdecl => CallConv.cdecl,
    PInvokeAttributes.callConvStdCall => CallConv.stdcall,
    PInvokeAttributes.callConvThisCall => CallConv.thiscall,
    PInvokeAttributes.callConvFastCall => CallConv.fastcall,
    _ => throw WinmdException(
      'Unknown calling convention: ${flags & PInvokeAttributes.callConvMask}',
    ),
  };

  /// The managed member that is forwarded to an unmanaged implementation.
  late final MemberForwarded memberForwarded = decode<MemberForwarded>(1);

  /// The name of the unmanaged function being imported.
  late final String importName = readString(2);

  /// The external module that contains the unmanaged function.
  late final ModuleRef importScope = readRow<ModuleRef>(3);

  @override
  String toString() => 'ImplMap(importName: $importName)';
}

@internal
final class ImplMapCompanion extends RowCompanion<ImplMap> {
  const ImplMapCompanion();

  @override
  ImplMap Function(MetadataIndex, int, int) get constructor => ImplMap.new;

  @override
  MetadataTable get table => MetadataTable.implMap;
}
