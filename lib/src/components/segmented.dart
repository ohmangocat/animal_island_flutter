import 'package:flutter/material.dart';

import '../animal_theme.dart';

@immutable
class AnimalSegmentedOption<T> {
  const AnimalSegmentedOption({
    required this.value,
    required this.label,
    this.icon,
    this.disabled = false,
  });

  final T value;
  final Widget label;
  final Widget? icon;
  final bool disabled;
}

class AnimalSegmented<T> extends StatefulWidget {
  const AnimalSegmented({
    super.key,
    required this.options,
    this.value,
    this.defaultValue,
    this.disabled = false,
    this.onChanged,
  });

  final List<AnimalSegmentedOption<T>> options;
  final T? value;
  final T? defaultValue;
  final bool disabled;
  final ValueChanged<T>? onChanged;

  @override
  State<AnimalSegmented<T>> createState() => _AnimalSegmentedState<T>();
}

class _AnimalSegmentedState<T> extends State<AnimalSegmented<T>> {
  T? _innerValue;

  T? get _value => widget.value ?? _innerValue;

  @override
  void initState() {
    super.initState();
    _innerValue = widget.defaultValue ??
        (widget.options.isEmpty ? null : widget.options.first.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0E8D8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFD8CCB8), width: 2),
      ),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final option in widget.options)
            _SegmentButton<T>(
              option: option,
              active: option.value == _value,
              disabled: widget.disabled || option.disabled,
              theme: theme,
              onTap: () => _select(option.value),
            ),
        ],
      ),
    );
  }

  void _select(T value) {
    if (widget.value == null) {
      setState(() => _innerValue = value);
    }
    widget.onChanged?.call(value);
  }
}

class _SegmentButton<T> extends StatefulWidget {
  const _SegmentButton({
    required this.option,
    required this.active,
    required this.disabled,
    required this.theme,
    required this.onTap,
  });

  final AnimalSegmentedOption<T> option;
  final bool active;
  final bool disabled;
  final AnimalThemeData theme;
  final VoidCallback onTap;

  @override
  State<_SegmentButton<T>> createState() => _SegmentButtonState<T>();
}

class _SegmentButtonState<T> extends State<_SegmentButton<T>> {
  var _hovered = false;

  bool get _enabled => !widget.disabled;

  @override
  Widget build(BuildContext context) {
    final foreground = widget.disabled
        ? widget.theme.disabledTextColor
        : widget.active
            ? Colors.white
            : _hovered
                ? widget.theme.primaryColor
                : widget.theme.textColor;

    return MouseRegion(
      cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: _enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: _enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: _enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: widget.active
                ? widget.theme.primaryColor
                : _hovered
                    ? widget.theme.primaryBackgroundColor
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: widget.active
                ? const [
                    BoxShadow(
                      color: Color(0xFFBDAEA0),
                      offset: Offset(0, 3),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: DefaultTextStyle.merge(
            style: widget.theme.textStyle(
              size: 13,
              weight: FontWeight.w900,
              color: foreground,
            ),
            child: IconTheme.merge(
              data: IconThemeData(color: foreground, size: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.option.icon != null) ...[
                    widget.option.icon!,
                    const SizedBox(width: 6),
                  ],
                  widget.option.label,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
