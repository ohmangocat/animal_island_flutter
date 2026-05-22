import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animal_theme.dart';
import 'input.dart';

class AnimalTextarea extends StatelessWidget {
  const AnimalTextarea({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.rows = 4,
    this.maxLength,
    this.allowClear = false,
    this.enabled = true,
    this.shadow = false,
    this.status,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final int rows;
  final int? maxLength;
  final bool allowClear;
  final bool enabled;
  final bool shadow;
  final AnimalInputStatus? status;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return AnimalInput(
      controller: controller,
      initialValue: initialValue,
      hintText: hintText,
      allowClear: allowClear,
      enabled: enabled,
      shadow: shadow,
      status: status,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: rows,
      maxLength: maxLength,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onClear: onClear,
    );
  }
}

class AnimalPasswordInput extends StatefulWidget {
  const AnimalPasswordInput({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText = '请输入密码',
    this.size = AnimalInputSize.middle,
    this.allowClear = false,
    this.enabled = true,
    this.shadow = false,
    this.status,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String hintText;
  final AnimalInputSize size;
  final bool allowClear;
  final bool enabled;
  final bool shadow;
  final AnimalInputStatus? status;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<AnimalPasswordInput> createState() => _AnimalPasswordInputState();
}

class _AnimalPasswordInputState extends State<AnimalPasswordInput> {
  var _visible = false;

  @override
  Widget build(BuildContext context) {
    return AnimalInput(
      controller: widget.controller,
      initialValue: widget.initialValue,
      hintText: widget.hintText,
      size: widget.size,
      allowClear: widget.allowClear,
      enabled: widget.enabled,
      shadow: widget.shadow,
      status: widget.status,
      obscureText: !_visible,
      autofillHints: const [AutofillHints.password],
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      suffix: _VisibilityToggle(
        visible: _visible,
        onTap: () => setState(() => _visible = !_visible),
      ),
    );
  }
}

class AnimalSearchInput extends StatefulWidget {
  const AnimalSearchInput({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText = '搜索',
    this.size = AnimalInputSize.middle,
    this.allowClear = true,
    this.enabled = true,
    this.shadow = false,
    this.onChanged,
    this.onSubmitted,
    this.onSearch,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String hintText;
  final AnimalInputSize size;
  final bool allowClear;
  final bool enabled;
  final bool shadow;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onSearch;

  @override
  State<AnimalSearchInput> createState() => _AnimalSearchInputState();
}

class _AnimalSearchInputState extends State<AnimalSearchInput> {
  late TextEditingController _controller;
  var _ownsController = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant AnimalSearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      _ownsController = widget.controller == null;
      _controller =
          widget.controller ?? TextEditingController(text: widget.initialValue);
    } else if (_ownsController &&
        widget.initialValue != null &&
        widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimalInput(
      controller: _controller,
      hintText: widget.hintText,
      size: widget.size,
      allowClear: widget.allowClear,
      enabled: widget.enabled,
      shadow: widget.shadow,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      prefix: const Icon(Icons.search_rounded, size: 18),
      suffix: _SearchSubmitButton(
        onTap: () => widget.onSearch?.call(_controller.text),
      ),
      onChanged: widget.onChanged,
      onSubmitted: (value) {
        widget.onSubmitted?.call(value);
        widget.onSearch?.call(value);
      },
    );
  }
}

class AnimalNumberInput extends StatefulWidget {
  const AnimalNumberInput({
    super.key,
    this.value,
    this.defaultValue = 0,
    this.min,
    this.max,
    this.step = 1,
    this.size = AnimalInputSize.middle,
    this.enabled = true,
    this.shadow = false,
    this.onChanged,
  });

  final num? value;
  final num defaultValue;
  final num? min;
  final num? max;
  final num step;
  final AnimalInputSize size;
  final bool enabled;
  final bool shadow;
  final ValueChanged<num>? onChanged;

  @override
  State<AnimalNumberInput> createState() => _AnimalNumberInputState();
}

class _AnimalNumberInputState extends State<AnimalNumberInput> {
  late final TextEditingController _controller;
  late num _innerValue;

  num get _value => widget.value ?? _innerValue;

  @override
  void initState() {
    super.initState();
    _innerValue = _clamp(widget.defaultValue);
    _controller = TextEditingController(text: _format(_value));
  }

  @override
  void didUpdateWidget(covariant AnimalNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = _format(_value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimalInput(
      controller: _controller,
      size: widget.size,
      enabled: widget.enabled,
      shadow: widget.shadow,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      suffix: _NumberStepper(
        enabled: widget.enabled,
        onIncrease: () => _commit(_value + widget.step),
        onDecrease: () => _commit(_value - widget.step),
      ),
      onChanged: (text) {
        final parsed = num.tryParse(text);
        if (parsed != null) {
          _commit(parsed, updateController: false);
        }
      },
      onSubmitted: (text) {
        final parsed = num.tryParse(text);
        _commit(parsed ?? _value);
      },
    );
  }

  void _commit(num next, {bool updateController = true}) {
    final clamped = _clamp(next);
    if (widget.value == null) {
      setState(() => _innerValue = clamped);
    }
    if (updateController) {
      _controller.text = _format(clamped);
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
    }
    widget.onChanged?.call(clamped);
  }

  num _clamp(num value) {
    var next = value;
    final min = widget.min;
    final max = widget.max;
    if (min != null && next < min) {
      next = min;
    }
    if (max != null && next > max) {
      next = max;
    }
    return next;
  }

  String _format(num value) {
    if (value is double && value == value.roundToDouble()) {
      return '${value.round()}';
    }
    return '$value';
  }
}

class _VisibilityToggle extends StatelessWidget {
  const _VisibilityToggle({required this.visible, required this.onTap});

  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _IconActionButton(
      icon: visible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
      label: visible ? '隐藏密码' : '显示密码',
      onTap: onTap,
    );
  }
}

class _SearchSubmitButton extends StatelessWidget {
  const _SearchSubmitButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _IconActionButton(
      icon: Icons.arrow_forward_rounded,
      label: '提交搜索',
      onTap: onTap,
    );
  }
}

class _NumberStepper extends StatelessWidget {
  const _NumberStepper({
    required this.enabled,
    required this.onIncrease,
    required this.onDecrease,
  });

  final bool enabled;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
              icon: Icons.keyboard_arrow_up_rounded,
              onTap: enabled ? onIncrease : null),
          _StepperButton(
              icon: Icons.keyboard_arrow_down_rounded,
              onTap: enabled ? onDecrease : null),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _IconActionButton(
      icon: icon,
      label: icon == Icons.keyboard_arrow_up_rounded ? '增加数值' : '减少数值',
      onTap: onTap,
      width: 20,
      height: 15,
      iconSize: 16,
      compact: true,
    );
  }
}

class _IconActionButton extends StatefulWidget {
  const _IconActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.width = 24,
    this.height = 24,
    this.iconSize = 18,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final double iconSize;
  final bool compact;

