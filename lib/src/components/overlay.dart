import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animal_theme.dart';
import 'button.dart';
import 'dialog.dart';

enum AnimalPopoverPlacement { top, right, bottom, left }

enum AnimalPopoverTrigger { click, hover, manual }

enum AnimalDrawerPlacement { left, right }

@immutable
class AnimalDropdownItem<T> {
  const AnimalDropdownItem({
    required this.value,
    required this.label,
    this.disabled = false,
    this.icon,
  });

  final T value;
  final Widget label;
  final bool disabled;
  final Widget? icon;
}

class AnimalPopover extends StatefulWidget {
  const AnimalPopover({
    super.key,
    required this.child,
    required this.content,
    this.title,
    this.placement = AnimalPopoverPlacement.bottom,
    this.trigger = AnimalPopoverTrigger.click,
    this.open,
    this.onOpenChanged,
    this.width = 260,
    this.gap = 10,
  });

  final Widget child;
  final Widget content;
  final Widget? title;
  final AnimalPopoverPlacement placement;
  final AnimalPopoverTrigger trigger;
  final bool? open;
  final ValueChanged<bool>? onOpenChanged;
  final double width;
  final double gap;

  @override
  State<AnimalPopover> createState() => _AnimalPopoverState();
}

class _AnimalPopoverState extends State<AnimalPopover> {
  final _triggerFocusNode = FocusNode();
  OverlayEntry? _entry;
  var _innerOpen = false;
  var _hoveringTrigger = false;
  var _hoveringOverlay = false;

  bool get _open => widget.open ?? _innerOpen;
  bool get _controlled => widget.open != null;
  bool get _hoverTrigger => widget.trigger == AnimalPopoverTrigger.hover;
  bool get _clickTrigger => widget.trigger == AnimalPopoverTrigger.click;

  @override
  void initState() {
    super.initState();
    _syncOverlayAfterFrame();
  }

  @override
  void didUpdateWidget(covariant AnimalPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncOverlayAfterFrame();
  }

  @override
  void dispose() {
    _triggerFocusNode.dispose();
    _remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      focusNode: _triggerFocusNode,
      enabled: widget.trigger != AnimalPopoverTrigger.manual,
      mouseCursor: widget.trigger == AnimalPopoverTrigger.click
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (intent) {
            if (_clickTrigger) {
              _setOpen(!_open);
            } else if (_hoverTrigger) {
              _setOpen(true);
            }
            return null;
          },
        ),
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (intent) {
            _setOpen(false);
            return null;
          },
        ),
      },
      child: MouseRegion(
        cursor: widget.trigger == AnimalPopoverTrigger.click
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        onEnter: _hoverTrigger
            ? (_) {
                _hoveringTrigger = true;
                _setOpen(true);
              }
            : null,
        onExit: _hoverTrigger
            ? (_) {
                _hoveringTrigger = false;
                _scheduleHoverClose();
              }
            : null,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _clickTrigger
              ? () {
                  _triggerFocusNode.requestFocus();
                  _setOpen(!_open);
                }
              : null,
          child: widget.child,
        ),
      ),
    );
  }

  void _setOpen(bool value) {
    if (_open == value) {
      return;
    }
    if (!_controlled) {
      setState(() => _innerOpen = value);
    }
    widget.onOpenChanged?.call(value);
    _syncOverlayAfterFrame();
  }

  void _scheduleHoverClose() {
    Future<void>.delayed(const Duration(milliseconds: 120), () {
      if (!mounted || !_hoverTrigger) {
        return;
      }
      if (!_hoveringTrigger && !_hoveringOverlay) {
        _setOpen(false);
      }
    });
  }

  void _syncOverlayAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_open && _entry == null) {
        _show();
      } else if (!_open && _entry != null) {
        _remove();
      } else if (_entry != null) {
        _entry!.markNeedsBuild();
      }
    });
  }

  void _show() {
    if (!mounted || _entry != null) {
      return;
    }
    final renderObject = context.findRenderObject();
    final overlay = Overlay.of(context);
    final overlayRenderObject = overlay.context.findRenderObject();
    if (renderObject is! RenderBox || overlayRenderObject is! RenderBox) {
      return;
    }
    final targetRect = renderObject.localToGlobal(
          Offset.zero,
          ancestor: overlayRenderObject,
        ) &
        renderObject.size;
    _entry = OverlayEntry(
      builder: (context) {
        return _PopoverOverlay(
          targetRect: targetRect,
          placement: widget.placement,
          gap: widget.gap,
          width: widget.width,
          onDismiss: () => _setOpen(false),
          onHoverChanged: _hoverTrigger
              ? (value) {
                  _hoveringOverlay = value;
                  if (value) {
                    _setOpen(true);
                  } else {
                    _scheduleHoverClose();
                  }
                }
              : null,
          child: _PopoverPanel(
            title: widget.title,
            child: widget.content,
          ),
        );
      },
    );
    overlay.insert(_entry!);
  }

  void _remove() {
    _entry?.remove();
    _entry = null;
  }
}

