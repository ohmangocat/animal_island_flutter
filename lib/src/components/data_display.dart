import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animal_theme.dart';

enum AnimalDescriptionsLayout { horizontal, vertical }

enum AnimalTimelineItemStatus {
  defaultStatus,
  success,
  warning,
  danger,
  primary
}

@immutable
class AnimalDescriptionItem {
  const AnimalDescriptionItem({
    required this.label,
    required this.child,
    this.span = 1,
  });

  final Widget label;
  final Widget child;
  final int span;
}

@immutable
class AnimalTimelineItem {
  const AnimalTimelineItem({
    required this.title,
    this.description,
    this.time,
    this.status = AnimalTimelineItemStatus.defaultStatus,
    this.icon,
    this.onTap,
    this.disabled = false,
  });

  final Widget title;
  final Widget? description;
  final Widget? time;
  final AnimalTimelineItemStatus status;
  final Widget? icon;
  final VoidCallback? onTap;
  final bool disabled;
}

class AnimalDescriptions extends StatelessWidget {
  const AnimalDescriptions({
    super.key,
    required this.items,
    this.title,
    this.column = 3,
    this.layout = AnimalDescriptionsLayout.horizontal,
    this.responsive = true,
    this.minColumnWidth = 170,
  });

  final List<AnimalDescriptionItem> items;
  final Widget? title;
  final int column;
  final AnimalDescriptionsLayout layout;
  final bool responsive;
  final double minColumnWidth;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final baseColumn = column < 1 ? 1 : column;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.contentBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.lightBorderColor, width: 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final effectiveColumn = _effectiveColumn(
            constraints.maxWidth,
            baseColumn,
          );
          final effectiveLayout = responsive && effectiveColumn == 1
              ? AnimalDescriptionsLayout.vertical
              : layout;
          final rows = _rows(effectiveColumn);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                DefaultTextStyle.merge(
                  style: theme.textStyle(
                    size: 16,
                    weight: FontWeight.w900,
                    color: theme.textColor,
                  ),
                  child: title!,
                ),
                const SizedBox(height: 12),
              ],
              for (final indexed in rows.indexed)
                _DescriptionRow(
                  items: indexed.$2,
                  last: indexed.$1 == rows.length - 1,
                  column: effectiveColumn,
                  layout: effectiveLayout,
                ),
            ],
          );
        },
      ),
    );
  }

  int _effectiveColumn(double maxWidth, int baseColumn) {
    if (!responsive || maxWidth.isInfinite || minColumnWidth <= 0) {
      return baseColumn;
    }
    final count = (maxWidth / minColumnWidth).floor();
    return count.clamp(1, baseColumn);
  }

  List<List<AnimalDescriptionItem>> _rows(int effectiveColumn) {
    final rows = <List<AnimalDescriptionItem>>[];
    var current = <AnimalDescriptionItem>[];
    var used = 0;
    for (final item in items) {
      final span = item.span.clamp(1, effectiveColumn);
      if (used + span > effectiveColumn && current.isNotEmpty) {
        rows.add(current);
        current = <AnimalDescriptionItem>[];
        used = 0;
      }
      current.add(item);
      used += span;
      if (used >= effectiveColumn) {
        rows.add(current);
        current = <AnimalDescriptionItem>[];
        used = 0;
      }
    }
    if (current.isNotEmpty) {
      rows.add(current);
    }
    return rows;
  }
}

class AnimalStatistic extends StatelessWidget {
  const AnimalStatistic({
    super.key,
    required this.value,
    this.title,
    this.prefix,
    this.suffix,
    this.description,
    this.color,
  });

  final num value;
  final Widget? title;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? description;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final valueColor = color ?? theme.primaryActiveColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: theme.elevatedBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.warmBorderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: theme.tactileShadowColor,
            offset: const Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            DefaultTextStyle.merge(
              style: theme.textStyle(
                size: 13,
                weight: FontWeight.w800,
                color: theme.secondaryTextColor,
              ),
              child: title!,
            ),
            const SizedBox(height: 8),
          ],
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (prefix != null) ...[
                IconTheme.merge(
                  data: IconThemeData(color: valueColor, size: 20),
                  child: prefix!,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                _formatValue(value),
                style: theme.textStyle(
                  size: 28,
                  weight: FontWeight.w900,
                  color: valueColor,
                  height: 1,
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: 5),
                DefaultTextStyle.merge(
                  style: theme.textStyle(
                    size: 13,
                    weight: FontWeight.w800,
                    color: theme.bodyTextColor,
                    height: 1.1,
                  ),
                  child: suffix!,
                ),
              ],
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            DefaultTextStyle.merge(
              style: theme.textStyle(
                size: 12,
                weight: FontWeight.w600,
                color: theme.secondaryTextColor,
              ),
              child: description!,
            ),
          ],
        ],
      ),
    );
  }

  String _formatValue(num value) {
    if (value is double && value == value.roundToDouble()) {
      return '${value.round()}';
    }
    return '$value';
  }
}

class AnimalTimeline extends StatelessWidget {
  const AnimalTimeline({
    super.key,
    required this.items,
  });

  final List<AnimalTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final indexed in items.indexed)
          _TimelineRow(
            item: indexed.$2,
            last: indexed.$1 == items.length - 1,
          ),
      ],
    );
  }
}

class _DescriptionRow extends StatelessWidget {
  const _DescriptionRow({
    required this.items,
    required this.last,
    required this.column,
    required this.layout,
  });

