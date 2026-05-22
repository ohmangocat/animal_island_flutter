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
- `AnimalRadio`
- `AnimalTabs`
- `AnimalTag`
- `AnimalBadge`
- `AnimalTooltip`
- `AnimalMessage`
- `AnimalProgress`
- `AnimalPagination`
- `AnimalEmpty`
- `AnimalIcon`
- `AnimalFooter`
- `AnimalForm`
- `AnimalDivider`
- `AnimalTime`
- `AnimalPhone`
- `AnimalTypewriter`
- `AnimalCodeBlock`
- `AnimalTextarea`
- `AnimalPasswordInput`
- `AnimalSearchInput`
- `AnimalNumberInput`
- `AnimalLoading`
- `AnimalTable`
- `AnimalAlert`
- `AnimalAvatar`
- `AnimalBreadcrumb`
- `AnimalSteps`
- `AnimalSlider`
- `AnimalRate`
- `AnimalSegmented`
- `AnimalSkeleton`
- `AnimalPopover`
- `AnimalDropdown`
- `AnimalDrawer`
- `AnimalConfirmDialog`
- `AnimalDescriptions`
- `AnimalStatistic`
- `AnimalTimeline`
- `AnimalCalendar`
- `AnimalUpload`
- `AnimalTree`
- `AnimalResult`

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

