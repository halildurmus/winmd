import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:winmd/winmd.dart';

void main() {
  group('PropertySig', () {
    test('default constructor uses expected values', () {
      const sig = PropertySig(returnType: Int32Type());
      check(sig.flags).equals(PropertyFlags.default$);
      check(sig.returnType).equals(const Int32Type());
      check(sig.types).deepEquals(const []);
    });

    test('equality: equal for same flags, return type, and types', () {
      const sig1 = PropertySig(
        flags: PropertyFlags.hasThis,
        returnType: BoolType(),
        types: [Int32Type()],
      );
      const sig2 = PropertySig(
        flags: PropertyFlags.hasThis,
        returnType: BoolType(),
        types: [Int32Type()],
      );
      check(sig1).equals(sig2);
    });

    test('equality: instances with different flags are not equal', () {
      const sig1 = PropertySig(returnType: BoolType());
      const sig2 = PropertySig(
        returnType: BoolType(),
        flags: PropertyFlags.hasThis,
      );
      check(sig1).not((it) => it.equals(sig2));
    });

    test('equality: instances with different return types are not equal', () {
      const sig1 = PropertySig(returnType: Int32Type());
      const sig2 = PropertySig(returnType: BoolType());
      check(sig1).not((it) => it.equals(sig2));
    });

    test('equality: instances with different types are not equal', () {
      const sig1 = PropertySig(returnType: Int32Type(), types: [BoolType()]);
      const sig2 = PropertySig(returnType: Int32Type(), types: [StringType()]);
      check(sig1).not((it) => it.equals(sig2));
    });
  });
}
