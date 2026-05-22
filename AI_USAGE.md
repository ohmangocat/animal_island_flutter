# animal_island_flutter · AI Usage Guide

> 面向 AI 代码助手：这是生成 `animal_island_flutter` 用法代码的优先参考。只使用本文件列出的组件、枚举和参数，不要套用 React 版 props，也不要臆造 `variant`、`shape`、`className`、`style` 等 Web API。

## 0. Setup

```yaml
dependencies:
  animal_island_flutter: ^0.1.2
```

```dart
import 'package:animal_island_flutter/animal_island_flutter.dart';
```

推荐在应用根部包一层：

```dart
MaterialApp(
  home: AnimalTheme(
    child: const App(),
  ),
)
```

主题定制优先使用 `AnimalThemeData.fromPrimary(...)`，再通过 `copyWith` 覆盖字体、圆角、行高、背景、文字和边框：

```dart
final theme = AnimalThemeData.fromPrimary(
  const Color(0xFF4E8F75),
  textColor: const Color(0xFF5B4228),
).copyWith(
  backgroundColor: const Color(0xFFF4F1E7),
  secondaryBackgroundColor: const Color(0xFFE9DFCC),
  borderColor: const Color(0xFFA89170),
  lightBorderColor: const Color(0xFFE2D5BD),
  radius: 22,
  fontFamily: 'Inter',
  fontPackage: null,
  fontFamilyFallback: const ['Noto Sans SC', 'sans-serif'],
  textHeight: 1.45,
);

AnimalTheme(data: theme, child: const App());
```

如果字体来自业务 App 自己的 `pubspec.yaml`，需要显式传 `fontPackage: null`。

主题换肤时不要逐个组件传颜色。优先使用这些令牌：

- 主色链路：`primaryColor`、`primaryHoverColor`、`primaryActiveColor`、`primaryBackgroundColor`。
- 条纹和强调：`primarySolidColor`、`primaryStripeBackgroundColor`、`primaryStripeColor`、`primaryStripeBorderColor`。
- 中立底色：`backgroundColor`、`secondaryBackgroundColor`、`contentBackgroundColor`、`elevatedBackgroundColor`、`subtleBackgroundColor`。
- 文本和图标：`textColor`、`bodyTextColor`、`secondaryTextColor`、`placeholderColor`、`mutedIconColor`。
- 边框和阴影：`borderColor`、`lightBorderColor`、`controlBorderColor`、`warmBorderColor`、`tactileShadowColor`。

最低环境来自 `pubspec.yaml`：

- Dart SDK: `>=3.3.0 <4.0.0`
- Flutter: `>=3.19.0`
- 依赖：`flutter_svg`

## 1. Public Exports

```dart
export 'src/animal_theme.dart';
export 'src/components/alert.dart';
export 'src/components/avatar.dart';
export 'src/components/badge.dart';
export 'src/components/breadcrumb.dart';
export 'src/components/button.dart';
export 'src/components/card.dart';
export 'src/components/checkbox.dart';
export 'src/components/code_block.dart';
export 'src/components/collapse.dart';
export 'src/components/cursor.dart';
export 'src/components/dialog.dart';
export 'src/components/divider.dart';
export 'src/components/empty.dart';
export 'src/components/footer.dart';
export 'src/components/form.dart';
export 'src/components/icon.dart';
export 'src/components/input.dart';
export 'src/components/input_variants.dart';
export 'src/components/loading.dart';
export 'src/components/message.dart';
export 'src/components/overlay.dart';
export 'src/components/pagination.dart';
export 'src/components/phone.dart';
export 'src/components/progress.dart';
export 'src/components/radio.dart';
export 'src/components/rate.dart';
export 'src/components/segmented.dart';
export 'src/components/select.dart';
export 'src/components/skeleton.dart';
export 'src/components/slider.dart';
export 'src/components/steps.dart';
export 'src/components/switch.dart';
export 'src/components/table.dart';
export 'src/components/tabs.dart';
export 'src/components/tag.dart';
export 'src/components/time.dart';
export 'src/components/tooltip.dart';
export 'src/components/typewriter.dart';
export 'src/components/data_display.dart';
```

