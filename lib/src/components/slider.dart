import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animal_theme.dart';

class AnimalSlider extends StatefulWidget {
  const AnimalSlider({
    super.key,
    this.value,
    this.defaultValue = 0,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.disabled = false,
    this.showLabel = true,
    this.onChanged,
  });

  final double? value;
  final double defaultValue;
  final double min;
  final double max;
  final int? divisions;
  final bool disabled;
  final bool showLabel;
  final ValueChanged<double>? onChanged;

  @override
  State<AnimalSlider> createState() => _AnimalSliderState();
}

class _AnimalSliderState extends State<AnimalSlider> {
  late double _innerValue;
  var _hovered = false;
  var _dragging = false;
  var _focused = false;

  double get _value => widget.value ?? _innerValue;

  bool get _enabled => !widget.disabled && widget.max > widget.min;

  @override
  void initState() {
    super.initState();
    _innerValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final value = _normalize(_value);
    final percent = widget.max > widget.min
        ? ((value - widget.min) / (widget.max - widget.min))
            .clamp(0.0, 1.0)
            .toDouble()
        : 0.0;
    final active = _hovered || _dragging || _focused;
    final handleSize = active ? 28.0 : 24.0;
    final trackBorderColor =
        active && percent > 0 ? theme.primaryColor : theme.controlBorderColor;

    return Opacity(
      opacity: widget.disabled ? 0.55 : 1,
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width =
                    constraints.hasBoundedWidth ? constraints.maxWidth : 240.0;
                return FocusableActionDetector(
                  enabled: _enabled,
                  mouseCursor: _enabled
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.basic,
                  onShowFocusHighlight: (value) {
                    if (mounted) {
                      setState(() => _focused = value);
                    }
                  },
                  shortcuts: const {
                    SingleActivator(LogicalKeyboardKey.arrowLeft):
                        _SliderDecreaseIntent(),
                    SingleActivator(LogicalKeyboardKey.arrowDown):
                        _SliderDecreaseIntent(),
                    SingleActivator(LogicalKeyboardKey.arrowRight):
                        _SliderIncreaseIntent(),
                    SingleActivator(LogicalKeyboardKey.arrowUp):
                        _SliderIncreaseIntent(),
                  },
                  actions: {
                    _SliderDecreaseIntent:
                        CallbackAction<_SliderDecreaseIntent>(
                      onInvoke: (intent) {
                        _changeBy(-_stepSize);
                        return null;
                      },
                    ),
                    _SliderIncreaseIntent:
                        CallbackAction<_SliderIncreaseIntent>(
                      onInvoke: (intent) {
                        _changeBy(_stepSize);
                        return null;
                      },
                    ),
                  },
                  child: MouseRegion(
                    cursor: _enabled
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                    onEnter: _enabled
                        ? (_) => setState(() => _hovered = true)
                        : null,
                    onExit: _enabled
                        ? (_) => setState(() => _hovered = false)
                        : null,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: _enabled
                          ? (details) =>
                              _setFromDx(details.localPosition.dx, width)
                          : null,
                      onHorizontalDragStart: _enabled
                          ? (_) => setState(() => _dragging = true)
                          : null,
                      onHorizontalDragCancel: _enabled
                          ? () => setState(() => _dragging = false)
                          : null,
                      onHorizontalDragEnd: _enabled
                          ? (_) => setState(() => _dragging = false)
                          : null,
                      onHorizontalDragUpdate: _enabled
                          ? (details) =>
                              _setFromDx(details.localPosition.dx, width)
                          : null,
                      child: SizedBox(
                        height: 36,
                        width: width,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              height: 14,
                              decoration: BoxDecoration(
                                color: theme.secondaryBackgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: trackBorderColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            if (percent > 0)
                              FractionallySizedBox(
                                widthFactor: percent,
                                child: Container(
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: theme.primaryActiveColor,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              left: math.max(
                                0,
                                math.min(
                                  width - handleSize,
                                  percent * (width - handleSize),
                                ),
                              ),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 140),
                                width: handleSize,
                                height: handleSize,
                                decoration: BoxDecoration(
                                  color: theme.elevatedBackgroundColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.primaryColor,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.tactileShadowColor,
                                      offset: const Offset(0, 3),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.showLabel) ...[
            const SizedBox(width: 12),
            SizedBox(
              width: 44,
              child: Text(
                _label(value),
                textAlign: TextAlign.right,
                style: theme.textStyle(
                  size: 12,
                  weight: FontWeight.w900,
                  color: theme.textColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _setFromDx(double dx, double width) {
    final ratio = (dx / width).clamp(0.0, 1.0).toDouble();
    final raw = widget.min + (widget.max - widget.min) * ratio;
    _setValue(raw);
  }

  void _changeBy(double delta) {
    if (!_enabled) {
      return;
    }
    _setValue(_value + delta);
  }

  void _setValue(double raw) {
    final next = _normalize(raw);
    if (widget.value == null) {
      setState(() => _innerValue = next);
    }
    widget.onChanged?.call(next);
  }

  double _normalize(double raw) {
    if (widget.max <= widget.min) {
      return widget.min;
    }
    var value = raw.clamp(widget.min, widget.max).toDouble();
    final divisions = widget.divisions;
    if (divisions != null && divisions > 0) {
      final step = (widget.max - widget.min) / divisions;
      final slot = ((value - widget.min) / step).round().clamp(0, divisions);
      value = widget.min + slot * step;
    }
    return value.clamp(widget.min, widget.max).toDouble();
  }

  double get _stepSize {
    final range = widget.max - widget.min;
    final divisions = widget.divisions;
    if (divisions != null && divisions > 0) {
      return range / divisions;
    }
    return range / 100;
  }

  String _label(double value) {
    if (value == value.roundToDouble()) {
      return '${value.round()}';
    }
    return value.toStringAsFixed(1);
  }
}

class AnimalSliderFormField extends FormField<double> {
  AnimalSliderFormField({
    super.key,
    double? value,
    double defaultValue = 0,
    double min = 0,
    double max = 100,
    int? divisions,
    bool disabled = false,
    bool showLabel = true,
    ValueChanged<double>? onChanged,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onSaved,
    super.validator,
    super.restorationId,
  }) : super(
          initialValue: value ?? defaultValue,
          enabled: !disabled,
          builder: (field) {
            return _SliderFormFieldShell(
              errorText: field.errorText,
              child: AnimalSlider(
                value: field.value,
                min: min,
                max: max,
                divisions: divisions,
                disabled: disabled,
                showLabel: showLabel,
                onChanged: (next) {
                  field.didChange(next);
                  onChanged?.call(next);
                },
              ),
            );
          },
        );
}

class _SliderFormFieldShell extends StatelessWidget {
  const _SliderFormFieldShell({
    required this.child,
    this.errorText,
  });

  final Widget child;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Text(
              errorText!,
              style: theme.textStyle(
                size: 12,
                weight: FontWeight.w700,
                color: theme.errorColor,
                height: 1.2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SliderDecreaseIntent extends Intent {
  const _SliderDecreaseIntent();
}

class _SliderIncreaseIntent extends Intent {
  const _SliderIncreaseIntent();
}
