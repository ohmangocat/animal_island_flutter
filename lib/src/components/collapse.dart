import 'package:flutter/material.dart';

import '../animal_theme.dart';

class AnimalCollapse extends StatefulWidget {
  const AnimalCollapse({
    super.key,
    required this.question,
    required this.answer,
    this.defaultExpanded = false,
    this.disabled = false,
  });

  final Widget question;
  final Widget answer;
  final bool defaultExpanded;
  final bool disabled;

  @override
  State<AnimalCollapse> createState() => _AnimalCollapseState();
}

class _AnimalCollapseState extends State<AnimalCollapse>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  @override
  void initState() {
    super.initState();
    _expanded = widget.defaultExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return MouseRegion(
      cursor:
          widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: widget.disabled ? 0.6 : 1,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.circular(theme.radius),
            border: Border.all(
              color: theme.borderColor,
              width: theme.borderWidth,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: widget.disabled
                    ? null
                    : () => setState(() => _expanded = !_expanded),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _expanded
                              ? theme.primaryActiveColor
                              : theme.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withValues(alpha: 0.30),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _expanded ? '-' : '+',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DefaultTextStyle.merge(
                          style: theme.textStyle(
                            size: 16,
                            weight: FontWeight.w700,
                          ),
                          child: widget.question,
                        ),
                      ),
                      AnimatedRotation(
                        turns: _expanded ? 0.125 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: CustomPaint(
                          size: const Size.square(20),
                          painter: _CollapseLeafPainter(
                            color: theme.primaryColor.withValues(
                              alpha: _expanded ? 1 : 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DefaultTextStyle.merge(
                      style: theme.textStyle(
                        size: 14,
                        weight: FontWeight.w500,
                        color: theme.secondaryTextColor,
                      ),
                      child: widget.answer,
                    ),
                  ),
                ),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 260),
                sizeCurve: Curves.easeOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollapseLeafPainter extends CustomPainter {
  const _CollapseLeafPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width * 0.708, size.height * 0.333)
      ..cubicTo(size.width * 0.333, size.height * 0.417, size.width * 0.246,
          size.height * 0.674, size.width * 0.159, size.height * 0.889)
      ..lineTo(size.width * 0.238, size.height * 0.917)
      ..lineTo(size.width * 0.278, size.height * 0.821)
      ..cubicTo(size.width * 0.298, size.height * 0.828, size.width * 0.318,
          size.height * 0.833, size.width * 0.333, size.height * 0.833)
      ..cubicTo(size.width * 0.792, size.height * 0.833, size.width * 0.917,
          size.height * 0.125, size.width * 0.917, size.height * 0.125)
      ..cubicTo(size.width * 0.875, size.height * 0.208, size.width * 0.583,
          size.height * 0.219, size.width * 0.375, size.height * 0.260)
      ..cubicTo(size.width * 0.167, size.height * 0.302, size.width * 0.083,
          size.height * 0.479, size.width * 0.083, size.height * 0.563)
      ..cubicTo(size.width * 0.083, size.height * 0.646, size.width * 0.156,
          size.height * 0.719, size.width * 0.156, size.height * 0.719)
      ..cubicTo(size.width * 0.292, size.height * 0.333, size.width * 0.708,
          size.height * 0.333, size.width * 0.708, size.height * 0.333)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CollapseLeafPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
