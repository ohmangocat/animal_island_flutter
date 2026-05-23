# Animal Island Flutter

<div align="center">
    <img src="doc/img/readme-home.png" alt="animal-island-flutter" style="border-radius: 12px; width: 40%; display: block; margin: 0 auto;" />
</div>
<div align="center">
    一个温暖、轻快、带有岛屿生活感的 Flutter 组件库
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

`animal_island_flutter` 是一个 Flutter UI 组件库，提供桌面 Web 文档、移动端预览、基础控件、表单控件、反馈组件、数据展示组件、复杂业务组件和移动端业务组件。

组件视觉以暖米色背景、青绿色主色、棕色文字、圆润控件、底部触感阴影、轻量动效和岛屿风格图形资源为核心。它适合做有一点可爱感、但仍然保持清晰可用的 Flutter 应用界面。

当前包已经发布到 pub.dev，并维护了本地文档站、手机模拟器预览、测试用例、发布脚本、AI 使用手册和设计提示文档。

## 安装

```yaml
dependencies:
  animal_island_flutter: ^0.1.3
```

```dart
import 'package:animal_island_flutter/animal_island_flutter.dart';
```

## 环境

| 项目 | 版本 |
| --- | --- |
| Package | `animal_island_flutter: ^0.1.3` |
| Flutter SDK | `>=3.19.0` |
| Dart SDK | `>=3.3.0 <4.0.0` |
| `flutter_svg` | `^2.0.17` |
| `flutter_lints` | `^5.0.0` |

## 平台支持

| 平台 | 状态 |
| --- | --- |
| Android | 已适配，可运行示例项目 |
| Windows | 已适配，可运行示例项目 |
| Web | 已适配，文档站和移动预览均可运行 |
| iOS | 代码侧保留支持，需要在 macOS + Xcode 环境自行测试 |

## 快速使用

