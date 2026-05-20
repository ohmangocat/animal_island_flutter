# Design Reference

This reference summarizes Animal Island Flutter visual rules. Prefer the repository's live `DESIGN_PROMPT.md` when working inside the project.

## Platform

- Flutter / Dart component library.
- Target Android, Windows, and Web.
- Mark iOS as self-test unless verified on macOS/Xcode.

## Fonts

Use rounded friendly fonts:

- `Nunito`
- `Noto Sans SC`
- `Zen Maru Gothic`
- `PingFang SC`
- `Microsoft YaHei`
- `sans-serif`

Body weight should be `500`; buttons and headings should be `600-700`; time digits can use `900`. Avoid thin text.

## Colors

| Token | Value |
| --- | --- |
| Background parchment | `#f8f8f0` |
| Content parchment | `rgb(247, 243, 223)` |
| Homepage green | `#7DC395` |
| Primary text | `#794f27` |
| Body text | `#725d42` |
| Muted text | `#8a7b66` |
| Disabled text | `#c4b89e` |
| Primary mint teal | `#19c8b9` |
| Primary hover | `#3dd4c6` |
| Primary active | `#11a89b` |
| Focus yellow | `#ffcc00` |
| Success green | `#6fba2c` |
| Warning yellow | `#f5c31c` |
| Error red | `#e05a5a` |
| Switch ON | `#86d67a` |
| Sidebar active | `#B7C6E5` |
| Sidebar hover | `#d6dff0` |

## Shape And Depth

- Buttons and inputs are pill-shaped.
- Middle button height is `45`.
- Middle input height is `40`.
- Cards use radius `20`.
- Title cards use organic uneven rounded corners.
- Modal uses an organic blob silhouette.
- Minimum interactive radius is `12`.
- Every tactile control needs a bottom-only 3D shadow.
- Hover moves up slightly; press moves down and reduces shadow.
- Avoid generic Material elevation shadows.

## Loading

- Button loading uses smooth diagonal stripes with `#0ec4b6` and `#01b0a7` at `-45deg`.
- Stripe animation must loop seamlessly.
- Page transition loading uses a black full-screen overlay with a small island illustration at bottom-right.
- Loading exit uses a circular center reveal.

## Docs Layout

- Desktop docs page has a `220px` sidebar.
- Sidebar background uses a leaf/sea illustration texture.
- Sidebar header "集合啦！Animal" is fixed.
- Sidebar menu list scrolls independently.
- Detail area uses repeated parchment/leaf background texture.
- Bottom guide line illustration sits behind scroll content.
- Code samples must be Dart/Flutter, not React/npm examples.

## Forbidden

- No pure black text except the loading overlay background.
- No cold gray page backgrounds.
- No square interactive controls.
- No sharp unrounded buttons.
- No blue browser-like focus ring.
- No flat controls without bottom shadow.
- No React, npm, JSX, or CSS class terminology in Flutter docs.
