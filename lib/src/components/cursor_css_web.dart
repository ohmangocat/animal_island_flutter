// ignore_for_file: avoid_web_libraries_in_flutter

// ignore: deprecated_member_use
import 'dart:html' as html;

const _styleId = 'animal-island-flutter-cursor';
const _cursorUrl =
    'assets/packages/animal_island_flutter/assets/animal_island/img/cursor/cursor-icon.png';

bool get supportsNativeAnimalCursor => true;

void ensureAnimalCursorCss() {
  if (html.document.getElementById(_styleId) != null) {
    return;
  }

  final style = html.StyleElement()
    ..id = _styleId
    ..text = '''
html,
body,
body *,
flutter-view,
flutter-view *,
flt-glass-pane,
flt-glass-pane *,
canvas {
  cursor: url("$_cursorUrl") 4 0, auto !important;
}
''';
  html.document.head?.append(style);
}