推荐在应用根部使用 `AnimalTheme`，统一接入颜色、字体、圆角、背景、边框和触感阴影。

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
              child: const Text('开始'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 主题定制

`AnimalThemeData.fromPrimary(...)` 可以根据一个品牌主色自动派生 hover、active、条纹 loading、浅背景等颜色。你也可以通过 `copyWith` 覆盖字体、圆角、行高、背景、文字、边框和阴影令牌。

```dart
final theme = AnimalThemeData.fromPrimary(
  const Color(0xFF4E8F75),
  textColor: const Color(0xFF5B4228),
).copyWith(
  radius: 22,
  fontFamily: 'Inter',
  fontPackage: null,
  fontFamilyFallback: const ['Noto Sans SC', 'sans-serif'],
  textHeight: 1.45,
);

AnimalTheme(data: theme, child: const App());
```

常用主题令牌：

| 令牌 | 用途 |
| --- | --- |
| `primaryColor` / `primaryHoverColor` / `primaryActiveColor` | 主色、hover、active |
| `primarySolidColor` / `primaryStripeColor` | Tabs 激活色、Button/Loading 条纹色 |
| `backgroundColor` / `secondaryBackgroundColor` | 页面底色、控件浅底 |
| `contentBackgroundColor` / `elevatedBackgroundColor` | 输入框、表格、浮层底色 |
| `textColor` / `bodyTextColor` / `secondaryTextColor` | 标题、正文、次要文本 |
| `borderColor` / `lightBorderColor` / `controlBorderColor` | 常规边框、浅边框、控件边框 |
| `tactileShadowColor` | 按钮、分页、滑块等底部触感阴影 |

当字体由你的应用工程注册时，将 `fontPackage` 设置为 `null`。

## 组件能力

当前组件库包含 74 个组件页面，覆盖基础控件、反馈、数据展示、表单、复杂业务和移动端业务场景。

| 分类 | 组件 |
| --- | --- |
| 基础控件 | `AnimalButton` / `AnimalInput` / `AnimalSwitch` / `AnimalCard` / `AnimalCollapse` / `AnimalTabs` / `AnimalCheckbox` / `AnimalSelect` |
| 展示与装饰 | `AnimalIcon` / `AnimalDivider` / `AnimalFooter` / `AnimalPhone` / `AnimalTime` / `AnimalTypewriter` / `AnimalCodeBlock` |
| 反馈组件 | `AnimalDialog` / `AnimalLoading` / `AnimalAlert` / `AnimalTooltip` / `AnimalMessage` / `AnimalProgress` / `AnimalEmpty` / `AnimalResult` |
| 选择与输入 | `AnimalRadio` / `AnimalRate` / `AnimalSlider` / `AnimalSegmented` / `AnimalTextarea` / `AnimalPasswordInput` / `AnimalSearchInput` / `AnimalNumberInput` |
| 导航与状态 | `AnimalPagination` / `AnimalBreadcrumb` / `AnimalSteps` / `AnimalBadge` / `AnimalTag` / `AnimalSkeleton` |
| 表单能力 | `AnimalForm` / `AnimalFormItem` / `AnimalInputFormField` / `AnimalSelectFormField` / `AnimalCheckboxFormField` / `AnimalRadioFormField` / `AnimalSwitchFormField` / `AnimalSliderFormField` / `AnimalRateFormField` / `AnimalCalendarFormField` / `AnimalUploadFormField` / `AnimalTreeFormField` |
| 浮层与详情 | `AnimalPopover` / `AnimalDropdown` / `AnimalDrawer` / `AnimalConfirmDialog` / `AnimalDescriptions` / `AnimalStatistic` / `AnimalTimeline` |
| 复杂业务 | `AnimalTable` / `AnimalCalendar` / `AnimalUpload` / `AnimalTree` |
| 移动基础 | `AnimalMobileNavBar` / `AnimalBottomBar` / `AnimalBottomSheet` / `AnimalActionSheet` / `AnimalListTile` / `AnimalCellGroup` / `AnimalMobileSearchBar` / `AnimalPicker` / `AnimalMobileDatePicker` / `AnimalMobileStepper` / `AnimalSwipeAction` / `AnimalPullRefresh` / `AnimalMobileSection` |
| 移动业务 | `AnimalMobileProductCard` / `AnimalMobileOrderCard` / `AnimalMobileProfileHeader` / `AnimalMobileStatsGrid` / `AnimalMobileCouponCard` / `AnimalMobileNoticeBar` / `AnimalMobileAddressCard` / `AnimalMobilePriceSummary` / `AnimalMobileCheckoutBar` / `AnimalMobileCartItem` / `AnimalMobileOrderTimeline` / `AnimalMobilePaymentMethodCard` / `AnimalMobileEmptyAction` |

## 文档与示例

仓库内置两个示例项目：

| 路径 | 说明 |
| --- | --- |
| [`example`](./example) | 组件文档站，包含首页、组件列表、组件详情、全局搜索、主题示例和手机模拟器入口。 |
| [`example/mobile_preview`](./example/mobile_preview) | 独立移动端预览项目，可单独打包到 Android、Windows 或 Web，用于体验移动组件在手机页面中的效果。 |

运行桌面文档站：

```powershell
cd example
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5178
```

运行移动端预览项目：

```powershell
cd example\mobile_preview
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5179
```

## 仓库结构

| 路径 | 说明 |
| --- | --- |
| [`lib/animal_island_flutter.dart`](./lib/animal_island_flutter.dart) | package 统一导出入口。 |
| [`lib/src/animal_theme.dart`](./lib/src/animal_theme.dart) | 主题令牌、默认主题和品牌色派生逻辑。 |
| [`lib/src/components`](./lib/src/components) | 组件源码目录。 |
| [`lib/src/components/mobile.dart`](./lib/src/components/mobile.dart) | 移动端基础组件和移动业务组件。 |
| [`assets/animal_island`](./assets/animal_island) | 字体、图标、光标、分割线、页脚、loading 等资源。 |
| [`test`](./test) | package 级 widget 测试。 |
| [`tool`](./tool) | 质量检查、文档构建和发布脚本。 |
| [`AI_USAGE.md`](./AI_USAGE.md) | 面向 AI 代码助手的 API 使用手册。 |
| [`DESIGN_PROMPT.md`](./DESIGN_PROMPT.md) | 视觉风格、色板、字体、动效和组件设计提示。 |
| [`skill/SKILL.md`](./skill/SKILL.md) | 当前项目的 Codex Skill 文档。 |

## 字体与资源

包内注册了 `Nunito`、`Noto Sans SC`、`Zen Maru Gothic` 三组字体，并提供常用图形资源：

- `assets/animal_island/fonts`：Flutter 可直接注册的 `.woff2` 字体资源。
- `assets/animal_island/img/cursor`：自定义光标和 Select hover 光标。
- `assets/animal_island/img/dividers`：分割线与波浪线。
- `assets/animal_island/img/footer`：页脚海浪和树图形。
- `assets/animal_island/img/icons`：岛屿风格图标。
- `assets/animal_island/img/loading`：loading 岛屿图形。

这些资源已经在 `pubspec.yaml` 中注册，安装 package 后可随组件一起使用。

## 本地开发

```powershell
flutter pub get
flutter analyze
flutter test
```

示例项目检查：

```powershell
cd example
flutter analyze
flutter test

cd mobile_preview
flutter analyze
flutter test
```

构建文档站和移动预览静态产物：

```powershell
powershell -ExecutionPolicy Bypass -File tool\build_docs.ps1 -Flutter C:\Dev\tools\flutter_3.41.0\bin\flutter.bat
```

完整质量检查：

```powershell
powershell -ExecutionPolicy Bypass -File tool\quality_check.ps1
```

## 发布

仓库提供了发布脚本 [`tool/release.ps1`](./tool/release.ps1)，用于更新版本号、同步 README 版本、检查 changelog、执行 dry-run，并在确认后发布到 pub.dev。

```powershell
powershell -ExecutionPolicy Bypass -File tool\release.ps1 -Version 0.1.4
```

正式发布：

```powershell
powershell -ExecutionPolicy Bypass -File tool\release.ps1 -Version 0.1.4 -Publish
```

如果终端需要临时代理，可以使用 `-ProxyUrl`。脚本只会在 dry-run 和 publish 步骤临时设置代理变量，结束后自动恢复：

```powershell
powershell -ExecutionPolicy Bypass -File tool\release.ps1 -Version 0.1.4 -Publish -ProxyUrl http://127.0.0.1:15236
```

## 命名约定

组件 API 遵循 Flutter/Dart 习惯：

- 回调使用 `onChanged`、`onPressed`、`onSelected` 等命名。
- 枚举值避免 Dart 关键字，例如 `AnimalButtonType.defaultType`、`AnimalCardColor.defaultColor`。
- 复杂控件优先提供 Flutter `Widget` 插槽，而不是字符串模板。
- 表单组件提供 `FormField` 包装，支持 `validator`、`onSaved`、`autovalidateMode`。
- 桌面交互覆盖 hover、focus、keyboard activation；移动组件关注安全区、底部面板和触摸反馈。

## 许可

MIT
