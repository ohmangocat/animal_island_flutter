import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../animal_theme.dart';

@immutable
class AnimalSelectOption<T> {
  const AnimalSelectOption({
    required this.key,
    required this.label,
  });

  final T key;
  final String label;
}

class AnimalSelect<T> extends StatefulWidget {
  const AnimalSelect({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.placeholder = '请选择',
    this.disabled = false,
    this.minWidth = 140,
    this.dropdownMaxHeight = 260,
  });

  final List<AnimalSelectOption<T>> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final String placeholder;
  final bool disabled;
  final double minWidth;
  final double dropdownMaxHeight;

  @override
  State<AnimalSelect<T>> createState() => _AnimalSelectState<T>();
}

class _AnimalSelectState<T> extends State<AnimalSelect<T>> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _open = false;
  bool _hovered = false;
  bool _focused = false;
  int? _hoveredIndex;

  AnimalSelectOption<T>? get _selected {
    for (final option in widget.options) {
      if (option.key == widget.value) {
        return option;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _removeOverlay(updateState: false);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimalSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.disabled && _open) {
      _removeOverlay();
      return;
    }
    if (_open &&
        (widget.value != oldWidget.value ||
            widget.options.length != oldWidget.options.length)) {
      _overlayEntry?.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final selected = _selected;

    return CompositedTransformTarget(
      link: _link,
      child: Semantics(
        button: true,
        enabled: !widget.disabled,
        expanded: _open,
        value: selected?.label ?? widget.placeholder,
        child: FocusableActionDetector(
          enabled: !widget.disabled,
          mouseCursor: widget.disabled
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          onShowFocusHighlight: (value) {
            if (mounted) {
              setState(() => _focused = value);
            }
          },
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.arrowDown): _SelectNextIntent(),
            SingleActivator(LogicalKeyboardKey.arrowUp):
                _SelectPreviousIntent(),
            SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
          },
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (intent) {
                _activateFocusedOption();
                return null;
              },
            ),
            _SelectNextIntent: CallbackAction<_SelectNextIntent>(
              onInvoke: (intent) {
                _moveHover(1);
                return null;
              },
            ),
            _SelectPreviousIntent: CallbackAction<_SelectPreviousIntent>(
              onInvoke: (intent) {
                _moveHover(-1);
                return null;
              },
            ),
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (intent) {
                _removeOverlay();
                return null;
              },
            ),
          },
          child: MouseRegion(
            cursor: widget.disabled
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: GestureDetector(
              onTap: widget.disabled ? null : _toggle,
              child: Opacity(
                opacity: widget.disabled ? 0.5 : 1,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: widget.minWidth),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.disabled
                          ? theme.disabledBackgroundColor
                          : (_hovered && !_open
                              ? theme.subtleBackgroundColor
                              : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _open || _hovered || _focused
                            ? theme.controlBorderColor
                            : theme.lightBorderColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            selected?.label ?? widget.placeholder,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textStyle(
                              size: 14,
                              weight: selected == null
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              color: selected == null
                                  ? theme.placeholderColor
                                  : theme.bodyTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        AnimatedRotation(
                          turns: _open ? 0.5 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: _open
                                ? theme.primaryColor
                                : theme.placeholderColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggle() {
    if (_open) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _activateFocusedOption() {
    if (widget.disabled) {
      return;
    }
    if (!_open) {
      _showOverlay(initialHoverIndex: _selectedIndex());
      return;
    }
    final index = _hoveredIndex ?? _selectedIndex();
    if (index == null || index < 0 || index >= widget.options.length) {
      return;
    }
    widget.onChanged(widget.options[index].key);
    _removeOverlay();
  }

  void _moveHover(int delta) {
    if (widget.disabled || widget.options.isEmpty) {
      return;
    }
    if (!_open) {
      final selectedIndex =
          _selectedIndex() ?? (delta > 0 ? -1 : widget.options.length);
      _showOverlay(
        initialHoverIndex:
            (selectedIndex + delta).clamp(0, widget.options.length - 1),
      );
      return;
    }
    final current = _hoveredIndex ?? _selectedIndex() ?? -1;
    _hoveredIndex = (current + delta).clamp(0, widget.options.length - 1);
    _overlayEntry?.markNeedsBuild();
  }

  int? _selectedIndex() {
    final selected = _selected;
    if (selected == null) {
      return null;
    }
    final index =
        widget.options.indexWhere((option) => option.key == selected.key);
    return index < 0 ? null : index;
  }

  void _showOverlay({int? initialHoverIndex}) {
    if (widget.disabled || widget.options.isEmpty) {
      return;
    }
    _hoveredIndex = initialHoverIndex;

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        final box = this.context.findRenderObject() as RenderBox;
        final triggerOffset = box.localToGlobal(Offset.zero);
        final viewportSize = MediaQuery.sizeOf(context);
        const viewportPadding = 12.0;
        const dropdownGap = 6.0;
        const optionHeight = 42.0;
        const dropdownVerticalPadding = 24.0;
        const estimatedWidth = 220.0;
        final desiredHeight =
            widget.options.length * optionHeight + dropdownVerticalPadding;
        final viewportMaxHeight =
            math.max(120.0, viewportSize.height - viewportPadding * 2);
        final maxDropdownHeight =
            math.min(widget.dropdownMaxHeight, viewportMaxHeight);
        final estimatedHeight = math.min(desiredHeight, maxDropdownHeight);
        final alignRight = triggerOffset.dx + estimatedWidth >
            viewportSize.width - viewportPadding;
        final spaceBelow = viewportSize.height -
            triggerOffset.dy -
            box.size.height -
            viewportPadding;
        final spaceAbove = triggerOffset.dy - viewportPadding;
        final openAbove =
            spaceBelow < estimatedHeight && spaceAbove > spaceBelow;
        final availableHeight = math.max(
          120.0,
          math.min(
            maxDropdownHeight,
            openAbove ? spaceAbove : spaceBelow,
          ),
        );

        Alignment targetAnchor;
        Alignment followerAnchor;
        Offset overlayOffset;
        if (openAbove) {
          targetAnchor = alignRight ? Alignment.topRight : Alignment.topLeft;
          followerAnchor =
              alignRight ? Alignment.bottomRight : Alignment.bottomLeft;
          overlayOffset = const Offset(0, -dropdownGap);
        } else {
          targetAnchor =
              alignRight ? Alignment.bottomRight : Alignment.bottomLeft;
          followerAnchor = alignRight ? Alignment.topRight : Alignment.topLeft;
          overlayOffset = const Offset(0, dropdownGap);
        }

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeOverlay,
              ),
            ),
            CompositedTransformFollower(
              link: _link,
              offset: overlayOffset,
              followerAnchor: followerAnchor,
              targetAnchor: targetAnchor,
              showWhenUnlinked: false,
              child: Material(
                color: Colors.transparent,
                child: StatefulBuilder(
                  builder: (context, setOverlayState) {
                    return _Dropdown<T>(
                      options: widget.options,
                      value: widget.value,
                      hoveredIndex: _hoveredIndex,
                      maxHeight: availableHeight,
                      minWidth: math.max(120, box.size.width),
                      maxWidth: math.max(
                          120, viewportSize.width - viewportPadding * 2),
                      onHover: (index) {
                        _hoveredIndex = index;
                        setOverlayState(() {});
                      },
                      onSelect: (value) {
                        widget.onChanged(value);
                        _removeOverlay();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_overlayEntry!);
    if (mounted) {
      setState(() => _open = true);
    } else {
      _open = true;
    }
  }

  void _removeOverlay({bool updateState = true}) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _hoveredIndex = null;
    if (updateState && mounted && _open) {
      setState(() => _open = false);
    } else {
      _open = false;
    }
  }
}

class _SelectNextIntent extends Intent {
  const _SelectNextIntent();
}

class _SelectPreviousIntent extends Intent {
  const _SelectPreviousIntent();
}

class AnimalSelectFormField<T> extends FormField<T> {
  AnimalSelectFormField({
    super.key,
    required List<AnimalSelectOption<T>> options,
    ValueChanged<T>? onChanged,
    T? value,
    String placeholder = '请选择',
    bool disabled = false,
    double minWidth = 140,
    double dropdownMaxHeight = 260,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onSaved,
    super.validator,
    super.restorationId,
  }) : super(
          initialValue: value,
          enabled: !disabled,
          builder: (field) {
            return _FormFieldShell(
              errorText: field.errorText,
              child: AnimalSelect<T>(
                options: options,
                value: field.value,
                placeholder: placeholder,
                disabled: disabled,
                minWidth: minWidth,
                dropdownMaxHeight: dropdownMaxHeight,
                onChanged: (next) {
                  field.didChange(next);
                  onChanged?.call(next);
                },
              ),
            );
          },
        );
}

class _FormFieldShell extends StatelessWidget {
  const _FormFieldShell({
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

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.options,
    required this.value,
    required this.hoveredIndex,
    required this.maxHeight,
    required this.minWidth,
    required this.maxWidth,
    required this.onHover,
    required this.onSelect,
  });

  final List<AnimalSelectOption<T>> options;
  final T? value;
  final int? hoveredIndex;
  final double maxHeight;
  final double minWidth;
  final double maxWidth;
  final ValueChanged<int?> onHover;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEA0),
        borderRadius: BorderRadius.circular(28),
      ),
      child: MouseRegion(
        onExit: (_) => onHover(null),
        cursor: SystemMouseCursors.click,
        child: IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final indexed in options.indexed)
                    _SelectOptionRow<T>(
                      option: indexed.$2,
                      selected: value == indexed.$2.key,
                      hovered: hoveredIndex == indexed.$1,
                      onHover: () => onHover(indexed.$1),
                      onSelect: () => onSelect(indexed.$2.key),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectOptionRow<T> extends StatefulWidget {
  const _SelectOptionRow({
    required this.option,
    required this.selected,
    required this.hovered,
    required this.onHover,
    required this.onSelect,
  });

  final AnimalSelectOption<T> option;
  final bool selected;
  final bool hovered;
  final VoidCallback onHover;
  final VoidCallback onSelect;

  @override
  State<_SelectOptionRow<T>> createState() => _SelectOptionRowState<T>();
}

class _SelectOptionRowState<T> extends State<_SelectOptionRow<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _slide;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slide = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -20, end: 5), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 5, end: 0), weight: 40),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _rotate = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -0.25, end: 0.08), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 0.08, end: 0), weight: 40),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(covariant _SelectOptionRow<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hovered && !oldWidget.hovered) {
      _controller.forward(from: 0);
    } else if (!widget.hovered && oldWidget.hovered) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final highlighted = widget.selected || widget.hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => widget.onHover(),
      child: GestureDetector(
        onTap: widget.onSelect,
        child: SizedBox(
          height: 42,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 0, 30, 0),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                if (widget.hovered)
                  Positioned(
                    left: -12,
                    top: 3.5,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_slide.value, 0),
                          child: Transform.rotate(
                            angle: _rotate.value,
                            child: child,
                          ),
                        );
                      },
                      child: const _SelectCursor(),
                    ),
                  ),
                if (widget.selected)
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        height: 14,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFFFCC00).withValues(alpha: 0.30),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      widget.option.label,
                      style: theme.textStyle(
                        size: 14,
                        weight: highlighted ? FontWeight.w800 : FontWeight.w600,
                        color: theme.bodyTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectCursor extends StatelessWidget {
  const _SelectCursor();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/animal_island/img/cursor/select-cursor.png',
      package: 'animal_island_flutter',
      width: 35,
      height: 35,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
