import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  var _focused = false;

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

    return FocusableActionDetector(
      enabled: _enabled,
      mouseCursor:
          _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onShowFocusHighlight: (value) {
        if (mounted) {
          setState(() => _focused = value);
        }
      },
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowLeft): _RateDecreaseIntent(),
        SingleActivator(LogicalKeyboardKey.arrowDown): _RateDecreaseIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight): _RateIncreaseIntent(),
        SingleActivator(LogicalKeyboardKey.arrowUp): _RateIncreaseIntent(),
      },
      actions: {
        _RateDecreaseIntent: CallbackAction<_RateDecreaseIntent>(
          onInvoke: (intent) {
            _changeBy(-1);
            return null;
          },
        ),
        _RateIncreaseIntent: CallbackAction<_RateIncreaseIntent>(
          onInvoke: (intent) {
            _changeBy(1);
            return null;
          },
        ),
      },
      child: Opacity(
        opacity: widget.disabled ? 0.55 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: _focused ? theme.shadowSmall : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 1; index <= count; index++)
                _RateStar(
                  active: index <= displayValue,
                  enabled: _enabled,
                  color: index <= displayValue
                      ? const Color(0xFFF5C31C)
                      : theme.controlBorderColor,
                  shadowColor: theme.tactileShadowColor,
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
        ),
      ),
    );
  }

  void _changeBy(int delta) {
    if (!_enabled) {
      return;
    }
    final count = widget.count.clamp(1, 10);
    final next = (_value + delta).clamp(0, count);
    if (next != _value) {
      _select(next);
    }
  }

  void _select(int value) {
    if (!_enabled) {
      return;
    }
    final next = value.clamp(0, widget.count.clamp(1, 10));
    if (widget.value == null) {
      setState(() {
        _innerValue = next;
        _hoverValue = null;
      });
    } else {
      setState(() => _hoverValue = null);
    }
    widget.onChanged?.call(next);
  }
}

class AnimalRateFormField extends FormField<int> {
  AnimalRateFormField({
    super.key,
    int? value,
    int defaultValue = 0,
    int count = 5,
    bool disabled = false,
    ValueChanged<int>? onChanged,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onSaved,
    super.validator,
    super.restorationId,
  }) : super(
          initialValue: value ?? defaultValue,
          enabled: !disabled,
          builder: (field) {
            return _RateFormFieldShell(
              errorText: field.errorText,
              child: AnimalRate(
                value: field.value,
                count: count,
                disabled: disabled,
                onChanged: (next) {
                  field.didChange(next);
                  onChanged?.call(next);
                },
              ),
            );
          },
        );
}

class _RateFormFieldShell extends StatelessWidget {
  const _RateFormFieldShell({
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

class _RateDecreaseIntent extends Intent {
  const _RateDecreaseIntent();
}

class _RateIncreaseIntent extends Intent {
  const _RateIncreaseIntent();
}

class _RateStar extends StatefulWidget {
  const _RateStar({
    required this.active,
    required this.enabled,
    required this.color,
    required this.shadowColor,
    required this.onEnter,
    required this.onExit,
    required this.onTap,
  });

  final bool active;
  final bool enabled;
  final Color color;
  final Color shadowColor;
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
                  ? [
                      Shadow(
                        color: widget.shadowColor,
                        offset: const Offset(0, 2),
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
