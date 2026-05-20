# Animal Island Flutter Example

<div align="center">
    <img src="../doc/img/readme-home.png" alt="animal-island-flutter-example" style="border-radius: 12px; width: 40%; display: block; margin: 0 auto;" />
</div>
<div align="center">
    Animal Island Flutter 的文档站与组件演示项目
</div>

## 介绍

这个示例项目复刻了 React `animal-island-ui` demo 的页面编排，并把所有示例改写为 Flutter 使用方式。它用于预览首页、组件列表、组件详情页、代码示例和跨端视觉效果。

## 项目链接

- GitHub: https://github.com/ohmangocat/animal_island_flutter
- Pub.dev: https://pub.dev/packages/animal_island_flutter
- 当前发布版本：`0.1.1`

## 运行

```powershell
cd animal_island_flutter/example
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5178
```

也可以直接使用 Chrome 设备运行：

```powershell
flutter run -d chrome
```

## 依赖版本

| 项目 | 版本 |
| --- | --- |
| `animal_island_flutter` | 发布版 `^0.1.1` |
| GitHub | `https://github.com/ohmangocat/animal_island_flutter` |
| Flutter SDK | `>=3.19.0` |
| Dart SDK | `>=3.3.0 <4.0.0` |
| `flutter_svg` | 由组件库依赖 `^2.0.17` |

仓库内的 example 为了方便本地调试，`pubspec.yaml` 使用 `path: ..` 指向当前源码；业务项目安装时请使用发布版：

```yaml
dependencies:
  animal_island_flutter: ^0.1.1
```

## 页面内容

| 页面 | 内容 |
| --- | --- |
| Home | 复刻 React demo 首页，含移动背景和 loading 过渡 |
| Components | 组件列表导航，集合啦 animal 标题固定展示 |
| Detail | 组件详情、使用示例、代码块和 API 说明 |

## 兼容平台

| 平台 | 状态 |
| --- | --- |
| Android | 已适配，可运行示例项目 |
| Windows | 已适配 Windows Flutter 工程 |
| Web | 已适配，可运行文档站预览 |
| iOS | 需在 macOS + Xcode 环境自行测试 |

## 相关文档

- [`../README.md`](../README.md)：组件库中文 README
- [`../README.en.md`](../README.en.md)：组件库英文 README
- [`../AI_USAGE.md`](../AI_USAGE.md)：AI 使用手册
- [`../DESIGN_PROMPT.md`](../DESIGN_PROMPT.md)：设计复刻提示词
- [`../skill/SKILL.md`](../skill/SKILL.md)：像素级复刻 Skill
