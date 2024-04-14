// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

@TestOn('windows')

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:winmd/winmd.dart';

void main() {
  late Scope win32Scope;

  setUpAll(() async {
    win32Scope = await MetadataStore.loadWin32Metadata();
  });

  test('Win32 scope contains appropriate assembly references', () {
    // Should at least have a reference to a .NET assembly and the
    // Windows.Foundation assemblies
    check(win32Scope.assemblyRefs.length).isGreaterThan(3);
  });

  test('Assembly name matches toString()', () {
    final assemblyRef = win32Scope.assemblyRefs.first;
    check(assemblyRef.name).equals(assemblyRef.toString());
  });

  tearDownAll(MetadataStore.close);
}
