import 'package:flutter/material.dart';

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
  var _hovered = false;

  bool get _enabled =>
      widget.item.onTap != null && !widget.item.disabled && !widget.active;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final color = widget.active
        ? theme.textColor
        : widget.item.disabled
            ? theme.disabledTextColor
            : _hovered
                ? theme.primaryColor
                : theme.secondaryTextColor;

    return MouseRegion(
      cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: _enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: _enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: _enabled ? widget.item.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: widget.active
                ? const Color(0xFFFFF8D6)
                : _hovered
                    ? theme.primaryBackgroundColor
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
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
    );
  }
}
