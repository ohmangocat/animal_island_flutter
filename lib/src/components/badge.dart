import 'package:flutter/material.dart';

import '../animal_theme.dart';

enum AnimalBadgeStatus { defaultStatus, primary, success, warning, danger }

class AnimalBadge extends StatelessWidget {
  const AnimalBadge({
    super.key,
    this.child,
    this.count,
    this.text,
    this.dot = false,
    this.showZero = false,
    this.maxCount = 99,
    this.status = AnimalBadgeStatus.danger,
    this.offset = Offset.zero,
  });

  final Widget? child;
  final int? count;
  final String? text;
  final bool dot;
  final bool showZero;
  final int maxCount;
  final AnimalBadgeStatus status;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final badge = _buildBadge(context);
    if (child == null) {
      return badge ?? const SizedBox.shrink();
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        if (badge != null)
          Positioned(
            top: -8 + offset.dy,
            right: -10 + offset.dx,
            child: badge,
          ),
      ],
    );
  }

  Widget? _buildBadge(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final color = _statusColor(theme, status);
    final label = text ?? _countText;
    if (!dot && (label == null || label.isEmpty)) {
      return null;
    }

    if (dot) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: theme.shadowSmall,
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: theme.shadowSmall,
      ),
      child: Text(
        label!,
        style: theme.textStyle(
          size: 11,
          weight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  String? get _countText {
    if (count == null) {
      return null;
    }
    if (count == 0 && !showZero) {
      return null;
    }
    if (count! > maxCount) {
      return '$maxCount+';
    }
    return '$count';
  }
}

Color _statusColor(AnimalThemeData theme, AnimalBadgeStatus status) {
  return switch (status) {
    AnimalBadgeStatus.defaultStatus => theme.secondaryTextColor,
    AnimalBadgeStatus.primary => theme.primaryColor,
    AnimalBadgeStatus.success => theme.successColor,
    AnimalBadgeStatus.warning => theme.warningColor,
    AnimalBadgeStatus.danger => theme.errorColor,
  };
}
