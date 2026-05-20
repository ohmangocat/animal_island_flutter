import 'package:flutter/material.dart';

import '../animal_theme.dart';

enum AnimalCheckboxSize { small, middle, large }

enum AnimalCheckboxDirection { horizontal, vertical }

@immutable
class AnimalCheckboxOption<T> {
  const AnimalCheckboxOption({
    required this.label,
    required this.value,
    this.disabled = false,
  });

  final Widget label;
  final T value;
  final bool disabled;
}

class AnimalCheckbox<T> extends StatefulWidget {
  const AnimalCheckbox({
    super.key,
    required this.options,
    this.value,
    this.defaultValue = const [],
    this.size = AnimalCheckboxSize.middle,
    this.disabled = false,
    this.direction = AnimalCheckboxDirection.horizontal,
    this.onChanged,
  });

  final List<AnimalCheckboxOption<T>> options;
  final List<T>? value;
  final List<T> defaultValue;
  final AnimalCheckboxSize size;
  final bool disabled;
  final AnimalCheckboxDirection direction;
  final ValueChanged<List<T>>? onChanged;

  @override
  State<AnimalCheckbox<T>> createState() => _AnimalCheckboxState<T>();
}

class _AnimalCheckboxState<T> extends State<AnimalCheckbox<T>> {
  late List<T> _innerValue;

  List<T> get _values => widget.value ?? _innerValue;

  @override
  void initState() {
    super.initState();
    _innerValue = List<T>.of(widget.defaultValue);
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.options
        .map((option) => _AnimalCheckboxItem<T>(
              option: option,
              size: widget.size,
              checked: _values.contains(option.value),
              disabled: widget.disabled || option.disabled,
              onTap: () => _toggle(option.value),
            ))
        .toList();

    if (widget.direction == AnimalCheckboxDirection.vertical) {
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
      spacing: 12,
      runSpacing: 8,
      children: children,
    );
  }

  void _toggle(T value) {
    final next = List<T>.of(_values);
    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }

    if (widget.value == null) {
      setState(() => _innerValue = next);
    }
    widget.onChanged?.call(next);
  }
}

class _AnimalCheckboxItem<T> extends StatefulWidget {
  const _AnimalCheckboxItem({
    required this.option,
    required this.size,
    required this.checked,
    required this.disabled,
    required this.onTap,
  });

  final AnimalCheckboxOption<T> option;
  final AnimalCheckboxSize size;
  final bool checked;
  final bool disabled;
  final VoidCallback onTap;

  @override
  State<_AnimalCheckboxItem<T>> createState() => _AnimalCheckboxItemState<T>();
}

class _AnimalCheckboxItemState<T> extends State<_AnimalCheckboxItem<T>> {
  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final metrics = _checkboxMetrics(widget.size);
    final enabled = !widget.disabled;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: enabled ? widget.onTap : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.55,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: metrics.boxSize,
                height: metrics.boxSize,
                decoration: BoxDecoration(
                  color: widget.checked
                      ? theme.primaryColor
                      : enabled
                          ? const Color(0xFFF7F3DF)
                          : theme.disabledBackgroundColor,
                  borderRadius: BorderRadius.circular(metrics.radius),
                  border: Border.all(
                    color: widget.checked
                        ? theme.primaryActiveColor
                        : theme.disabledTextColor,
                    width: 2,
                  ),
                ),
                child: widget.checked
                    ? Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.4, end: 1),
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOutBack,
                          builder: (context, scale, child) {
                            return Transform.scale(scale: scale, child: child);
                          },
                          child: SizedBox.square(
                            dimension: metrics.checkSize,
                            child: const CustomPaint(
                              painter: _CheckboxCheckPainter(),
                            ),
                          ),
                        ),
                      )
                    : null,
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
                child: widget.option.label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckboxCheckPainter extends CustomPainter {
  const _CheckboxCheckPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.125, size.height * 0.5)
      ..lineTo(size.width * 0.375, size.height * 0.75)
      ..lineTo(size.width * 0.875, size.height * 0.25);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckboxCheckPainter oldDelegate) => false;
}

_CheckboxMetrics _checkboxMetrics(AnimalCheckboxSize size) {
  return switch (size) {
    AnimalCheckboxSize.small => const _CheckboxMetrics(18, 12, 10, 12),
    AnimalCheckboxSize.middle => const _CheckboxMetrics(22, 14, 12, 14),
    AnimalCheckboxSize.large => const _CheckboxMetrics(28, 16, 16, 16),
  };
}

class _CheckboxMetrics {
  const _CheckboxMetrics(
    this.boxSize,
    this.radius,
    this.checkSize,
    this.fontSize,
  );

  final double boxSize;
  final double radius;
  final double checkSize;
  final double fontSize;
}
