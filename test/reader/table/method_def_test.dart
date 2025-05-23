import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:winmd/windows_metadata.dart';
import 'package:winmd/winmd.dart';

import '../../versions.dart';

void main() async {
  final metadata = MetadataLookup(
    await WindowsMetadataLoader().loadAllMetadata(versions: metadataVersions),
  );

  group('MethodDef', () {
    test('AsyncCausalityTracer.TraceSynchronousWorkCompletion', () {
      final typeDef = metadata.findSingleType(
        'Windows.Foundation.Diagnostics',
        'AsyncCausalityTracer',
      );
      final method = typeDef.findMethod('TraceSynchronousWorkCompletion');
      check(method.token).equals(0x06004B5C);
      check(method.rva).equals(0);
      check(method.implFlags).equals(MethodImplAttributes.runtime);
      check(method.codeType).equals(CodeType.runtime);
      check(method.isManaged).isTrue();
      check(method.flags).equals(
        MethodAttributes.public |
            MethodAttributes.static |
            MethodAttributes.hideBySig,
      );
      check(method.memberAccess).equals(MemberAccess.public);
      check(method.vTableLayout).equals(VTableLayout.reuseSlot);
      check(method.name).equals('TraceSynchronousWorkCompletion');
      check(method.signature).equals(
        const MethodSignature(
          types: [
            NamedValueType(
              TypeName('Windows.Foundation.Diagnostics', 'CausalityTraceLevel'),
            ),
            NamedValueType(
              TypeName('Windows.Foundation.Diagnostics', 'CausalitySource'),
            ),
            NamedValueType(
              TypeName(
                'Windows.Foundation.Diagnostics',
                'CausalitySynchronousWork',
              ),
            ),
          ],
        ),
      );
      final params = method.params;
      check(params.length).equals(3);
      check(params[0].flags).equals(ParamAttributes.in$);
      check(params[0].sequence).equals(1);
      check(params[0].name).equals('traceLevel');
      check(params[1].flags).equals(ParamAttributes.in$);
      check(params[1].sequence).equals(2);
      check(params[1].name).equals('source');
      check(params[2].flags).equals(ParamAttributes.in$);
      check(params[2].sequence).equals(3);
      check(params[2].name).equals('work');
      check(method.parent.name).equals('AsyncCausalityTracer');
      check(method.generics).isEmpty();
      check(method.implMap).isNull();
      check(method.hasAttribute('DocumentationAttribute')).isFalse();
    });

    test('IAsyncCausalityTracerStatics.TraceSynchronousWorkCompletion', () {
      final typeDef = metadata.findSingleType(
        'Windows.Foundation.Diagnostics',
        'IAsyncCausalityTracerStatics',
      );
      final method = typeDef.findMethod('TraceSynchronousWorkCompletion');
      check(method.rva).equals(0);
      check(method.implFlags).equals(MethodImplAttributes.il);
      check(method.codeType).equals(CodeType.msil);
      check(method.isManaged).isTrue();
      check(method.flags).equals(
        MethodAttributes.public |
            MethodAttributes.virtual |
            MethodAttributes.hideBySig |
            MethodAttributes.abstract |
            MethodAttributes.newSlot,
      );
      check(method.memberAccess).equals(MemberAccess.public);
      check(method.vTableLayout).equals(VTableLayout.newSlot);
      check(method.name).equals('TraceSynchronousWorkCompletion');
      check(method.signature).equals(
        const MethodSignature(
          callingConvention: CallingConvention.HASTHIS,
          types: [
            NamedValueType(
              TypeName('Windows.Foundation.Diagnostics', 'CausalityTraceLevel'),
            ),
            NamedValueType(
              TypeName('Windows.Foundation.Diagnostics', 'CausalitySource'),
            ),
            NamedValueType(
              TypeName(
                'Windows.Foundation.Diagnostics',
                'CausalitySynchronousWork',
              ),
            ),
          ],
        ),
      );
      final params = method.params;
      check(params.length).equals(3);
      check(params[0].flags).equals(ParamAttributes.in$);
      check(params[0].sequence).equals(1);
      check(params[0].name).equals('traceLevel');
      check(params[1].flags).equals(ParamAttributes.in$);
      check(params[1].sequence).equals(2);
      check(params[1].name).equals('source');
      check(params[2].flags).equals(ParamAttributes.in$);
      check(params[2].sequence).equals(3);
      check(params[2].name).equals('work');
      check(method.parent.name).equals('IAsyncCausalityTracerStatics');
      check(method.generics).isEmpty();
      check(method.implMap).isNull();
      check(method.hasAttribute('DocumentationAttribute')).isFalse();
    });

    test('DoDragDrop', () {
      final method = metadata.findFunction(
        'Windows.Win32.System.Ole',
        'DoDragDrop',
      );
      check(method.rva).equals(0);
      check(method.implFlags).equals(MethodImplAttributes.il);
      check(method.codeType).equals(CodeType.msil);
      check(method.isManaged).isTrue();
      check(method.flags).equals(
        MethodAttributes.public |
            MethodAttributes.static |
            MethodAttributes.hideBySig |
            MethodAttributes.pinvokeImpl,
      );
      check(method.memberAccess).equals(MemberAccess.public);
      check(method.vTableLayout).equals(VTableLayout.reuseSlot);
      check(method.name).equals('DoDragDrop');
      check(method.signature).equals(
        const MethodSignature(
          returnType: NamedValueType(
            TypeName('Windows.Win32.Foundation', 'HRESULT'),
          ),
          types: [
            NamedClassType(TypeName('Windows.Win32.System.Com', 'IDataObject')),
            NamedClassType(TypeName('Windows.Win32.System.Ole', 'IDropSource')),
            NamedValueType(TypeName('Windows.Win32.System.Ole', 'DROPEFFECT')),
            MutablePointerType(
              NamedValueType(
                TypeName('Windows.Win32.System.Ole', 'DROPEFFECT'),
              ),
              1,
            ),
          ],
        ),
      );
      final params = method.params;
      check(params.length).equals(5);
      check(params[0].flags).equals(const ParamAttributes(0));
      check(params[0].sequence).equals(0);
      check(params[0].name).isEmpty();
      check(params[1].flags).equals(ParamAttributes.in$);
      check(params[1].sequence).equals(1);
      check(params[1].name).equals('pDataObj');
      check(params[2].flags).equals(ParamAttributes.in$);
      check(params[2].sequence).equals(2);
      check(params[2].name).equals('pDropSource');
      check(params[3].flags).equals(ParamAttributes.in$);
      check(params[3].sequence).equals(3);
      check(params[3].name).equals('dwOKEffects');
      check(params[4].flags).equals(ParamAttributes.out);
      check(params[4].sequence).equals(4);
      check(params[4].name).equals('pdwEffect');
      check(method.parent.namespace).equals('Windows.Win32.System.Ole');
      check(method.parent.name).equals('Apis');
      check(method.generics).isEmpty();
      final implMap = method.implMap;
      check(implMap).isNotNull();
      check(implMap!.flags).equals(
        PInvokeAttributes.noMangle | PInvokeAttributes.callConvPlatformApi,
      );
      check(implMap.charSet).equals(CharSet.notSpecified);
      check(implMap.callConv).equals(CallConv.platformApi);
      check(implMap.memberForwarded.name).equals('DoDragDrop');
      check(implMap.importName).equals('DoDragDrop');
      check(implMap.importScope.name).equals('OLE32.dll');
      check(method.hasAttribute('DocumentationAttribute')).isTrue();
    });

    test('GetAltMonthNames', () {
      final method = metadata.findFunction(
        'Windows.Win32.System.Ole',
        'GetAltMonthNames',
      );
      check(method.rva).equals(0);
      check(method.implFlags).equals(MethodImplAttributes.il);
      check(method.codeType).equals(CodeType.msil);
      check(method.isManaged).isTrue();
      check(method.flags).equals(
        MethodAttributes.public |
            MethodAttributes.static |
            MethodAttributes.hideBySig |
            MethodAttributes.pinvokeImpl,
      );
      check(method.memberAccess).equals(MemberAccess.public);
      check(method.vTableLayout).equals(VTableLayout.reuseSlot);
      check(method.name).equals('GetAltMonthNames');
      check(method.signature).equals(
        const MethodSignature(
          returnType: NamedValueType(
            TypeName('Windows.Win32.Foundation', 'HRESULT'),
          ),
          types: [
            Uint32Type(),
            MutablePointerType(
              NamedValueType(TypeName('Windows.Win32.Foundation', 'PWSTR')),
              2,
            ),
          ],
        ),
      );
      final params = method.params;
      check(params.length).equals(3);
      check(params[0].flags).equals(const ParamAttributes(0));
      check(params[0].sequence).equals(0);
      check(params[0].name).isEmpty();
      check(params[1].flags).equals(ParamAttributes.in$);
      check(params[1].sequence).equals(1);
      check(params[1].name).equals('lcid');
      check(params[2].flags).equals(ParamAttributes.out);
      check(params[2].sequence).equals(2);
      check(params[2].name).equals('prgp');
      check(method.parent.namespace).equals('Windows.Win32.System.Ole');
      check(method.parent.name).equals('Apis');
      check(method.generics).isEmpty();
      final implMap = method.implMap;
      check(implMap).isNotNull();
      check(implMap!.flags).equals(
        PInvokeAttributes.noMangle | PInvokeAttributes.callConvPlatformApi,
      );
      check(implMap.charSet).equals(CharSet.notSpecified);
      check(implMap.callConv).equals(CallConv.platformApi);
      check(implMap.memberForwarded.name).equals('GetAltMonthNames');
      check(implMap.importName).equals('GetAltMonthNames');
      check(implMap.importScope.name).equals('OLEAUT32.dll');
      check(method.hasAttribute('DocumentationAttribute')).isTrue();
    });
  });

  group('MethodDefExtension', () {
    group('findParameter', () {
      final typeDef = metadata.findSingleType(
        'Windows.Foundation.Collections',
        'StringMap',
      );
      final method = typeDef.findMethod('Insert');

      test('returns matching parameter if found', () {
        final param = method.findParameter('key');
        check(param.name).equals('key');
      });

      test('throws if parameter not found', () {
        check(
          () => method.findParameter('NonexistentParameter'),
        ).throws<WinmdException>();
      });
    });

    group('tryFindParameter', () {
      final typeDef = metadata.findSingleType(
        'Windows.Foundation.Collections',
        'StringMap',
      );
      final method = typeDef.findMethod('Insert');

      test('returns matching parameter if found', () {
        final param = method.tryFindParameter('value');
        check(param).isNotNull();
        check(param!.name).equals('value');
      });

      test('returns null if parameter not found', () {
        final param = method.tryFindParameter('DoesNotExist');
        check(param).isNull();
      });
    });
  });
}
