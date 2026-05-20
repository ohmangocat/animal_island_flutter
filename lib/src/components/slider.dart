import 'dart:math' as math;

import 'package:flutter/material.dart';

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

  double get _value => widget.value ?? _innerValue;

  bool get _enabled =>
      !widget.disabled && widget.max > widget.min && widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _innerValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final value = _normalize(_value);
    final percent = ((value - widget.min) / (widget.max - widget.min))
        .clamp(0.0, 1.0)
        .toDouble();

    return Opacity(
      opacity: widget.disabled ? 0.55 : 1,
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width =
                    constraints.hasBoundedWidth ? constraints.maxWidth : 240.0;
                return MouseRegion(
                  cursor: _enabled
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.basic,
                  onEnter:
                      _enabled ? (_) => setState(() => _hovered = true) : null,
                  onExit:
                      _enabled ? (_) => setState(() => _hovered = false) : null,
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
                              color: const Color(0xFFF0E8D8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFD8CCB8),
                                width: 2,
                              ),
                            ),
                          ),
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
                            left: math.max(0, percent * width - 12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 140),
                              width: _hovered || _dragging ? 28 : 24,
                              height: _hovered || _dragging ? 28 : 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF8D6),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.primaryColor,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFFBDAEA0),
                                    offset: Offset(0, 3),
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
    final next = _normalize(raw);
    if (widget.value == null) {
      setState(() => _innerValue = next);
    }
    widget.onChanged?.call(next);
  }

  double _normalize(double raw) {
    var value = raw.clamp(widget.min, widget.max).toDouble();
    final divisions = widget.divisions;
    if (divisions != null && divisions > 0) {
      final step = (widget.max - widget.min) / divisions;
      final slot = ((value - widget.min) / step).round().clamp(0, divisions);
      value = widget.min + slot * step;
    }
    return value.clamp(widget.min, widget.max).toDouble();
  }

  String _label(double value) {
    if (value == value.roundToDouble()) {
      return '${value.round()}';
    }
    return value.toStringAsFixed(1);
  }
}
