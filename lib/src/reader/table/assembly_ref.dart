import '../../attributes.dart';
import '../../culture.dart';
import '../metadata_index.dart';
import '../metadata_table.dart';
import '../row.dart';

/// Represents an `AssemblyRef` metadata table entry, describing a reference to
/// an external assembly.
///
/// This class models a single row in the `AssemblyRef` table. The fields are
/// populated by interpreting the binary metadata as specified in ECMA-335
/// `§II.22.5`.
///
/// The `AssemblyRef` table has the following columns:
///  - **MajorVersion** (2-byte value)
///  - **MinorVersion** (2-byte value)
///  - **BuildNumber** (2-byte value)
///  - **RevisionNumber** (2-byte value)
///  - **Flags** (4-byte value, AssemblyFlags)
///  - **PublicKeyOrToken** (Blob Heap Index)
///  - **Name** (String Heap Index)
///  - **Culture** (String Heap Index)
///  - **HashValue** (Blob Heap Index)
final class AssemblyRef extends Row {
  AssemblyRef(super.metadataIndex, super.readerIndex, super.position);

  @override
  MetadataTable get table => MetadataTable.assemblyRef;

  /// The major version of the referenced assembly.
  late final majorVersion = readUint16(0);

  /// The minor version of the referenced assembly.
  late final minorVersion = readUint16(0, 2);

  /// The build number of the referenced assembly.
  late final buildNumber = readUint16(0, 4);

  /// The revision number of the referenced assembly.
  late final revisionNumber = readUint16(0, 6);

  /// The flags associated with the referenced assembly.
  late final flags = AssemblyFlags(readUint(1));

  /// The public key or token identifying the referenced assembly, if available.
  late final publicKeyOrToken = () {
    final blob = readBlob(2);
    if (blob.isEmpty) return null;
    return blob;
  }();

  /// The name of the assembly.
  late final name = readString(3);

  /// The culture supported by the referenced assembly, if specified.
  late final culture = () {
    final culture = readString(4);
    if (culture.isEmpty) return null;
    return Culture(culture);
  }();

  /// The hash value of the referenced assembly, if available.
  late final hashValue = () {
    final blob = readBlob(5);
    if (blob.isEmpty) return null;
    return blob;
  }();

  /// The version of the referenced assembly in `Major.Minor.Build.Revision`
  /// format (e.g., `4.0.0.0`).
  late final version =
      '$majorVersion.$minorVersion.$buildNumber.$revisionNumber';

  @override
  String toString() => 'AssemblyRef(name: $name, version: $version)';
}

final class AssemblyRefCompanion extends RowCompanion<AssemblyRef> {
  const AssemblyRefCompanion();

  @override
  AssemblyRef Function(MetadataIndex, int, int) get constructor =>
      AssemblyRef.new;

  @override
  MetadataTable get table => MetadataTable.assemblyRef;
}
