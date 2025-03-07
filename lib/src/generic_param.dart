import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'method.dart';
import 'mixins/custom_attributes_mixin.dart';
import 'models/models.dart';
import 'scope.dart';
import 'token_object.dart';
import 'type_aliases.dart';
import 'type_def.dart';
import 'win32/win32.dart';

/// A generic parameter.
///
/// Generic parameters belong to [Method]s or [TypeDef]s and contain
/// [GenericParamConstraint]s.
class GenericParam extends TokenObject with CustomAttributesMixin {
  GenericParam(
    super.scope,
    super.token,
    this.sequence,
    this._attributes,
    this._parentToken,
    this.name,
  );

  /// Creates a generic parameter object from a provided token.
  factory GenericParam.fromToken(Scope scope, int token) {
    assert(
      TokenType.fromToken(token) == TokenType.genericParam,
      'Token $token is not a generic parameter token',
    );

    return using((arena) {
      final pulParamSeq = arena<ULONG>();
      final pdwParamFlags = arena<DWORD>();
      final ptOwner = arena<mdToken>();
      final reserved = arena<DWORD>();
      final wzName = arena<WCHAR>(stringBufferSize).cast<Utf16>();
      final pchName = arena<ULONG>();

      scope.reader.getGenericParamProps(
        token,
        pulParamSeq,
        pdwParamFlags,
        ptOwner,
        reserved,
        wzName,
        stringBufferSize,
        pchName,
      );

      return GenericParam(
        scope,
        token,
        pulParamSeq.value,
        pdwParamFlags.value,
        ptOwner.value,
        wzName.toDartString(),
      );
    });
  }

  final String name;
  final int sequence;

  final int _attributes;
  final _constraints = <GenericParamConstraint>[];
  final int _parentToken;

  /// The object representing the owner of the parameter.
  ///
  /// The object is a [TokenObject], which may either be a [TypeDef] or a
  /// [Method]. You can use the [TokenObject.tokenType] property to identify the
  /// parent type.
  TokenObject get parent => switch (TokenType.fromToken(_parentToken)) {
    TokenType.typeDef => TypeDef.fromToken(scope, _parentToken),
    TokenType.methodDef => Method.fromToken(scope, _parentToken),
    _ => throw const WinmdException('Unrecognized parent token.'),
  };

  /// Returns the parameter variance.
  Variance get variance => switch (_attributes & gpVarianceMask) {
    gpNonVariant => Variance.nonvariant,
    gpCovariant => Variance.covariant,
    gpContravariant => Variance.contravariant,
    _ => throw const WinmdException('Unrecognized variance type.'),
  };

  /// Returns a list of the constraints on the generic parameter.
  List<GenericParamConstraint> get constraints {
    if (_constraints.isNotEmpty) return _constraints;
    return using((arena) {
      final phEnum = arena<HCORENUM>();
      final rGenericParamConstraints = arena<mdGenericParam>();
      final pcGenericParamConstraints = arena<ULONG>();
      while (true) {
        try {
          reader.enumGenericParamConstraints(
            phEnum,
            token,
            rGenericParamConstraints,
            1,
            pcGenericParamConstraints,
          );
          if (pcGenericParamConstraints.value == 0) break;
          final gpcToken = rGenericParamConstraints.value;
          final constraint = GenericParamConstraint.fromToken(scope, gpcToken);
          _constraints.add(constraint);
        } on WindowsException {
          break;
        }
      }
      reader.closeEnum(phEnum.value);
      return _constraints;
    });
  }

  /// Returns special constraints that exist on a generic parameter.
  SpecialConstraints get specialConstraints =>
      SpecialConstraints(_attributes & gpSpecialConstraintMask);

  @override
  String toString() => name;
}

/// A generic parameter constraint.
///
/// Each generic parameter can be constrained to derive from zero or one
/// classes, or to implement zero or more interfaces. This class implements a
/// single constraint. Generic constraints are described in §II.22.21 of the
/// ECMA-335 spec.
class GenericParamConstraint extends TokenObject with CustomAttributesMixin {
  GenericParamConstraint(
    super.scope,
    super.token,
    this._parentToken,
    this._constraintType,
  );

  /// Creates a generic parameter constraint object from a provided token.
  factory GenericParamConstraint.fromToken(Scope scope, int token) {
    assert(
      TokenType.fromToken(token) == TokenType.genericParamConstraint,
      'Token $token is not a generic parameter constraint token',
    );

    return using((arena) {
      final ptGenericParam = arena<mdGenericParam>();
      final ptkConstraintType = arena<mdToken>();

      scope.reader.getGenericParamConstraintProps(
        token,
        ptGenericParam,
        ptkConstraintType,
      );

      return GenericParamConstraint(
        scope,
        token,
        ptGenericParam.value,
        ptkConstraintType.value,
      );
    });
  }

  final int _constraintType;
  final int _parentToken;

  /// The generic parameter that is constrained by this object.
  GenericParam get parent => GenericParam.fromToken(scope, _parentToken);

  /// The type of the constraint.
  ///
  /// For example, `class Foo<T> where T : System.Enum` has a constraintType
  /// that matches System.Enum).
  TypeDef get constraintType => TypeDef.fromToken(scope, _constraintType);
}

/// Identifies special constraints on a generic parameter.
class SpecialConstraints {
  const SpecialConstraints(this._attributes);

  final int _attributes;

  /// Indicates that no constraint applies to the Type parameter.
  bool get noConstraints => _attributes == gpNoSpecialConstraint;

  /// Indicates that the Type parameter must be a reference type.
  bool get referenceType =>
      _attributes & gpReferenceTypeConstraint == gpReferenceTypeConstraint;

  /// Indicates that the Type parameter must be a value type that cannot be a
  /// null value.
  bool get notNullable =>
      _attributes & gpNotNullableValueTypeConstraint ==
      gpNotNullableValueTypeConstraint;

  /// Indicates that the Type parameter must have a default public constructor
  /// that takes no parameters.
  bool get defaultConstructor =>
      _attributes & gpDefaultConstructorConstraint ==
      gpDefaultConstructorConstraint;
}
