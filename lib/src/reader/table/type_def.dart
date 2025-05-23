import 'package:meta/meta.dart';

import '../../attributes.dart';
import '../../common.dart';
import '../../exception.dart';
import '../codes.dart';
import '../has_custom_attributes.dart';
import '../metadata_index.dart';
import '../metadata_table.dart';
import '../row.dart';
import '../type_category.dart';
import 'class_layout.dart';
import 'event.dart';
import 'field.dart';
import 'generic_param.dart';
import 'interface_impl.dart';
import 'method_def.dart';
import 'method_impl.dart';
import 'nested_class.dart';
import 'property.dart';

/// Represents a row in the `TypeDef` metadata table.
///
/// The fields are populated by interpreting the binary metadata as specified in
/// ECMA-335 `§II.22.37`.
///
/// The `TypeDef` table has the following columns:
///  - **Flags** (4-byte bitmask of TypeAttributes)
///  - **TypeName** (String Heap Index)
///  - **TypeNamespace** (String Heap Index)
///  - **Extends** (TypeDefOrRef Coded Index)
///  - **FieldList** (Field Table Index)
///  - **MethodList** (MethodDef Table Index)
final class TypeDef extends Row with HasCustomAttributes {
  TypeDef(super.metadataIndex, super.readerIndex, super.index);

  @override
  MetadataTable get table => MetadataTable.typeDef;

  @override
  int get token => (MetadataTableId.typeDef << 24) | index;

  /// Type attributes that represents various attributes of the type, such as
  /// visibility, layout, and semantics.
  late final flags = TypeAttributes(readUint32(0));

  /// The visibility of the type.
  late final TypeVisibility typeVisibility =
      TypeVisibility.values[flags & TypeAttributes.visibilityMask];

  /// Whether the type is nested, i.e., defined under another type.
  late final bool isNested = switch (typeVisibility) {
    TypeVisibility.notPublic || TypeVisibility.public => false,
    _ => true,
  };

  /// The layout of the type.
  late final TypeLayout typeLayout = switch (flags &
      TypeAttributes.layoutMask) {
    TypeAttributes.autoLayout => TypeLayout.auto,
    TypeAttributes.sequentialLayout => TypeLayout.sequential,
    TypeAttributes.explicitLayout => TypeLayout.explicit,
    _ => throw WinmdException(
      'Unknown type layout: ${flags & TypeAttributes.layoutMask}',
    ),
  };

  /// The semantics of the type.
  late final TypeSemantics typeSemantics = switch (flags &
      TypeAttributes.classSemanticsMask) {
    TypeAttributes.class$ => TypeSemantics.class$,
    TypeAttributes.interface => TypeSemantics.interface,
    _ => throw WinmdException(
      'Unknown type semantics: ${flags & TypeAttributes.classSemanticsMask}',
    ),
  };

  /// The string format used by the type.
  late final StringFormat stringFormat = switch (flags &
      TypeAttributes.stringFormatMask) {
    TypeAttributes.ansiClass => StringFormat.ansi,
    TypeAttributes.unicodeClass => StringFormat.unicode,
    TypeAttributes.autoClass => StringFormat.auto,
    TypeAttributes.customFormatClass => StringFormat.custom,
    _ => throw WinmdException(
      'Unknown string format: ${flags & TypeAttributes.stringFormatMask}',
    ),
  };

  /// The name of the type.
  late final String name = readString(1);

  /// The namespace of the type.
  late final String namespace = readString(2);

  /// The type that the current type extends, or `null` if there is no base
  /// type.
  late final TypeDefOrRef? extends$ = () {
    if (readUint(3) == 0) return null;
    return decode<TypeDefOrRef>(3);
  }();

  /// The list of fields defined in the type, if any.
  late final List<Field> fields = getList<Field>(4).toList(growable: false);

  /// The list of methods defined in the type, if any.
  late final List<MethodDef> methods = getList<MethodDef>(
    5,
  ).toList(growable: false);

  /// The category of the type, which could be a class, interface, enum, struct,
  /// delegate, or attribute.
  late final TypeCategory category = () {
    final extends$ = this.extends$;
    if (extends$ == null) return TypeCategory.interface;
    if (extends$.namespace != 'System') return TypeCategory.class$;
    return switch (extends$.name) {
      'Enum' => TypeCategory.enum$,
      'MulticastDelegate' => TypeCategory.delegate,
      'ValueType' => TypeCategory.struct,
      'Attribute' => TypeCategory.attribute,
      _ => TypeCategory.class$,
    };
  }();

  /// The class layout associated with the type, if any.
  late final ClassLayout? classLayout = getEqualRange<ClassLayout>(
    2,
    index + 1,
  ).firstOrNull;

