import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'constants.dart';
import 'scope.dart';
import 'token_object.dart';
import 'win32/win32.dart';

/// Layout information for the class referenced by a specified token.
class ClassLayout extends TokenObject {
  ClassLayout(Scope scope, int classToken) : super(scope, classToken) {
    // Check for synthetic type like GUID.
    if (classToken == 0) return;

    using((arena) {
      final pdwPackSize = arena<DWORD>();
      final rgFieldOffset = arena<COR_FIELD_OFFSET>(256);
      final pcFieldOffset = arena<ULONG>();
      final pulClassSize = arena<ULONG>();

      // An assumption is made here that there are no more than 256 fields in a
      // struct. If that's not the case, this will fail and throw an exception.
      try {
        reader.getClassLayout(
          classToken,
          pdwPackSize,
          rgFieldOffset,
          256,
          pcFieldOffset,
          pulClassSize,
        );
      } on WindowsException catch (e) {
        if (e.hr == CLDB_E_RECORD_NOTFOUND) {
          // No class layout record, so leave the fields null
          return;
        }
        rethrow;
      }

      packingAlignment = pdwPackSize.value;
      minimumSize = pulClassSize.value;

      final offsetCount = pcFieldOffset.value;
      for (var i = 0; i < offsetCount; i++) {
        final offset = (rgFieldOffset + i).ref;
        final fieldOffset = FieldOffset(
          scope,
          offset.ridOfField,
          offset.ulOffset,
        );
        fieldOffsets.add(fieldOffset);
      }
    });
  }

  /// The array of field offsets, for manually-aligned structs.
  final List<FieldOffset> fieldOffsets = [];

  /// The size in bytes of the class represented.
  int? minimumSize;

  /// The pack size of the class.
  ///
  /// If specified, this contains one of the values 1, 2, 4, 8, or 16,
  /// representing the packing alignment of the class. If null, no packing
  /// alignment is specified.
  int? packingAlignment;
}

/// A tuple of a field and its byte offset within a parent struct.
class FieldOffset extends TokenObject {
  const FieldOffset(super.scope, super.token, this.offset);

  /// The byte offset of a specific field relative to its parent struct.
  ///
  /// Normally fields are located consecutively within a struct, but in a union
  /// the fields are aligned with the 0th index of the struct.
  final int offset;
}
