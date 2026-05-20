# Animal Island Flutter 设计提示词

用于 v0、Figma AI、Framer AI、Midjourney、DALL-E 或其他设计生成工具。生成结果需要服务于 Flutter 组件库，因此请把控件理解为 Widget，而不是 HTML/React DOM。

## UI 工具提示词

```text
Design a Flutter UI component library in the style of "Animal Island Flutter",
an Animal Crossing-inspired cozy cross-platform Flutter widget kit.

The UI must feel like a warm island game interface, not a generic SaaS dashboard.
Use rounded, tactile, game-like controls with 3D bottom shadows.

=== PLATFORM ===
Flutter / Dart component library.
Target Android, Windows and Web. iOS should be self-tested on macOS/Xcode.

=== FONTS ===
Use rounded friendly fonts:
Nunito, Noto Sans SC, Zen Maru Gothic, PingFang SC, Microsoft YaHei, sans-serif.
Body weight 500, buttons/headings 600-700, time digits 900.
Do not use thin text.

=== COLORS ===
Background parchment: #f8f8f0
Content parchment: rgb(247, 243, 223)
Homepage green: #7DC395
Primary text: #794f27
Body text: #725d42
Muted text: #8a7b66
Disabled text: #c4b89e
Primary mint teal: #19c8b9
Primary hover: #3dd4c6
Primary active: #11a89b
Focus yellow: #ffcc00
Success green: #6fba2c
Warning yellow: #f5c31c
Error red: #e05a5a
Switch ON: #86d67a
Sidebar active: #B7C6E5
Sidebar hover: #d6dff0

=== SHAPE ===
Buttons and inputs are pill-shaped.
Middle button height 45, radius 50.
Input middle height 40, radius 50.
Cards radius 20.
Title cards use organic uneven rounded corners.
Modal uses an organic blob silhouette, not a rectangle.
Minimum interactive radius 12.

=== DEPTH ===
Every clickable control must have a bottom-only 3D shadow:
button shadow #bdaea0, input shadow #d4c9b4, switch-on shadow #5a9e1e.
Hover moves up slightly; press moves down and reduces shadow.
Avoid generic Material elevation shadows.

=== COMPONENTS ===
Show Flutter-style widgets:
AnimalButton, AnimalInput, AnimalSwitch, AnimalDialog, AnimalCard,
AnimalCollapse, AnimalSelect, AnimalTabs, AnimalCheckbox, AnimalCodeBlock,
AnimalLoading, AnimalTable, AnimalTime, AnimalPhone, AnimalFooter, AnimalDivider,
AnimalIcon and AnimalCursor.

=== LOADING ===
Button loading uses smooth diagonal stripes:
#0ec4b6 and #01b0a7 at -45deg, loop seamlessly.
Page transition loading uses black full-screen overlay with a small island illustration
floating at bottom-right, then closes through a circular center reveal.

=== DOCS LAYOUT ===
Desktop docs page has 220px sidebar.
Sidebar background uses a leaf/sea illustration texture.
Sidebar header "集合啦！Animal" is fixed; menu list scrolls.
Details area has repeated parchment/leaf background texture and a bottom guide line illustration.
The docs content should remain Flutter/Dart examples, not React/npm examples.

=== FORBIDDEN ===
No pure black text except the loading overlay background.
No cold gray page backgrounds.
No square interactive controls.
No sharp unrounded buttons.
No blue browser-like focus ring.
No flat controls without bottom shadow.
No React, npm, JSX or CSS class terminology in Flutter docs.
```

## 图片生成提示词

```text
Pixel-perfect screenshot of a Flutter widget documentation app,
Animal Crossing inspired cozy island UI,
warm parchment panels, mint teal accents, brown rounded text,
pill-shaped 3D buttons with bottom shadows, organic blob modal,
leaf texture sidebar, 220px fixed navigation with active light-blue item,
Flutter/Dart code samples in dark warm code blocks,
animated island loading overlay concept, NookPhone-like colorful icon cards,
friendly rounded typography Nunito and Noto Sans SC,
soft pastoral UI illustration style, no cold corporate SaaS look,
high resolution, clean component library documentation screen.
```

## 关键数值速查

| Token | 值 | 用途 |
| --- | --- | --- |
| 主背景 | `#f8f8f0` | 通用页面和控件背景 |
| 内容背景 | `rgb(247, 243, 223)` | Card / Modal / Input |
| 正文文字 | `#725d42` | 组件正文 |
| 标题文字 | `#794f27` | 标题、侧栏 |
| 主色 | `#19c8b9` | 主操作、选中态 |
| hover 主色 | `#3dd4c6` | hover |
| focus 黄 | `#ffcc00` | 输入框焦点 |
| 按钮阴影 | `#bdaea0` | 3D 按键底边 |
| 输入阴影 | `#d4c9b4` | 输入框底边 |
| Switch ON | `#86d67a` | 开启背景 |
| Sidebar active | `#B7C6E5` | 选中菜单 |
| Sidebar hover | `#d6dff0` | hover 菜单 |
| Button middle | `45px` | 默认按钮高度 |
| Input middle | `40px` | 默认输入高度 |
| Sidebar width | `220px` | 文档页导航宽度 |
| Phone shell | `527 x 788` | `AnimalPhone` 默认比例 |
| Footer sea | `80px` | 海浪底部 |
| Footer tree | `60px` | 树林底部 |
| Divider | `12px` | 分割线高度 |

## Flutter 设计约束

- 使用 `AnimalThemeData` 的主题色和字体，不要在业务页面随意改成 Material 默认蓝。
- 所有可点击 Widget 都需要明确 hover/pressed/disabled 状态。
- Web/Windows 需要鼠标 hover 和手型光标；Android/iOS 需要触摸反馈自然。
- 固定尺寸装饰组件要保留 `AspectRatio` 或约束，避免小屏溢出。
- 代码示例必须是 Dart，不写 JSX、TSX、CSS Modules。
- 文档背景、侧栏背景和底部装饰要使用 demo 资产，不用纯渐变替代。
