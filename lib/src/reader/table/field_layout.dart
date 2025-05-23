import 'package:meta/meta.dart';

import '../../common.dart';
import '../metadata_index.dart';
import '../metadata_table.dart';
import '../row.dart';
import 'field.dart';

/// Represents a row in the `FieldLayout` metadata table.
///
/// The fields are populated by interpreting the binary metadata as specified in
/// ECMA-335 `§II.22.16`.
///
/// The `FieldLayout` table has the following columns:
///  - **Offset** (4-byte constant)
///  - **Field** (Field Table Index)
final class FieldLayout extends Row {
  FieldLayout(super.metadataIndex, super.readerIndex, super.index);

  @override
  MetadataTable get table => MetadataTable.fieldLayout;

  @override
  int get token => (MetadataTableId.fieldLayout << 24) | index;

  /// The byte offset of the field within its containing type.
  ///
  /// This value specifies how many bytes from the start of the type's instance
  /// data the field's storage begins.
  late final int offset = readUint32(0);

  /// The [Field] to which this layout information applies.
  late final Field field = readRow<Field>(1);

  @override
  String toString() => 'FieldLayout(offset: $offset, field: $field)';
}

@internal
final class FieldLayoutCompanion extends RowCompanion<FieldLayout> {
  const FieldLayoutCompanion();

  @override
  FieldLayout Function(MetadataIndex, int, int) get constructor =>
      FieldLayout.new;

  @override
  MetadataTable get table => MetadataTable.fieldLayout;
}
