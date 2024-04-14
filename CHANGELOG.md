## 5.0.1

- Fix deprecation warnings
- Update links

## 5.0.0

- **BREAKING:** The type of the `Field.value` field has been changed from `int`
  to `Object?` to accommodate a wider range of field values (including `double`
  and `String`).
- Bump minimum required Dart SDK version to `3.3.0`.

## 4.1.0

- Added `MetadataStore.loadWdkMetadata()` method to load the
  Windows Driver Kit (WDK) metadata (#87)

## 4.0.1

- The `MetadataStore.loadWinRTMetadata()` method now loads the latest *stable*
  version of the metadata if the `version` parameter is not specified.
  Previously, it would load the latest available version of the package, which
  could be a *pre-release* version.

## 4.0.0

### Major Changes

- Win32 metadata is no longer bundled with this package. Instead, it will be
  downloaded from the NuGet package `Microsoft.Windows.SDK.Win32Metadata` when
  you call the `MetadataStore.loadWin32Metadata()` method. By default, the
  latest available version of the package will be downloaded. You also have the
  option to specify a different version by setting the `version` parameter.
- In previous versions, Windows Runtime (WinRT) metadata was loaded from
  Windows Metadata (.winmd) files on users' machines. In version `4.0.0`, this
  behavior has changed. The WinRT metadata is now obtained from the NuGet
  package `Microsoft.Windows.SDK.Contracts` when you call the
  `MetadataStore.loadWinRTMetadata()` method. By default, the latest available
  version of the package will be downloaded. Like the Win32 metadata, you can
  specify a different version by setting the `version` parameter.
- **BREAKING**: The method `MetadataStore.getScopeForAsset()` has been removed.
- **BREAKING**: The method `MetadataStore.getScopeForFile()` has been renamed to
  `MetadataStore.loadMetadataFromFile()`.
- **BREAKING**: The method `MetadataStore.getWin32Scope()` has been renamed to
  `MetadataStore.loadWin32Metadata()` and now returns `Future<Scope>`.
- **BREAKING**: The method `MetadataStore.winmdFileContainingType()` has been
  removed.

### Other Changes

- Added `MetadataStore.loadWinRTMetadata()` method to load the
  Windows Runtime (WinRT) metadata.
- Fix an error related to the parsing of constant reference parameters
- Support enumerating all classes, interfaces, and structs in the `Scope` (#79)
- Fix attributes of simple array size parameters (#78)

## 3.0.1

- Fix an error when enumerating methods of a `TypeDef` (#74)
- Fix naming conflicts with multiple simple array type parameters in a function
  (#76)

## 3.0.0

- **BREAKING**: The names of metadata attributes changed in the above winmd
  file. Replace all instances of `Windows.Win32.Interop.*` with
  `Windows.Win32.Foundation.Metadata.*`.
- Fix bug with a simple array type in a function signature (#72, thanks
  @ds84182)
- Update to Windows.Win32.winmd v51.0.33.6962.
- Upgrade to Dart 3

## 2.4.9

- Update to Windows.Win32.winmd v47.0.14.4635.

## 2.4.8

- Adopt `package:checks` for tests instead of `package:tests`.
- Update to Windows.Win32.winmd v42.0.18.50823.

## 2.4.7

- Update win32 dependency.

## 2.4.6

- Update to Windows.Win32.winmd v41.0.5.54252.

## 2.4.5

- Update error messages

## 2.4.4

- Update to Windows.Win32.winmd v38.0.1.26489.

## 2.4.3

- Update to Windows.Win32.winmd v37.0.33.41815.

## 2.4.2

- Update to Windows.Win32.winmd v37.0.25.4095.

## 2.4.1

- Update to Windows.Win32.winmd v37.0.24.13458.

## 2.4.0

- Update to Windows.Win32.winmd v37.0.19.10366.
- Notable metadata changes:
  - Win32 modules now contain extensions (e.g. `gdi32` -> `gdi32.dll`)
  - Win32 preservesig values updated
  - More strong value types (e.g. `COLORREF` is no longer a generic `Uint32`)

## 2.3.0

- Potential breaking change: `Method` and `TypeIdentifier` offer more friendly
  `.toString()` values.
- Make `TypeIdentifier` const.

## 2.2.4

- Update to Windows.Win32.winmd v25.0.28.17102.

## 2.2.3

- Update to Windows.Win32.winmd v24.0.6.19647.
- Add protection to ensure typeSpecs don't produce erroneous results.

## 2.2.2

- Adjust simple array types (thanks @halildurmus).

## 2.2.1

- Add support for reference types and fix simple array types.

## 2.2.0

- Potential breaking change: semantics of `TypeDef.isClass` have changed.
  `.isClass` is now only true for real classes (not delegates, structs, or other
  objects that may be represented in the metadata as classes but are actually
  different types). For old-style behavior, use `.representsAsClass` instead.

## 2.1.1

- Add extra guard for typeDef.parent

## 2.1.0

- Update to package:ffi 2.0.0
- Use super parameters

## 2.0.0

- Update enumerations to match Dart lint requirements (breaking change).

## 1.2.0

- Correctly handle custom attributes with parameters.
- Add findAttribute() and existsAttribute() methods.
- Add support for Windows.Win32.Interop.dll.
- Remove customAttributeAsBytes in favor of customAttribute.signatureBlob.

## 1.1.1

- Move COR_FIELD_OFFSET here from win32 (since it belongs here)

## 1.1.0

- Upgrade minimum required Dart version to 2.17, and take advantage of new
  language features (enhanced enums, super constructors).
- Add `memberRef` and `constructor` properties to `CustomAttributes`
- Add `AssemblyRef` class that lists referenced assemblies
- Expand `TypeRef` support to load referenced WinRT assemblies
- Add new test that exhaustively verifies a WinRT interface with generics
- Update to Windows.Win32.winmd v23.0.3.6210.

## 1.0.32

- Update to Windows.Win32.winmd v23.0.0.18996.

## 1.0.31

- Update to Windows.Win32.winmd v22.0.14.373.

## 1.0.30

- Fix GenericTypeModifier test
- Update to Windows.Win32.winmd v22.0.3.46746.

## 1.0.29

- Update to Windows.Win32.winmd v21.0.5.16515.

## 1.0.28

- Add test for GetDateTime
- Update to Windows.Win32.winmd v19.0.6.9593.

## 1.0.27

- Update to Windows.Win32.winmd v18.0.3.21405.

## 1.0.26

- Update to Windows.Win32.winmd v17.0.23.22086.

## 1.0.25

- Update to Windows.Win32.winmd v17.0.11.56775.

## 1.0.24

- Update to latest win32metadata `.winmd` file.
- Bump minimum Dart SDK to 2.15.0.

## 1.0.23

- Update to latest win32metadata `.winmd` file.

## 1.0.22

- Performance improvements (thanks to @dantup).

## 1.0.21

- Extra backstop of looking locally for Win32 metadata file. This is for
  compiled EXEs.

## 1.0.20

- Export architecture mixin.
- Add more tests.

## 1.0.19

- Update to latest win32metadata `.winmd` file.
- Add code coverage generation

## 1.0.18

- Move architectures to a mixin.

## 1.0.17

- Much faster for deeply nested types.
- Add support for "fake" getters and setters in Win32 metadata.
- More tolerant support of nested types.
- Built-in support for platform architecture without attribute queries.
- More tests.

## 1.0.16

- Better integrate support for nested types.

## 1.0.15

- Add platform architecture support.

## 1.0.14

- Add support for nested types.

## 1.0.13

- Update to latest win32metadata `.winmd` file.

## 1.0.12

- Fix accidental break.

## 1.0.11

- [Broken build] Please upgrade to 1.0.12.
- Update to latest win32metadata `.winmd` file.

## 1.0.10

- Minor tweaks to property detection
- Update to latest win32metadata `.winmd` file.

## 1.0.9

- Update to latest win32metadata `.winmd` file.

## 1.0.8

- Update to latest win32metadata `.winmd` file.

## 1.0.7

- Update to latest win32metadata `.winmd` file.

## 1.0.6

- Update to latest win32metadata `.winmd` file.

## 1.0.5

- Update to latest win32metadata `.winmd` file.

## 1.0.4

- Treat HSTRING as an int, rather than as a `Pointer<IntPtr>`, for consistency
  with other handle types.

## 1.0.3

- Fix bug with parsing generic type definitions (thanks, @sunbreak)
- Update to latest win32metadata `.winmd` file.

## 1.0.2

- Update to latest win32metadata `.winmd` file.

## 1.0.1

- Update to latest win32metadata `.winmd` file.
- Switch to linter package

## 1.0.0

- Update to Dart 2.13, which includes new FFI support for packed structs, type
  aliases and arrays.
- Overhaul the APIs to include much better support for attributes. WinMD can now
  successfully access all the Win32 APIs (enums, delegates, functions,
  interfaces and structs) and all documented metadata, as demonstrated with the
  object_tests folder.
- Move all projection code to [win32](https://pub.dev/packages/win32). This
  package now is focused exclusively on extracting metadata from WinMD files,
  rather than attempting to build Dart projections from it. That code is a
  better fit for win32, since it will evolve with the generated output.
- Add support for events, properties, and delegates.
- Expose scope in TokenObject.
- Clearer abstraction between underlying COM calls and external API.
- Update to latest win32metadata `.winmd` file.
- Support generic parameters and generic parameter constraints.
- Add support for GetPEKind and GetUserVersionString.
- Much better documentation.

## 0.4.12

- Update to latest win32metadata `.winmd` file.
- Support nested classes

## 0.4.11

- Update to latest win32metadata `.winmd` file.
- Use metadata for Win32 intrinsic value types

## 0.4.10

- Update to latest win32metadata `.winmd` file.

## 0.4.9

- Update to latest win32metadata `.winmd` file.

## 0.4.8

- Update to latest win32metadata `.winmd` file.

## 0.4.7

- Minor fixes

## 0.4.6

- Add struct generation

## 0.4.5

- Bundle the latest win32metadata `.winmd` file with the package, and expose it
  via the `MetadataStore.getWin32Scope()` method. This will ensure that this
  library's projection APIs stay in sync with any changes to the metadata file
  itself. You can still supply your own copy of `Windows.Win32.winmd` file and
  load with the `MetadataStore.getScopeForFile()` call.
- Project all enums as `Uint32`, for consistency.
- Add more tests to ensure a couple of regressions never creep in again.

## 0.4.4

- Fix projection of Pointers to interfaces (thanks @bonukai).

## 0.4.3

- Add PVALENTW
- Revert tip-of-tree .winmd

## 0.4.2

- Add more COM interface types

## 0.4.1

- Support printing COM tests

## 0.4.0

- Broad refactoring, focusing the core WinMD package on reading metadata and
  moving transforms to the projection/ folder. Also fix a memory leak on the
  enumerations.
- Rework API for projection of metadata
- Improve generation of Windows Runtime get properties and types
- Add more tests

## 0.3.0-dev.2

- Updated to FFI 1.0 and adopted breaking changes

## 0.3.0-dev.1

- Refactoring

## 0.2.0-dev.4

- Improvements to Win32 metadata parsing
- Move primary development branch to `main`

## 0.2.0-dev.3

- Fix Dart floating-point type error

## 0.2.0-dev.2

- Add basic support for Win32 metadata

## 0.2.0-dev.1

- Initial version, extracted from win32