## 2. Component API

### 2.1 AnimalButton

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
AnimalButton(
  type: AnimalButtonType.primary,
  onPressed: save,
  child: const Text('保存'),
)
AnimalButton(
  type: AnimalButtonType.primary,
  loading: true,
  onPressed: () {},
  child: const Text('Loading'),
)
```

### 2.2 AnimalInput

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
  TextInputAction? textInputAction,
  TextCapitalization textCapitalization = TextCapitalization.none,
  Iterable<String>? autofillHints,
  int? maxLines = 1,
  int? maxLength,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  VoidCallback? onEditingComplete,
  VoidCallback? onClear,
})

AnimalInputFormField({
  String? initialValue,
  TextEditingController? controller,
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
  TextInputAction? textInputAction,
  TextCapitalization textCapitalization = TextCapitalization.none,
  Iterable<String>? autofillHints,
  int? maxLines = 1,
  int? maxLength,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  VoidCallback? onEditingComplete,
  VoidCallback? onClear,
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  FormFieldSetter<String>? onSaved,
  FormFieldValidator<String>? validator,
})
```

`controller` 与 `initialValue` 二选一优先使用 `controller`。`allowClear` 会显示清除按钮并触发 `onClear`。
需要接入 Flutter `Form` 时使用 `AnimalInputFormField`，不要在外层再包一个 `TextFormField`。

```dart
final formKey = GlobalKey<FormState>();

Form(
  key: formKey,
  child: AnimalInputFormField(
    hintText: '岛民昵称',
    allowClear: true,
    textInputAction: TextInputAction.done,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return '请输入昵称';
      }
      return null;
    },
    onSaved: (value) {},
  ),
)
```

### 2.3 AnimalSwitch

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
  Widget? checkedChild,
  Widget? uncheckedChild,
  ValueChanged<bool>? onChanged,
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  FormFieldSetter<bool>? onSaved,
  FormFieldValidator<bool>? validator,
})
```

`value` 非空时为受控模式；否则使用 `defaultValue` 初始化内部状态。
接入 Flutter `Form` 时使用 `AnimalSwitchFormField`，错误文本会沿用 Animal 主题色。

### 2.4 AnimalDialog

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

常用方式：

```dart
AnimalDialog.show<void>(
  context: context,
  title: const Text('确认'),
  child: const Text('是否继续？'),
  onOk: submit,
);
```

`AnimalDialog.show` 额外支持 `barrierDismissible`。关闭动作由 `Navigator.maybePop()` 处理。

### 2.5 AnimalCard

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

### 2.6 AnimalCollapse

```dart
AnimalCollapse({
  required Widget question,
  required Widget answer,
  bool defaultExpanded = false,
  bool disabled = false,
})
```

### 2.7 AnimalCursor

```dart
AnimalCursor({
  required Widget child,
  MouseCursor cursor = SystemMouseCursors.click,
  bool showImageCursor = true,
})
```

Web 会注入自定义图片光标；其他平台使用 `MouseRegion` 的 `cursor` 回退。

### 2.8 AnimalSelect

```dart
class AnimalSelectOption<T> {
  const AnimalSelectOption({required T key, required String label});
}

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
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  FormFieldSetter<T>? onSaved,
  FormFieldValidator<T>? validator,
})
```

`AnimalSelect` 是受控组件，必须提供 `value` 和 `onChanged`。下拉层会根据视口空间自动上下翻转，并通过 `dropdownMaxHeight` 限制高度，超出后内部滚动，避免移动端溢出。支持 hover 光标与键盘打开/选择/关闭。表单场景使用 `AnimalSelectFormField`，`onChanged` 可选。

### 2.9 AnimalCheckbox

```dart
enum AnimalCheckboxSize { small, middle, large }
enum AnimalCheckboxDirection { horizontal, vertical }

