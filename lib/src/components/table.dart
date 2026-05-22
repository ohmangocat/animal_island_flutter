import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../animal_theme.dart';

@immutable
class AnimalTableColumn<T> {
  const AnimalTableColumn({
    required this.title,
    required this.cellBuilder,
    this.width,
    this.alignment = Alignment.centerLeft,
  });

  final Widget title;
  final Widget Function(BuildContext context, T row, int index) cellBuilder;
  final double? width;
  final AlignmentGeometry alignment;
}

class AnimalTable<T> extends StatefulWidget {
  const AnimalTable({
    super.key,
    required this.columns,
    required this.rows,
    this.loading = false,
    this.empty,
    this.emptyText,
    this.striped = true,
    this.showHeader = true,
    this.maxHeight,
    this.onRowTap,
  });

  final List<AnimalTableColumn<T>> columns;
  final List<T> rows;
  final bool loading;
  final Widget? empty;
  final String? emptyText;
  final bool striped;
  final bool showHeader;
  final double? maxHeight;
  final void Function(T row, int index)? onRowTap;

  @override
  State<AnimalTable<T>> createState() => _AnimalTableState<T>();
}

class _AnimalTableState<T> extends State<AnimalTable<T>> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final tableWidth = _tableWidth;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: theme.contentBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
                PointerDeviceKind.stylus,
              },
            ),
            child: Scrollbar(
              controller: _horizontalController,
              thumbVisibility: true,
              trackVisibility: true,
              interactive: true,
              radius: const Radius.circular(999),
              thickness: 8,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              child: SingleChildScrollView(
                controller: _horizontalController,
                primary: false,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: tableWidth,
                    maxHeight: widget.maxHeight ?? double.infinity,
                  ),
                  child: _TableContent<T>(
                    columns: widget.columns,
                    rows: widget.rows,
                    tableWidth: tableWidth,
                    empty: widget.empty,
                    emptyText: widget.emptyText,
                    striped: widget.striped,
                    showHeader: widget.showHeader,
                    maxHeight: widget.maxHeight,
                    onRowTap: widget.onRowTap,
                    theme: theme,
                  ),
                ),
              ),
            ),
          ),
          if (widget.loading)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ColoredBox(
                  color: theme.contentBackgroundColor.withValues(alpha: 0.82),
                  child: Center(
                    child: SizedBox.square(
                      dimension: 40,
                      child: _TableLoadingSpinner(theme: theme),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double get _tableWidth {
    var total = 0.0;
    for (final column in widget.columns) {
      total += column.width ?? 160;
    }
    return total;
  }
}

class _TableContent<T> extends StatelessWidget {
  const _TableContent({
    required this.columns,
    required this.rows,
    required this.tableWidth,
    required this.empty,
    required this.emptyText,
    required this.striped,
    required this.showHeader,
    required this.maxHeight,
    required this.onRowTap,
    required this.theme,
  });

  final List<AnimalTableColumn<T>> columns;
  final List<T> rows;
  final double tableWidth;
  final Widget? empty;
  final String? emptyText;
  final bool striped;
  final bool showHeader;
  final double? maxHeight;
  final void Function(T row, int index)? onRowTap;
  final AnimalThemeData theme;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return SizedBox(
        width: tableWidth,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showHeader) _Header<T>(columns: columns),
              _EmptyTableBody(
                tableWidth: tableWidth,
                empty: empty,
                emptyText: emptyText,
                theme: theme,
              ),
            ],
          ),
        ),
      );
    }

    if (maxHeight != null) {
      return SizedBox(
        width: tableWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) _Header<T>(columns: columns),
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  return _tableRow(index);
                },
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: tableWidth,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) _Header<T>(columns: columns),
            for (final indexed in rows.indexed) _tableRow(indexed.$1),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(int index) {
    final row = rows[index];
    return _Row<T>(
      row: row,
      rowIndex: index,
      columns: columns,
      striped: striped && index.isOdd,
      onTap: onRowTap == null ? null : () => onRowTap!(row, index),
    );
  }
}

class _EmptyTableBody extends StatelessWidget {
  const _EmptyTableBody({
    required this.tableWidth,
    required this.empty,
    required this.emptyText,
    required this.theme,
  });

