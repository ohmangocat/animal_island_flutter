import 'package:flutter/material.dart';

import '../animal_theme.dart';

enum AnimalStepsDirection { horizontal, vertical }

enum AnimalStepStatus { wait, process, finish, error }

@immutable
class AnimalStepItem {
  const AnimalStepItem({
    required this.title,
    this.description,
    this.status,
    this.disabled = false,
  });

  final Widget title;
  final Widget? description;
  final AnimalStepStatus? status;
  final bool disabled;
}

class AnimalSteps extends StatelessWidget {
  const AnimalSteps({
    super.key,
    required this.items,
    this.current = 0,
    this.direction = AnimalStepsDirection.horizontal,
    this.onChanged,
  });

  final List<AnimalStepItem> items;
  final int current;
  final AnimalStepsDirection direction;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    if (direction == AnimalStepsDirection.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < items.length; index++)
            _VerticalStep(
              item: items[index],
              index: index,
              status: _statusFor(index),
              last: index == items.length - 1,
              onTap: _tapFor(index),
            ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          Expanded(
            child: _HorizontalStep(
              item: items[index],
              index: index,
              status: _statusFor(index),
              onTap: _tapFor(index),
            ),
          ),
          if (index != items.length - 1)
            _StepConnector(
                status: index < current
                    ? AnimalStepStatus.finish
                    : AnimalStepStatus.wait),
        ],
      ],
    );
  }

  AnimalStepStatus _statusFor(int index) {
    final itemStatus = items[index].status;
    if (itemStatus != null) {
      return itemStatus;
    }
    if (index < current) {
      return AnimalStepStatus.finish;
    }
    if (index == current) {
      return AnimalStepStatus.process;
    }
    return AnimalStepStatus.wait;
  }

  VoidCallback? _tapFor(int index) {
    if (items[index].disabled || onChanged == null) {
      return null;
    }
    return () => onChanged!(index);
  }
}

class _HorizontalStep extends StatelessWidget {
  const _HorizontalStep({
    required this.item,
    required this.index,
    required this.status,
    required this.onTap,
  });

  final AnimalStepItem item;
  final int index;
  final AnimalStepStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _StepTapRegion(
      enabled: onTap != null,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepDot(index: index, status: status, disabled: item.disabled),
          const SizedBox(height: 8),
          _StepText(item: item, status: status, center: true),
        ],
      ),
    );
  }
}

class _VerticalStep extends StatelessWidget {
  const _VerticalStep({
    required this.item,
    required this.index,
    required this.status,
    required this.last,
    required this.onTap,
  });

  final AnimalStepItem item;
  final int index;
  final AnimalStepStatus status;
  final bool last;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _StepDot(index: index, status: status, disabled: item.disabled),
              if (!last)
                Expanded(
                  child: Container(
                    width: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: status == AnimalStepStatus.finish
                          ? theme.primaryColor
                          : theme.lightBorderColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 18),
              child: _StepTapRegion(
                enabled: onTap != null,
                onTap: onTap,
                child: _StepText(item: item, status: status),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.status});

  final AnimalStepStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Container(
      width: 28,
      height: 3,
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: status == AnimalStepStatus.finish
            ? theme.primaryColor
            : theme.lightBorderColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.index,
    required this.status,
    required this.disabled,
  });

  final int index;
  final AnimalStepStatus status;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final color = _stepColor(theme, disabled ? AnimalStepStatus.wait : status);
    final foreground = status == AnimalStepStatus.wait || disabled
        ? theme.secondaryTextColor
        : Colors.white;
    final icon = switch (status) {
      AnimalStepStatus.finish => Icons.check_rounded,
      AnimalStepStatus.error => Icons.close_rounded,
      AnimalStepStatus.process || AnimalStepStatus.wait => null,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: status == AnimalStepStatus.wait || disabled
              ? theme.controlBorderColor
              : color,
          width: 2,
        ),
        boxShadow: disabled
            ? null
            : [
                BoxShadow(
                  color: theme.tactileShadowColor,
                  offset: const Offset(0, 3),
                  blurRadius: 0,
                ),
              ],
      ),
      child: icon == null
          ? Text(
              '${index + 1}',
              style: theme.textStyle(
                size: 13,
                weight: FontWeight.w900,
                color: foreground,
              ),
            )
          : Icon(icon, color: Colors.white, size: 18),
    );
  }
}

class _StepText extends StatelessWidget {
  const _StepText({
    required this.item,
    required this.status,
    this.center = false,
  });

  final AnimalStepItem item;
  final AnimalStepStatus status;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final color = item.disabled
        ? theme.disabledTextColor
        : status == AnimalStepStatus.process
            ? theme.textColor
            : theme.secondaryTextColor;

    return DefaultTextStyle.merge(
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: theme.textStyle(
        size: 13,
        weight: status == AnimalStepStatus.process
            ? FontWeight.w900
            : FontWeight.w700,
        color: color,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          item.title,
          if (item.description != null) ...[
            const SizedBox(height: 2),
            DefaultTextStyle.merge(
              style: theme.textStyle(
                size: 11,
                weight: FontWeight.w500,
                color: item.disabled
                    ? theme.disabledTextColor
                    : theme.secondaryTextColor,
              ),
              child: item.description!,
            ),
          ],
        ],
      ),
    );
  }
}

class _StepTapRegion extends StatefulWidget {
  const _StepTapRegion({
    required this.enabled,
    required this.child,
    this.onTap,
  });

  final bool enabled;
  final VoidCallback? onTap;
  final Widget child;

  @override
  State<_StepTapRegion> createState() => _StepTapRegionState();
}

class _StepTapRegionState extends State<_StepTapRegion> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: widget.enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: widget.enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 140),
          scale: _hovered ? 1.02 : 1,
          child: widget.child,
        ),
      ),
    );
  }
}

Color _stepColor(AnimalThemeData theme, AnimalStepStatus status) {
  return switch (status) {
    AnimalStepStatus.wait => theme.contentBackgroundColor,
    AnimalStepStatus.process => theme.primaryColor,
    AnimalStepStatus.finish => theme.successColor,
    AnimalStepStatus.error => theme.errorColor,
  };
}
