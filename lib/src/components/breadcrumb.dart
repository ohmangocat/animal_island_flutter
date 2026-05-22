import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animal_theme.dart';

@immutable
class AnimalBreadcrumbItem {
  const AnimalBreadcrumbItem({
    required this.label,
    this.onTap,
    this.disabled = false,
  });

  final Widget label;
  final VoidCallback? onTap;
  final bool disabled;
}

class AnimalBreadcrumb extends StatelessWidget {
  const AnimalBreadcrumb({
    super.key,
    required this.items,
    this.separator,
  });

  final List<AnimalBreadcrumbItem> items;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _BreadcrumbChip(
            item: items[index],
            active: index == items.length - 1,
          ),
          if (index != items.length - 1)
            DefaultTextStyle.merge(
              style: theme.textStyle(
                size: 13,
                weight: FontWeight.w900,
                color: const Color(0xFFC3AD7A),
              ),
              child: separator ?? const Text('/'),
            ),
        ],
      ],
    );
  }
}

class _BreadcrumbChip extends StatefulWidget {
  const _BreadcrumbChip({required this.item, required this.active});

  final AnimalBreadcrumbItem item;
  final bool active;

  @override
  State<_BreadcrumbChip> createState() => _BreadcrumbChipState();
}

class _BreadcrumbChipState extends State<_BreadcrumbChip> {
  final _focusNode = FocusNode();
  var _hovered = false;
  var _focused = false;
  var _pressed = false;

  bool get _enabled =>
      widget.item.onTap != null && !widget.item.disabled && !widget.active;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final highlighted = _enabled && (_hovered || _focused);
    final color = widget.active
        ? theme.textColor
        : widget.item.disabled
            ? theme.disabledTextColor
            : highlighted
                ? theme.primaryColor
                : theme.secondaryTextColor;

    return Semantics(
      button: _enabled,
      enabled: _enabled,
      selected: widget.active,
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
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.active
                    ? theme.elevatedBackgroundColor
                    : highlighted
                        ? theme.primaryBackgroundColor
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: highlighted
                      ? theme.controlBorderColor
                      : Colors.transparent,
                ),
              ),
              child: DefaultTextStyle.merge(
                style: theme.textStyle(
                  size: 13,
                  weight: widget.active ? FontWeight.w900 : FontWeight.w700,
                  color: color,
                ),
                child: widget.item.label,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _activate() {
    if (_enabled) {
      widget.item.onTap?.call();
    }
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
