import 'dart:async';
import 'package:flutter/material.dart';

import '../animal_theme.dart';

enum AnimalTooltipPlacement { top, right, bottom, left }

class AnimalTooltip extends StatefulWidget {
  const AnimalTooltip({
    super.key,
    required this.message,
    required this.child,
    this.placement = AnimalTooltipPlacement.top,
    this.preferBelow,
    this.waitDuration = const Duration(milliseconds: 350),
    this.showDuration = const Duration(seconds: 3),
    this.gap = 10,
  });

  final String message;
  final Widget child;
  final AnimalTooltipPlacement placement;
  final bool? preferBelow;
  final Duration waitDuration;
  final Duration showDuration;
  final double gap;

  @override
  State<AnimalTooltip> createState() => _AnimalTooltipState();
}

class _AnimalTooltipState extends State<AnimalTooltip> {
  OverlayEntry? _entry;
  Timer? _waitTimer;
  Timer? _hideTimer;

  AnimalTooltipPlacement get _placement {
    final preferBelow = widget.preferBelow;
    if (preferBelow != null) {
      return preferBelow
          ? AnimalTooltipPlacement.bottom
          : AnimalTooltipPlacement.top;
    }
    return widget.placement;
  }

  @override
  void dispose() {
    _waitTimer?.cancel();
    _hideTimer?.cancel();
    _removeTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _scheduleShow(),
      onExit: (_) => _removeTooltip(),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPressStart: (_) => _showTooltip(),
        onLongPressEnd: (_) => _removeTooltip(),
        child: widget.child,
      ),
    );
  }

  void _scheduleShow() {
    _waitTimer?.cancel();
    _waitTimer = Timer(widget.waitDuration, _showTooltip);
  }

  void _showTooltip() {
    if (!mounted || _entry != null) {
      return;
    }

    final renderObject = context.findRenderObject();
    final overlay = Overlay.of(context);
    final overlayRenderObject = overlay.context.findRenderObject();
    if (renderObject is! RenderBox || overlayRenderObject is! RenderBox) {
      return;
    }

    final targetRect = renderObject.localToGlobal(
          Offset.zero,
          ancestor: overlayRenderObject,
        ) &
        renderObject.size;

    _hideTimer?.cancel();
    _entry = OverlayEntry(
      builder: (context) {
        return _AnimalTooltipOverlay(
          targetRect: targetRect,
          message: widget.message,
          placement: _placement,
          gap: widget.gap,
        );
      },
    );
    Overlay.of(context).insert(_entry!);
    _hideTimer = Timer(widget.showDuration, _removeTooltip);
  }

  void _removeTooltip() {
    _waitTimer?.cancel();
    _hideTimer?.cancel();
    _entry?.remove();
    _entry = null;
  }
}

class _AnimalTooltipOverlay extends StatelessWidget {
  const _AnimalTooltipOverlay({
    required this.targetRect,
    required this.message,
    required this.placement,
    required this.gap,
  });

  final Rect targetRect;
  final String message;
  final AnimalTooltipPlacement placement;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomSingleChildLayout(
          delegate: _TooltipPositionDelegate(
            targetRect: targetRect,
            placement: placement,
            gap: gap,
          ),
          child: _TooltipBubble(
            message: message,
            placement: placement,
          ),
        ),
      ),
    );
  }
}