AnimalInputFormField({
  String? initialValue,
  TextEditingController? controller,
  String? hintText,
  AnimalInputSize size = AnimalInputSize.middle,
  bool allowClear = false,
  bool enabled = true,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  FormFieldSetter<String>? onSaved,
  FormFieldValidator<String>? validator,
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

AnimalSwitchFormField({
  bool? value,
  bool defaultValue = false,
  AnimalSwitchSize size = AnimalSwitchSize.normal,
  bool disabled = false,
  bool loading = false,
  FormFieldSetter<bool>? onSaved,
  FormFieldValidator<bool>? validator,
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
  double dropdownMaxHeight = 260,
})

AnimalSelectFormField<T>({
  required List<AnimalSelectOption<T>> options,
  ValueChanged<T>? onChanged,
  T? value,
  String placeholder = '请选择',
  bool disabled = false,
  double minWidth = 140,
  double dropdownMaxHeight = 260,
  FormFieldSetter<T>? onSaved,
  FormFieldValidator<T>? validator,
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

AnimalCheckboxFormField<T>({
  required List<AnimalCheckboxOption<T>> options,
  List<T>? value,
  List<T> defaultValue = const [],
  AnimalCheckboxSize size = AnimalCheckboxSize.middle,
  bool disabled = false,
  AnimalCheckboxDirection direction = AnimalCheckboxDirection.horizontal,
  FormFieldSetter<List<T>>? onSaved,
  FormFieldValidator<List<T>>? validator,
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

`AnimalSelect` limits long dropdowns with `dropdownMaxHeight` and scrolls options internally.
`AnimalTable` includes built-in horizontal scrolling when column widths exceed the container.

```dart
enum AnimalRadioSize { small, middle, large }
enum AnimalRadioDirection { horizontal, vertical }

AnimalRadio<T>({
  required List<AnimalRadioOption<T>> options,
  T? value,
  T? defaultValue,
  AnimalRadioSize size = AnimalRadioSize.middle,
  bool disabled = false,
  AnimalRadioDirection direction = AnimalRadioDirection.horizontal,
  ValueChanged<T>? onChanged,
})

AnimalRadioFormField<T>({
  required List<AnimalRadioOption<T>> options,
  T? value,
  T? defaultValue,
  AnimalRadioSize size = AnimalRadioSize.middle,
  bool disabled = false,
  AnimalRadioDirection direction = AnimalRadioDirection.horizontal,
  FormFieldSetter<T>? onSaved,
  FormFieldValidator<T>? validator,
})
```

```dart
enum AnimalTagColor { defaultColor, primary, success, warning, danger, blue, purple, brown }
enum AnimalTagSize { small, middle, large }

AnimalTag({required Widget child, AnimalTagColor color = AnimalTagColor.defaultColor})
AnimalBadge({Widget? child, int? count, String? text, bool dot = false})
enum AnimalTooltipPlacement { top, right, bottom, left }

AnimalTooltip({
  required String message,
  required Widget child,
  AnimalTooltipPlacement placement = AnimalTooltipPlacement.top,
  bool? preferBelow,
  Duration waitDuration = const Duration(milliseconds: 350),
  Duration showDuration = const Duration(seconds: 3),
  double gap = 10,
})
AnimalMessage.success(context, const Text('Saved'))
AnimalProgress(value: 0.6)
AnimalPagination(current: 1, total: 80, onChanged: (page) {})
AnimalEmpty(description: '暂无数据')
```

```dart
enum AnimalAlertType { info, success, warning, error }
enum AnimalAvatarSize { small, middle, large }
enum AnimalAvatarShape { circle, square }
enum AnimalStepsDirection { horizontal, vertical }
enum AnimalStepStatus { wait, process, finish, error }

AnimalAlert({required Widget child, Widget? title, AnimalAlertType type = AnimalAlertType.info})
AnimalAvatar({Widget? child, ImageProvider? image, String? imageUrl, AnimalIconName? icon})
AnimalBreadcrumb({required List<AnimalBreadcrumbItem> items})
AnimalSteps({required List<AnimalStepItem> items, int current = 0, ValueChanged<int>? onChanged})
AnimalSlider(value: 46, min: 0, max: 100, divisions: 10, onChanged: (value) {})
AnimalSliderFormField(value: 46, divisions: 10, validator: (value) => null)
AnimalRate(value: 4, onChanged: (score) {})
AnimalRateFormField(value: 4, validator: (value) => null)
AnimalSegmented<String>(options: options, value: 'list', onChanged: (value) {})
AnimalSkeleton(active: true, rows: 3)
```

```dart
enum AnimalFormLayout { vertical, horizontal, inline }
AnimalForm(child: formFields, layout: AnimalFormLayout.horizontal, labelWidth: 96)
AnimalFormItem(label: const Text('昵称'), required: true, child: const AnimalInput())

AnimalTextarea(rows: 4, maxLength: 80, allowClear: true)
AnimalPasswordInput(allowClear: true)
AnimalSearchInput(onSearch: (value) {})
AnimalNumberInput(defaultValue: 1, min: 0, max: 10, step: 1)
```

```dart
enum AnimalPopoverPlacement { top, right, bottom, left }
enum AnimalPopoverTrigger { click, hover, manual }
enum AnimalDrawerPlacement { left, right }

AnimalPopover(content: const Text('提示'), child: const Text('打开'))
AnimalDropdown<String>(items: items, onChanged: (value) {}, child: child)
AnimalDrawer.show<void>(context: context, title: const Text('标题'), child: child)
AnimalConfirmDialog.show(context: context, content: const Text('确定继续？'))
```

```dart
enum AnimalDescriptionsLayout { horizontal, vertical }
enum AnimalTimelineItemStatus { defaultStatus, success, warning, danger, primary }

AnimalDescriptions(
  responsive: true,
  minColumnWidth: 170,
  items: const [
  AnimalDescriptionItem(label: Text('名称'), child: Text('星露岛')),
  ],
)
AnimalStatistic(title: const Text('访客'), value: 128, suffix: const Text('人'))
AnimalTimeline(items: [
  AnimalTimelineItem(
    title: const Text('整理背包'),
    status: AnimalTimelineItemStatus.success,
    onTap: () {},
  ),
])
```

```dart
enum AnimalUploadStatus { ready, uploading, done, error }
enum AnimalResultStatus { success, warning, error, info }

AnimalCalendar(value: selected, onChanged: (date) {})
AnimalUpload(files: files, onTap: () {}, onRemove: (file) {})
AnimalTree<String>(nodes: nodes, selectedValue: 'rose', onChanged: (value) {})
AnimalResult(status: AnimalResultStatus.success, title: const Text('提交成功'))
AnimalCalendarFormField(defaultValue: DateTime(2026, 5, 18), validator: (value) => null)
AnimalUploadFormField(files: files, validator: (files) => null)
AnimalTreeFormField<String>(nodes: nodes, defaultValue: 'rose', validator: (value) => null)
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
11. `AnimalProgress.value` uses a `0..1` ratio.
12. Public docs should show the pub.dev dependency; repository examples may use `path: ..`.
13. `AnimalSlider.value` uses the `min..max` numeric range, not a `0..1` ratio.
14. `AnimalSteps.current` is a zero-based index.
15. Use `Animal*FormField` wrappers inside Flutter `Form`; do not wrap Animal controls with unrelated Material form widgets just to validate.
16. Use `AnimalForm` and `AnimalFormItem` for label/help/error layout; keep validation controls inside Flutter `Form`.
17. `AnimalDropdown` closes itself after a non-disabled item is selected.
18. `AnimalPopover.open` is controlled state for manual or external control; do not invent React-style `visible`.
19. `AnimalDescriptions.span` is clamped to `1..column`, and responsive layouts reduce columns by container width unless `responsive` is false.
20. `AnimalCalendar.value` and `AnimalCalendar.month` are `DateTime`; keep date-only comparisons when handling selected days.
21. `AnimalUpload` is display/control state only; native file picking belongs in the app layer.
22. Stage 4 form wrappers are `AnimalCalendarFormField`, `AnimalUploadFormField`, and `AnimalTreeFormField`.
23. `AnimalCalendar` supports focused day keyboard navigation: arrow keys move days, PageUp/PageDown move months.
24. `AnimalUpload` supports Enter/Space activation when the upload area has focus, and removable file rows expose keyboard-activatable remove buttons.
25. `AnimalTimelineItem.onTap` enables click/hover/focus/Enter/Space behavior; use `disabled: true` to show an unavailable interactive step.
