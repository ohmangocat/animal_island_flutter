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
Primary stripe: #01b0a7
Floating surface: #fff8d6
Control border: #d8ccb8
Warm border: #d9c889
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
Phase 3 business widgets should also be covered:
AnimalForm, AnimalTextarea, AnimalPasswordInput, AnimalSearchInput,
AnimalNumberInput, AnimalPopover, AnimalDropdown, AnimalDrawer,
AnimalConfirmDialog, AnimalDescriptions, AnimalStatistic and AnimalTimeline.
Phase 4 complex widgets should also be covered:
AnimalCalendar, AnimalUpload, AnimalTree and AnimalResult.

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
| 实心强调 | `#0cc0b5` | Tabs active、强调底色 |
| Loading 条纹 | `#0ec4b6 / #01b0a7` | Button / Loading stripes |
| 浮层背景 | `#fff8d6` | Tooltip / Message / Avatar |
| 控件边框 | `#d8ccb8` | Slider / Segmented / Steps |
| 暖色边框 | `#d9c889` | Empty / Tooltip / Avatar |
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
- 自定义品牌色优先使用 `AnimalThemeData.fromPrimary(...)`，让 hover、active、浅背景由同一主色派生。
- 完整换肤需要同步考虑中立色令牌：`backgroundColor`、`secondaryBackgroundColor`、`textColor`、`borderColor`、`lightBorderColor`。组件会继续派生 `contentBackgroundColor`、`elevatedBackgroundColor`、`controlBorderColor`、`bodyTextColor` 和 `tactileShadowColor`。
- Button/Loading 的条纹色不要手写固定色，使用主题派生的 `primaryStripeBackgroundColor`、`primaryStripeColor` 和 `primaryStripeBorderColor`。
- 如果业务 App 使用自己的字体，主题里设置 `fontPackage: null`，并提供 `fontFamilyFallback`。
- 所有可点击 Widget 都需要明确 hover/pressed/disabled 状态。
- 可点击卡片、面包屑、折叠面板和开关需要同时支持桌面小手、focus 高亮、pressed 位移和 `Enter` / `Space` 键盘触发；没有交互回调的展示型组件不要显示小手。
- Alert/Tag 的关闭按钮、Input 清除按钮、密码显隐、搜索提交和数字步进属于高频小动作，也要做成可聚焦按钮，保留小圆形 hover 背景和轻微 pressed 位移。
- 表单组件优先使用 `AnimalInputFormField`、`AnimalSelectFormField`、`AnimalCheckboxFormField`、`AnimalRadioFormField`、`AnimalSwitchFormField`、`AnimalSliderFormField` 和 `AnimalRateFormField`；错误文本使用主题 `errorColor`，不要混用 Material 默认蓝色表单样式。
- 阶段三表单布局使用 `AnimalForm` / `AnimalFormItem` 统一 label、必填星号、帮助文本、错误文本和 horizontal/inline spacing；不要让业务页自己随意拼接不对齐的表单行。
- `AnimalPopover`、`AnimalDropdown`、`AnimalDrawer`、`AnimalConfirmDialog` 属于浮层体系，背景使用 `elevatedBackgroundColor` 或 `contentBackgroundColor`，保留暖色边框、圆角和底部阴影，不使用 Material 默认蓝灰阴影。
- `AnimalDescriptions`、`AnimalStatistic`、`AnimalTimeline` 属于详情展示体系，适合详情页、抽屉和仪表盘；文字层级要清晰，状态点使用主题 success/warning/error/primary，不要变成冷色 SaaS 面板。详情表在窄容器中应自动减少列数，可点击时间线节点需要 hover、小手、focus 和键盘触发状态。
- `AnimalCalendar`、`AnimalUpload`、`AnimalTree`、`AnimalResult` 属于阶段四复杂业务组件；保留暖色容器、圆角、手型光标、键盘可达性和明确的 success/warning/error/info 语义，不要直接使用默认 Material 日期选择器、上传面板或结果页样式。上传文件删除按钮也要作为真正的交互按钮处理。
- Web/Windows 需要鼠标 hover 和手型光标；Android/iOS 需要触摸反馈自然。
- 固定尺寸装饰组件要保留 `AspectRatio` 或约束，避免小屏溢出。
- 代码示例必须是 Dart，不写 JSX、TSX、CSS Modules。
- 文档背景、侧栏背景和底部装饰要使用 demo 资产，不用纯渐变替代。
