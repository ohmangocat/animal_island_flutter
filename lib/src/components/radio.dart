import 'package:flutter/material.dart';

import '../animal_theme.dart';

enum AnimalRadioSize { small, middle, large }

enum AnimalRadioDirection { horizontal, vertical }

@immutable
class AnimalRadioOption<T> {
  const AnimalRadioOption({
    required this.label,
    required this.value,
    this.disabled = false,
  });

  final Widget label;
  final T value;
  final bool disabled;
}

class AnimalRadio<T> extends StatefulWidget {
  const AnimalRadio({
    super.key,
    required this.options,
    this.value,
    this.defaultValue,
    this.size = AnimalRadioSize.middle,
    this.disabled = false,
    this.direction = AnimalRadioDirection.horizontal,
    this.onChanged,
  });

  final List<AnimalRadioOption<T>> options;
  final T? value;
  final T? defaultValue;
  final AnimalRadioSize size;
  final bool disabled;
  final AnimalRadioDirection direction;
  final ValueChanged<T>? onChanged;

  @override
  State<AnimalRadio<T>> createState() => _AnimalRadioState<T>();
}

class _AnimalRadioState<T> extends State<AnimalRadio<T>> {
  T? _innerValue;

  T? get _value => widget.value ?? _innerValue;

  @override
  void initState() {
    super.initState();
    _innerValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.options
        .map((option) => _AnimalRadioItem<T>(
              option: option,
              size: widget.size,
              checked: option.value == _value,
              disabled: widget.disabled || option.disabled,
              onTap: () => _select(option.value),
            ))
        .toList();

    if (widget.direction == AnimalRadioDirection.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final child in children)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: child,
            ),
        ],
      );
    }

    return Wrap(
      spacing: 14,
      runSpacing: 8,
      children: children,
    );
  }

  void _select(T value) {
    if (widget.value == null) {
      setState(() => _innerValue = value);
    }
    widget.onChanged?.call(value);
  }
}

class _AnimalRadioItem<T> extends StatelessWidget {
  const _AnimalRadioItem({
    required this.option,
    required this.size,
    required this.checked,
    required this.disabled,
    required this.onTap,
  });

  final AnimalRadioOption<T> option;
  final AnimalRadioSize size;
  final bool checked;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final metrics = _radioMetrics(size);
    final enabled = !disabled;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.55,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: metrics.outerSize,
                height: metrics.outerSize,
                padding: EdgeInsets.all(metrics.padding),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: checked
                      ? theme.primaryBackgroundColor
                      : enabled
                          ? const Color(0xFFF7F3DF)
                          : theme.disabledBackgroundColor,
                  border: Border.all(
                    color: checked ? theme.primaryColor : theme.borderColor,
                    width: 2,
                  ),
                  boxShadow: enabled ? theme.shadowSmall : null,
                ),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutBack,
                  scale: checked ? 1 : 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DefaultTextStyle.merge(
                style: theme.textStyle(
                  size: metrics.fontSize,
                  weight: FontWeight.w500,
                  color: enabled
                      ? const Color(0xFF725D42)
                      : theme.disabledTextColor,
                ),
                child: option.label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_RadioMetrics _radioMetrics(AnimalRadioSize size) {
  return switch (size) {
    AnimalRadioSize.small => const _RadioMetrics(18, 4, 12),
    AnimalRadioSize.middle => const _RadioMetrics(22, 5, 14),
    AnimalRadioSize.large => const _RadioMetrics(28, 6, 16),
  };
}

class _RadioMetrics {
  const _RadioMetrics(this.outerSize, this.padding, this.fontSize);

  final double outerSize;
  final double padding;
  final double fontSize;
}
