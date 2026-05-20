import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../animal_theme.dart';

enum AnimalCardType { defaultType, title, dashed }

enum AnimalCardColor {
  defaultColor,
  appPink,
  purple,
  appBlue,
  appYellow,
  appOrange,
  appTeal,
  appGreen,
  appRed,
  limeGreen,
  yellowGreen,
  brown,
  warmPeachPink,
}

class AnimalCard extends StatefulWidget {
  const AnimalCard({
    super.key,
    required this.child,
    this.type = AnimalCardType.defaultType,
    this.color = AnimalCardColor.defaultColor,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final AnimalCardType type;
  final AnimalCardColor color;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  State<AnimalCard> createState() => _AnimalCardState();
}

class _AnimalCardState extends State<AnimalCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final palette = _cardPalette(widget.color);
    final isDashed = widget.type == AnimalCardType.dashed;
    final isTitle = widget.type == AnimalCardType.title;

    final borderRadius = isTitle
        ? const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(35),
            bottomRight: Radius.circular(45),
            bottomLeft: Radius.circular(38),
          )
        : BorderRadius.circular(20);

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      transform:
          Matrix4.translationValues(0, _hovered && !isDashed ? -2 : 0, 0),
      padding: widget.padding ??
          (isTitle
              ? const EdgeInsets.symmetric(horizontal: 32, vertical: 12)
              : const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
      decoration: BoxDecoration(
        color: isDashed ? const Color(0xFFFAF8F2) : palette.background,
        borderRadius: borderRadius,
      ),
      foregroundDecoration: isDashed
          ? ShapeDecoration(
              shape: _DashedRoundedBorder(
                color: _hovered
                    ? const Color(0xFFD4C4A8)
                    : const Color(0xFFE8DCC8),
                width: 2,
                radius: 20,
              ),
            )
          : null,
      child: DefaultTextStyle.merge(
        style: theme.textStyle(
          size: 14,
          weight: isTitle ? FontWeight.w600 : FontWeight.w500,
          color: palette.foreground,
        ),
        child: widget.child,
      ),
    );

    if (widget.onTap != null) {
      card = GestureDetector(onTap: widget.onTap, child: card);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: card,
    );
  }
}

class _DashedRoundedBorder extends ShapeBorder {
  const _DashedRoundedBorder({
    required this.color,
    required this.width,
    required this.radius,
  });

  final Color color;
  final double width;
  final double radius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        rect.deflate(width),
        Radius.circular(radius),
      ));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        rect.deflate(width / 2),
        Radius.circular(radius),
      ));
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + 6, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += 12;
      }
    }
  }

  @override
  ShapeBorder scale(double t) {
    return _DashedRoundedBorder(
      color: color,
      width: width * t,
      radius: radius * t,
    );
  }
}

_CardPalette _cardPalette(AnimalCardColor color) {
  return switch (color) {
    AnimalCardColor.defaultColor =>
      const _CardPalette(Color(0xFFF7F3DF), Color(0xFF725D42)),
    AnimalCardColor.appPink =>
      const _CardPalette(Color(0xFFF8A6B2), Colors.white),
    AnimalCardColor.purple =>
      const _CardPalette(Color(0xFFB77DEE), Colors.white),
    AnimalCardColor.appBlue =>
      const _CardPalette(Color(0xFF889DF0), Colors.white),
    AnimalCardColor.appYellow =>
      const _CardPalette(Color(0xFFF7CD67), Color(0xFF725D42)),
    AnimalCardColor.appOrange =>
      const _CardPalette(Color(0xFFE59266), Colors.white),
    AnimalCardColor.appTeal =>
      const _CardPalette(Color(0xFF82D5BB), Colors.white),
    AnimalCardColor.appGreen =>
      const _CardPalette(Color(0xFF8AC68A), Colors.white),
    AnimalCardColor.appRed =>
      const _CardPalette(Color(0xFFFC736D), Colors.white),
    AnimalCardColor.limeGreen =>
      const _CardPalette(Color(0xFFD1DA49), Color(0xFF3D5A1A)),
    AnimalCardColor.yellowGreen =>
      const _CardPalette(Color(0xFFECDF52), Color(0xFF725D42)),
    AnimalCardColor.brown =>
      const _CardPalette(Color(0xFF9A835A), Colors.white),
    AnimalCardColor.warmPeachPink =>
      const _CardPalette(Color(0xFFE18C6F), Colors.white),
  };
}

class _CardPalette {
  const _CardPalette(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
