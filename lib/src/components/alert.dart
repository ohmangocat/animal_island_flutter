import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animal_theme.dart';

enum AnimalAlertType { info, success, warning, error }

class AnimalAlert extends StatefulWidget {
  const AnimalAlert({
    super.key,
    required this.child,
    this.title,
    this.type = AnimalAlertType.info,
    this.showIcon = true,
    this.closable = false,
    this.onClose,
  });

  final Widget? title;
  final Widget child;
  final AnimalAlertType type;
  final bool showIcon;
  final bool closable;
  final VoidCallback? onClose;

  @override
  State<AnimalAlert> createState() => _AnimalAlertState();
}

class _AnimalAlertState extends State<AnimalAlert> {
  var _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return const SizedBox.shrink();
    }

    final theme = AnimalTheme.of(context);
    final palette = _alertPalette(theme, widget.type);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: theme.tactileShadowColor,
            offset: const Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showIcon) ...[
            _AlertIcon(type: widget.type, color: palette.foreground),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: DefaultTextStyle.merge(
              style: theme.textStyle(
                size: 14,
                weight: FontWeight.w600,
                color: theme.bodyTextColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.title != null) ...[
                    DefaultTextStyle.merge(
                      style: theme.textStyle(
                        size: 15,
                        weight: FontWeight.w900,
                        color: palette.foreground,
                      ),
                      child: widget.title!,
                    ),
                    const SizedBox(height: 4),
                  ],
                  widget.child,
                ],
              ),
            ),
          ),
          if (widget.closable) ...[
            const SizedBox(width: 10),
            _AlertCloseButton(
              onTap: () {
                setState(() => _visible = false);
                widget.onClose?.call();
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _AlertIcon extends StatelessWidget {
  const _AlertIcon({required this.type, required this.color});

  final AnimalAlertType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      AnimalAlertType.info => Icons.info_rounded,
      AnimalAlertType.success => Icons.check_circle_rounded,
      AnimalAlertType.warning => Icons.warning_rounded,
      AnimalAlertType.error => Icons.cancel_rounded,
    };

    return Icon(icon, color: color, size: 22);
  }
}

class _AlertCloseButton extends StatefulWidget {
  const _AlertCloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_AlertCloseButton> createState() => _AlertCloseButtonState();
}

class _AlertCloseButtonState extends State<_AlertCloseButton> {
  final _focusNode = FocusNode();
  var _hovered = false;
  var _focused = false;
  var _pressed = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final highlighted = _hovered || _focused;

    return Semantics(
      button: true,
      enabled: true,
      label: '关闭提示',
      child: FocusableActionDetector(
        focusNode: _focusNode,
        mouseCursor: SystemMouseCursors.click,
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
              widget.onTap();
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => _setHovered(true),
          onExit: (_) {
            _setHovered(false);
            _setPressed(false);
          },
          child: GestureDetector(
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            onTap: () {
              _focusNode.requestFocus();
              widget.onTap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: highlighted
                    ? theme.bodyTextColor.withValues(alpha: 0.10)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: highlighted ? theme.textColor : theme.secondaryTextColor,
              ),
            ),
          ),
        ),
      ),
    );
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

_AlertPalette _alertPalette(AnimalThemeData theme, AnimalAlertType type) {
  return switch (type) {
    AnimalAlertType.info => _AlertPalette(
        background: theme.primaryBackgroundColor,
        border: theme.primaryColor,
        foreground: theme.primaryActiveColor,
      ),
    AnimalAlertType.success => const _AlertPalette(
        background: Color(0xFFEAF7D8),
        border: Color(0xFF9DD56E),
        foreground: Color(0xFF5A9E1E),
      ),
    AnimalAlertType.warning => const _AlertPalette(
        background: Color(0xFFFFF3C2),
        border: Color(0xFFF5C31C),
        foreground: Color(0xFF9A7410),
      ),
    AnimalAlertType.error => const _AlertPalette(
        background: Color(0xFFFFE0DD),
        border: Color(0xFFFFA19A),
        foreground: Color(0xFFE05A5A),
      ),
  };
}

class _AlertPalette {
  const _AlertPalette({
    required this.background,
    required this.border,
    required this.foreground,
  });

  final Color background;
  final Color border;
  final Color foreground;
}
