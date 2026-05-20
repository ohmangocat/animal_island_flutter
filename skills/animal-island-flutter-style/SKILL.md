---
name: animal-island-flutter-style
description: Use when building, refactoring, documenting, publishing, or visually tuning the animal_island_flutter Flutter component library, including pixel-level Animal Island style restoration, Flutter/Dart API usage, demo/docs pages, Android/Windows/Web compatibility, README/pub.dev docs, and AI usage or design prompt maintenance.
---

# Animal Island Flutter Style

Use this skill to maintain `animal_island_flutter` or create Flutter UI that must follow its cozy Animal Island design language.

## Reference Loading

- Read `references/api.md` when writing examples, changing component APIs, updating docs tables, or checking valid constructor parameters.
- Read `references/design.md` when tuning visual details, spacing, colors, fonts, loading states, docs backgrounds, or pixel-level restoration.
- In the repository, prefer the live files when present: `AI_USAGE.md`, `DESIGN_PROMPT.md`, `lib/animal_island_flutter.dart`, `lib/src/components/*.dart`, and `example/lib/main.dart`.

## Workflow

1. Identify whether the task touches library code, docs/demo code, package metadata, or visual assets.
2. Inspect the local implementation before changing behavior. Do not assume React props exist in Flutter.
3. Keep examples Flutter/Dart-only and import from `package:animal_island_flutter/animal_island_flutter.dart`.
4. Preserve the Animal Island visual language: warm parchment backgrounds, brown text, mint teal primary actions, pill controls, and bottom-only tactile shadows.
5. Keep Android, Windows, and Web compatible. Treat iOS as self-test unless verified on macOS with Xcode.
6. Update docs and example snippets whenever public API, install version, package URLs, or demo behavior changes.

## Core Rules

- Wrap apps or demos in `AnimalTheme`.
- Use Dart enum names exactly, such as `defaultType`, `defaultColor`, `normal`, and `middle`.
- Use `onChanged`, not React `onChange`.
- Use Widget children, not HTML, JSX, CSS classes, or React nodes.
- Do not invent Web props such as `className`, `style`, `htmlType`, `open`, or `maskClosable`.
- Use `AnimalCursor` for custom cursor behavior instead of app-level CSS hacks.
- Keep README/pub.dev install snippets aligned with the current package version in `pubspec.yaml`.

## Component Guardrails

- `AnimalButton`: loading state uses smooth diagonal stripes and disables action.
- `AnimalSwitch`: handle spacing must be vertically centered and symmetric between on/off states.
- `AnimalDialog`: keep the organic blob clipper and warm border; do not replace it with a rectangular `AlertDialog`.
- `AnimalSelect`: keep selected state, hover affordance, and pointer cursor on desktop.
- `AnimalTabs`: active leaf sits near the active tab top-right; keep animation subtle.
- `AnimalLoading`: island loading can be full-screen with black overlay, bottom-right island animation, and circular reveal close.
- `AnimalPhone`, `AnimalFooter`, `AnimalDivider`, `AnimalIcon`: prefer bundled source assets over approximate redraws.
- `AnimalTable`: preserve warm rows, striped option, loading overlay, and empty state semantics.

## Docs App Rules

- Mirror the React demo content order where useful, but rewrite all content for Flutter/Dart.
- Home page install snippets should show the published dependency, while `example/pubspec.yaml` may keep `path: ..` for local development.
- Sidebar width is `220`; header is fixed; menu list scrolls independently.
- Sidebar background uses `menu_bg.svg`; detail background uses repeated `content_bg_pc.jpg`.
- Bottom guide decoration uses `guide-bg-line.webp` behind scroll content.
- Avoid npm, TSX, CSS Modules, or `import style` language unless explicitly explaining migration differences.

## Validation

Before finalizing code or visual changes:

```powershell
C:\Dev\tools\flutter_3.41.0\bin\flutter.bat analyze
C:\Dev\tools\flutter_3.41.0\bin\flutter.bat test
```

If `example` changed, also run checks from the example directory when practical:

```powershell
cd example
C:\Dev\tools\flutter_3.41.0\bin\flutter.bat analyze
C:\Dev\tools\flutter_3.41.0\bin\flutter.bat test
```

For visible UI changes, start or restart the docs app and inspect it:

```powershell
cd C:\Dev\repos\animal\animal_island_flutter\example
C:\Dev\tools\flutter_3.41.0\bin\flutter.bat run -d web-server --web-hostname 127.0.0.1 --web-port 5178
```

Then verify `http://127.0.0.1:5178/` in the browser when available.

## New Component Checklist

- Export the public widget from `lib/animal_island_flutter.dart`.
- Document constructor defaults in `AI_USAGE.md`.
- Add demo content to `example/lib/main.dart`.
- Use Flutter snippets in code blocks and API tables.
- Cover hover, pressed, disabled, loading, and empty states where relevant.
- Add tests for behavior with meaningful risk.
- Avoid unrelated refactors, generated-file churn, or asset replacement without a visual reason.
