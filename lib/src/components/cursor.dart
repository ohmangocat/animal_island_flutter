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
  Offset _position = Offset.zero;
  bool _visible = false;

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
        setState(() {
          _visible = true;
          _position = event.localPosition;
        });
      },
      onHover: (event) => setState(() => _position = event.localPosition),
      onExit: (_) => setState(() => _visible = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_visible)
            Positioned(
              left: _position.dx - 4,
              top: _position.dy,
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
