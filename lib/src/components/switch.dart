import 'package:flutter/material.dart';

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
  late bool _innerValue;
  bool _hovered = false;

  bool get _checked => widget.value ?? _innerValue;
  bool get _enabled => !widget.disabled && !widget.loading;

  @override
  void initState() {
    super.initState();
    _innerValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final small = widget.size == AnimalSwitchSize.small;
    final width = small ? 38.0 : 52.0;
    final height = small ? 20.0 : 28.0;
    final handleSize = small ? 14.0 : 21.0;
    const borderWidth = 2.5;
    final uncheckedLeft = small ? 1.0 : 2.0;
    final checkedLeft = width - handleSize - (small ? 7.0 : 7.5);
    final label = _checked ? widget.checkedChild : widget.uncheckedChild;
    final showLabel = label != null;
    final background = _checked
        ? (_hovered ? const Color(0xFF7CCC70) : const Color(0xFF86D67A))
        : const Color(0xFFD4C9B4);
    final borderColor = _checked
        ? (_hovered ? const Color(0xFF5A9E1E) : theme.successColor)
        : (_hovered ? const Color(0xFFA89878) : theme.disabledTextColor);
    final insetShadowColor = _checked
        ? const Color(0xFF5A9E1E).withValues(alpha: 0.2)
        : const Color(0xFF725D42).withValues(alpha: 0.15);

    return MouseRegion(
      cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _enabled
            ? () {
                final next = !_checked;
                if (widget.value == null) {
                  setState(() => _innerValue = next);
                }
                widget.onChanged?.call(next);
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
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: borderColor, width: borderWidth),
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
                      color: const Color(0xFFF7F3DF),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _checked
                            ? theme.successColor
                            : theme.disabledTextColor,
                        width: 2.5,
                      ),
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
                                      : const Color(0xFFA89878),
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
    );
  }
}
