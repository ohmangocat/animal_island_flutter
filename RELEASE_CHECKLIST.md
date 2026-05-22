# Release Checklist

This checklist is for publishing `animal_island_flutter` to pub.dev and keeping the docs preview aligned with the package.

## 1. Version And Changelog

- Update `version` in `pubspec.yaml`.
- Keep README installation snippets aligned with the same version.
- Update `example/mobile_preview/pubspec.yaml` version metadata when the public package version changes.
- Move completed `CHANGELOG.md` items from `Unreleased` into a dated release section.

## 2. Local Quality Gate

Run the full release gate from the repository root:

```powershell
.\tool\quality_check.ps1
```

This runs root package analysis/tests, `flutter pub publish --dry-run`, example analysis/tests, mobile preview analysis/tests, mobile preview web build, and docs web build.

For a quicker code-only check while iterating:

```powershell
.\tool\quality_check.ps1 -SkipBuild -SkipPublishDryRun
```

## 3. Docs Build

The docs site embeds the standalone mobile preview build in `example/web/mobile_preview`.

```powershell
.\tool\build_docs.ps1
```

Run this when mobile preview pages change, then test the docs app at `http://127.0.0.1:5178/`.

## 4. Platform Smoke Test

- Android: run the example or mobile preview app on an emulator/device.
- Windows: run `flutter run -d windows` from `example` or `example/mobile_preview`.
- Web: run the docs app with `flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5178`.
- iOS: self-test on macOS with Xcode before claiming support.

## 5. Publish

```powershell
flutter pub publish --dry-run
flutter pub publish
```

After publishing, create a git tag such as `v0.1.2`, push the tag, and verify the pub.dev package page renders README, screenshots, topics, and repository links correctly.
