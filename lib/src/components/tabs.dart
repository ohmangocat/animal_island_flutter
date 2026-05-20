import 'package:flutter/material.dart';

import '../animal_theme.dart';

@immutable
class AnimalTabItem {
  const AnimalTabItem({
    required this.key,
    required this.label,
    required this.child,
  });

  final String key;
  final Widget label;
  final Widget child;
}

class AnimalTabs extends StatefulWidget {
  const AnimalTabs({
    super.key,
    required this.items,
    this.defaultActiveKey,
    this.activeKey,
    this.onChanged,
    this.leafAnimation = true,
    this.shadow = true,
  });

  final List<AnimalTabItem> items;
  final String? defaultActiveKey;
  final String? activeKey;
  final ValueChanged<String>? onChanged;
  final bool leafAnimation;
  final bool shadow;

  @override
  State<AnimalTabs> createState() => _AnimalTabsState();
}

class _AnimalTabsState extends State<AnimalTabs> {
  late String? _innerActiveKey;

  String? get _activeKey =>
      widget.activeKey ?? _innerActiveKey ?? widget.items.firstOrNull?.key;

  @override
  void initState() {
    super.initState();
    _innerActiveKey = widget.defaultActiveKey ?? widget.items.firstOrNull?.key;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final activeKey = _activeKey;
    final activeItem =
        widget.items.where((item) => item.key == activeKey).firstOrNull;

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.lightBorderColor, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              border: Border(
                bottom: BorderSide(color: theme.lightBorderColor, width: 2),
              ),
            ),
            child: Wrap(
              spacing: 4,
              runSpacing: 8,
              children: [
                for (final item in widget.items)
                  _TabButton(
                    item: item,
                    active: item.key == activeKey,
                    leafAnimation: widget.leafAnimation,
                    shadow: widget.shadow,
                    onTap: () => _activate(item.key),
                  ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Padding(
              key: ValueKey(activeKey),
              padding: const EdgeInsets.all(24),
              child: DefaultTextStyle.merge(
                style: theme.textStyle(
                  size: 14,
                  weight: FontWeight.w500,
                  color: theme.secondaryTextColor,
                ),
                child: activeItem?.child ?? const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _activate(String key) {
    if (widget.activeKey == null) {
      setState(() => _innerActiveKey = key);
    }
    widget.onChanged?.call(key);
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.item,
    required this.active,
    required this.leafAnimation,
    required this.shadow,
    required this.onTap,
  });

  final AnimalTabItem item;
  final bool active;
  final bool leafAnimation;
  final bool shadow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: _HoverableTabBody(
          active: active,
          shadow: shadow,
          leafAnimation: leafAnimation,
          item: item,
          theme: theme,
        ),
      ),
    );
  }
}

class _HoverableTabBody extends StatefulWidget {
  const _HoverableTabBody({
    required this.active,
    required this.shadow,
    required this.leafAnimation,
    required this.item,
    required this.theme,
  });

  final bool active;
  final bool shadow;
  final bool leafAnimation;
  final AnimalTabItem item;
  final AnimalThemeData theme;

  @override
  State<_HoverableTabBody> createState() => _HoverableTabBodyState();
}

class _HoverableTabBodyState extends State<_HoverableTabBody> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final theme = widget.theme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF0CC0B5)
              : (_hovered
                  ? theme.primaryColor.withValues(alpha: 0.10)
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(24),
          boxShadow: active && widget.shadow
              ? [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.08),
                    offset: const Offset(0, 3),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: active ? 1.2 : 1,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      Icons.circle,
                      size: 6,
                      color:
                          !active ? const Color(0xFFFFF9E3) : theme.textColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  DefaultTextStyle.merge(
                    style: theme.textStyle(
                      size: 14,
                      weight: active ? FontWeight.w600 : FontWeight.w500,
                      color: active ? const Color(0xFFFFF9E3) : theme.textColor,
                    ),
                    child: widget.item.label,
                  ),
                ],
              ),
            ),
            if (active)
              Positioned(
                right: -6,
                top: -5,
                child: _Leaf(animation: widget.leafAnimation),
              ),
          ],
        ),
      ),
    );
  }
}

class _Leaf extends StatefulWidget {
  const _Leaf({required this.animation});

  final bool animation;

  @override
  State<_Leaf> createState() => _LeafState();
}

class _LeafState extends State<_Leaf> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.animation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _Leaf oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.animation && _controller.isAnimating) {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: widget.animation ? (_controller.value - 0.5) * 0.35 : 0,
          child: child,
        );
      },
      child: Image.asset(
        'assets/animal_island/img/icons/icon-leaf.png',
        package: 'animal_island_flutter',
        width: 18,
        height: 18,
        fit: BoxFit.contain,
      ),
    );
  }
}