class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  const _TooltipPositionDelegate({
    required this.targetRect,
    required this.placement,
    required this.gap,
  });

  final Rect targetRect;
  final AnimalTooltipPlacement placement;
  final double gap;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    const viewportPadding = 16.0;
    final maxWidth =
        (constraints.maxWidth - viewportPadding).clamp(0.0, 280.0).toDouble();
    final maxHeight = (constraints.maxHeight - viewportPadding)
        .clamp(0.0, constraints.maxHeight)
        .toDouble();
    return BoxConstraints(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final position = switch (placement) {
      AnimalTooltipPlacement.top => Offset(
          targetRect.center.dx - childSize.width / 2,
          targetRect.top - gap - childSize.height,
        ),
      AnimalTooltipPlacement.right => Offset(
          targetRect.right + gap,
          targetRect.center.dy - childSize.height / 2,
        ),
      AnimalTooltipPlacement.bottom => Offset(
          targetRect.center.dx - childSize.width / 2,
          targetRect.bottom + gap,
        ),
      AnimalTooltipPlacement.left => Offset(
          targetRect.left - gap - childSize.width,
          targetRect.center.dy - childSize.height / 2,
        ),
    };
    const padding = 8.0;
    final maxX = size.width - childSize.width - padding;
    final maxY = size.height - childSize.height - padding;
    return Offset(
      position.dx.clamp(padding, maxX < padding ? padding : maxX).toDouble(),
      position.dy.clamp(padding, maxY < padding ? padding : maxY).toDouble(),
    );
  }

  @override
  bool shouldRelayout(covariant _TooltipPositionDelegate oldDelegate) {
    return oldDelegate.targetRect != targetRect ||
        oldDelegate.placement != placement ||
        oldDelegate.gap != gap;
  }
}

class _TooltipBubble extends StatelessWidget {
  const _TooltipBubble({
    required this.message,
    required this.placement,
  });

  final String message;
  final AnimalTooltipPlacement placement;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Align(
      widthFactor: 1,
      heightFactor: 1,
      child: Material(
        color: Colors.transparent,
        child: CustomPaint(
          painter: _TooltipArrowPainter(
            placement: placement,
            fill: const Color(0xFFFFF8D6),
            stroke: const Color(0xFFD9C889),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 240),
            margin: _bubbleMargin(placement),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8D6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD9C889), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  offset: Offset(0, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Text(
              message,
              style: theme.textStyle(
                size: 12,
                weight: FontWeight.w700,
                color: const Color(0xFF794F27),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

EdgeInsets _bubbleMargin(AnimalTooltipPlacement placement) {
  return switch (placement) {
    AnimalTooltipPlacement.top => const EdgeInsets.only(bottom: 6),
    AnimalTooltipPlacement.right => const EdgeInsets.only(left: 6),
    AnimalTooltipPlacement.bottom => const EdgeInsets.only(top: 6),
    AnimalTooltipPlacement.left => const EdgeInsets.only(right: 6),
  };
}

class _TooltipArrowPainter extends CustomPainter {
  const _TooltipArrowPainter({
    required this.placement,
    required this.fill,
    required this.stroke,
  });

  final AnimalTooltipPlacement placement;
  final Color fill;
  final Color stroke;

  @override
  void paint(Canvas canvas, Size size) {
    const arrow = 8.0;
    final path = Path();

    switch (placement) {
      case AnimalTooltipPlacement.top:
        final x = size.width / 2;
        path
          ..moveTo(x - arrow, size.height - arrow - 1)
          ..lineTo(x, size.height)
          ..lineTo(x + arrow, size.height - arrow - 1);
      case AnimalTooltipPlacement.bottom:
        final x = size.width / 2;
        path
          ..moveTo(x - arrow, arrow + 1)
          ..lineTo(x, 0)
          ..lineTo(x + arrow, arrow + 1);
      case AnimalTooltipPlacement.left:
        final y = size.height / 2;
        path
          ..moveTo(size.width - arrow - 1, y - arrow)
          ..lineTo(size.width, y)
          ..lineTo(size.width - arrow - 1, y + arrow);
      case AnimalTooltipPlacement.right:
        final y = size.height / 2;
        path
          ..moveTo(arrow + 1, y - arrow)
          ..lineTo(0, y)
          ..lineTo(arrow + 1, y + arrow);
    }

    path.close();
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _TooltipArrowPainter oldDelegate) {
    return oldDelegate.placement != placement ||
        oldDelegate.fill != fill ||
        oldDelegate.stroke != stroke;
  }
}
