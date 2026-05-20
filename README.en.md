# Animal Island Flutter

<div align="center">
    <img src="doc/img/readme-home.png" alt="animal-island-flutter" style="border-radius: 12px; width: 40%; display: block; margin: 0 auto;" />
</div>
<div align="center">
    A Flutter component library inspired by animal-island-ui
</div>
<br/>
<div align="center">
    <a href="https://pub.dev/packages/animal_island_flutter"><img src="https://img.shields.io/pub/v/animal_island_flutter.svg?style=flat-square" alt="Pub Version"></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square" alt="License"></a>
    <img src="https://img.shields.io/badge/platform-Android%20%7C%20Windows%20%7C%20Web-brightgreen?style=flat-square" alt="Platforms">
    <img src="https://img.shields.io/badge/flutter-%3E%3D3.19.0-blue?style=flat-square" alt="Flutter">
</div>
<br/>
<p align="center">
    <a href="./README.md">简体中文</a> | English
</p>

## Introduction

`animal_island_flutter` is a Flutter component library recreated from [`animal-island-ui`](https://github.com/guokaigdg/animal-island-ui). It keeps the warm beige background, teal primary color, brown text, pill shapes, 3D button shadows, island-style icons, and playful component interactions from the React version, while exposing idiomatic Flutter and Dart APIs.

The project is built for learning Flutter component library design, cross-platform UI recreation, and documentation-site implementation. The visual direction is inspired by cozy life-simulation island interfaces, but the components, code, and bundled assets are implemented inside this project.

## Preview

The documentation/demo app lives in [`example`](./example). Its content follows the React demo structure and is rewritten for Flutter usage.

```powershell
cd example
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5178
```

## Installation

Install the published package from pub.dev:

```yaml
dependencies:
  animal_island_flutter: ^0.1.1
```

Import the library entry point:

```dart
import 'package:animal_island_flutter/animal_island_flutter.dart';
```

For local source development, use a temporary path dependency:

```yaml
dependencies:
  animal_island_flutter:
    path: ../animal_island_flutter
```

## Versions And Dependencies

| Item | Version |
| --- | --- |
| Package | `animal_island_flutter: ^0.1.1` |
| Flutter SDK | `>=3.19.0` |
| Dart SDK | `>=3.3.0 <4.0.0` |
| `flutter_svg` | `^2.0.17` |
| `flutter_lints` | `^5.0.0` |

## Platform Support

| Platform | Status |
| --- | --- |
| Android | Adapted and available for the example app |
| Windows | Adapted for Flutter Windows projects |
| Web | Adapted for the documentation preview |
| iOS | Please test on macOS with Xcode |

## Quick Start

It is recommended to wrap your app with `AnimalTheme`:

```dart
void main() {
  runApp(
    MaterialApp(
      home: AnimalTheme(
        child: const App(),
      ),
    ),
  );
}
```

```dart
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const AnimalCard(
              type: AnimalCardType.title,
              child: Text('Animal Island'),
            ),
            const SizedBox(height: 16),
            AnimalInput(
              hintText: 'What would you like to do today?',
              allowClear: true,
              prefix: const Icon(Icons.search_rounded),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            AnimalButton(
              type: AnimalButtonType.primary,
              block: true,
              onPressed: () {},
              child: const Text('Start Adventure'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Documentation

| Document | Purpose |
| --- | --- |
| [`example`](./example) | Flutter documentation and component demo app, arranged like the React demo and rewritten with Flutter examples. |
| [`AI_USAGE.md`](./AI_USAGE.md) | Flutter API handbook for AI coding assistants, including components, enums, defaults, common combinations, and invalid patterns. |
| [`DESIGN_PROMPT.md`](./DESIGN_PROMPT.md) | Design and generation prompt covering palette, fonts, motion, backgrounds, component styles, and prohibitions. |
| [`skill/SKILL.md`](./skill/SKILL.md) | Pixel-perfect recreation Skill for maintaining this Flutter component library with AI assistants. |

## Component Mapping

| React `animal-island-ui` | Flutter |
| --- | --- |
| `Button` | `AnimalButton` |
| `Input` | `AnimalInput` |
| `Switch` | `AnimalSwitch` |
| `Modal` | `AnimalDialog.show(...)` / `AnimalDialog` |
| `Card` | `AnimalCard` |
| `Collapse` | `AnimalCollapse` |
| `Cursor` | `AnimalCursor` |
| `Time` | `AnimalTime` |
| `Phone` | `AnimalPhone` |
| `Footer` | `AnimalFooter` |
| `Divider` | `AnimalDivider` |
| `Typewriter` | `AnimalTypewriter` |
| `Icon` / `ICON_LIST` | `AnimalIcon` / `animalIconList` |
| `Select` | `AnimalSelect` |
| `Tabs` | `AnimalTabs` |
| `Checkbox` | `AnimalCheckbox` |
| `CodeBlock` | `AnimalCodeBlock` |
| `Loading` | `AnimalLoading` |
| `Table` | `AnimalTable` |
| Extended basics | `AnimalRadio` / `AnimalTag` / `AnimalBadge` / `AnimalTooltip` / `AnimalMessage` / `AnimalProgress` / `AnimalPagination` / `AnimalEmpty` |
| Advanced basics | `AnimalAlert` / `AnimalAvatar` / `AnimalBreadcrumb` / `AnimalSteps` / `AnimalSlider` / `AnimalRate` / `AnimalSegmented` / `AnimalSkeleton` |

## Component Coverage

The package currently includes 35 Flutter components: `Button`, `Input`, `Switch`, `Modal`, `Card`, `Collapse`, `Cursor`, `Time`, `Phone`, `Footer`, `Divider`, `Typewriter`, `Icon`, `Select`, `Tabs`, `Checkbox`, `CodeBlock`, `Loading`, `Table`, `Radio`, `Tag`, `Badge`, `Tooltip`, `Message`, `Progress`, `Pagination`, `Empty`, `Alert`, `Avatar`, `Breadcrumb`, `Steps`, `Slider`, `Rate`, `Segmented`, and `Skeleton`.

The Flutter version keeps the visual and interaction semantics aligned with the React version where possible. A few web-specific APIs are translated into Flutter conventions:

- `default` is a Dart keyword, so enum values use `defaultType` / `defaultColor`
- `Modal.open` becomes `AnimalDialog.show(...)` or a custom `AnimalDialog`
- `Select.value/onChange` becomes `AnimalSelect.value/onChanged`
- `Checkbox.defaultValue/value` becomes `AnimalCheckbox.defaultValue/value`
- `Table.dataSource` becomes `AnimalTable.rows`
- `Table.render` becomes `AnimalTableColumn.cellBuilder`
- `Loading.active` becomes `AnimalLoading(active: true/false)`

## Dart Naming Differences

| React Usage | Flutter Usage |
| --- | --- |
| `type="default"` | `AnimalButtonType.defaultType` |
| `Card type="default"` | `AnimalCardType.defaultType` |
| `Card color="default"` | `AnimalCardColor.defaultColor` |
| `Switch size="default"` | `AnimalSwitchSize.normal` |
| `onChange` | `onChanged` |
| `checkedChildren` | `checkedChild` |
| `unCheckedChildren` | `uncheckedChild` |

## Local Development

```powershell
flutter pub get
flutter analyze
flutter test
```

Run the example:

```powershell
cd example
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5178
```

Generate platform projects:

```powershell
cd example
flutter create --platforms=android,ios,windows .
```

## Visual Assets

The package uses SVG/PNG/WebP assets from the React source, located in [`assets/animal_island/img`](./assets/animal_island/img). Fonts come from the React project's `@fontsource/nunito`, `@fontsource/noto-sans-sc`, and `@fontsource/zen-maru-gothic` packages and are bundled as Flutter-registerable `.woff2` files in [`assets/animal_island/fonts`](./assets/animal_island/fonts). `Icon`, `Divider`, `Footer`, `Phone`, `Select`, `Cursor`, and related components prefer source visual assets where available; `Modal` uses a Flutter `CustomClipper` to recreate the objectBoundingBox blob shape.

## Notes

- This project is mainly intended for learning, research, and UI component library recreation demos.
- If you use it in a commercial project, please evaluate visual style, trademark, asset, and compliance risks on your own.
- This project is not an official Nintendo product and has no association, authorization, or cooperation with Nintendo Co., Ltd.
- Android, Windows, and Web have been adapted for the example app. iOS should be tested on macOS with Xcode.

## License

MIT
