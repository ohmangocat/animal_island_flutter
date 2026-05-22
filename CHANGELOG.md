# Changelog

## Unreleased

## 0.1.2 - 2026-05-23

- Started phase 2 with theme customization improvements: brand-color palette derivation, app font support, text-height tokens, and Theme docs.
- Threaded theme-derived primary accents through Button loading stripes, Loading stripes, Tabs, Table loading/hover states, and Progress labels.
- Extended theme neutral tokens across form, feedback, navigation, loading placeholder, and selection components.
- Expanded Theme docs with neutral token examples, derived token API rows, and skinning guidance for README and AI usage docs.
- Added `AnimalInputFormField` plus common Flutter text input parameters for Form validation and keyboard workflows.
- Added 8 advanced basic components: Alert, Avatar, Breadcrumb, Steps, Slider, Rate, Segmented, and Skeleton.
- Added 8 extended basic components: Radio, Tag, Badge, Tooltip, Message, Progress, Pagination, and Empty.
- Added demo documentation, public API exports, usage notes, and widget tests for the extended component set.
- Stabilized Select hover cursor rendering with a bundled PNG asset and safer overlay lifecycle handling.
- Restored symmetric Switch handle spacing and added regression coverage for Select and Switch interaction states.
- Added keyboard activation and focus styling for Button, uncontrolled initial value syncing for Input, and visible overlay updates for Tooltip.
- Added keyboard support for Tabs and Table rows, safer Message auto-dismiss handling, and Dialog escape-key regression coverage.
- Completed first-stage interaction stabilization with keyboard and disabled-state coverage for Radio, Checkbox, Segmented, Rate, Slider, and Pagination.
- Refined Slider endpoint rendering so the handle stays inside the track and the zero-value state does not show a filled segment.
- Completed phase 2 API polish with FormField wrappers for Select, Checkbox, Radio, Switch, Slider, and Rate, plus Select keyboard navigation and updated docs/tests.
- Started and completed phase 3 business-ready components: Form/FormItem, Textarea, PasswordInput, SearchInput, NumberInput, Popover, Dropdown, Drawer, ConfirmDialog, Descriptions, Statistic, and Timeline.
- Added phase 3 documentation pages, API tables, usage snippets, widget tests, README/AI usage/design prompt updates, and Dropdown auto-close behavior.
- Added phase 4 complex business components: Calendar, Upload, Tree, and Result with docs, tests, and public exports.
- Started phase 5 production-readiness work with FormField wrappers for Calendar, Upload, and Tree, plus Tree keyboard expand/collapse and added accessibility semantics.
- Extended phase 5 interaction coverage with Calendar keyboard date/month navigation and Upload keyboard activation.
- Added phase 5 desktop and accessibility polish for Drawer, Dropdown, Popover, Calendar, Tree, Upload remove actions, responsive Descriptions, and interactive Timeline items.
- Added keyboard/focus/hover production polish for Card, Collapse, Breadcrumb, and Switch, including regression tests for desktop and keyboard workflows.
- Added keyboard/focus/hover support for small action buttons in Alert, Tag, Input clear, PasswordInput, SearchInput, and NumberInput steppers.
- Added release-readiness tooling with PowerShell quality checks, docs/mobile-preview builds, GitHub Actions CI, pub.dev metadata, and release checklist documentation.

## 0.1.1

- Updated the package README with pub.dev installation, dependency versions, platform compatibility, and preview image.
- Added English README documentation.
- Updated the example README for the Flutter documentation/demo app.
- Added the README home preview image under the pub package `doc` directory.

## 0.1.0

- Initial Flutter component library release.
- Added 19 Animal Island styled components: Button, Input, Switch, Modal, Card, Footer, Collapse, Cursor, Time, Phone, Divider, Typewriter, Icon, Select, Tabs, Checkbox, CodeBlock, Loading, and Table.
- Added a Flutter documentation/example app adapted from the React demo.
- Bundled source image assets and fontsource-derived font assets for consistent Android, Windows, Web, and iOS rendering.