  final double tableWidth;
  final Widget? empty;
  final String? emptyText;
  final AnimalThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tableWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 20),
        child: Center(
          child: empty ??
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomPaint(
                    size: const Size.square(48),
                    painter: _TableEmptyIconPainter(
                      theme.secondaryTextColor.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    emptyText ?? '暂无数据',
                    style: theme.textStyle(
                      color: theme.secondaryTextColor,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

class _TableLoadingSpinner extends StatefulWidget {
  const _TableLoadingSpinner({required this.theme});

  final AnimalThemeData theme;

  @override
  State<_TableLoadingSpinner> createState() => _TableLoadingSpinnerState();
}

class _TableLoadingSpinnerState extends State<_TableLoadingSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CircularProgressIndicator(
        strokeWidth: 4,
        strokeCap: StrokeCap.round,
        valueColor: AlwaysStoppedAnimation<Color>(widget.theme.primaryColor),
        backgroundColor: widget.theme.primaryColor.withValues(alpha: 0.18),
      ),
    );
  }
}

class _TableEmptyIconPainter extends CustomPainter {
  const _TableEmptyIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final sx = size.width / 24;
    final sy = size.height / 24;

    final path = Path()
      ..moveTo(19 * sx, 3 * sy)
      ..lineTo(5 * sx, 3 * sy)
      ..cubicTo(3.9 * sx, 3 * sy, 3 * sx, 3.9 * sy, 3 * sx, 5 * sy)
      ..lineTo(3 * sx, 19 * sy)
      ..cubicTo(3 * sx, 20.1 * sy, 3.9 * sx, 21 * sy, 5 * sx, 21 * sy)
      ..lineTo(19 * sx, 21 * sy)
      ..cubicTo(20.1 * sx, 21 * sy, 21 * sx, 20.1 * sy, 21 * sx, 19 * sy)
      ..lineTo(21 * sx, 5 * sy)
      ..cubicTo(21 * sx, 3.9 * sy, 20.1 * sx, 3 * sy, 19 * sx, 3 * sy)
      ..close()
      ..moveTo(19 * sx, 19 * sy)
      ..lineTo(5 * sx, 19 * sy)
      ..lineTo(5 * sx, 5 * sy)
      ..lineTo(19 * sx, 5 * sy)
      ..close()
      ..moveTo(7 * sx, 10 * sy)
      ..lineTo(9 * sx, 10 * sy)
      ..lineTo(9 * sx, 17 * sy)
      ..lineTo(7 * sx, 17 * sy)
      ..close()
      ..moveTo(11 * sx, 7 * sy)
      ..lineTo(13 * sx, 7 * sy)
      ..lineTo(13 * sx, 17 * sy)
      ..lineTo(11 * sx, 17 * sy)
      ..close()
      ..moveTo(15 * sx, 13 * sy)
      ..lineTo(17 * sx, 13 * sy)
      ..lineTo(17 * sx, 17 * sy)
      ..lineTo(15 * sx, 17 * sy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TableEmptyIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _Header<T> extends StatelessWidget {
  const _Header({required this.columns});

  final List<AnimalTableColumn<T>> columns;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return Stack(
      children: [
        Row(
          children: [
            for (final column in columns)
              SizedBox(
                width: column.width ?? 160,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Align(
                    alignment: column.alignment,
                    child: DefaultTextStyle.merge(
                      style: theme.textStyle(
                        size: 14,
                        weight: FontWeight.w700,
                        color: theme.bodyTextColor,
                      ),
                      child: column.title,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 0,
          height: 1,
          child: CustomPaint(
            painter: _DashedLinePainter(theme.secondaryBackgroundColor),
          ),
        ),
      ],
    );
  }
}

class _Row<T> extends StatefulWidget {
  const _Row({
    required this.row,
    required this.rowIndex,
    required this.columns,
    required this.striped,
    this.onTap,
  });

  final T row;
  final int rowIndex;
  final List<AnimalTableColumn<T>> columns;
  final bool striped;
  final VoidCallback? onTap;

  @override
  State<_Row<T>> createState() => _RowState<T>();
}

class _RowState<T> extends State<_Row<T>> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final highlighted = _hovered || _focused;

    return MouseRegion(
      cursor: widget.onTap == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: FocusableActionDetector(
        enabled: widget.onTap != null,
        mouseCursor: widget.onTap == null
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
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              widget.onTap?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 180),
            scale: highlighted ? 1.01 : 1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(highlighted ? 30 : 0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _RowBackgroundPainter(
                        hovered: highlighted,
                        striped: widget.striped,
                        theme: theme,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (final column in widget.columns)
                        SizedBox(
                          width: column.width ?? 160,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            child: Align(
                              alignment: column.alignment,
                              child: DefaultTextStyle.merge(
                                style: theme.textStyle(
                                  size: 14,
                                  weight: FontWeight.w500,
                                  color: highlighted
                                      ? const Color(0xFF3D2E1E)
                                      : theme.bodyTextColor,
                                ),
                                child: column.cellBuilder(
                                  context,
                                  widget.row,
                                  widget.rowIndex,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (!highlighted)
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 0,
                      height: 1,
                      child: CustomPaint(
                        painter: _DashedLinePainter(
                          theme.secondaryBackgroundColor,
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
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
          Offset(x, 0), Offset((x + 6).clamp(0, size.width), 0), paint);
      x += 12;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _RowBackgroundPainter extends CustomPainter {
  const _RowBackgroundPainter({
    required this.hovered,
    required this.striped,
    required this.theme,
  });

  final bool hovered;
  final bool striped;
  final AnimalThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    if (!hovered) {
      canvas.drawRect(
        rect,
        Paint()
          ..color = striped
              ? theme.backgroundColor.withValues(alpha: 0.6)
              : theme.contentBackgroundColor,
      );
      return;
    }

    canvas.drawRect(
      rect,
      Paint()..color = theme.primarySolidColor.withValues(alpha: 0.60),
    );
    final stripePaint = Paint()
      ..color = theme.primaryStripeBackgroundColor.withValues(alpha: 0.60);
    const stripe = 10.0;
    for (var x = -size.height; x < size.width + size.height; x += stripe * 2) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + stripe, size.height)
        ..lineTo(x + stripe + size.height, 0)
        ..lineTo(x + size.height, 0)
        ..close();
      canvas.drawPath(path, stripePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RowBackgroundPainter oldDelegate) {
    return oldDelegate.hovered != hovered ||
        oldDelegate.striped != striped ||
        oldDelegate.theme != theme;
  }
}
