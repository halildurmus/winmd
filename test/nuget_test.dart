@TestOn('windows')

import 'dart:io';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:winmd/winmd.dart';

void main() {
  test('Nuget can get versions', () async {
    final versions = await NuGet.getVersions('Microsoft.Windows.SDK.Contracts');
    check(versions.length).isGreaterThan(10);
    check(versions).contains('10.0.19041.1');
    check(versions.where((element) => element.endsWith('preview')))
        .isNotEmpty();
  });

  test('Nuget can detect latest version', () async {
    final previewVersion = await NuGet.getLatestVersion(
        'Microsoft.Windows.SDK.Contracts',
        includePreviewVersions: true);
    check(previewVersion).endsWith('preview');

    final stableVersion = await NuGet.getLatestVersion(
        'Microsoft.Windows.SDK.Contracts',
        includePreviewVersions: false);
    check(stableVersion).not(it()..endsWith('preview'));
  });

  test('Nuget can download a file', () async {
    // Pick a small package (this one is 346KB).
    final bytes =
        await NuGet.downloadPackage('Microsoft.Win32.Registry', '5.0.0');

    // Perhaps the exact size could vary if it is patched?
    check(bytes.lengthInBytes).isCloseTo(346 * 1024, 100 * 1024);
  });

  test('Nuget can identify a temporary directory', () {
    final tempDir = NuGet.tempDirectory;
    check(tempDir)
      ..isNotEmpty()
      ..contains('winmd_')
      ..not(it()..endsWith('\\'));
  });

  test('Temporary directory should stay constant within same invocation', () {
    final temp1 = NuGet.tempDirectory;
    final temp2 = NuGet.tempDirectory;
    check(temp1).equals(temp2);
  });

  test('Nuget can extract a file', () async {
    final path = await NuGet.unpackPackage('Microsoft.Win32.Registry', '5.0.0');
    final dir = Directory(path);
    try {
      check(dir.listSync().length).isGreaterOrEqual(4);
      check(File('$path\\LICENSE.TXT').existsSync()).isTrue();
    } finally {
      dir.deleteSync(recursive: true);
    }
  });

  test('Can find mdmerge', () {
    final path = MdMerge.getExecutablePath();
    check(path)
      ..isNotEmpty()
      ..endsWith('mdmerge.exe');
  });

  test('Can load metadata from NuGet', () async {
    const win32pkg = 'Microsoft.Windows.SDK.Win32Metadata';
    final latestVersion =
        await NuGet.getLatestVersion(win32pkg, includePreviewVersions: true);
    final win32PackagePath = await NuGet.unpackPackage(win32pkg, latestVersion);
    final win32Metadata = File('$win32PackagePath\\Windows.Win32.winmd');
    check(win32Metadata.existsSync()).isTrue();
    final scope = MetadataStore.getScopeForFile(win32Metadata);
    final typeDef =
        scope.findTypeDef('Windows.Win32.UI.WindowsAndMessaging.Apis');
    check(typeDef).isNotNull();
  });

  tearDownAll(() async {
    MetadataStore.close();
  });
}