class AnimalCheckboxOption<T> {
  const AnimalCheckboxOption({
    required Widget label,
    required T value,
    bool disabled = false,
  });
}

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
  ValueChanged<List<T>>? onChanged,
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  FormFieldSetter<List<T>>? onSaved,
  FormFieldValidator<List<T>>? validator,
})
```

### 2.10 AnimalTabs

```dart
class AnimalTabItem {
  const AnimalTabItem({
    required String key,
    required Widget label,
    required Widget child,
  });
}

AnimalTabs({
  required List<AnimalTabItem> items,
  String? defaultActiveKey,
  String? activeKey,
  ValueChanged<String>? onChanged,
  bool leafAnimation = true,
  bool shadow = true,
})
```

`activeKey` 非空时为受控模式；默认选中 `defaultActiveKey` 或第一个 tab。

### 2.11 AnimalIcon

```dart
enum AnimalIconName {
  miles, camera, chat, critterpedia, design,
  diy, helicopter, map, shopping, variant,
}

const animalIconList = <AnimalIconInfo>[...];

AnimalIcon({
  required AnimalIconName name,
  double size = 24,
  bool bounce = false,
})
```

### 2.12 Decorative Components

```dart
enum AnimalFooterType { sea, tree }
AnimalFooter({AnimalFooterType type = AnimalFooterType.tree, double? height})

enum AnimalDividerType { lineBrown, lineTeal, lineWhite, lineYellow, waveYellow }
AnimalDivider({AnimalDividerType type = AnimalDividerType.lineBrown, double height = 12})

AnimalTime({DateTime? now})
AnimalPhone({double width = 527, double height = 788})
```

### 2.13 Text / Code / Loading / Table

```dart
AnimalTypewriter({
  required String text,
  Duration speed = const Duration(milliseconds: 90),
  Object? trigger,
  bool autoPlay = true,
  TextStyle? style,
  VoidCallback? onDone,
})

AnimalCodeBlock({
  required String code,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(20)),
})

enum AnimalLoadingStyle { island, spinner, stripes }
AnimalLoading({
  double size = 28,
  double strokeWidth = 3,
  bool active = true,
  AnimalLoadingStyle style = AnimalLoadingStyle.island,
})

class AnimalTableColumn<T> {
  const AnimalTableColumn({
    required Widget title,
    required Widget Function(BuildContext context, T row, int index) cellBuilder,
    double? width,
    AlignmentGeometry alignment = Alignment.centerLeft,
  });
}

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

`AnimalTable` 在列宽总和超出容器时会自动横向滚动，并显示底部滚动条；窄屏或移动端无需额外包裹横向 `SingleChildScrollView`。

### 2.14 Extended Basics

```dart
enum AnimalRadioSize { small, middle, large }
enum AnimalRadioDirection { horizontal, vertical }

class AnimalRadioOption<T> {
  const AnimalRadioOption({
    required Widget label,
    required T value,
    bool disabled = false,
  });
}

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
  ValueChanged<T>? onChanged,
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  FormFieldSetter<T>? onSaved,
  FormFieldValidator<T>? validator,
})
```

```dart
enum AnimalTagColor {
  defaultColor, primary, success, warning, danger, blue, purple, brown,
}
enum AnimalTagSize { small, middle, large }

AnimalTag({
  required Widget child,
  AnimalTagColor color = AnimalTagColor.defaultColor,
  AnimalTagSize size = AnimalTagSize.middle,
  bool closable = false,
  VoidCallback? onClose,
  Widget? icon,
})
```

```dart
enum AnimalBadgeStatus { defaultStatus, primary, success, warning, danger }

AnimalBadge({
  Widget? child,
  int? count,
  String? text,
  bool dot = false,
  bool showZero = false,
  int maxCount = 99,
  AnimalBadgeStatus status = AnimalBadgeStatus.danger,
  Offset offset = Offset.zero,
})
```

```dart
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

AnimalMessage.success(context, const Text('保存成功'));

AnimalProgress({
  required double value, // 0..1
  double height = 16,
  bool showLabel = true,
})

AnimalPagination({
  required int current,
  required int total,
  required ValueChanged<int> onChanged,
  int pageSize = 10,
  int maxVisiblePages = 5,
  bool disabled = false,
})

AnimalEmpty({
  String description = '暂无数据',
  Widget? icon,
  Widget? action,
})
```