  final List<AnimalDescriptionItem> items;
  final bool last;
  final int column;
  final AnimalDescriptionsLayout layout;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Expanded(
            flex: item.span.clamp(1, column),
            child: _DescriptionCell(
              item: item,
              layout: layout,
              last: last,
            ),
          ),
      ],
    );
  }
}

class _DescriptionCell extends StatelessWidget {
  const _DescriptionCell({
    required this.item,
    required this.layout,
    required this.last,
  });

  final AnimalDescriptionItem item;
  final AnimalDescriptionsLayout layout;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final labelStyle = theme.textStyle(
      size: 12,
      weight: FontWeight.w900,
      color: theme.secondaryTextColor,
    );
    final valueStyle = theme.textStyle(
      size: 13,
      weight: FontWeight.w700,
      color: theme.bodyTextColor,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: last
              ? BorderSide.none
              : BorderSide(color: theme.lightBorderColor),
        ),
      ),
      child: layout == AnimalDescriptionsLayout.vertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle.merge(style: labelStyle, child: item.label),
                const SizedBox(height: 5),
                DefaultTextStyle.merge(style: valueStyle, child: item.child),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(minWidth: 72, maxWidth: 120),
                  child: DefaultTextStyle.merge(
                      style: labelStyle, child: item.label),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DefaultTextStyle.merge(
                      style: valueStyle, child: item.child),
                ),
              ],
            ),
    );
  }
}

class _TimelineRow extends StatefulWidget {
  const _TimelineRow({
    required this.item,
    required this.last,
  });

  final AnimalTimelineItem item;
  final bool last;

  @override
  State<_TimelineRow> createState() => _TimelineRowState();
}

class _TimelineRowState extends State<_TimelineRow> {
  final _focusNode = FocusNode();
  var _hovered = false;
  var _focused = false;
  var _pressed = false;

  bool get _interactive => widget.item.onTap != null && !widget.item.disabled;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final color = _timelineColor(theme, widget.item.status);
    final highlighted = _interactive && (_hovered || _focused);
    final textOpacity = widget.item.disabled ? 0.48 : 1.0;

    return Semantics(
      button: _interactive,
      enabled: _interactive,
      child: FocusableActionDetector(
        focusNode: _focusNode,
        enabled: _interactive,
        mouseCursor:
            _interactive ? SystemMouseCursors.click : SystemMouseCursors.basic,
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
          cursor: _interactive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: _interactive ? (_) => _setHovered(true) : null,
          onExit: _interactive
              ? (_) {
                  _setHovered(false);
                  _setPressed(false);
                }
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: _interactive ? (_) => _setPressed(true) : null,
            onTapUp: _interactive ? (_) => _setPressed(false) : null,
            onTapCancel: _interactive ? () => _setPressed(false) : null,
            onTap: _interactive
                ? () {
                    _focusNode.requestFocus();
                    _activate();
                  }
                : null,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 28,
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          curve: Curves.easeOut,
                          transform: Matrix4.translationValues(
                            0,
                            _pressed ? 1 : 0,
                            0,
                          ),
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: widget.item.disabled
                                ? theme.controlBorderColor
                                : color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: highlighted
                                  ? theme.elevatedBackgroundColor
                                  : Colors.white,
                              width: highlighted ? 4 : 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(
                                  alpha: highlighted ? 0.38 : 0.28,
                                ),
                                blurRadius: 0,
                                offset: Offset(0, _pressed ? 1 : 3),
                              ),
                            ],
                          ),
                          child: widget.item.icon == null
                              ? null
                              : IconTheme.merge(
                                  data: const IconThemeData(
                                    size: 11,
                                    color: Colors.white,
                                  ),
                                  child: widget.item.icon!,
                                ),
                        ),
                        if (!widget.last)
                          Expanded(
                            child: Container(
                              width: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              color: theme.lightBorderColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOut,
                      transform: Matrix4.translationValues(
                        0,
                        _pressed ? 1 : 0,
                        0,
                      ),
                      margin: EdgeInsets.only(bottom: widget.last ? 0 : 18),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: highlighted
                            ? theme.subtleBackgroundColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: highlighted
                              ? theme.controlBorderColor
                              : Colors.transparent,
                        ),
                      ),
                      child: Opacity(
                        opacity: textOpacity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultTextStyle.merge(
                              style: theme.textStyle(
                                size: 14,
                                weight: FontWeight.w900,
                                color: theme.textColor,
                              ),
                              child: widget.item.title,
                            ),
                            if (widget.item.description != null) ...[
                              const SizedBox(height: 4),
                              DefaultTextStyle.merge(
                                style: theme.textStyle(
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: theme.bodyTextColor,
                                ),
                                child: widget.item.description!,
                              ),
                            ],
                            if (widget.item.time != null) ...[
                              const SizedBox(height: 4),
                              DefaultTextStyle.merge(
                                style: theme.textStyle(
                                  size: 11,
                                  weight: FontWeight.w700,
                                  color: theme.secondaryTextColor,
                                ),
                                child: widget.item.time!,
                              ),
                            ],
                          ],
                        ),
                      ),
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

  void _activate() {
    if (_interactive) {
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

Color _timelineColor(AnimalThemeData theme, AnimalTimelineItemStatus status) {
  return switch (status) {
    AnimalTimelineItemStatus.defaultStatus => theme.controlBorderColor,
    AnimalTimelineItemStatus.success => theme.successColor,
    AnimalTimelineItemStatus.warning => theme.warningColor,
    AnimalTimelineItemStatus.danger => theme.errorColor,
    AnimalTimelineItemStatus.primary => theme.primaryColor,
  };
}
