import 'package:flutter/material.dart';

import 'cursor_css.dart' if (dart.library.html) 'cursor_css_web.dart'
    as cursor_css;

class AnimalCursor extends StatefulWidget {
  const AnimalCursor({
    super.key,
    required this.child,
    this.cursor = SystemMouseCursors.none,
    this.showImageCursor = true,
  });

  final Widget child;
  final MouseCursor cursor;
  final bool showImageCursor;

  @override
  State<AnimalCursor> createState() => _AnimalCursorState();
}

class _AnimalCursorState extends State<AnimalCursor> {
  final ValueNotifier<_CursorState> _cursorState =
      ValueNotifier<_CursorState>(_CursorState.hidden);

  @override
  void dispose() {
    _cursorState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showImageCursor) {
      return MouseRegion(
        cursor: widget.cursor,
        child: widget.child,
      );
    }

    if (cursor_css.supportsNativeAnimalCursor) {
      cursor_css.ensureAnimalCursorCss();
      return widget.child;
    }

    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (event) {
        _cursorState.value = _CursorState(event.localPosition, true);
      },
      onHover: (event) {
        _cursorState.value = _CursorState(event.localPosition, true);
      },
      onExit: (_) => _cursorState.value = _CursorState.hidden,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          ValueListenableBuilder<_CursorState>(
            valueListenable: _cursorState,
            builder: (context, state, child) {
              if (!state.visible) {
                return const SizedBox.shrink();
              }
              return Positioned(
                left: state.position.dx - 4,
                top: state.position.dy,
                child: child!,
              );
            },
            child: IgnorePointer(
              child: Image.asset(
                'assets/animal_island/img/cursor/cursor-icon.png',
                package: 'animal_island_flutter',
                width: 49,
                height: 48,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CursorState {
  const _CursorState(this.position, this.visible);

  static const hidden = _CursorState(Offset.zero, false);

  final Offset position;
  final bool visible;
}
