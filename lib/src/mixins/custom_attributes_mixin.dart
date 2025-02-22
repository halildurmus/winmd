import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import '../custom_attribute.dart';
import '../models/models.dart';
import '../token_object.dart';
import '../type_aliases.dart';

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

  /// Returns the first attribute matching the given name.
  CustomAttribute? findAttribute(String attributeName) =>
      customAttributes.where((attr) => attr.name == attributeName).firstOrNull;

  /// Whether this object has an attribute matching the given name.
  bool hasAttribute(String attributeName) =>
      findAttribute(attributeName) != null;

  Iterable<CustomAttribute> _getCustomAttributes() {
    final customAttributes = <CustomAttribute>[];

    using((arena) {
      final phEnum = arena<HCORENUM>();
      final rAttrs = arena<mdCustomAttribute>();
      final pcAttrs = arena<ULONG>();

      // Certain TokenObjects may not have a valid token (e.g. a return
      // type has a token of 0). In this case, we return an empty set, since
      // calling EnumCustomAttributes with a scope of 0 will return all
      // attributes on all objects in the scope.
      if (!isResolvedToken) return <CustomAttribute>[];

      var hr = reader.enumCustomAttributes(
        phEnum,
        token,
        0,
        rAttrs,
        1,
        pcAttrs,
      );
      while (hr == S_OK) {
        final attrToken = rAttrs.value;
        final customAttribute = CustomAttribute.fromToken(scope, attrToken);
        customAttributes.add(customAttribute);
        hr = reader.enumCustomAttributes(phEnum, token, 0, rAttrs, 1, pcAttrs);
      }
      reader.closeEnum(phEnum.value);
    });

    return customAttributes;
  }
}
