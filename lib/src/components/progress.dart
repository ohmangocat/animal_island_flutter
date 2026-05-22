import 'package:flutter/material.dart';

import '../animal_theme.dart';

class AnimalProgress extends StatelessWidget {
  const AnimalProgress({
    super.key,
    required this.value,
    this.height = 16,
    this.showLabel = true,
    this.color,
    this.backgroundColor,
  });

  final double value;
  final double height;
  final bool showLabel;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final percent = value.clamp(0, 1).toDouble();
    final label = '${(percent * 100).round()}%';

    return Row(
      children: [
        Expanded(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor ?? theme.secondaryBackgroundColor,
              borderRadius: BorderRadius.circular(height),
              border: Border.all(color: theme.lightBorderColor, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percent,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: color ?? theme.primaryColor,
                          borderRadius: BorderRadius.circular(height),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              offset: Offset(0, 2),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ProgressStripePainter(
                            color: Colors.white.withValues(alpha: 0.22),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 10),
          SizedBox(
            width: 42,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: theme.textStyle(
                size: 12,
                weight: FontWeight.w800,
                color: theme.textColor,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProgressStripePainter extends CustomPainter {
  const _ProgressStripePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const gap = 16.0;
    for (var x = -size.height; x < size.width + size.height; x += gap) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + 6, size.height)
        ..lineTo(x + size.height + 6, 0)
        ..lineTo(x + size.height, 0)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressStripePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
