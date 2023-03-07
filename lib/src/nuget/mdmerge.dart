import 'dart:io';

import 'package:win32_registry/win32_registry.dart';

import '../utils/exception.dart';

class MdMerge {
  static String getExecutablePath() {
    const path = r'SOFTWARE\WOW6432Node\Microsoft\Microsoft SDKs\Windows\v10.0';
    final regKey = Registry.openPath(RegistryHive.localMachine, path: path);
    final installationFolder = regKey.getValueAsString('InstallationFolder');
    final productVersion = regKey.getValueAsString('ProductVersion');
    regKey.close();

    if (installationFolder == null || productVersion == null) {
      throw WinmdException(
          'Failed to get information of the installed Windows SDK.');
    }

    final processorArch = Platform.environment['PROCESSOR_ARCHITECTURE'];
    final arch = processorArch == 'ARM64' ? 'arm64' : 'x64';
    return '${installationFolder}bin\\$productVersion.0\\$arch\\mdmerge.exe';
  }

  static void mergeMetadata(String metadataPath, int hierarchyLevels) {
    print('Merging WinRT Metadata files into single file...');
    final mdmergeExePath = getExecutablePath();
    final workingDir = Directory(r'winrt\ref\netstandard2.0').path;
    Process.runSync(
        mdmergeExePath, ['-o', 'out', '-i', '.', '-n', '$hierarchyLevels'],
        workingDirectory: workingDir);
  }
}
