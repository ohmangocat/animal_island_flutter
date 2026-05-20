# API Reference

This reference summarizes the public `animal_island_flutter` API. Prefer the repository's live `AI_USAGE.md` when working inside the project.

## Setup

```yaml
dependencies:
  animal_island_flutter: ^0.1.1
```

```dart
import 'package:animal_island_flutter/animal_island_flutter.dart';
```

Wrap demos or apps in `AnimalTheme`:

```dart
MaterialApp(
  home: AnimalTheme(
    child: const App(),
  ),
)
```

Minimum environment:

- Dart SDK: `>=3.3.0 <4.0.0`
- Flutter: `>=3.19.0`
- Dependency: `flutter_svg`

## Public Components

- `AnimalButton`
- `AnimalInput`
- `AnimalSwitch`
- `AnimalDialog`
- `AnimalCard`
- `AnimalCollapse`
- `AnimalCursor`
- `AnimalSelect`
- `AnimalCheckbox`
- `AnimalTabs`
- `AnimalIcon`
- `AnimalFooter`
- `AnimalDivider`
- `AnimalTime`
- `AnimalPhone`
- `AnimalTypewriter`
- `AnimalCodeBlock`
- `AnimalLoading`
- `AnimalTable`

## Key APIs

```dart
enum AnimalButtonType { primary, defaultType, dashed, text, link }
enum AnimalButtonSize { small, middle, large }

AnimalButton({
  required Widget child,
  VoidCallback? onPressed,
  AnimalButtonType type = AnimalButtonType.defaultType,
  AnimalButtonSize size = AnimalButtonSize.middle,
  bool danger = false,
  bool ghost = false,
  bool block = false,
  bool loading = false,
  bool disabled = false,
  Widget? icon,
})
```

```dart
enum AnimalInputSize { small, middle, large }
enum AnimalInputStatus { error, warning }

AnimalInput({
  TextEditingController? controller,
  String? initialValue,
  String? hintText,
  AnimalInputSize size = AnimalInputSize.middle,
  Widget? prefix,
  Widget? suffix,
  bool allowClear = false,
  AnimalInputStatus? status,
  bool shadow = false,
  bool enabled = true,
  bool obscureText = false,
  TextInputType? keyboardType,
  ValueChanged<String>? onChanged,
  VoidCallback? onClear,
})
```

```dart
enum AnimalSwitchSize { small, normal }

AnimalSwitch({
  bool? value,
  bool defaultValue = false,
  AnimalSwitchSize size = AnimalSwitchSize.normal,
  bool disabled = false,
  bool loading = false,
  Widget? checkedChild,
  Widget? uncheckedChild,
  ValueChanged<bool>? onChanged,
})
```

```dart
AnimalDialog({
  Widget? title,
  required Widget child,
  double width = 520,
  Widget? footer,
  bool showFooter = true,
  VoidCallback? onClose,
  VoidCallback? onOk,
  bool typewriter = true,
  Duration typeSpeed = const Duration(milliseconds: 80),
})
```

```dart
enum AnimalCardType { defaultType, title, dashed }
enum AnimalCardColor {
  defaultColor, appPink, purple, appBlue, appYellow, appOrange,
  appTeal, appGreen, appRed, limeGreen, yellowGreen, brown, warmPeachPink,
}

AnimalCard({
  required Widget child,
  AnimalCardType type = AnimalCardType.defaultType,
  AnimalCardColor color = AnimalCardColor.defaultColor,
  EdgeInsetsGeometry? padding,
  VoidCallback? onTap,
})
```

```dart
AnimalSelect<T>({
  required List<AnimalSelectOption<T>> options,
  required T? value,
  required ValueChanged<T> onChanged,
  String placeholder = '请选择',
  bool disabled = false,
  double minWidth = 140,
})
```

```dart
AnimalCheckbox<T>({
  required List<AnimalCheckboxOption<T>> options,
  List<T>? value,
  List<T> defaultValue = const [],
  AnimalCheckboxSize size = AnimalCheckboxSize.middle,
  bool disabled = false,
  AnimalCheckboxDirection direction = AnimalCheckboxDirection.horizontal,
  ValueChanged<List<T>>? onChanged,
})
```

```dart
AnimalTabs({
  required List<AnimalTabItem> items,
  String? defaultActiveKey,
  String? activeKey,
  ValueChanged<String>? onChanged,
  bool leafAnimation = true,
  bool shadow = true,
})
```

```dart
enum AnimalIconName {
  miles, camera, chat, critterpedia, design,
  diy, helicopter, map, shopping, variant,
}

AnimalIcon({
  required AnimalIconName name,
  double size = 24,
  bool bounce = false,
})
```

```dart
enum AnimalLoadingStyle { island, spinner, stripes }

AnimalLoading({
  double size = 28,
  double strokeWidth = 3,
  bool active = true,
  AnimalLoadingStyle style = AnimalLoadingStyle.island,
})
```

```dart
AnimalTable<T>({
  required List<AnimalTableColumn<T>> columns,
  required List<T> rows,
  bool loading = false,
  Widget? empty,
  String? emptyText,
  bool striped = true,
  bool showHeader = true,
  double? maxHeight,
  void Function(T row, int index)? onRowTap,
})
```

## Hard Rules

1. Import public API from `package:animal_island_flutter/animal_island_flutter.dart`.
2. Do not use React props: no `className`, `style`, `htmlType`, `open`, or `onChange`.
3. Use Dart enum names: `defaultType`, `defaultColor`, `normal`.
4. `AnimalSelect` requires `value` and `onChanged`.
5. Controlled `AnimalCheckbox`, `AnimalSwitch`, and `AnimalTabs` should include change callbacks.
6. Loading buttons disable action.
7. `AnimalTypewriter` receives `String text`, not a widget tree.
8. `AnimalCodeBlock` does not expose a `language` parameter.
9. Do not remove pill radii or 3D bottom shadows.
10. Custom image cursor is Web/desktop-oriented and should use `AnimalCursor`.