### 2.15 Advanced Basics

```dart
enum AnimalAlertType { info, success, warning, error }

AnimalAlert({
  Widget? title,
  required Widget child,
  AnimalAlertType type = AnimalAlertType.info,
  bool showIcon = true,
  bool closable = false,
  VoidCallback? onClose,
})
```

```dart
enum AnimalAvatarSize { small, middle, large }
enum AnimalAvatarShape { circle, square }

AnimalAvatar({
  Widget? child,
  ImageProvider? image,
  String? imageUrl,
  AnimalIconName? icon,
  AnimalAvatarSize size = AnimalAvatarSize.middle,
  AnimalAvatarShape shape = AnimalAvatarShape.circle,
})
```

```dart
AnimalBreadcrumb({
  required List<AnimalBreadcrumbItem> items,
  Widget? separator,
})

AnimalSteps({
  required List<AnimalStepItem> items,
  int current = 0,
  AnimalStepsDirection direction = AnimalStepsDirection.horizontal,
  ValueChanged<int>? onChanged,
})
```

```dart
AnimalSlider({
  double? value,
  double defaultValue = 0,
  double min = 0,
  double max = 100,
  int? divisions,
  bool disabled = false,
  bool showLabel = true,
  ValueChanged<double>? onChanged,
})

AnimalSliderFormField({
  double? value,
  double defaultValue = 0,
  double min = 0,
  double max = 100,
  int? divisions,
  bool disabled = false,
  bool showLabel = true,
  ValueChanged<double>? onChanged,
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  FormFieldSetter<double>? onSaved,
  FormFieldValidator<double>? validator,
})

AnimalRate({
  int? value,
  int defaultValue = 0,
  int count = 5,
  bool disabled = false,
  ValueChanged<int>? onChanged,
})

AnimalRateFormField({
  int? value,
  int defaultValue = 0,
  int count = 5,
  bool disabled = false,
  ValueChanged<int>? onChanged,
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  FormFieldSetter<int>? onSaved,
  FormFieldValidator<int>? validator,
})
```

```dart
AnimalSegmented<T>({
  required List<AnimalSegmentedOption<T>> options,
  T? value,
  T? defaultValue,
  bool disabled = false,
  ValueChanged<T>? onChanged,
})

AnimalSkeleton({
  bool active = true,
  int rows = 3,
  double? width,
  double lineHeight = 14,
  Widget? child,
})
```

### 2.16 Phase 3 Business Components

```dart
enum AnimalFormLayout { vertical, horizontal, inline }

AnimalForm({
  required Widget child,
  GlobalKey<FormState>? formKey,
  AnimalFormLayout layout = AnimalFormLayout.vertical,
  double labelWidth = 112,
  double spacing = 16,
  AutovalidateMode? autovalidateMode,
  VoidCallback? onChanged,
})

AnimalFormItem({
  required Widget child,
  Widget? label,
  bool required = false,
  Widget? help,
  String? errorText,
  AnimalFormLayout? layout,
  double? labelWidth,
  EdgeInsetsGeometry? margin,
})
```

```dart
AnimalTextarea({
  TextEditingController? controller,
  String? initialValue,
  String? hintText,
  int rows = 4,
  int? maxLength,
  bool allowClear = false,
  bool enabled = true,
  bool shadow = false,
  AnimalInputStatus? status,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  VoidCallback? onClear,
})

AnimalPasswordInput({
  TextEditingController? controller,
  String? initialValue,
  String hintText = '请输入密码',
  AnimalInputSize size = AnimalInputSize.middle,
  bool allowClear = false,
  bool enabled = true,
  bool shadow = false,
  AnimalInputStatus? status,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
})

AnimalSearchInput({
  TextEditingController? controller,
  String? initialValue,
  String hintText = '搜索',
  AnimalInputSize size = AnimalInputSize.middle,
  bool allowClear = true,
  bool enabled = true,
  bool shadow = false,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  ValueChanged<String>? onSearch,
})

AnimalNumberInput({
  num? value,
  num defaultValue = 0,
  num? min,
  num? max,
  num step = 1,
  AnimalInputSize size = AnimalInputSize.middle,
  bool enabled = true,
  bool shadow = false,
  ValueChanged<num>? onChanged,
})
```