class AnimalDropdown<T> extends StatefulWidget {
  const AnimalDropdown({
    super.key,
    required this.child,
    required this.items,
    required this.onChanged,
    this.placement = AnimalPopoverPlacement.bottom,
    this.width = 220,
  });

  final Widget child;
  final List<AnimalDropdownItem<T>> items;
  final ValueChanged<T> onChanged;
  final AnimalPopoverPlacement placement;
  final double width;

  @override
  State<AnimalDropdown<T>> createState() => _AnimalDropdownState<T>();
}

class _AnimalDropdownState<T> extends State<AnimalDropdown<T>> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    return AnimalPopover(
      open: _open,
      onOpenChanged: (value) => setState(() => _open = value),
      placement: widget.placement,
      width: widget.width,
      content: _DropdownMenu<T>(
        items: widget.items,
        onChanged: (value) {
          widget.onChanged(value);
          setState(() => _open = false);
        },
        onDismiss: () => setState(() => _open = false),
      ),
      child: widget.child,
    );
  }
}

class AnimalDrawer extends StatelessWidget {
  const AnimalDrawer({
    super.key,
    required this.child,
    this.title,
    this.footer,
    this.placement = AnimalDrawerPlacement.right,
    this.width = 360,
    this.onClose,
  });

  final Widget child;
  final Widget? title;
  final Widget? footer;
  final AnimalDrawerPlacement placement;
  final double width;
  final VoidCallback? onClose;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    Widget? title,
    Widget? footer,
    AnimalDrawerPlacement placement = AnimalDrawerPlacement.right,
    double width = 360,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AnimalDrawer(
          title: title,
          footer: footer,
          placement: placement,
          width: width,
          onClose: () => Navigator.of(context).maybePop(),
          child: child,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final begin = placement == AnimalDrawerPlacement.right
            ? const Offset(1, 0)
            : const Offset(-1, 0);
        return SlideTransition(
          position: Tween(begin: begin, end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final alignment = placement == AnimalDrawerPlacement.right
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final close = onClose ?? () => Navigator.of(context).maybePop();

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      },
      child: Actions(
        actions: {
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (intent) {
              close();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Align(
            alignment: alignment,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: width,
                  margin: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.contentBackgroundColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: theme.warmBorderColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withValues(alpha: 0.24),
                        offset: const Offset(0, 8),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 18, 14, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: DefaultTextStyle.merge(
                                style: theme.textStyle(
                                  size: 18,
                                  weight: FontWeight.w900,
                                  color: theme.textColor,
                                ),
                                child: title ?? const Text('Drawer'),
                              ),
                            ),
                            _DrawerCloseButton(onPressed: close),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE8E2D6)),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(22),
                          child: DefaultTextStyle.merge(
                            style: theme.textStyle(
                              size: 14,
                              weight: FontWeight.w600,
                              color: theme.bodyTextColor,
                            ),
                            child: child,
                          ),
                        ),
                      ),
                      if (footer != null)
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: footer,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerCloseButton extends StatefulWidget {
  const _DrawerCloseButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_DrawerCloseButton> createState() => _DrawerCloseButtonState();
}

class _DrawerCloseButtonState extends State<_DrawerCloseButton> {
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
    final active = _hovered || _focused || _pressed;
    final color = _pressed
        ? theme.primaryActiveColor
        : active
            ? theme.primaryColor
            : theme.bodyTextColor;

    return Semantics(
      button: true,
      label: '关闭',
      child: Tooltip(
        message: '关闭',
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
                widget.onPressed();
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
              behavior: HitTestBehavior.opaque,
              onTapDown: (_) => _setPressed(true),
              onTapUp: (_) => _setPressed(false),
              onTapCancel: () => _setPressed(false),
              onTap: () {
                _focusNode.requestFocus();
                widget.onPressed();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: active
                      ? theme.primaryBackgroundColor
                      : theme.elevatedBackgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        active ? theme.primaryColor : theme.controlBorderColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.tactileShadowColor.withValues(alpha: 0.36),
                      offset: Offset(0, _pressed ? 0 : 1),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Icon(Icons.close_rounded, color: color, size: 20),
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

abstract final class AnimalConfirmDialog {
  static Future<bool?> show({
    required BuildContext context,
    required Widget content,
    Widget? title,
    String okText = '确定',
    String cancelText = '取消',
    VoidCallback? onOk,
    bool danger = false,
  }) {
    return AnimalDialog.show<bool>(
      context: context,
      title: title,
      child: content,
      showFooter: true,
      footer: Builder(
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimalButton(
                type: AnimalButtonType.primary,
                onPressed: () => Navigator.of(context).maybePop(false),
                child: Text(cancelText),
              ),
              const SizedBox(width: 12),
              AnimalButton(
                type: AnimalButtonType.primary,
                danger: danger,
                onPressed: () {
                  onOk?.call();
                  Navigator.of(context).maybePop(true);
                },
                child: Text(okText),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PopoverOverlay extends StatelessWidget {
  const _PopoverOverlay({
    required this.targetRect,
    required this.placement,
    required this.gap,
    required this.width,
    required this.onDismiss,
    required this.child,
    this.onHoverChanged,
  });

  final Rect targetRect;
  final AnimalPopoverPlacement placement;
  final double gap;
  final double width;
  final VoidCallback onDismiss;
  final Widget child;
  final ValueChanged<bool>? onHoverChanged;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onDismiss,
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: false,
            child: CustomSingleChildLayout(
              delegate: _PopoverPositionDelegate(
                targetRect: targetRect,
                placement: placement,
                gap: gap,
              ),
              child: MouseRegion(
                onEnter: onHoverChanged == null
                    ? null
                    : (_) => onHoverChanged!(true),
                onExit: onHoverChanged == null
                    ? null
                    : (_) => onHoverChanged!(false),
                child: SizedBox(width: width, child: child),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PopoverPanel extends StatelessWidget {
  const _PopoverPanel({
    required this.child,
    this.title,
  });

  final Widget child;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.elevatedBackgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.warmBorderColor, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: DefaultTextStyle.merge(
          style: theme.textStyle(
            size: 13,
            weight: FontWeight.w700,
            color: theme.bodyTextColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                DefaultTextStyle.merge(
                  style: theme.textStyle(
                    size: 15,
                    weight: FontWeight.w900,
                    color: theme.textColor,
                  ),
                  child: title!,
                ),
                const SizedBox(height: 8),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownMenu<T> extends StatelessWidget {
  const _DropdownMenu({
    required this.items,
    required this.onChanged,
    required this.onDismiss,
  });

  final List<AnimalDropdownItem<T>> items;
  final ValueChanged<T> onChanged;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
        },
        child: Actions(
          actions: {
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (intent) {
                onDismiss();
                return null;
              },
            ),
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final indexed in items.indexed)
                FocusTraversalOrder(
                  order: NumericFocusOrder(indexed.$1.toDouble()),
                  child: _DropdownMenuRow<T>(
                    item: indexed.$2,
                    theme: theme,
                    onTap: () {
                      if (!indexed.$2.disabled) {
                        onChanged(indexed.$2.value);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuRow<T> extends StatefulWidget {
  const _DropdownMenuRow({
    required this.item,
    required this.theme,
    required this.onTap,
  });

  final AnimalDropdownItem<T> item;
  final AnimalThemeData theme;
  final VoidCallback onTap;

  @override
  State<_DropdownMenuRow<T>> createState() => _DropdownMenuRowState<T>();
}

class _DropdownMenuRowState<T> extends State<_DropdownMenuRow<T>> {
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
    final disabled = widget.item.disabled;
    final active = !disabled && (_hovered || _focused || _pressed);
    final color =
        disabled ? widget.theme.disabledTextColor : widget.theme.bodyTextColor;
    return FocusableActionDetector(
      focusNode: _focusNode,
      enabled: !disabled,
      mouseCursor:
          disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
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
            if (!disabled) {
              widget.onTap();
            }
            return null;
          },
        ),
      },
      child: MouseRegion(
        cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
        onEnter: (_) => _setHovered(true),
        onExit: (_) {
          _setHovered(false);
          _setPressed(false);
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: disabled ? null : (_) => _setPressed(true),
          onTapUp: disabled ? null : (_) => _setPressed(false),
          onTapCancel: disabled ? null : () => _setPressed(false),
          onTap: disabled
              ? null
              : () {
                  _focusNode.requestFocus();
                  widget.onTap();
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: active
                  ? widget.theme.primaryBackgroundColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active ? widget.theme.primaryColor : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Opacity(
              opacity: disabled ? 0.55 : 1,
              child: Row(
                children: [
                  if (widget.item.icon != null) ...[
                    IconTheme.merge(
                      data: IconThemeData(
                        color: active ? widget.theme.primaryColor : color,
                        size: 16,
                      ),
                      child: widget.item.icon!,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: DefaultTextStyle.merge(
                      style: widget.theme.textStyle(
                        size: 13,
                        weight: active ? FontWeight.w900 : FontWeight.w800,
                        color: active ? widget.theme.primaryActiveColor : color,
                      ),
                      child: widget.item.label,
                    ),
                  ),
                ],
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

class _PopoverPositionDelegate extends SingleChildLayoutDelegate {
  const _PopoverPositionDelegate({
    required this.targetRect,
    required this.placement,
    required this.gap,
  });

  final Rect targetRect;
  final AnimalPopoverPlacement placement;
  final double gap;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    const padding = 8.0;
    return BoxConstraints(
      maxWidth: (constraints.maxWidth - padding * 2)
          .clamp(0, double.infinity)
          .toDouble(),
      maxHeight: (constraints.maxHeight - padding * 2)
          .clamp(0, double.infinity)
          .toDouble(),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final position = switch (placement) {
      AnimalPopoverPlacement.top => Offset(
          targetRect.center.dx - childSize.width / 2,
          targetRect.top - gap - childSize.height,
        ),
      AnimalPopoverPlacement.right => Offset(
          targetRect.right + gap,
          targetRect.center.dy - childSize.height / 2,
        ),
      AnimalPopoverPlacement.bottom => Offset(
          targetRect.center.dx - childSize.width / 2,
          targetRect.bottom + gap,
        ),
      AnimalPopoverPlacement.left => Offset(
          targetRect.left - gap - childSize.width,
          targetRect.center.dy - childSize.height / 2,
        ),
    };
    const padding = 8.0;
    final maxX = size.width - childSize.width - padding;
    final maxY = size.height - childSize.height - padding;
    return Offset(
      position.dx.clamp(padding, maxX < padding ? padding : maxX).toDouble(),
      position.dy.clamp(padding, maxY < padding ? padding : maxY).toDouble(),
    );
  }

  @override
  bool shouldRelayout(covariant _PopoverPositionDelegate oldDelegate) {
    return oldDelegate.targetRect != targetRect ||
        oldDelegate.placement != placement ||
        oldDelegate.gap != gap;
  }
}
