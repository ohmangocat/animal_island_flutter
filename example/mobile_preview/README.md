# Animal Island Mobile Preview

这是 `animal_island_flutter` 文档站内的独立手机预览应用。

它和桌面文档分开运行，文档站只通过 iframe 挂载构建后的 Web 产物。这样 `AnimalMessage`、`AnimalDialog`、下拉菜单等浮层都会落在手机预览自己的 Flutter 应用里，不会跑到外层文档页面。

## 本地运行

```powershell
cd example/mobile_preview
C:\Dev\tools\flutter_3.41.0\bin\flutter.bat run -d chrome
```

## 构建到文档 iframe

```powershell
cd example/mobile_preview
C:\Dev\tools\flutter_3.41.0\bin\flutter.bat build web --debug --base-href /mobile_preview/ --pwa-strategy=none
```

然后将 `example/mobile_preview/build/web/` 内容复制到 `example/web/mobile_preview/`。文档站里的 `手机预览` 入口会加载 `mobile_preview/index.html`。

## 平台

- Web：用于嵌入文档站。
- Android / Windows：可按 Flutter 标准流程单独打包验证。
- iOS：需要在 macOS + Xcode 环境自行测试。
