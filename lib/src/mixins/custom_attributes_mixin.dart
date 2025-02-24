import 'dart:ffi';

import 'package:ffi/ffi.dart';

import '../custom_attribute.dart';
import '../models/models.dart';
import '../token_object.dart';
import '../type_aliases.dart';
import '../win32/win32.dart';

/// Represents an object that has custom (named) attributes associated with it.
mixin CustomAttributesMixin on TokenObject {
  /// Enumerates all attributes that this object has.
  late final customAttributes = _getCustomAttributes();

  /// Retrieve the string associated with a specific attribute name.
  ///
  /// If the attribute's first parameter is not a string, then return an empty
  /// string.
  String attributeAsString(String attributeName) {
    final attribute = findAttribute(attributeName);
    if (attribute?.parameters case [
      final param,
      ...,
    ] when param.type.baseType == BaseType.stringType) {
      return param.value as String;
    }

    return '';
  }

  /// Returns the first attribute matching the given [name].
  CustomAttribute? findAttribute(String name) =>
      customAttributes.where((attr) => attr.name == name).firstOrNull;

  /// Whether this object has an attribute matching the given [name].
  bool hasAttribute(String name) => findAttribute(name) != null;

  Iterable<CustomAttribute> _getCustomAttributes() {
    final customAttributes = <CustomAttribute>[];
    return using((arena) {
      final phEnum = arena<HCORENUM>();
      final rAttrs = arena<mdCustomAttribute>();
      final pcAttrs = arena<ULONG>();

      // Certain TokenObjects may not have a valid token (e.g. a return
      // type has a token of 0). In this case, we return an empty set, since
      // calling EnumCustomAttributes with a scope of 0 will return all
      // attributes on all objects in the scope.
      if (!isResolvedToken) return const <CustomAttribute>[];

      while (true) {
        try {
          reader.enumCustomAttributes(phEnum, token, 0, rAttrs, 1, pcAttrs);
          if (pcAttrs.value == 0) break;
          final attrToken = rAttrs.value;
          final customAttribute = CustomAttribute.fromToken(scope, attrToken);
          customAttributes.add(customAttribute);
        } on WindowsException {
          break;
        }
      }
      reader.closeEnum(phEnum.value);
      return customAttributes;
    });
  }
}