```dart
enum AnimalPopoverPlacement { top, right, bottom, left }
enum AnimalPopoverTrigger { click, hover, manual }

AnimalPopover({
  required Widget child,
  required Widget content,
  Widget? title,
  AnimalPopoverPlacement placement = AnimalPopoverPlacement.bottom,
  AnimalPopoverTrigger trigger = AnimalPopoverTrigger.click,
  bool? open,
  ValueChanged<bool>? onOpenChanged,
  double width = 260,
  double gap = 10,
})

AnimalDropdown<T>({
  required Widget child,
  required List<AnimalDropdownItem<T>> items,
  required ValueChanged<T> onChanged,
  AnimalPopoverPlacement placement = AnimalPopoverPlacement.bottom,
  double width = 220,
})
```

`AnimalDropdown` 选中非禁用项后会自动关闭浮层。`AnimalPopoverTrigger.manual` 需要通过 `open` 和 `onOpenChanged` 受控。

```dart
enum AnimalDrawerPlacement { left, right }

AnimalDrawer.show<T>({
  required BuildContext context,
  required Widget child,
  Widget? title,
  Widget? footer,
  AnimalDrawerPlacement placement = AnimalDrawerPlacement.right,
  double width = 360,
  bool barrierDismissible = true,
})

AnimalConfirmDialog.show({
  required BuildContext context,
  required Widget content,
  Widget? title,
  String okText = '确定',
  String cancelText = '取消',
  VoidCallback? onOk,
  bool danger = false,
})
```

```dart
enum AnimalDescriptionsLayout { horizontal, vertical }

AnimalDescriptions({
  required List<AnimalDescriptionItem> items,
  Widget? title,
  int column = 3,
  AnimalDescriptionsLayout layout = AnimalDescriptionsLayout.horizontal,
  bool responsive = true,
  double minColumnWidth = 170,
})

AnimalStatistic({
  required num value,
  Widget? title,
  Widget? prefix,
  Widget? suffix,
  Widget? description,
  Color? color,
})

enum AnimalTimelineItemStatus {
  defaultStatus, success, warning, danger, primary,
}

AnimalTimelineItem({
  required Widget title,
  Widget? description,
  Widget? time,
  AnimalTimelineItemStatus status = AnimalTimelineItemStatus.defaultStatus,
  Widget? icon,
  VoidCallback? onTap,
  bool disabled = false,
})

AnimalTimeline({
  required List<AnimalTimelineItem> items,
})
```

`AnimalDescriptions` 默认会根据容器宽度自动减少列数，窄容器下切换为纵向标签，适合抽屉、弹窗和移动端详情页。`AnimalTimelineItem.onTap` 会启用 hover、小手光标和 `Enter` / `Space` 键盘触发；只读节点不要传 `onTap`，禁用节点使用 `disabled: true`。

### 2.17 Phase 4 Complex Business Components

```dart
AnimalCalendar({
  DateTime? value,
  DateTime? defaultValue,
  DateTime? month,
  DateTime? firstDate,
  DateTime? lastDate,
  ValueChanged<DateTime>? onChanged,
  ValueChanged<DateTime>? onMonthChanged,
})

AnimalCalendarFormField({
  DateTime? value,
  DateTime? defaultValue,
  DateTime? month,
  DateTime? firstDate,
  DateTime? lastDate,
  bool disabled = false,
  FormFieldValidator<DateTime>? validator,
  FormFieldSetter<DateTime>? onSaved,
})
```

`AnimalCalendar` 聚焦日期后支持方向键移动日期，`PageUp` / `PageDown` 切换月份；超出 `firstDate` / `lastDate` 的日期不会被选中。