  @override
  State<_IconActionButton> createState() => _IconActionButtonState();
}

class _IconActionButtonState extends State<_IconActionButton> {
  final _focusNode = FocusNode();
  var _hovered = false;
  var _focused = false;
  var _pressed = false;

  bool get _enabled => widget.onTap != null;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final highlighted = _enabled && (_hovered || _focused);

    return Semantics(
      button: _enabled,
      enabled: _enabled,
      label: widget.label,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        enabled: _enabled,
        mouseCursor:
            _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onShowFocusHighlight: (value) {
          if (mounted) {
            setState(() => _focused = value);
          }
        },
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              _activate();
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor:
              _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onEnter: _enabled ? (_) => _setHovered(true) : null,
          onExit: _enabled
              ? (_) {
                  _setHovered(false);
                  _setPressed(false);
                }
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _enabled ? (_) => _setPressed(true) : null,
            onTapUp: _enabled ? (_) => _setPressed(false) : null,
            onTapCancel: _enabled ? () => _setPressed(false) : null,
            onTap: _enabled
                ? () {
                    _focusNode.requestFocus();
                    _activate();
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
              width: widget.width,
              height: widget.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: highlighted && !widget.compact
                    ? theme.bodyTextColor.withValues(alpha: 0.10)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: !_enabled
                    ? theme.disabledTextColor
                    : highlighted
                        ? theme.bodyTextColor
                        : theme.secondaryTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _activate() {
    widget.onTap?.call();
  }

  void _setHovered(bool value) {
    if (mounted && _hovered != value) {
      setState(() => _hovered = value);
    }
  }

  void _setPressed(bool value) {
    if (mounted && _pressed != value) {
      setState(() => _pressed = value);
    }
  }
}
