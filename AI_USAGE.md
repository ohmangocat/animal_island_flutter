# animal_island_flutter · AI Usage Guide

> 面向 AI 代码助手：这是生成 `animal_island_flutter` 用法代码的优先参考。只使用本文件列出的组件、枚举和参数，不要套用 React 版 props，也不要臆造 `variant`、`shape`、`className`、`style` 等 Web API。

## 0. Setup

```yaml
dependencies:
  animal_island_flutter:
    path: ../animal_island_flutter
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

最低环境来自 `pubspec.yaml`：

- Dart SDK: `>=3.3.0 <4.0.0`
- Flutter: `>=3.19.0`
- 依赖：`flutter_svg`

## 1. Public Exports

```dart
export 'src/animal_theme.dart';
export 'src/components/button.dart';
export 'src/components/card.dart';
export 'src/components/checkbox.dart';
export 'src/components/code_block.dart';
export 'src/components/collapse.dart';
export 'src/components/cursor.dart';
export 'src/components/dialog.dart';
export 'src/components/divider.dart';
export 'src/components/footer.dart';
export 'src/components/icon.dart';
export 'src/components/input.dart';
export 'src/components/loading.dart';
export 'src/components/phone.dart';
export 'src/components/select.dart';
export 'src/components/switch.dart';
export 'src/components/table.dart';
export 'src/components/tabs.dart';
export 'src/components/time.dart';
export 'src/components/typewriter.dart';
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
  ValueChanged<String>? onChanged,
  VoidCallback? onClear,
})
```

`controller` 与 `initialValue` 二选一优先使用 `controller`。`allowClear` 会显示清除按钮并触发 `onClear`。

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
```

`value` 非空时为受控模式；否则使用 `defaultValue` 初始化内部状态。

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
})
```

`AnimalSelect` 是受控组件，必须提供 `value` 和 `onChanged`。下拉层会根据视口空间自动上下翻转。

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

## 3. Common Recipes

### Form

```dart
AnimalCard(
  child: Column(
    children: [
      AnimalInput(
        hintText: '邮箱',
        allowClear: true,
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) {},
      ),
      const SizedBox(height: 12),
      AnimalSwitch(
        defaultValue: true,
        checkedChild: const Text('ON'),
        uncheckedChild: const Text('OFF'),
        onChanged: (value) {},
      ),
      const SizedBox(height: 16),
      AnimalButton(
        type: AnimalButtonType.primary,
        block: true,
        onPressed: () {},
        child: const Text('提交'),
      ),
    ],
  ),
)
```

### Confirm Dialog

```dart
AnimalDialog.show<void>(
  context: context,
  title: const Text('删除记录？'),
  child: const Text('这个操作无法撤销。'),
  onOk: () {
    deleteRecord();
    Navigator.of(context).maybePop();
  },
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
