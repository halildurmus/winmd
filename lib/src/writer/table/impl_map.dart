import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../attributes.dart';
import '../../common.dart';
import '../codes.dart';
import '../heap/metadata_heap.dart';
import '../helpers.dart';
import '../row.dart';
import '../table_stream.dart';
import 'index.dart';

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
final class ImplMap implements Row {
  const ImplMap({
    required this.memberForwarded,
    required this.importName,
    required this.importScope,
    this.mappingFlags = const PInvokeAttributes(0),
  });

  final PInvokeAttributes mappingFlags;
  final MemberForwarded memberForwarded;
  final StringIndex importName;
  final ModuleRefIndex importScope;

  @override
  void serialize(BytesBuilder buffer, TableStream stream) {
    buffer
      ..writeUint16(mappingFlags)
      ..writeCodedIndex(memberForwarded, stream)
      ..writeHeapIndex(importName, stream)
      ..writeTableIndex(importScope, stream);
  }
}

@internal
final class ImplMapCompanion extends RowCompanion<ImplMap> {
  const ImplMapCompanion();

  @override
  MetadataTableId get tableId => MetadataTableId.implMap;
}
