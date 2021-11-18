// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'base.dart';
import 'com/IMetaDataImport2.dart';
import 'moduleref.dart';
import 'pekind.dart';
import 'type_aliases.dart';
import 'typedef.dart';
import 'utils/exception.dart';

/// A metadata scope, which typically matches an on-disk file.
///
/// Rather than being created directly, you should obtain a scope from a
/// [MetadataStore], which caches scopes to avoid duplication.
class Scope {
  late final String guid;
  late final String name;
  final IMetaDataImport2 reader;

  final _enums = <TypeDef>[];
  final _modules = <ModuleRef>[];
  final _typedefs = <TypeDef>[];
  final _userStrings = <String>[];

  Scope(this.reader) {
    using((Arena arena) {
      final szName = arena<WCHAR>(MAX_STRING_SIZE).cast<Utf16>();
      final pchName = arena<ULONG>();
      final pmvid = arena<GUID>();

      final hr = reader.GetScopeProps(szName, MAX_STRING_SIZE, pchName, pmvid);
      if (SUCCEEDED(hr)) {
        name = szName.toDartString();
        guid = pmvid.ref.toString();
      } else {
        throw COMException(hr);
      }
    });
  }

  @override
  String toString() => name;

  TypeDef? findTypeDef(String typedef) {
    final typeDef = typeDefs.where((t) => t.name == typedef);
    return (typeDef.isNotEmpty ? typeDef.first : null);
  }

  TypeDef? findTypeDefByToken(int token) {
    final typeDef = typeDefs.where((t) => t.token == token);
    return (typeDef.isNotEmpty ? typeDef.first : null);
  }

  /// Get an enumerated list of typedefs for this scope.
  List<TypeDef> get typeDefs {
    if (_typedefs.isEmpty) {
      using((Arena arena) {
        final phEnum = arena<HCORENUM>();
        final rgTypeDefs = arena<mdTypeDef>();
        final pcTypeDefs = arena<ULONG>();

        var hr = reader.EnumTypeDefs(phEnum, rgTypeDefs, 1, pcTypeDefs);
        while (hr == S_OK) {
          final typeDefToken = rgTypeDefs.value;

          _typedefs.add(TypeDef.fromToken(this, typeDefToken));
          hr = reader.EnumTypeDefs(phEnum, rgTypeDefs, 1, pcTypeDefs);
        }
        reader.CloseEnum(phEnum.value);
      });
    }

    return _typedefs;
  }

  int get moduleToken {
    final pmd = calloc<mdModule>();

    try {
      final hr = reader.GetModuleFromScope(pmd);
      if (SUCCEEDED(hr)) {
        return pmd.value;
      } else {
        throw WinmdException('Unable to find module token.');
      }
    } finally {
      free(pmd);
    }
  }

  List<TypeDef> get delegates =>
      typeDefs.where((typeDef) => typeDef.isDelegate).toList();

  /// Get an enumerated list of modules in this scope.
  List<ModuleRef> get moduleRefs {
    if (_modules.isEmpty) {
      using((Arena arena) {
        final phEnum = arena<HCORENUM>();
        final rgModuleRefs = arena<mdModuleRef>();
        final pcModuleRefs = arena<ULONG>();

        var hr = reader.EnumModuleRefs(phEnum, rgModuleRefs, 1, pcModuleRefs);
        while (hr == S_OK) {
          final moduleToken = rgModuleRefs.value;
          _modules.add(ModuleRef.fromToken(this, moduleToken));
          hr = reader.EnumModuleRefs(phEnum, rgModuleRefs, 1, pcModuleRefs);
        }
        reader.CloseEnum(phEnum.value);
      });
    }

    return _modules;
  }

  /// Get an enumerated list of all hard-coded strings in this scope.
  List<String> get userStrings {
    if (_userStrings.isEmpty) {
      using((Arena arena) {
        final phEnum = arena<HCORENUM>();
        final rgStrings = arena<mdString>();
        final pcStrings = arena<ULONG>();
        final szString = arena<WCHAR>(MAX_STRING_SIZE).cast<Utf16>();
        final pchString = arena<ULONG>();

        var hr = reader.EnumUserStrings(phEnum, rgStrings, 1, pcStrings);
        while (hr == S_OK) {
          final stringToken = rgStrings.value;
          hr = reader.GetUserString(
              stringToken, szString, MAX_STRING_SIZE, pchString);
          if (hr == S_OK) {
            _userStrings.add(szString.toDartString());
          }
          hr = reader.EnumUserStrings(phEnum, rgStrings, 1, pcStrings);
        }
        reader.CloseEnum(phEnum.value);
      });
    }

    return _userStrings;
  }

  /// Get an enumerated list of all enumerations in this scope.
  List<TypeDef> get enums {
    if (_enums.isEmpty) {
      for (final typeDef in typeDefs) {
        if (typeDef.parent?.name == 'System.Enum') {
          _enums.add(typeDef);
        }
      }
    }
    return _enums;
  }

  PEKind get executableKind => PEKind(reader);

  String get versionNumber => using((Arena arena) {
        final pwzBuf = arena<WCHAR>(MAX_STRING_SIZE).cast<Utf16>();
        final pccBufSize = arena<DWORD>();

        final hr = reader.GetVersionString(pwzBuf, MAX_STRING_SIZE, pccBufSize);

        if (SUCCEEDED(hr)) {
          return pwzBuf.toDartString();
        } else {
          return '';
        }
      });
}
