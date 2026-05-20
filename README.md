# Animal Island Flutter

<div align="center">
    <img src="doc/img/readme-home.png" alt="animal-island-flutter" style="border-radius: 12px; width: 40%; display: block; margin: 0 auto;" />
</div>
<div align="center">
    一款复刻 animal-island-ui 风格的 Flutter 组件库
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
    简体中文 | <a href="./README.en.md">English</a>
</p>

## 介绍

`animal_island_flutter` 是基于 [`animal-island-ui`](https://github.com/guokaigdg/animal-island-ui) 复刻的 Flutter 组件库。它保留 React 版的暖米色背景、青绿色主色、棕色文字、pill 圆角、3D 按键阴影、动森风格图标和游戏式控件手感，同时使用 Flutter/Dart 更自然的 Widget API。

本项目用于学习 Flutter 组件库设计、跨端 UI 复刻和文档站搭建。视觉灵感来自生活模拟游戏的温暖岛屿氛围，但组件、代码和资源均以本项目内实现为准。

## 预览

示例文档项目位于 [`example`](./example)，当前文档页按 React demo 的内容结构改写为 Flutter 使用环境。

```powershell
cd example
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5178
```

## 安装

从 pub.dev 安装当前发布版：

```yaml
dependencies:
  animal_island_flutter: ^0.1.1
```

入口导入：

```dart
import 'package:animal_island_flutter/animal_island_flutter.dart';
```

如果需要和本仓库源码联调，可以临时改成本地 path 依赖：

```yaml
dependencies:
  animal_island_flutter:
    path: ../animal_island_flutter
```

## 版本与依赖

| 项目 | 版本 |
| --- | --- |
| Package | `animal_island_flutter: ^0.1.1` |
| Flutter SDK | `>=3.19.0` |
| Dart SDK | `>=3.3.0 <4.0.0` |
| `flutter_svg` | `^2.0.17` |
| `flutter_lints` | `^5.0.0` |

## 兼容平台

| 平台 | 状态 |
| --- | --- |
| Android | 已适配，可运行示例项目 |
| Windows | 已适配 Windows Flutter 工程 |
| Web | 已适配，可运行文档站预览 |
| iOS | 需在 macOS + Xcode 环境自行测试 |

## 快速上手

推荐在应用根部包一层 `AnimalTheme`：

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
              hintText: '今天想做什么？',
              allowClear: true,
              prefix: const Icon(Icons.search_rounded),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            AnimalButton(
              type: AnimalButtonType.primary,
              block: true,
              onPressed: () {},
              child: const Text('开始冒险'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 文档

| 文档 | 用途 |
| --- | --- |
| [`example`](./example) | Flutter 文档站与组件演示项目，内容按 React demo 编排并改写为 Flutter 示例。 |
| [`AI_USAGE.md`](./AI_USAGE.md) | 面向 AI 代码助手的 Flutter API 手册，列出组件、枚举、默认值、常见组合和禁用写法。 |
| [`DESIGN_PROMPT.md`](./DESIGN_PROMPT.md) | 设计/生成提示词，整理色板、字体、动效、背景、组件样式和禁止清单。 |
| [`skill/SKILL.md`](./skill/SKILL.md) | 像素级复刻 Skill，给 AI 助手维护 Flutter 组件库时使用。 |

## 组件映射

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

## 组件覆盖

当前包含 35 个 Flutter 组件：`Button`、`Input`、`Switch`、`Modal`、`Card`、`Collapse`、`Cursor`、`Time`、`Phone`、`Footer`、`Divider`、`Typewriter`、`Icon`、`Select`、`Tabs`、`Checkbox`、`CodeBlock`、`Loading`、`Table`、`Radio`、`Tag`、`Badge`、`Tooltip`、`Message`、`Progress`、`Pagination`、`Empty`、`Alert`、`Avatar`、`Breadcrumb`、`Steps`、`Slider`、`Rate`、`Segmented`、`Skeleton`。

Flutter 版本会优先保持视觉和交互语义一致；少量 Web/React 专属 API 会转换成 Flutter 习惯写法：

- `default` 在 Dart 中是关键字，因此枚举值写成 `defaultType` / `defaultColor`
- `Modal.open` 改为 `AnimalDialog.show(...)` 或自行构建 `AnimalDialog`
- `Select.value/onChange` 改为 `AnimalSelect.value/onChanged`
- `Checkbox.defaultValue/value` 改为 `AnimalCheckbox.defaultValue/value`
- `Table.dataSource` 改为 `AnimalTable.rows`
- `Table.render` 改为 `AnimalTableColumn.cellBuilder`
- `Loading.active` 改为 `AnimalLoading(active: true/false)`

## Dart 命名差异

| React 写法 | Flutter 写法 |
| --- | --- |
| `type="default"` | `AnimalButtonType.defaultType` |
| `Card type="default"` | `AnimalCardType.defaultType` |
| `Card color="default"` | `AnimalCardColor.defaultColor` |
| `Switch size="default"` | `AnimalSwitchSize.normal` |
| `onChange` | `onChanged` |
| `checkedChildren` | `checkedChild` |
| `unCheckedChildren` | `uncheckedChild` |

## 本地开发

```powershell
flutter pub get
flutter analyze
flutter test
```

运行示例：

```powershell
cd example
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5178
```

生成平台工程：

```powershell
cd example
flutter create --platforms=android,ios,windows .
```

## 视觉资产

项目已接入 React 源码中的 SVG/PNG/WebP 资源，位于 [`assets/animal_island/img`](./assets/animal_island/img)。字体来自 React 项目声明的 `@fontsource/nunito`、`@fontsource/noto-sans-sc`、`@fontsource/zen-maru-gothic` npm 包，已抽取为 Flutter 可注册的 `.woff2`，位于 [`assets/animal_island/fonts`](./assets/animal_island/fonts)。`Icon`、`Divider`、`Footer`、`Phone`、`Select`、`Cursor` 等组件会优先使用源码视觉资产；`Modal` 使用 Flutter 原生 `CustomClipper` 复刻 objectBoundingBox blob 轮廓。

## 注意事项

- 本项目主要用于学习、研究和 UI 组件库复刻展示。
- 若用于商业项目，请自行评估视觉风格、商标、素材和合规风险。
- 本项目不是任天堂官方产品，与任天堂株式会社无任何关联、授权或合作关系。
- Android、Windows、Web 已完成示例项目适配；iOS 需在 macOS + Xcode 环境自行测试。

## License

MIT
