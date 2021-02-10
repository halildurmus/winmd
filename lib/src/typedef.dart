// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'constants.dart';
import '_base.dart';
import 'method.dart';
import 'metadatastore.dart';
import 'utils.dart';

/// Represents a TypeDef in the Windows Metadata file
class TypeDef extends AttributeObject {
  final String typeName;
  final int flags;
  final int baseTypeToken;

  /// Is the type a class?
  bool get isClass =>
      (flags & CorTypeAttr.tdClass == CorTypeAttr.tdClass) &&
      (flags & CorTypeAttr.tdInterface != CorTypeAttr.tdInterface);

  /// Is the type an interface?
  bool get isInterface =>
      flags & CorTypeAttr.tdInterface == CorTypeAttr.tdInterface;

  /// Is the type a non-Windows Runtime type, such as System.Object or
  /// IInspectable?
  ///
  /// More information at:
  /// https://docs.microsoft.com/en-us/uwp/winrt-cref/winmd-files#type-system-encoding
  bool get isSystemType => systemTokens.containsValue(typeName);

  /// Create a typedef.
  ///
  /// Typically, typedefs should be obtained from a [WinmdScope] object rather
  /// than being created directly.
  TypeDef(IMetaDataImport2 reader,
      [int token = 0,
      this.typeName = '',
      this.flags = 0,
      this.baseTypeToken = 0])
      : super(reader, token);

  /// Instantiate a typedef from a token.
  ///
  /// If the token is a TypeDef, it will be created directly; otherwise it will
  /// be retrieved by finding the scope that it comes from and returning a
  /// typedef from the new scope.
  factory TypeDef.fromToken(IMetaDataImport2 reader, int token) {
    if (tokenIsTypeRef(token)) {
      return TypeDef.fromTypeRefToken(reader, token);
    } else if (tokenIsTypeDef(token)) {
      return TypeDef.fromTypeDefToken(reader, token);
    } else {
      print('Unrecognized token $token');
      return TypeDef(reader);
    }
  }

  /// Instantiate a typedef from a TypeDef token.
  factory TypeDef.fromTypeDefToken(IMetaDataImport2 reader, int typeDefToken) {
    final nRead = calloc<Uint32>();
    final tdFlags = calloc<Uint32>();
    final baseClassToken = calloc<Uint32>();
    final typeName = calloc<Uint8>(256 * 2).cast<Utf16>();

    try {
      final hr = reader.GetTypeDefProps(
          typeDefToken, typeName, 256, nRead, tdFlags, baseClassToken);

      if (SUCCEEDED(hr)) {
        return TypeDef(reader, typeDefToken, typeName.unpackString(nRead.value),
            tdFlags.value, baseClassToken.value);
      } else {
        throw WindowsException(hr);
      }
    } finally {
      calloc.free(nRead);
      calloc.free(tdFlags);
      calloc.free(baseClassToken);
      calloc.free(typeName);
    }
  }

  /// Instantiate a typedef from a TypeRef token.
  ///
  /// Unless the TypeRef token is `IInspectable`, the COM parent interface for
  /// Windows Runtime classes, the TypeRef is used to obtain the host scope
  /// metadata file, from which the TypeDef can be found and returned.
  factory TypeDef.fromTypeRefToken(IMetaDataImport2 reader, int typeRefToken) {
    final ptkResolutionScope = calloc<Uint32>();
    final szName = calloc<Uint8>(256 * 2).cast<Utf16>();
    final pchName = calloc<Uint32>();

    // a token like IInspectable is out of reach of GetTypeRefProps, since it is
    // a plain COM object. These objects are returned as system types.
    if (systemTokens.containsKey(typeRefToken)) {
      return TypeDef(reader, 0, systemTokens[typeRefToken]!);
    }

    try {
      final hr = reader.GetTypeRefProps(
          typeRefToken, ptkResolutionScope, szName, 256, pchName);

      if (SUCCEEDED(hr)) {
        final typeName = szName.unpackString(pchName.value);

        // TODO: Can we shortcut something by using the resolution scope token?
        try {
          final newScope = MetadataStore.getScopeForType(typeName);
          return newScope.findTypeDef(typeName);
        } catch (exception) {
          if (systemTokens.containsValue(typeName)) {
            return TypeDef(reader, 0, typeName);
          } else {
            throw WinmdException(
                'Unable to find scope for $typeName [${typeRefToken.toHexString(32)}]...');
          }
        }
      } else {
        throw WindowsException(hr);
      }
    } finally {
      calloc.free(ptkResolutionScope);
      calloc.free(szName);
      calloc.free(pchName);
    }
  }

