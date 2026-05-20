import 'package:flutter/material.dart';

import '../animal_theme.dart';

class AnimalPagination extends StatelessWidget {
  const AnimalPagination({
    super.key,
    required this.current,
    required this.total,
    required this.onChanged,
    this.pageSize = 10,
    this.maxVisiblePages = 5,
    this.disabled = false,
  });

  final int current;
  final int total;
  final int pageSize;
  final int maxVisiblePages;
  final bool disabled;
  final ValueChanged<int> onChanged;

  int get _pageCount => (total / pageSize).ceil().clamp(1, 999999);

  @override
  Widget build(BuildContext context) {
    final pageCount = _pageCount;
    final safeCurrent = current.clamp(1, pageCount);
    final pages = _visiblePages(safeCurrent, pageCount, maxVisiblePages);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _PageButton(
          label: '‹',
          disabled: disabled || safeCurrent <= 1,
          onTap: () => onChanged(safeCurrent - 1),
        ),
        for (final page in pages)
          _PageButton(
            label: '$page',
            active: page == safeCurrent,
            disabled: disabled,
            onTap: () => onChanged(page),
          ),
        _PageButton(
          label: '›',
          disabled: disabled || safeCurrent >= pageCount,
          onTap: () => onChanged(safeCurrent + 1),
        ),
      ],
    );
  }
}

List<int> _visiblePages(int current, int total, int maxVisiblePages) {
  final visible = maxVisiblePages.clamp(1, total);
  var start = current - visible ~/ 2;
  var end = start + visible - 1;
  if (start < 1) {
    start = 1;
    end = visible;
  }
  if (end > total) {
    end = total;
    start = (end - visible + 1).clamp(1, total);
  }
  return [for (var page = start; page <= end; page++) page];
}

class _PageButton extends StatefulWidget {
  const _PageButton({
    required this.label,
    required this.onTap,
    this.active = false,
    this.disabled = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool active;
  final bool disabled;

  @override
  State<_PageButton> createState() => _PageButtonState();
}

class _PageButtonState extends State<_PageButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final enabled = !widget.disabled;
    final active = widget.active;
    final yOffset = enabled ? (_pressed ? 2.0 : (_hovered ? -1.0 : 0.0)) : 0.0;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled
          ? (_) => setState(() {
                _hovered = false;
                _pressed = false;
              })
          : null,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTapUp: enabled
            ? (_) {
                setState(() => _pressed = false);
                widget.onTap();
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          transform: Matrix4.translationValues(0, yOffset, 0),
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? theme.primaryColor : const Color(0xFFF7F3DF),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: active
                  ? theme.primaryActiveColor
                  : _hovered
                      ? theme.primaryColor
                      : theme.borderColor,
              width: 2,
            ),
            boxShadow: enabled
                ? const [
                    BoxShadow(
                      color: Color(0xFFBDAEA0),
                      offset: Offset(0, 3),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: theme.textStyle(
              size: 13,
              weight: FontWeight.w900,
              color: !enabled
                  ? theme.disabledTextColor
                  : active
                      ? Colors.white
                      : theme.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
