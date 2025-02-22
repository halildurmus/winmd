import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart' hide TokenType;

import 'models/models.dart';
import 'scope.dart';
import 'token_object.dart';

/// An assembly reference.
///
/// This class is used to declare a reference to an external assembly. For
/// example, the Windows.Globalization assembly may contain references to object
/// in the Windows.Foundation assembly. The linkage is established through an
/// AssemblyRef entry.
class AssemblyRef extends TokenObject {
  const AssemblyRef(super.scope, super.token, this.name, this.version);

  /// Creates a assembly ref object from a provided token.
  factory AssemblyRef.fromToken(Scope scope, int token) {
    assert(
      TokenType.fromToken(token) == TokenType.assemblyRef,
      'Token $token is not an assembly ref token',
    );

    return using((arena) {
      final ppbPublicKeyOrToken = arena<Pointer<BYTE>>();
      final pcbPublicKeyOrToken = arena<ULONG>();
      final szName = arena<WCHAR>(stringBufferSize).cast<Utf16>();
      final pchName = arena<ULONG>();
      final pMetaData = arena<ASSEMBLYMETADATA>();
      final ppbHashValue = arena<Pointer<BYTE>>();
      final pcbHashValue = arena<ULONG>();
      final pdwAssemblyRefFlags = arena<DWORD>();

      final hr = scope.assemblyImport.getAssemblyRefProps(
        token,
        ppbPublicKeyOrToken,
        pcbPublicKeyOrToken,
        szName,
        stringBufferSize,
        pchName,
        pMetaData,
        ppbHashValue,
        pcbHashValue,
        pdwAssemblyRefFlags,
      );
      if (FAILED(hr)) throw WindowsException(hr);

      final ASSEMBLYMETADATA(
        :usMajorVersion,
        :usMinorVersion,
        :usBuildNumber,
        :usRevisionNumber,
      ) = pMetaData.ref;
      final versionString =
          '$usMajorVersion.'
          '$usMinorVersion.'
          '$usBuildNumber.'
          '$usRevisionNumber';

      return AssemblyRef(scope, token, szName.toDartString(), versionString);
    });
  }

  /// The name of the assembly.
  final String name;

  /// The version of the assembly.
  final String version;

  @override
  String toString() => name;
}