  /// Converts an individual interface into a type.
  TypeDef processInterfaceToken(int token) {
    final pClass = calloc<Uint32>();
    final ptkIface = calloc<Uint32>();

    try {
      final hr = reader.GetInterfaceImplProps(token, pClass, ptkIface);
      if (SUCCEEDED(hr)) {
        if (tokenIsTypeRef(ptkIface.value)) {
          return TypeDef.fromTypeRefToken(reader, ptkIface.value);
        } else if (tokenIsTypeDef(pClass.value)) {
          return TypeDef.fromTypeDefToken(reader, ptkIface.value);
        }
      }

      throw WindowsException(hr);
    } finally {
      calloc.free(pClass);
      calloc.free(ptkIface);
    }
  }

  /// Enumerate all interfaces that this type implements.
  List<TypeDef> get interfaces {
    final interfaces = <TypeDef>[];

    final phEnum = calloc<IntPtr>();
    final rImpls = calloc<Uint32>();
    final pcImpls = calloc<Uint32>();

    try {
      var hr = reader.EnumInterfaceImpls(phEnum, token, rImpls, 1, pcImpls);
      while (hr == S_OK) {
        final token = rImpls.value;

        interfaces.add(processInterfaceToken(token));
        hr = reader.EnumInterfaceImpls(phEnum, token, rImpls, 1, pcImpls);
      }
      return interfaces;
    } finally {
      reader.CloseEnum(phEnum.address);

      calloc.free(rImpls);
      calloc.free(pcImpls);

      // dispose phEnum crashes here, so leave it allocated
    }
  }

  /// Enumerate all methods contained within this type.
  List<Method> get methods {
    final methods = <Method>[];

    final phEnum = calloc<IntPtr>();
    final mdMethodDef = calloc<Uint32>();
    final pcTokens = calloc<Uint32>();

    try {
      var hr = reader.EnumMethods(phEnum, token, mdMethodDef, 1, pcTokens);
      while (hr == S_OK) {
        final token = mdMethodDef.value;

        methods.add(Method.fromToken(reader, token));
        hr = reader.EnumMethods(phEnum, token, mdMethodDef, 1, pcTokens);
      }
      return methods;
    } finally {
      reader.CloseEnum(phEnum.address);

      calloc.free(mdMethodDef);
      calloc.free(pcTokens);
      // dispose phEnum crashes here, so leave it allocated
    }
  }

  /// Get a method matching the name, if one exists.
  ///
  /// Returns null if the method is not found.
  Method? findMethod(String methodName) {
    final szName = TEXT(methodName);
    final pmb = calloc<Uint32>();

    try {
      final hr = reader.FindMethod(token, szName, nullptr, 0, pmb);
      if (SUCCEEDED(hr)) {
        return Method.fromToken(reader, pmb.value);
      } else if (hr == CLDB_E_RECORD_NOTFOUND) {
        return null;
      } else {
        throw COMException(hr);
      }
    } finally {
      calloc.free(szName);
      calloc.free(pmb);
    }
  }

  /// Gets the type referencing this type's superclass.
  TypeDef? get parent =>
      token == 0 ? null : TypeDef.fromToken(reader, baseTypeToken);

  /// Get the GUID for this type.
  ///
  /// Returns null if a GUID couldn't be found.
  String? get guid {
    final attributeName = TEXT('Windows.Foundation.Metadata.GuidAttribute');
    final ppData = calloc<IntPtr>();
    final pcbData = calloc<Uint32>();

    try {
      final hr = reader.GetCustomAttributeByName(
          token, attributeName, ppData, pcbData);
      if (SUCCEEDED(hr) && pcbData.value == 20) {
        final blob = Pointer<Uint8>.fromAddress(ppData.value);
        final guid = blob.elementAt(2).cast<GUID>();
        return guid.ref.toString();
      } else {
        return null;
      }
    } finally {
      calloc.free(attributeName);
      calloc.free(ppData);
      calloc.free(pcbData);
    }
  }
}