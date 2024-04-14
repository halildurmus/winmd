// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import '../generic_param.dart';
import '../token_object.dart';
import '../type_aliases.dart';

/// Represents an object that contains generic parameters.
mixin GenericParamsMixin on TokenObject {
  /// Returns a list of generic parameters on this object.
  List<GenericParam> get genericParams {
    final params = <GenericParam>[];

    using((Arena arena) {
      final phEnum = arena<HCORENUM>();
      final rGenericParams = arena<ULONG>();
      final pcGenericParams = arena<ULONG>();

      var hr = reader.enumGenericParams(
          phEnum, token, rGenericParams, 1, pcGenericParams);
      while (hr == S_OK) {
        final genericParamToken = rGenericParams.value;

        params.add(GenericParam.fromToken(scope, genericParamToken));
        hr = reader.enumGenericParams(
            phEnum, token, rGenericParams, 1, pcGenericParams);
      }
      reader.closeEnum(phEnum.value);
    });

    return params;
  }
}