```dart
enum AnimalUploadStatus { ready, uploading, done, error }

AnimalUpload({
  List<AnimalUploadFile> files = const [],
  VoidCallback? onTap,
  ValueChanged<AnimalUploadFile>? onRemove,
  bool disabled = false,
  String title = '上传文件',
  String hint = '点击选择文件，或将文件拖到这里',
})

AnimalUploadFormField({
  List<AnimalUploadFile> files = const [],
  VoidCallback? onTap,
  ValueChanged<AnimalUploadFile>? onRemove,
  ValueChanged<List<AnimalUploadFile>>? onChanged,
  bool disabled = false,
  bool removable = true,
  FormFieldValidator<List<AnimalUploadFile>>? validator,
  FormFieldSetter<List<AnimalUploadFile>>? onSaved,
})
```

`AnimalUpload` 上传区域获得焦点后支持 `Enter` / `Space` 触发 `onTap`，文件行删除按钮也支持 hover、小手和键盘触发。组件只负责展示和触发，文件选择、拖拽上传、权限处理仍由业务层完成。

```dart
AnimalTree<T>({
  required List<AnimalTreeNode<T>> nodes,
  T? selectedValue,
  List<T> defaultExpandedValues = const [],
  ValueChanged<T>? onChanged,
  ValueChanged<List<T>>? onExpandedChanged,
})

AnimalTreeFormField<T>({
  required List<AnimalTreeNode<T>> nodes,
  T? selectedValue,
  T? defaultValue,
  List<T> defaultExpandedValues = const [],
  bool disabled = false,
  FormFieldValidator<T>? validator,
  FormFieldSetter<T>? onSaved,
})
```

```dart
enum AnimalResultStatus { success, warning, error, info }

AnimalResult({
  required Widget title,
  Widget? description,
  AnimalResultStatus status = AnimalResultStatus.info,
  Widget? extra,
  Widget? action,
})
```

## 3. Common Recipes

### Form

```dart
final formKey = GlobalKey<FormState>();

Form(
  key: formKey,
  child: AnimalCard(
    child: Column(
      children: [
        AnimalInputFormField(
          hintText: '邮箱',
          allowClear: true,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value == null || value.isEmpty ? '请输入邮箱' : null,
        ),
        const SizedBox(height: 12),
        AnimalSelectFormField<String>(
          options: const [
            AnimalSelectOption(key: 'north', label: '北半球'),
            AnimalSelectOption(key: 'south', label: '南半球'),
          ],
          value: null,
          validator: (value) => value == null ? '请选择岛屿半球' : null,
        ),
        const SizedBox(height: 12),
        AnimalSwitchFormField(
          checkedChild: const Text('ON'),
          uncheckedChild: const Text('OFF'),
          validator: (value) => value == true ? null : '需要同意通知',
        ),
        const SizedBox(height: 12),
        AnimalCalendarFormField(
          defaultValue: DateTime(2026, 5, 18),
          validator: (value) => value == null ? '请选择预约日期' : null,
        ),
        const SizedBox(height: 16),
        AnimalButton(
          type: AnimalButtonType.primary,
          block: true,
          onPressed: () {
            final state = formKey.currentState!;
            if (state.validate()) {
              state.save();
            }
          },
          child: const Text('提交'),
        ),
      ],
    ),
  ),
)
```

### Form Layout

```dart
AnimalForm(
  formKey: formKey,
  layout: AnimalFormLayout.horizontal,
  labelWidth: 96,
  child: Column(
    children: const [
      AnimalFormItem(
        label: Text('岛民昵称'),
        required: true,
        help: Text('显示在岛民名片上'),
        child: AnimalInput(hintText: '请输入昵称', allowClear: true),
      ),
      AnimalFormItem(
        label: Text('留言'),
        child: AnimalTextarea(rows: 4, hintText: '写下今天的计划'),
      ),
    ],
  ),
)
```

### Overlay

```dart
AnimalDropdown<String>(
  items: const [
    AnimalDropdownItem(
      value: 'copy',
      icon: Icon(Icons.copy_rounded),
      label: Text('复制地址'),
    ),
    AnimalDropdownItem(
      value: 'delete',
      label: Text('删除记录'),
      disabled: true,
    ),
  ],
  onChanged: (value) {},
  child: const AnimalButton(child: Text('打开菜单')),
)

AnimalDrawer.show<void>(
  context: context,
  title: const Text('岛屿背包'),
  child: const Text('抽屉内容'),
)
```

