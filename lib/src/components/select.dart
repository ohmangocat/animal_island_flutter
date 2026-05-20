import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  });

  final List<AnimalSelectOption<T>> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final String placeholder;
  final bool disabled;
  final double minWidth;

  @override
  State<AnimalSelect<T>> createState() => _AnimalSelectState<T>();
}

class _AnimalSelectState<T> extends State<AnimalSelect<T>> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _open = false;
  bool _hovered = false;
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
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final selected = _selected;

    return CompositedTransformTarget(
      link: _link,
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
                      ? const Color(0xFFF5F5F0)
                      : (_hovered && !_open
                          ? const Color(0xFFFFFDF7)
                          : Colors.white),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _open || _hovered
                        ? const Color(0xFFD4C4A8)
                        : const Color(0xFFE8DCC8),
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
                              ? const Color(0xFFA09080)
                              : const Color(0xFF725D42),
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
                            : const Color(0xFFA09080),
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
    if (_open) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) {
        final box = this.context.findRenderObject() as RenderBox;
        final triggerOffset = box.localToGlobal(Offset.zero);
        final viewportSize = MediaQuery.sizeOf(context);
        const estimatedWidth = 200.0;
        final estimatedHeight = widget.options.length * 42 + 24;
        final openRight = triggerOffset.dx + box.size.width + estimatedWidth <=
            viewportSize.width;
        final spaceBelow =
            viewportSize.height - triggerOffset.dy - box.size.height;
        final spaceAbove = triggerOffset.dy;

        Alignment targetAnchor;
        Alignment followerAnchor;
        Offset overlayOffset;
        if (spaceBelow < estimatedHeight && spaceAbove > spaceBelow) {
          targetAnchor = openRight ? Alignment.topRight : Alignment.topLeft;
          followerAnchor =
              openRight ? Alignment.bottomLeft : Alignment.bottomRight;
          overlayOffset = Offset(openRight ? 6 : -6, -6);
        } else if (spaceBelow < estimatedHeight ||
            spaceAbove < estimatedHeight) {
          targetAnchor =
              openRight ? Alignment.bottomRight : Alignment.bottomLeft;
          followerAnchor = openRight ? Alignment.topLeft : Alignment.topRight;
          overlayOffset = Offset(openRight ? 6 : -6, 6);
        } else {
          targetAnchor =
              openRight ? Alignment.centerRight : Alignment.centerLeft;
          followerAnchor =
              openRight ? Alignment.centerLeft : Alignment.centerRight;
          overlayOffset = Offset(openRight ? 6 : -6, 0);
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
    setState(() => _open = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _hoveredIndex = null;
    if (mounted && _open) {
      setState(() => _open = false);
    }
  }
}

class _Dropdown<T> extends StatelessWidget {
  const _Dropdown({
    required this.options,
    required this.value,
    required this.hoveredIndex,
    required this.onHover,
    required this.onSelect,
  });

  final List<AnimalSelectOption<T>> options;
  final T? value;
  final int? hoveredIndex;
  final ValueChanged<int?> onHover;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    const rowHeight = 42.0;

    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEA0),
        borderRadius: BorderRadius.circular(28),
      ),
      child: MouseRegion(
        onHover: (event) {
          final index = ((event.localPosition.dy - 12) / rowHeight).floor();
          if (index >= 0 && index < options.length) {
            onHover(index);
          } else {
            onHover(null);
          }
        },
        onExit: (_) => onHover(null),
        cursor: SystemMouseCursors.click,
        child: IntrinsicWidth(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 120),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final indexed in options.indexed)
                  _SelectOptionRow<T>(
                    option: indexed.$2,
                    selected: value == indexed.$2.key,
                    hovered: hoveredIndex == indexed.$1,
                    onSelect: () => onSelect(indexed.$2.key),
                  ),
              ],
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
    required this.onSelect,
  });

  final AnimalSelectOption<T> option;
  final bool selected;
  final bool hovered;
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
    return GestureDetector(
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
                        color: const Color(0xFFFFCC00).withValues(alpha: 0.30),
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
                      color: const Color(0xFF725D42),
                    ),
                  ),
                ],
              ),
            ],
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
    return SvgPicture.asset(
      'assets/animal_island/img/cursor/select-cursor.svg',
      package: 'animal_island_flutter',
      width: 35,
      height: 35,
      fit: BoxFit.contain,
    );
  }
}
