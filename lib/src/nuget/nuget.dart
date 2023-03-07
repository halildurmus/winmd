import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:ffi/ffi.dart';
import 'package:http/http.dart' as http;
import 'package:win32/win32.dart';

/// Utilities for working with nuget.org, Microsoft's package manager.
class NuGet {
  static const authority = 'api.nuget.org';
  static const basePath = '/v3-flatcontainer';

  static final String tempDirectory = _getTemporaryDirectory();

  static Future<List<String>> getVersions(String packageName) async {
    final uri = Uri.https(
      authority,
      '$basePath/${packageName.toLowerCase()}/index.json',
    );
    final response = await http.get(uri);
    final decodedResponse = jsonDecode(response.body);
    if (decodedResponse['versions'] == null) {
      throw Exception('Failed to get the versions of $packageName.');
    }

    final versions = decodedResponse['versions'] as List;
    return versions.cast<String>();
  }

  static Future<String> getLatestVersion(String packageName,
      {bool includePreviewVersions = false}) async {
    final versions = await getVersions(packageName);

    if (includePreviewVersions) {
      return versions.last;
    } else {
      // Otherwise, return the latest stable version.
      return versions.lastWhere((version) => !version.contains('preview'));
    }
  }

  static Future<Uint8List> downloadPackage(
      String packageName, String? version) async {
    final packageNameLowerCase = packageName.toLowerCase();
    final downloadVersion =
        version ?? await getLatestVersion(packageNameLowerCase);
    print('  Downloading $packageName.$downloadVersion.nupkg...');
    final uri = Uri.https(
        authority,
        '$basePath/$packageNameLowerCase/$downloadVersion/'
        '$packageNameLowerCase.$downloadVersion.nupkg');
    final response = await http.Client().get(uri);
    return response.bodyBytes;
  }

  static String _getTemporaryDirectory() {
    final pTempDir = wsalloc(MAX_PATH);
    try {
      final retValue = GetTempPath(MAX_PATH, pTempDir);
      if (retValue == 0 || retValue > MAX_PATH) {
        throw Exception('Failed to retrieve a valid temporary directory.');
      }

      final path =
          Directory(pTempDir.toDartString()).createTempSync('winmd_').path;
      return path;
    } finally {
      free(pTempDir);
    }
  }

  static Future<String> unpackPackage(
      String packageName, String? version) async {
    final bytes = await downloadPackage(packageName, version);
    final archive = ZipDecoder().decodeBytes(bytes);
    final path = '$tempDirectory\\$packageName';
    Directory(path).createSync();

    extractArchiveToDisk(archive, path);

    return path;
  }
}