  /// The list of events defined in the type, if any.
  late final List<Event> events = () {
    final eventIndex = index + 1;
    final eventMapRow = reader.tableStream.eventMap
        .where(
          (row) =>
              reader.readUint(row, MetadataTable.eventMap, 0) == eventIndex,
        )
        .firstOrNull;
    if (eventMapRow == null) return const <Event>[];

    final companion = Row.companion<Event>();
    final rows = reader.getList(
      eventMapRow,
      MetadataTable.eventMap,
      1,
      MetadataTable.event,
    );
    return rows
        .map(
          (index) => companion.constructor(metadataIndex, readerIndex, index),
        )
        .toList(growable: false);
  }();

  /// The list of generic parameters defined for the type, if any.
  late final List<GenericParam> generics = getEqualRange<GenericParam>(
    2,
    TypeOrMethodDef.typeDef(this).encode(),
  ).toList(growable: false);

  /// The list of interfaces implemented by the type, if any.
  late final List<InterfaceImpl> interfaceImpls = getEqualRange<InterfaceImpl>(
    0,
    index + 1,
  ).toList(growable: false);

  /// The list of method implementations defined for the type, if any.
  late final List<MethodImpl> methodImpls = getEqualRange<MethodImpl>(
    0,
    index + 1,
  ).toList(growable: false);

  /// The type that encloses the current type, if the type is nested.
  late final TypeDef? enclosingClass = getEqualRange<NestedClass>(
    0,
    index + 1,
  ).firstOrNull?.outer;

  /// The nested types defined under the type, if any.
  late final List<TypeDef> nestedTypes = metadataIndex
      .nestedTypes(this)
      .toList(growable: false);

  /// The list of properties defined in the type, if any.
  late final List<Property> properties = () {
    final propertyIndex = index + 1;
    final propertyMapRow = reader.tableStream.propertyMap
        .where(
          (row) =>
              reader.readUint(row, MetadataTable.propertyMap, 0) ==
              propertyIndex,
        )
        .firstOrNull;
    if (propertyMapRow == null) return const <Property>[];

    final companion = Row.companion<Property>();
    final rows = reader.getList(
      propertyMapRow,
      MetadataTable.propertyMap,
      1,
      MetadataTable.property,
    );
    return rows
        .map(
          (index) => companion.constructor(metadataIndex, readerIndex, index),
        )
        .toList(growable: false);
  }();

  @override
  String toString() =>
      namespace.isEmpty ? 'TypeDef($name)' : 'TypeDef($namespace.$name)';
}

/// Extension methods for querying members of a [TypeDef] by name.
extension TypeDefExtension on TypeDef {
  /// Finds an event by its [name].
  ///
  /// Throws a [WinmdException] if the event is not found.
  Event findEvent(String name) =>
      events.where((e) => e.name == name).firstOrNull ??
      (throw WinmdException('Event "$name" not found in $this'));

  /// Attempts to find an event by its [name].
  ///
  /// Returns `null` if the event is not found.
  Event? tryFindEvent(String name) =>
      events.where((e) => e.name == name).firstOrNull;

  /// Finds a field by its [name].
  ///
  /// Throws a [WinmdException] if the field is not found.
  Field findField(String name) =>
      fields.where((f) => f.name == name).firstOrNull ??
      (throw WinmdException('Field "$name" not found in $this'));

  /// Attempts to find a field by its [name].
  ///
  /// Returns `null` if the field is not found.
  Field? tryFindField(String name) =>
      fields.where((f) => f.name == name).firstOrNull;

  /// Finds a method by its [name].
  ///
  /// Throws a [WinmdException] if the method is not found.
  MethodDef findMethod(String name) =>
      methods.where((m) => m.name == name).firstOrNull ??
      (throw WinmdException('Method "$name" not found in $this'));

  /// Attempts to find a method by its [name].
  ///
  /// Returns `null` if the method is not found.
  MethodDef? tryFindMethod(String name) =>
      methods.where((m) => m.name == name).firstOrNull;

  /// Finds a property by its [name].
  ///
  /// Throws a [WinmdException] if the property is not found.
  Property findProperty(String name) =>
      properties.where((p) => p.name == name).firstOrNull ??
      (throw WinmdException('Property "$name" not found in $this'));

  /// Attempts to find a property by its [name].
  ///
  /// Returns `null` if the property is not found.
  Property? tryFindProperty(String name) =>
      properties.where((p) => p.name == name).firstOrNull;
}

@internal
final class TypeDefCompanion extends RowCompanion<TypeDef> {
  const TypeDefCompanion();

  @override
  TypeDef Function(MetadataIndex, int, int) get constructor => TypeDef.new;

  @override
  MetadataTable get table => MetadataTable.typeDef;
}
