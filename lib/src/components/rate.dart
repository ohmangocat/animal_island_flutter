import 'package:flutter/material.dart';

import '../animal_theme.dart';

class AnimalRate extends StatefulWidget {
  const AnimalRate({
    super.key,
    this.value,
    this.defaultValue = 0,
    this.count = 5,
    this.disabled = false,
    this.onChanged,
  });

  final int? value;
  final int defaultValue;
  final int count;
  final bool disabled;
  final ValueChanged<int>? onChanged;

  @override
  State<AnimalRate> createState() => _AnimalRateState();
}

class _AnimalRateState extends State<AnimalRate> {
  late int _innerValue;
  int? _hoverValue;

  int get _value => widget.value ?? _innerValue;

  bool get _enabled => !widget.disabled;

  @override
  void initState() {
    super.initState();
    _innerValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final displayValue = _hoverValue ?? _value;
    final count = widget.count.clamp(1, 10);

    return Opacity(
      opacity: widget.disabled ? 0.55 : 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 1; index <= count; index++)
            _RateStar(
              active: index <= displayValue,
              enabled: _enabled,
              color: index <= displayValue
                  ? const Color(0xFFF5C31C)
                  : const Color(0xFFD8CCB8),
              onEnter: () => setState(() => _hoverValue = index),
              onExit: () => setState(() => _hoverValue = null),
              onTap: () => _select(index),
            ),
          const SizedBox(width: 8),
          Text(
            '$displayValue/$count',
            style: theme.textStyle(
              size: 12,
              weight: FontWeight.w900,
              color: theme.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  void _select(int value) {
    if (!_enabled) {
      return;
    }
    if (widget.value == null) {
      setState(() => _innerValue = value);
    }
    widget.onChanged?.call(value);
  }
}

class _RateStar extends StatefulWidget {
  const _RateStar({
    required this.active,
    required this.enabled,
    required this.color,
    required this.onEnter,
    required this.onExit,
    required this.onTap,
  });

  final bool active;
  final bool enabled;
  final Color color;
  final VoidCallback onEnter;
  final VoidCallback onExit;
  final VoidCallback onTap;

  @override
  State<_RateStar> createState() => _RateStarState();
}

class _RateStarState extends State<_RateStar> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: widget.enabled ? (_) => widget.onEnter() : null,
      onExit: widget.enabled ? (_) => widget.onExit() : null,
      child: GestureDetector(
        onTapDown:
            widget.enabled ? (_) => setState(() => _pressed = true) : null,
        onTapCancel:
            widget.enabled ? () => setState(() => _pressed = false) : null,
        onTapUp: widget.enabled
            ? (_) {
                setState(() => _pressed = false);
                widget.onTap();
              }
            : null,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: _pressed ? 0.88 : (widget.active ? 1.08 : 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              Icons.star_rounded,
              size: 28,
              color: widget.color,
              shadows: widget.active
                  ? const [
                      Shadow(
                        color: Color(0xFFBDAEA0),
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
