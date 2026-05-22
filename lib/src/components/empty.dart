import 'package:flutter/material.dart';

import '../animal_theme.dart';

class AnimalEmpty extends StatelessWidget {
  const AnimalEmpty({
    super.key,
    this.description = '暂无数据',
    this.icon,
    this.action,
  });

  final String description;
  final Widget? icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? const _EmptyLeafIcon(),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textStyle(
              size: 14,
              weight: FontWeight.w700,
              color: theme.secondaryTextColor,
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: 14),
            action!,
          ],
        ],
      ),
    );
  }
}

class _EmptyLeafIcon extends StatelessWidget {
  const _EmptyLeafIcon();

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: theme.elevatedBackgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: theme.warmBorderColor, width: 3),
        boxShadow: theme.shadowSmall,
      ),
      child: CustomPaint(
        painter: _LeafPainter(color: theme.primaryColor),
      ),
    );
  }
}

class _LeafPainter extends CustomPainter {
  const _LeafPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width * 0.52, size.height * 0.18)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.22,
        size.width * 0.18,
        size.height * 0.54,
        size.width * 0.42,
        size.height * 0.66,
      )
      ..cubicTo(
        size.width * 0.64,
        size.height * 0.78,
        size.width * 0.84,
        size.height * 0.56,
        size.width * 0.74,
        size.height * 0.34,
      )
      ..cubicTo(
        size.width * 0.69,
        size.height * 0.24,
        size.width * 0.62,
        size.height * 0.19,
        size.width * 0.52,
        size.height * 0.18,
      )
      ..close();
    canvas.drawPath(path, paint);

    final vein = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width * 0.42, size.height * 0.64),
      Offset(size.width * 0.62, size.height * 0.32),
      vein,
    );
  }

  @override
  bool shouldRepaint(covariant _LeafPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
