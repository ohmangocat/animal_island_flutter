import 'package:flutter/material.dart';

import '../animal_theme.dart';

enum AnimalTagColor {
  defaultColor,
  primary,
  success,
  warning,
  danger,
  blue,
  purple,
  brown,
}

enum AnimalTagSize { small, middle, large }

class AnimalTag extends StatelessWidget {
  const AnimalTag({
    super.key,
    required this.child,
    this.color = AnimalTagColor.defaultColor,
    this.size = AnimalTagSize.middle,
    this.closable = false,
    this.onClose,
    this.icon,
  });

  final Widget child;
  final AnimalTagColor color;
  final AnimalTagSize size;
  final bool closable;
  final VoidCallback? onClose;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final colors = _tagColors(theme, color);
    final metrics = _tagMetrics(size);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(metrics.radius),
        border: Border.all(color: colors.border, width: 1.5),
      ),
      child: Padding(
        padding: metrics.padding,
        child: DefaultTextStyle.merge(
          style: theme.textStyle(
            size: metrics.fontSize,
            weight: FontWeight.w700,
            color: colors.foreground,
          ),
          child: IconTheme.merge(
            data:
                IconThemeData(color: colors.foreground, size: metrics.iconSize),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 5),
                ],
                child,
                if (closable) ...[
                  const SizedBox(width: 6),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: onClose,
                      child: Text(
                        '×',
                        style: theme.textStyle(
                          size: metrics.fontSize + 1,
                          weight: FontWeight.w900,
                          color: colors.foreground,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_TagMetrics _tagMetrics(AnimalTagSize size) {
  return switch (size) {
    AnimalTagSize.small => const _TagMetrics(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        radius: 12,
        fontSize: 11,
        iconSize: 13,
      ),
    AnimalTagSize.middle => const _TagMetrics(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        radius: 16,
        fontSize: 12,
        iconSize: 15,
      ),
    AnimalTagSize.large => const _TagMetrics(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        radius: 18,
        fontSize: 14,
        iconSize: 17,
      ),
  };
}

_TagColors _tagColors(AnimalThemeData theme, AnimalTagColor color) {
  return switch (color) {
    AnimalTagColor.defaultColor => const _TagColors(
        background: Color(0xFFF7F3DF),
        foreground: Color(0xFF725D42),
        border: Color(0xFFE8E2D6),
      ),
    AnimalTagColor.primary => _TagColors(
        background: theme.primaryBackgroundColor,
        foreground: theme.primaryActiveColor,
        border: theme.primaryColor,
      ),
    AnimalTagColor.success => const _TagColors(
        background: Color(0xFFEAF7D8),
        foreground: Color(0xFF5A9E1E),
        border: Color(0xFF9DD56E),
      ),
    AnimalTagColor.warning => const _TagColors(
        background: Color(0xFFFFF3C2),
        foreground: Color(0xFF9A7410),
        border: Color(0xFFF5C31C),
      ),
    AnimalTagColor.danger => const _TagColors(
        background: Color(0xFFFFE0DD),
        foreground: Color(0xFFE05A5A),
        border: Color(0xFFFFA19A),
      ),
    AnimalTagColor.blue => const _TagColors(
        background: Color(0xFFE8F0FF),
        foreground: Color(0xFF5E7FBF),
        border: Color(0xFFB7C6E5),
      ),
    AnimalTagColor.purple => const _TagColors(
        background: Color(0xFFF2E8FF),
        foreground: Color(0xFF8A68BD),
        border: Color(0xFFD3B7F0),
      ),
    AnimalTagColor.brown => const _TagColors(
        background: Color(0xFFF0E8D8),
        foreground: Color(0xFF794F27),
        border: Color(0xFFD5C4A6),
      ),
  };
}

class _TagMetrics {
  const _TagMetrics({
    required this.padding,
    required this.radius,
    required this.fontSize,
    required this.iconSize,
  });

  final EdgeInsetsGeometry padding;
  final double radius;
  final double fontSize;
  final double iconSize;
}

class _TagColors {
  const _TagColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
