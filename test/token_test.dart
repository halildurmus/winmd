@TestOn('windows')
library;

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:winmd/winmd.dart';

void main() {
  late Scope win32Scope;
  late Scope winrtScope;

  setUpAll(() async {
    (win32Scope, winrtScope) =
        await (
          MetadataStore.loadWin32Scope(),
          MetadataStore.loadWinrtScope(),
        ).wait;
  });

  test('0 is not a valid token', () {
    check(win32Scope.reader.isValidToken(0)).isFalse();
  });

  test('0x00000001 is a valid token', () {
    // This should be the module identifier in all normal circumstances
    check(win32Scope.reader.isValidToken(0x00000001)).isTrue();
  });

  test('ValueType', () {
    final typeDef = win32Scope.findTypeDef(
      'Windows.Win32.UI.WindowsAndMessaging.ACCEL',
    );
    check(typeDef).isNotNull();
    check(typeDef!.isResolvedToken).isTrue();
    final parent = typeDef.parent;
    check(parent).isNotNull();
    check(parent!.name).equals('System.ValueType');
    check(parent.isResolvedToken).isFalse();
  });

  test('IInspectable works', () {
    final typeDef = winrtScope.findTypeDef(
      'Windows.Foundation.Collections.IPropertySet',
    );
    check(typeDef).isNotNull();
    final parent = typeDef!.parent;
    check(parent).isNotNull();
    check(parent!.name).endsWith('IInspectable');
  });

  tearDownAll(MetadataStore.close);
}
