import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import '../base.dart';
import '../genericparam.dart';
import '../type_aliases.dart';

/// Represents an object that contains generic parameters.
mixin GenericParamsMixin on TokenObject {
  List<GenericParam> get genericParams {
    final params = <GenericParam>[];

    final phEnum = calloc<HCORENUM>();
    final rGenericParams = calloc<ULONG>();
    final pcGenericParams = calloc<ULONG>();

    try {
      var hr = reader.EnumGenericParams(
          phEnum, token, rGenericParams, 1, pcGenericParams);
      while (hr == S_OK) {
        final genericParamToken = rGenericParams.value;

        params.add(GenericParam.fromToken(scope, genericParamToken));
        hr = reader.EnumGenericParams(
            phEnum, token, rGenericParams, 1, pcGenericParams);
      }
      return params;
    } finally {
      reader.CloseEnum(phEnum.value);
      free(phEnum);
      free(rGenericParams);
      free(pcGenericParams);
    }
  }
}
