import 'package:flutter/material.dart';

import '../animal_theme.dart';
import 'button.dart';
import 'typewriter.dart';

class AnimalDialog extends StatelessWidget {
  const AnimalDialog({
    super.key,
    this.title,
    required this.child,
    this.width = 520,
    this.footer,
    this.showFooter = true,
    this.onClose,
    this.onOk,
    this.typewriter = true,
    this.typeSpeed = const Duration(milliseconds: 80),
  });

  final Widget? title;
  final Widget child;
  final double width;
  final Widget? footer;
  final bool showFooter;
  final VoidCallback? onClose;
  final VoidCallback? onOk;
  final bool typewriter;
  final Duration typeSpeed;

  static Future<T?> show<T>({
    required BuildContext context,
    Widget? title,
    required Widget child,
    double width = 520,
    bool barrierDismissible = true,
    Widget? footer,
    bool showFooter = true,
    VoidCallback? onOk,
    bool typewriter = true,
    Duration typeSpeed = const Duration(milliseconds: 80),
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) => AnimalDialog(
        title: title,
        width: width,
        footer: footer,
        showFooter: showFooter,
        onClose: () => Navigator.of(context).maybePop(),
        onOk: onOk,
        typewriter: typewriter,
        typeSpeed: typeSpeed,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: CustomPaint(
          painter: _AnimalDialogShadowPainter(theme.shadowColor),
          foregroundPainter: _AnimalDialogBorderPainter(
            color: theme.disabledTextColor,
            width: 2.5,
          ),
          child: ClipPath(
            clipper: const _AnimalDialogClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: theme.contentBackgroundColor,
                boxShadow: theme.shadowLarge,
              ),
              padding: const EdgeInsets.fromLTRB(48, 48, 48, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: DefaultTextStyle.merge(
                        style: theme.textStyle(
                          size: 28,
                          weight: FontWeight.w700,
                          color: theme.bodyTextColor,
                        ),
                        child: title!,
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DefaultTextStyle.merge(
                      style: theme.textStyle(
                        size: 20,
                        weight: FontWeight.w600,
                        color: const Color(0xFF8A7B66),
                      ),
                      child: _maybeTypewriter(context, child),
                    ),
                  ),
                  if (showFooter) ...[
                    footer ??
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimalButton(
                              type: AnimalButtonType.primary,
                              onPressed: onClose ??
                                  () => Navigator.of(context).maybePop(),
                              child: const Text('取消'),
                            ),
                            const SizedBox(width: 12),
                            AnimalButton(
                              type: AnimalButtonType.primary,
                              onPressed: onOk ??
                                  () => Navigator.of(context).maybePop(true),
                              child: const Text('确定'),
                            ),
                          ],
                        ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _maybeTypewriter(BuildContext context, Widget body) {
    if (!typewriter || body is! Text || body.data == null) {
      return body;
    }

    return AnimalTypewriter(
      text: body.data!,
      speed: typeSpeed,
      style: DefaultTextStyle.of(context).style.merge(body.style),
    );
  }
}

class _AnimalDialogClipper extends CustomClipper<Path> {
  const _AnimalDialogClipper();

  @override
  Path getClip(Size size) {
    return _modalPath(Offset.zero & size);
  }

  @override
  bool shouldReclip(covariant _AnimalDialogClipper oldClipper) => false;
}

class _AnimalDialogShadowPainter extends CustomPainter {
  const _AnimalDialogShadowPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(
      _modalPath(Offset.zero & size),
      color.withValues(alpha: 0.25),
      12,
      false,
    );
  }

  @override
  bool shouldRepaint(covariant _AnimalDialogShadowPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _AnimalDialogBorderPainter extends CustomPainter {
  const _AnimalDialogBorderPainter({
    required this.color,
    required this.width,
  });

  final Color color;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _modalPath(Offset.zero & size);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0x66FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = width + 2
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _AnimalDialogBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.width != width;
  }
}

Path _modalPath(Rect rect) {
  Offset p(double x, double y) {
    return Offset(rect.left + rect.width * x, rect.top + rect.height * y);
  }

  final path = Path()
    ..moveTo(p(0.501, 0.005).dx, p(0.501, 0.005).dy)
    ..lineTo(p(0.523, 0.005).dx, p(0.523, 0.005).dy)
    ..lineTo(p(0.549, 0.006).dx, p(0.549, 0.006).dy)
    ..cubicTo(p(0.704, 0.010).dx, p(0.704, 0.010).dy, p(0.796, 0.017).dx,
        p(0.796, 0.017).dy, p(0.825, 0.027).dx, p(0.825, 0.027).dy)
    ..lineTo(p(0.827, 0.028).dx, p(0.827, 0.028).dy)
    ..cubicTo(p(0.872, 0.045).dx, p(0.872, 0.045).dy, p(0.939, 0.044).dx,
        p(0.939, 0.044).dy, p(0.978, 0.170).dx, p(0.978, 0.170).dy)
    ..cubicTo(p(1.000, 0.254).dx, p(1.000, 0.254).dy, p(1.000, 0.365).dx,
        p(1.000, 0.365).dy, p(0.990, 0.505).dx, p(0.990, 0.505).dy)
    ..lineTo(p(0.988, 0.513).dx, p(0.988, 0.513).dy)
    ..cubicTo(p(0.979, 0.558).dx, p(0.979, 0.558).dy, p(0.971, 0.598).dx,
        p(0.971, 0.598).dy, p(0.965, 0.633).dx, p(0.965, 0.633).dy)
    ..cubicTo(p(0.956, 0.689).dx, p(0.956, 0.689).dy, p(0.979, 0.770).dx,
        p(0.979, 0.770).dy, p(0.964, 0.865).dx, p(0.964, 0.865).dy)
    ..cubicTo(p(0.953, 0.928).dx, p(0.953, 0.928).dy, p(0.921, 0.966).dx,
        p(0.921, 0.966).dy, p(0.869, 0.979).dx, p(0.869, 0.979).dy)
    ..cubicTo(p(0.821, 0.986).dx, p(0.821, 0.986).dy, p(0.773, 0.992).dx,
        p(0.773, 0.992).dy, p(0.726, 0.995).dx, p(0.726, 0.995).dy)
    ..lineTo(p(0.712, 0.996).dx, p(0.712, 0.996).dy)
    ..lineTo(p(0.694, 0.997).dx, p(0.694, 0.997).dy)
    ..cubicTo(p(0.648, 1.000).dx, p(0.648, 1.000).dy, p(0.586, 1.000).dx,
        p(0.586, 1.000).dy, p(0.507, 1.000).dx, p(0.507, 1.000).dy)
    ..lineTo(p(0.464, 1.000).dx, p(0.464, 1.000).dy)
    ..cubicTo(p(0.385, 1.000).dx, p(0.385, 1.000).dy, p(0.325, 0.998).dx,
        p(0.325, 0.998).dy, p(0.283, 0.995).dx, p(0.283, 0.995).dy)
    ..cubicTo(p(0.234, 0.992).dx, p(0.234, 0.992).dy, p(0.184, 0.987).dx,
        p(0.184, 0.987).dy, p(0.133, 0.979).dx, p(0.133, 0.979).dy)
    ..cubicTo(p(0.081, 0.966).dx, p(0.081, 0.966).dy, p(0.050, 0.928).dx,
        p(0.050, 0.928).dy, p(0.039, 0.865).dx, p(0.039, 0.865).dy)
    ..cubicTo(p(0.023, 0.770).dx, p(0.023, 0.770).dy, p(0.047, 0.689).dx,
        p(0.047, 0.689).dy, p(0.037, 0.633).dx, p(0.037, 0.633).dy)
    ..cubicTo(p(0.031, 0.595).dx, p(0.031, 0.595).dy, p(0.023, 0.552).dx,
        p(0.023, 0.552).dy, p(0.013, 0.505).dx, p(0.013, 0.505).dy)
    ..cubicTo(p(-0.006, 0.365).dx, p(-0.006, 0.365).dy, p(-0.002, 0.254).dx,
        p(-0.002, 0.254).dy, p(0.024, 0.170).dx, p(0.024, 0.170).dy)
    ..cubicTo(p(0.064, 0.045).dx, p(0.064, 0.045).dy, p(0.130, 0.045).dx,
        p(0.130, 0.045).dy, p(0.174, 0.028).dx, p(0.174, 0.028).dy)
    ..lineTo(p(0.175, 0.028).dx, p(0.175, 0.028).dy)
    ..cubicTo(p(0.204, 0.017).dx, p(0.204, 0.017).dy, p(0.303, 0.009).dx,
        p(0.303, 0.009).dy, p(0.474, 0.005).dx, p(0.474, 0.005).dy)
    ..lineTo(p(0.501, 0.005).dx, p(0.501, 0.005).dy)
    ..close();

  return path;
}
