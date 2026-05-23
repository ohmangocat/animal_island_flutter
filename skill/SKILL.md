---
name: animal-island-flutter-style
description: Use when building, refactoring, documenting, or visually tuning the Animal Island Flutter component library. Applies to Flutter/Dart widgets inspired by animal-island-ui, pixel-level restoration, docs/demo pages, Android/Windows/Web compatibility, API docs, design prompts, and AI usage documentation.
---

# Animal Island Flutter Style

Use this skill when working in `animal_island_flutter` or creating Flutter UI that must match the Animal Island design language.

## Source Of Truth

- API usage: read `AI_USAGE.md`.
- Design prompts and visual tokens: read `DESIGN_PROMPT.md`.
- Demo/content structure: compare with `animal-island-ui-main/demo`, but rewrite examples for Flutter/Dart.
- Public exports: `lib/animal_island_flutter.dart`.
- Component implementations: `lib/src/components/*.dart`, especially `mobile.dart` for phone-first and mobile business widgets.
- Example docs app: `example/lib/main.dart`.

## Core Style

- Warm parchment background: `#f8f8f0` and `rgb(247, 243, 223)`.
- Brown text, never pure black for normal UI: `#794f27`, `#725d42`, `#8a7b66`.
- Mint teal primary: `#19c8b9`, hover `#3dd4c6`, active `#11a89b`.
- Focus yellow: `#ffcc00`, not browser blue.
- Rounded controls: pill buttons/inputs, card radius 20, menu radius 12.
- 3D bottom shadow is mandatory on tactile controls. Prefer bottom-only shadow over Material elevation.
- Font stack comes from bundled assets through `AnimalTheme`: Nunito, Noto Sans SC, Zen Maru Gothic.

## Flutter Rules

1. Import only `package:animal_island_flutter/animal_island_flutter.dart` in examples.
2. Wrap apps or demos in `AnimalTheme`.
3. Use Dart enum names exactly: `defaultType`, `defaultColor`, `normal`, `middle`.
4. Use `onChanged`, not React `onChange`.
5. Use Widget children, not HTML/React nodes.
6. Do not invent Web props such as `className`, `style`, `htmlType`, `open`, `maskClosable`.
7. Keep examples compatible with Android, Windows and Web. Mark iOS as self-test unless verified on macOS/Xcode.
8. For Web cursor work, use `AnimalCursor`; do not hand-roll CSS in app code unless fixing the library.

## Component Notes

- `AnimalButton`: loading state is diagonal stripes and disables action. Keep stripe loop seamless.
- `AnimalSwitch`: handle must be visually centered and symmetric between on/off spacing.
- `AnimalDialog`: use the existing custom clipper blob and warm border; do not replace with rectangular `AlertDialog`.
- `AnimalSelect`: must show selected state and pointer cursor/hover affordance on desktop.
- `AnimalTabs`: active leaf belongs near the active tab's top-right; keep the leaf animation subtle.
- `AnimalLoading`: island style is full-screen capable, black background, bottom-right island animation, circular reveal on close.
- `AnimalPhone`, `AnimalFooter`, `AnimalDivider`, `AnimalIcon`: prefer bundled assets over approximated vector redraws.
- `AnimalTable`: preserve warm row backgrounds, striped option and loading overlay.
- Mobile foundation widgets include `AnimalMobileNavBar`, `AnimalBottomBar`, `AnimalBottomSheet`, `AnimalActionSheet`, `AnimalListTile`, `AnimalCellGroup`, `AnimalMobileSearchBar`, `AnimalPicker`, `AnimalMobileDatePicker`, `AnimalMobileStepper`, `AnimalSwipeAction`, `AnimalPullRefresh`, and `AnimalMobileSection`; keep safe areas, bottom-sheet sizing, touch feedback, hover cursors, focus, and keyboard activation.
- Mobile business widgets include `AnimalMobileProductCard`, `AnimalMobileOrderCard`, `AnimalMobileProfileHeader`, `AnimalMobileStatsGrid`, `AnimalMobileCouponCard`, `AnimalMobileNoticeBar`, `AnimalMobileAddressCard`, `AnimalMobilePriceSummary`, `AnimalMobileCheckoutBar`, `AnimalMobileCartItem`, `AnimalMobileOrderTimeline`, `AnimalMobilePaymentMethodCard`, and `AnimalMobileEmptyAction`; keep warm bordered cards, bottom tactile shadows, clear amount/status hierarchy, selected states, safe-area aware checkout bars, and do not replace them with generic Material cards.

## Docs App Rules

- Home page should mirror React demo composition, but all install/run/code content must be Flutter/Dart.
- Component docs should follow `animal-island-ui-main/demo` ordering and copy structure where possible.
- Sidebar width is `220`; header is fixed; menu list scrolls independently.
- Use compact docs layout below `900px`; keep the 761px tablet-width regression covered to avoid overflow at the desktop/mobile breakpoint.
- Sidebar background uses `menu_bg.svg`.
- Detail background uses repeated `content_bg_pc.jpg`.
- Bottom guide decoration uses `guide-bg-line.webp` behind the scroll content.
- Do not put React terms such as npm, TSX, CSS Modules, `import style` into Flutter docs unless explicitly comparing migration.

## Pixel Checks

Before finalizing visual changes:

1. Run `dart format` on changed Dart files.
2. Run `flutter analyze` in the package root.
3. Run `flutter test` in the package root.
4. Run `flutter analyze` and `flutter test` in `example` if demo/docs changed.
5. If `example/mobile_preview` changed, also run analyze and test there.
6. Build static docs when public docs or mobile preview changed:

```powershell
powershell -ExecutionPolicy Bypass -File tool\build_docs.ps1 -Flutter C:\Dev\tools\flutter_3.41.0\bin\flutter.bat
```

7. Start or restart the example preview:

```powershell
cd C:\Dev\repos\animal\animal_island_flutter\example
C:\Dev\tools\flutter_3.41.0\bin\flutter.bat run -d web-server --web-hostname 127.0.0.1 --web-port 5178
```

8. Inspect `http://127.0.0.1:5178/` visually when a browser is available.

## New Component Checklist

- Public widget exported from `lib/animal_island_flutter.dart`.
- Constructor defaults documented in `AI_USAGE.md`.
- Demo page added to `example/lib/main.dart`.
- Standalone mobile preview route added to `example/mobile_preview/lib/main.dart` for mobile components.
- API table and example code use Flutter snippets.
- Hover, pressed, disabled and loading states covered where relevant.
- Tests added for behavior with meaningful risk.
- No unrelated refactors or asset churn.
