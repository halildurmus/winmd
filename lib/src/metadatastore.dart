// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:cli';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'com/IMetaDataDispenser.dart';
import 'com/IMetaDataImport2.dart';
import 'scope.dart';
import 'type_aliases.dart';
import 'typedef.dart';

/// Caches a reader for each file scope.
///
/// Use this to obtain a reference of a scope without creating unnecessary
/// copies or cycles.
class MetadataStore {
  static Map<String, Scope> cache = {};
  static late IMetaDataDispenser dispenser;
  static bool isInitialized = false;

  /// Initialize the [MetadataStore] object.
  ///
  /// This is done automatically by any method that uses it.
  static void initialize() {
    // This must have the same object lifetime as MetadataStore itself.
    final dispenserObject = calloc<COMObject>();

    final hr = MetaDataGetDispenser(convertToCLSID(CLSID_CorMetaDataDispenser),
        convertToIID(IID_IMetaDataDispenser), dispenserObject.cast());

    if (FAILED(hr)) {
      throw WindowsException(hr);
    }

    dispenser = IMetaDataDispenser(dispenserObject);

    isInitialized = true;
  }

  /// Return the scope that contains the Win32 metadata.
  ///
  /// The Windows Runtime metadata is included as part of Windows, but Win32
  /// metadata is not. We include a copy that is tested to work with this
  /// package, since it's likely that the two will be used together.
  ///
  /// By having this here, we remove the need for this large file to be
  /// distributed with the win32 package, since it's only used at development
  /// time for generating types. It also reduces the risk of breaking changes
  /// being out of sync with the winmd library, since the two can be more
  /// tightly bound together.
  static Scope getWin32Scope() {
    const win32ScopeName = 'Windows.Win32.winmd';
    if (cache.containsKey(win32ScopeName)) {
      return cache[win32ScopeName]!;
    } else {
      final uri = Uri.parse('package:winmd/assets/$win32ScopeName');
      final future = Isolate.resolvePackageUri(uri);
      final package = waitFor(future, timeout: const Duration(seconds: 5));
      if (package == null) {
        throw Exception('Could not find $win32ScopeName.');
      }
      final fileScope = File.fromUri(package);

      return getScopeForFile(fileScope);
    }
  }

  /// Takes a metadata file path and returns the matching scope.
  static Scope getScopeForFile(File fileScope) {
    if (!isInitialized) initialize();

    final filename = fileScope.uri.pathSegments.last;

    if (cache.containsKey(filename)) {
      return cache[filename]!;
    } else {
      final szFile = fileScope.path.toNativeUtf16();
      final pReader = calloc<COMObject>();

      try {
        final hr = dispenser.OpenScope(szFile, CorOpenFlags.ofRead,
            convertToIID(IID_IMetaDataImport2), pReader.cast());
        if (FAILED(hr)) {
          throw WindowsException(hr);
        } else {
          final scope = Scope(IMetaDataImport2(pReader));
          cache[filename] = scope;
          return scope;
        }
      } finally {
        free(szFile);
      }
    }
  }

  /// Takes a typename (e.g. `Windows.Globalization.Calendar`) and returns the
  /// metadata scope that contains the type.
  static Scope getScopeForType(String typeName) {
    if (typeName.startsWith('Windows.Win32')) {
      // It's a Win32 type.

      // The following will throw an exception if the Win32 scope isn't in the
      // cache, since we don't know where to find the Win32 metadata if it's not
      // already loaded. This won't be a problem, so long as the original Win32
      // metadata scope was loaded with getScopeForFile.
      final cacheEntry =
          cache.keys.firstWhere((entry) => entry.contains('Windows.Win32'));

      return cache[cacheEntry]!;
    } else {
      // Assume it's a Windows Runtime type
      final hstrTypeName = convertToHString(typeName);

      final hstrMetaDataFilePath = calloc<IntPtr>();
      final spMetaDataImport = calloc<Pointer>();
      final typeDef = calloc<mdTypeDef>();

      try {
        // For apps that are not Windows Store apps, RoGetMetaDataFile can only be
        // used for classes that are part of the Windows Runtime itself (i.e. not
        // third-party types).
        final hr = RoGetMetaDataFile(hstrTypeName.value, nullptr,
            hstrMetaDataFilePath, spMetaDataImport, typeDef);
        if (SUCCEEDED(hr)) {
          final filePath = convertFromHString(hstrMetaDataFilePath);
          return getScopeForFile(File(filePath));
        } else {
          throw WindowsException(hr);
        }
      } finally {
        WindowsDeleteString(hstrTypeName.value);
        WindowsDeleteString(hstrMetaDataFilePath.value);

        free(hstrTypeName);
        free(hstrMetaDataFilePath);
      }
    }
  }

  /// Find a matching typedef, if one exists, for a Windows Runtime type.
  static TypeDef? getMetadataForType(String typeName) {
    if (!isInitialized) initialize();

    final scope = getScopeForType(typeName);
    return scope.findTypeDef(typeName);
  }

  /// Dispose of all objects.
  ///
  /// The readers and dispensers should be automatically torn down with the end
  /// of the process, but it's polite to do this in an orderly manner,
  /// particularly if the calling app outlives the cache lifetime.
  static void close() {
    if (!isInitialized) return;

    for (final scope in cache.values) {
      free(scope.reader.ptr);
    }
    free(dispenser.ptr);

    cache.clear();
    isInitialized = false;
  }

  /// Print information about the cache for debugging purposes.
  static String cacheInfo() =>
      'Store: [${MetadataStore.cache.keys.join(', ')}]';
}
