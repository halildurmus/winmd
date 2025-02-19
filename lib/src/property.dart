import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart' hide TokenType;

import 'method.dart';
import 'mixins/custom_attributes_mixin.dart';
import 'models/models.dart';
import 'scope.dart';
import 'token_object.dart';
import 'type_aliases.dart';
import 'type_def.dart';
import 'type_identifier.dart';

/// A property object.
class Property extends TokenObject with CustomAttributesMixin {
  Property(
    super.scope,
    super.token,
    this._parentToken,
    this.name,
    this._attributes,
    this.signatureBlob,
    this.typeIdentifier,
    this.baseType,
    this.defaultValue,
    this._setterToken,
    this._getterToken,
    this.otherMethodTokens,
  );

  /// Creates a property object from a provided token.
  factory Property.fromToken(Scope scope, int token) {
    assert(
      TokenType.fromToken(token) == TokenType.property,
      'Token $token is not a property token',
    );

    return using((arena) {
      final ptkTypeDef = arena<mdTypeDef>();
      final szProperty = arena<WCHAR>(stringBufferSize).cast<Utf16>();
      final pchProperty = arena<ULONG>();
      final pdwPropFlags = arena<DWORD>();
      final ppvSigBlob = arena<PCCOR_SIGNATURE>();
      final pcbSigBlob = arena<ULONG>();
      final pdwCPlusTypeFlag = arena<DWORD>();
      final ppDefaultValue = arena<UVCP_CONSTANT>();
      final pcchDefaultValue = arena<ULONG>();
      final ptkSetter = arena<mdMethodDef>();
      final ptkGetter = arena<mdMethodDef>();
      final rgOtherMethod = arena<mdMethodDef>(256);
      final pcOtherMethod = arena<ULONG>();

      final reader = scope.reader;
      final hr = reader.getPropertyProps(
        token,
        ptkTypeDef,
        szProperty,
        stringBufferSize,
        pchProperty,
        pdwPropFlags,
        ppvSigBlob,
        pcbSigBlob,
        pdwCPlusTypeFlag,
        ppDefaultValue,
        pcchDefaultValue,
        ptkSetter,
        ptkGetter,
        rgOtherMethod,
        256,
        pcOtherMethod,
      );
      if (FAILED(hr)) throw WindowsException(hr);

      final propName = szProperty.toDartString();

      // PropertySig is defined in §II.23.2.5 of ECMA-335.
      final signature = ppvSigBlob.value.asTypedList(pcbSigBlob.value);
      final typeTuple = TypeTuple.fromSignature(signature.sublist(2), scope);
      final defaultValue = ppDefaultValue.value.asTypedList(
        pcchDefaultValue.value,
      );
      final otherMethodTokens = rgOtherMethod.asTypedList(pcOtherMethod.value);

      return Property(
        scope,
        token,
        ptkTypeDef.value,
        propName,
        pdwPropFlags.value,
        signature,
        typeTuple.typeIdentifier,
        BaseType.fromCorElementType(pdwCPlusTypeFlag.value),
        defaultValue,
        ptkSetter.value,
        ptkGetter.value,
        otherMethodTokens,
      );
    });
  }

  final BaseType baseType;
  final Uint8List defaultValue;
  final String name;
  final Uint32List otherMethodTokens;
  final Uint8List signatureBlob;
  final TypeIdentifier typeIdentifier;

  final int _attributes;
  final int _getterToken;
  final int _parentToken;
  final int _setterToken;

  /// Returns the get accessor method for the property.
  Method? get getterMethod =>
      reader.isValidToken(_getterToken) == TRUE
          ? Method.fromToken(scope, _getterToken)
          : null;

  /// Returns the set accessor method for the property.
  Method? get setterMethod =>
      reader.isValidToken(_setterToken) == TRUE
          ? Method.fromToken(scope, _setterToken)
          : null;

  /// Returns the [TypeDef] representing the type that implements the property.
  TypeDef get parent => scope.findTypeDefByToken(_parentToken)!;

  /// Returns true if the property is special; the name describes how.
  bool get isSpecialName => _attributes & prSpecialName == prSpecialName;

  /// Returns true if the property has a default value.
  bool get hasDefault => _attributes & prHasDefault == prHasDefault;

  /// Returns true if the property has a getter. If false, the property is
  /// write-only.
  bool get hasGetter => reader.isValidToken(_getterToken) == TRUE;

  /// Returns true if the property has a setter. If false, the property is
  /// read-only.
  bool get hasSetter => reader.isValidToken(_setterToken) == TRUE;

  /// Returns true if the common language runtime metadata internal APIs should
  /// check the encoding of the property name.
  bool get isRTSpecialName => _attributes & prRTSpecialName == prRTSpecialName;

  @override
  String toString() => name;
}
