import 'dart:typed_data';

import 'package:win32/win32.dart';

import '../enums.dart';
import '../scope.dart';
import '../typedef.dart';
import '../typeidentifier.dart';
import 'blob.dart';

/// An intermediate representation of a segment of a signature.
class TypeTuple {
  /// Returns the second item of the tuple
  final int offsetLength;

  /// Returns the first item of the tuple
  final TypeIdentifier typeIdentifier;

  /// Creates a new tuple value with the specified items.
  const TypeTuple(this.typeIdentifier, this.offsetLength);

  /// Parse a single type from the signature blob.
  ///
  /// Returns a [TypeTuple] containing the runtime type and the number of bytes
  /// consumed.
  ///
  /// Details on the blob format can be found at §II.23.1.16 and §II.23.2 of
  /// ECMA-335.
  factory TypeTuple.fromSignature(Uint8List signatureBlob, Scope scope) {
    final paramType = signatureBlob.first;
    final baseType = BaseType.fromCorElementType(paramType);
    // final runtimeType = TypeIdentifier.fromValue(paramType);
    var dataLength = 0;

    switch (baseType) {
      case BaseType.valueTypeModifier:
      case BaseType.classTypeModifier:
        final uncompressed =
            UncompressedData.fromBlob(signatureBlob.sublist(1));
        final token = _unencodeDefRefSpecToken(uncompressed.data);
        final tokenAsType = TypeDef.fromToken(scope, token);

        dataLength = uncompressed.dataLength + 1;
        return TypeTuple(
            TypeIdentifier(baseType, name: tokenAsType.name, type: tokenAsType),
            dataLength);

      case BaseType.referenceTypeModifier:
      case BaseType.pointerTypeModifier:
      case BaseType.simpleArrayType:
        final typeArgTuple =
            TypeTuple.fromSignature(signatureBlob.sublist(1), scope);
        dataLength = 1 + typeArgTuple.offsetLength;
        return TypeTuple(
            TypeIdentifier(baseType, typeArg: typeArgTuple.typeIdentifier),
            dataLength);

      case BaseType.genericTypeModifier:
        // return a type with a generic
        final classTuple =
            TypeTuple.fromSignature(signatureBlob.sublist(1), scope);
        final runtimeType = TypeIdentifier(baseType,
            name: classTuple.typeIdentifier.name,
            type: classTuple.typeIdentifier.type);
        dataLength = 1 + classTuple.offsetLength;

        final argsCount = signatureBlob[dataLength]; // GENERICINST + class
        dataLength++; // skip over argsCount

        // Build up a stack of type identifiers, since this could be
        // Foo<Bar<T>>. Start with Foo, and then work through the arguments.
        final typeIdentifiers = <TypeIdentifier>[runtimeType];
        for (var idx = 0; idx < argsCount; idx++) {
          final arg =
              TypeTuple.fromSignature(signatureBlob.sublist(dataLength), scope);
          typeIdentifiers.add(arg.typeIdentifier);

          // Keep unwrapping until there are no types left.
          var typeIdentifier = arg.typeIdentifier.typeArg;
          while (typeIdentifier != null) {
            typeIdentifiers.add(typeIdentifier);
            typeIdentifier = typeIdentifier.typeArg;
          }

          dataLength += arg.offsetLength;
        }

        // Unwrap them into a parent
        var type = typeIdentifiers.last;
        for (var idx = typeIdentifiers.length - 2; idx >= 0; idx--) {
          final newType = typeIdentifiers[idx].copyWith(typeArg: type);
          type = newType;
        }
        return TypeTuple(type, dataLength);

      case BaseType.arrayTypeModifier:
        // Format is [Type ArrayShape] (see §II.23.2.13)
        final arrayTuple =
            TypeTuple.fromSignature(signatureBlob.sublist(1), scope);
        dataLength = 1 + arrayTuple.offsetLength;

        final dimensionsCount = signatureBlob[dataLength++]; // rank
        final dimensionUpperBounds = List<int>.filled(dimensionsCount, 0);
        final numSizes = signatureBlob[dataLength++];
        for (var i = 0; i < numSizes; i++) {
          final uncompressed =
              UncompressedData.fromBlob(signatureBlob.sublist(dataLength));
          dataLength += uncompressed.dataLength;
          dimensionUpperBounds[i] = uncompressed.data;
        }
        return TypeTuple(
            TypeIdentifier(baseType,
                typeArg: arrayTuple.typeIdentifier,
                arrayDimensions: dimensionUpperBounds),
            dataLength);

      case BaseType.classVariableTypeModifier:
      case BaseType.methodVariableTypeModifier:
        // Element is a generic parameter of a type or a method
        final uncompressed =
            UncompressedData.fromBlob(signatureBlob.sublist(1));
        dataLength = 2; // modifier + seq
        return TypeTuple(
            TypeIdentifier(baseType,
                name: TypeIdentifier(baseType).toString(),
                genericParameterSequence: uncompressed.data),
            dataLength);

      default:
        return TypeTuple(TypeIdentifier(baseType), 1);
    }
  }

  /// Decodes a single `TypeDef` / `TypeRef` / `TypeSpec` token.
  static int _unencodeDefRefSpecToken(int encoded) {
    final token = encoded >> 2;

    if (encoded & 0x03 == 0x00) {
      // typedef
      return CorTokenType.mdtTypeDef | token;
    }
    if (encoded & 0x03 == 0x01) {
      // typeref
      return CorTokenType.mdtTypeRef | token;
    }
    if (encoded & 0x03 == 0x02) {
      // typespec
      return CorTokenType.mdtTypeSpec | token;
    } else {
      return 0;
    }
  }
}