### Data Display

```dart
const AnimalDescriptions(
  title: Text('岛屿信息'),
  items: [
    AnimalDescriptionItem(label: Text('名称'), child: Text('星露岛')),
    AnimalDescriptionItem(label: Text('水果'), child: Text('桃子')),
  ],
)

const AnimalStatistic(title: Text('今日访客'), value: 128, suffix: Text('人'))

const AnimalTimeline(
  items: [
    AnimalTimelineItem(
      title: Text('整理背包'),
      status: AnimalTimelineItemStatus.success,
    ),
  ],
)
```

### Confirm Dialog

```dart
final ok = await AnimalConfirmDialog.show(
  context: context,
  title: const Text('删除记录？'),
  danger: true,
  okText: '删除',
  content: const Text('这个操作无法撤销。'),
);
```

### Table

```dart
AnimalTable<Item>(
  rows: items,
  columns: [
    AnimalTableColumn<Item>(
      title: const Text('名称'),
      cellBuilder: (_, row, __) => Text(row.name),
    ),
  ],
  loading: loading,
  onRowTap: (row, index) {},
)
```

## 4. Hard Rules

1. 只从 `package:animal_island_flutter/animal_island_flutter.dart` 导入公开 API。
2. 不要把 React props 写进 Flutter：没有 `className`、`style`、`htmlType`、`open`、`onChange`。
3. Dart 枚举使用 camelCase：`defaultType`、`defaultColor`、`normal`。
4. `AnimalSelect` 必须提供 `value` 和 `onChanged`。
5. `AnimalCheckbox` / `AnimalSwitch` / `AnimalTabs` 传入 `value` 或 `activeKey` 时，应同时传 `onChanged`。
6. 按钮 loading 状态会禁用点击；不要依赖 loading 按钮触发 `onPressed`。
7. `AnimalTypewriter` 只接收 `String text`，不是 ReactNode 树。
8. `AnimalCodeBlock` 用于 Dart/JS/TS 示例显示，不提供 `language` 参数。
9. 不要强行覆盖圆角和 3D 底部阴影；这是设计语言核心。
10. Web 光标由 `AnimalCursor` 注入 CSS，Android/iOS 上不会显示鼠标图片光标。
11. `AnimalProgress.value` 使用 `0..1` 比例，不是 `0..100`。
12. 仓库内 `example/pubspec.yaml` 可使用 `path: ..`，对外文档安装示例使用 pub.dev 版本。
13. `AnimalSlider.value` 使用 `min..max` 范围内数值；`AnimalProgress.value` 才使用 `0..1` 比例。
14. `AnimalSteps.current` 是从 `0` 开始的步骤索引。
15. 自定义品牌色优先用 `AnimalThemeData.fromPrimary`；不要逐个组件硬编码颜色。
16. 完整换肤要同时考虑 `backgroundColor`、`secondaryBackgroundColor`、`textColor`、`borderColor` 和 `lightBorderColor`，组件会派生中立底色和控件边框。
17. 使用应用自身字体时，`copyWith(fontPackage: null)`，否则 Flutter 会按 package 字体查找。
18. `AnimalPopover.open` 仅用于受控模式；不要像 React 一样传 `visible` 或 `openChange`。
19. `AnimalNumberInput.value` 是 `num?`，回调也是 `ValueChanged<num>`，需要整数时在业务层 `round()`。
20. `AnimalDescriptions.column` 至少按 `1` 处理，`span` 会被限制在 `1..column`。

## 5. Minimal Boilerplate

```dart
import 'package:animal_island_flutter/animal_island_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimalTheme(
        child: const DemoPage(),
      ),
    ),
  );
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimalCursor(
      child: Scaffold(
        body: Center(
          child: AnimalButton(
            type: AnimalButtonType.primary,
            onPressed: () {},
            child: const Text('Start'),
          ),
        ),
      ),
    );
  }
}
```
