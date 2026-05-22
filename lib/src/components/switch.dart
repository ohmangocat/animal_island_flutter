import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animal_theme.dart';

enum AnimalSwitchSize { small, normal }

class AnimalSwitch extends StatefulWidget {
  const AnimalSwitch({
    super.key,
    this.value,
    this.defaultValue = false,
    this.size = AnimalSwitchSize.normal,
    this.disabled = false,
    this.loading = false,
    this.checkedChild,
    this.uncheckedChild,
    this.onChanged,
  });

  final bool? value;
  final bool defaultValue;
  final AnimalSwitchSize size;
  final bool disabled;
  final bool loading;
  final Widget? checkedChild;
  final Widget? uncheckedChild;
  final ValueChanged<bool>? onChanged;

  @override
  State<AnimalSwitch> createState() => _AnimalSwitchState();
}

class _AnimalSwitchState extends State<AnimalSwitch> {
  final _focusNode = FocusNode();
  late bool _innerValue;
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  bool get _checked => widget.value ?? _innerValue;
  bool get _enabled => !widget.disabled && !widget.loading;

  @override
  void initState() {
    super.initState();
    _innerValue = widget.defaultValue;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final small = widget.size == AnimalSwitchSize.small;
    final width = small ? 38.0 : 52.0;
    final height = small ? 20.0 : 28.0;
    final handleSize = small ? 14.0 : 21.0;
    const borderWidth = 2.5;
    final handleInset = small ? 1.0 : 2.0;
    final uncheckedLeft = handleInset;
    final checkedLeft = width - handleSize - handleInset - borderWidth * 2;
    final label = _checked ? widget.checkedChild : widget.uncheckedChild;
    final showLabel = label != null;
    final highlighted = _enabled && (_hovered || _focused);
    final background = _checked
        ? (highlighted ? const Color(0xFF7CCC70) : const Color(0xFF86D67A))
        : const Color(0xFFD4C9B4);
    final borderColor = _checked
        ? (highlighted ? const Color(0xFF5A9E1E) : theme.successColor)
        : (highlighted ? theme.borderHoverColor : theme.disabledTextColor);
    final insetShadowColor = _checked
        ? const Color(0xFF5A9E1E).withValues(alpha: 0.2)
        : theme.bodyTextColor.withValues(alpha: 0.15);

    return Semantics(
      button: true,
      toggled: _checked,
      enabled: _enabled,
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
              _toggle();
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
            onTapDown: _enabled ? (_) => _setPressed(true) : null,
            onTapUp: _enabled ? (_) => _setPressed(false) : null,
            onTapCancel: _enabled ? () => _setPressed(false) : null,
            onTap: _enabled
                ? () {
                    _focusNode.requestFocus();
                    _toggle();
                  }
                : null,
            child: Opacity(
              opacity: widget.disabled
                  ? 0.5
                  : widget.loading
                      ? 0.7
                      : 1,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: borderColor, width: borderWidth),
                  boxShadow: highlighted
                      ? [
                          BoxShadow(
                            color: theme.tactileShadowColor.withValues(
                              alpha: 0.38,
                            ),
                            offset: Offset(0, _pressed ? 1 : 3),
                            blurRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(borderWidth),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  insetShadowColor,
                                  insetShadowColor.withValues(alpha: 0),
                                ],
                                stops: const [0, 0.72],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (showLabel)
                      Positioned.fill(
                        left: borderWidth +
                            (_checked ? (small ? 6 : 8) : (small ? 20 : 28)),
                        right: borderWidth +
                            (_checked ? (small ? 20 : 28) : (small ? 6 : 8)),
                        child: Align(
                          alignment: _checked
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: DefaultTextStyle.merge(
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: theme
                                  .textStyle(
                                size: small ? 9 : 11,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              )
                                  .copyWith(
                                height: 1,
                                letterSpacing: small ? 0.18 : 0.22,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    offset: const Offset(0, 1),
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: label,
                            ),
                          ),
                        ),
                      ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      left: _checked ? checkedLeft : uncheckedLeft,
                      width: handleSize,
                      height: handleSize,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.contentBackgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _checked
                                ? theme.successColor
                                : theme.disabledTextColor,
                            width: 2.5,
                          ),
                          boxShadow: highlighted
                              ? [
                                  BoxShadow(
                                    color: theme.tactileShadowColor.withValues(
                                      alpha: 0.22,
                                    ),
                                    offset: const Offset(0, 1),
                                    blurRadius: 0,
                                  ),
                                ]
                              : null,
                        ),
                        child: widget.loading
                            ? Center(
                                child: SizedBox.square(
                                  dimension: small ? 8 : 11,
                                  child: CircularProgressIndicator(
                                    strokeWidth: small ? 1.6 : 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _checked
                                          ? theme.successColor
                                          : theme.borderHoverColor,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggle() {
    if (!_enabled) {
      return;
    }
    final next = !_checked;
    if (widget.value == null) {
      setState(() => _innerValue = next);
    }
    widget.onChanged?.call(next);
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

class AnimalSwitchFormField extends FormField<bool> {
  AnimalSwitchFormField({
    super.key,
    bool? value,
    bool defaultValue = false,
    AnimalSwitchSize size = AnimalSwitchSize.normal,
    bool disabled = false,
    bool loading = false,
    Widget? checkedChild,
    Widget? uncheckedChild,
    ValueChanged<bool>? onChanged,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onSaved,
    super.validator,
    super.restorationId,
  }) : super(
          initialValue: value ?? defaultValue,
          enabled: !disabled && !loading,
          builder: (field) {
            return _SwitchFormFieldShell(
              errorText: field.errorText,
              child: AnimalSwitch(
                value: field.value ?? false,
                size: size,
                disabled: disabled,
                loading: loading,
                checkedChild: checkedChild,
                uncheckedChild: uncheckedChild,
                onChanged: (next) {
                  field.didChange(next);
                  onChanged?.call(next);
                },
              ),
            );
          },
        );
}

class _SwitchFormFieldShell extends StatelessWidget {
  const _SwitchFormFieldShell({
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
