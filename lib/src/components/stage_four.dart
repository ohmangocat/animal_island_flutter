import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animal_theme.dart';
import 'empty.dart';

enum AnimalResultStatus { success, warning, error, info }

enum AnimalUploadStatus { ready, uploading, done, error }

@immutable
class AnimalUploadFile {
  const AnimalUploadFile({
    required this.name,
    this.status = AnimalUploadStatus.ready,
    this.progress = 0,
    this.size,
    this.message,
  });

  final String name;
  final AnimalUploadStatus status;
  final double progress;
  final String? size;
  final String? message;

  AnimalUploadFile copyWith({
    String? name,
    AnimalUploadStatus? status,
    double? progress,
    String? size,
    String? message,
  }) {
    return AnimalUploadFile(
      name: name ?? this.name,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      size: size ?? this.size,
      message: message ?? this.message,
    );
  }
}

@immutable
class AnimalTreeNode<T> {
  const AnimalTreeNode({
    required this.value,
    required this.label,
    this.children = const [],
    this.disabled = false,
    this.icon,
  });

  final T value;
  final Widget label;
  final List<AnimalTreeNode<T>> children;
  final bool disabled;
  final Widget? icon;
}

class AnimalCalendar extends StatefulWidget {
  const AnimalCalendar({
    super.key,
    this.value,
    this.defaultValue,
    this.month,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.onMonthChanged,
  });

  final DateTime? value;
  final DateTime? defaultValue;
  final DateTime? month;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onChanged;
  final ValueChanged<DateTime>? onMonthChanged;

  @override
  State<AnimalCalendar> createState() => _AnimalCalendarState();
}

class AnimalCalendarFormField extends FormField<DateTime> {
  AnimalCalendarFormField({
    super.key,
    this.value,
    this.defaultValue,
    this.month,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.onMonthChanged,
    this.disabled = false,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onSaved,
    super.validator,
    super.restorationId,
  }) : super(
          initialValue: _dateOnly(value ?? defaultValue ?? DateTime.now()),
          enabled: !disabled,
          builder: (field) {
            final widget = field.widget as AnimalCalendarFormField;
            final current = field.value ??
                _dateOnly(
                    widget.value ?? widget.defaultValue ?? DateTime.now());
            return _StageFourFormFieldShell(
              errorText: field.errorText,
              child: Opacity(
                opacity: widget.disabled ? 0.58 : 1,
                child: IgnorePointer(
                  ignoring: widget.disabled,
                  child: AnimalCalendar(
                    value: current,
                    month: widget.month,
                    firstDate: widget.firstDate,
                    lastDate: widget.lastDate,
                    onChanged: (next) {
                      field.didChange(next);
                      widget.onChanged?.call(next);
                    },
                    onMonthChanged: widget.onMonthChanged,
                  ),
                ),
              ),
            );
          },
        );

  final DateTime? value;
  final DateTime? defaultValue;
  final DateTime? month;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onChanged;
  final ValueChanged<DateTime>? onMonthChanged;
  final bool disabled;

  @override
  FormFieldState<DateTime> createState() => _AnimalCalendarFormFieldState();
}

class _AnimalCalendarFormFieldState extends FormFieldState<DateTime> {
  @override
  AnimalCalendarFormField get widget => super.widget as AnimalCalendarFormField;

  @override
  void didUpdateWidget(covariant AnimalCalendarFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.value ?? widget.defaultValue;
    final previous = oldWidget.value ?? oldWidget.defaultValue;
    if (next != null &&
        (previous == null || !_isSameDay(next, previous)) &&
        (value == null || !_isSameDay(value!, next))) {
      setValue(_dateOnly(next));
    }
  }
}

class _AnimalCalendarState extends State<AnimalCalendar> {
  late DateTime _selected;
  late DateTime _visibleMonth;

  DateTime get _value => _dateOnly(widget.value ?? _selected);

  @override
  void initState() {
    super.initState();
    _selected =
        _dateOnly(widget.defaultValue ?? widget.value ?? DateTime.now());
    _visibleMonth = _monthOnly(widget.month ?? _selected);
  }

  @override
  void didUpdateWidget(covariant AnimalCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && !_isSameDay(widget.value!, _selected)) {
      _selected = _dateOnly(widget.value!);
    }
    if (widget.month != null && !_isSameMonth(widget.month!, _visibleMonth)) {
      _visibleMonth = _monthOnly(widget.month!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final days = _calendarDays(_visibleMonth);

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowLeft): _CalendarMoveIntent(-1),
        SingleActivator(LogicalKeyboardKey.arrowRight): _CalendarMoveIntent(1),
        SingleActivator(LogicalKeyboardKey.arrowUp): _CalendarMoveIntent(-7),
        SingleActivator(LogicalKeyboardKey.arrowDown): _CalendarMoveIntent(7),
        SingleActivator(LogicalKeyboardKey.pageUp): _CalendarMonthIntent(-1),
        SingleActivator(LogicalKeyboardKey.pageDown): _CalendarMonthIntent(1),
      },
      child: Actions(
        actions: {
          _CalendarMoveIntent: CallbackAction<_CalendarMoveIntent>(
            onInvoke: (intent) {
              _moveSelectionBy(intent.days);
              return null;
            },
          ),
          _CalendarMonthIntent: CallbackAction<_CalendarMonthIntent>(
            onInvoke: (intent) {
              _moveSelectionByMonths(intent.months);
              return null;
            },
          ),
        },
        child: Container(
          width: 336,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.elevatedBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: theme.warmBorderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: theme.tactileShadowColor,
                offset: const Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CalendarHeader(
                month: _visibleMonth,
                onPrevious: () => _changeMonth(-1),
                onNext: () => _changeMonth(1),
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 7,
                childAspectRatio: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final label in const ['日', '一', '二', '三', '四', '五', '六'])
                    Center(
                      child: Text(
                        label,
                        style: theme.textStyle(
                          size: 12,
                          weight: FontWeight.w900,
                          color: theme.secondaryTextColor,
                        ),
                      ),
                    ),
                  for (final day in days)
                    _CalendarDayCell(
                      day: day,
                      currentMonth: _isSameMonth(day, _visibleMonth),
                      selected: _isSameDay(day, _value),
                      today: _isSameDay(day, DateTime.now()),
                      disabled: !_canSelect(day),
                      onTap: () => _select(day),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeMonth(int offset) {
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + offset);
    setState(() => _visibleMonth = _monthOnly(next));
    widget.onMonthChanged?.call(_visibleMonth);
  }

  void _select(DateTime day) {
    if (!_canSelect(day)) {
      return;
    }
    final next = _dateOnly(day);
    final nextMonth = _monthOnly(next);
    final monthChanged = !_isSameMonth(nextMonth, _visibleMonth);
    if (widget.value == null || (widget.month == null && monthChanged)) {
      setState(() {
        if (widget.value == null) {
          _selected = next;
        }
        if (widget.month == null && monthChanged) {
          _visibleMonth = nextMonth;
        }
      });
    }
    if (monthChanged) {
      widget.onMonthChanged?.call(nextMonth);
    }
    widget.onChanged?.call(next);
  }

  void _moveSelectionBy(int days) {
    _select(_value.add(Duration(days: days)));
  }

  void _moveSelectionByMonths(int months) {
    final base = _value;
    final targetLastDay = DateTime(base.year, base.month + months + 1, 0).day;
    final targetDay = base.day > targetLastDay ? targetLastDay : base.day;
    _select(DateTime(base.year, base.month + months, targetDay));
  }

  bool _canSelect(DateTime day) {
    final date = _dateOnly(day);
    final first =
        widget.firstDate == null ? null : _dateOnly(widget.firstDate!);
    final last = widget.lastDate == null ? null : _dateOnly(widget.lastDate!);
    if (first != null && date.isBefore(first)) {
      return false;
    }
    if (last != null && date.isAfter(last)) {
      return false;
    }
    return true;
  }
}

class AnimalUpload extends StatelessWidget {
  const AnimalUpload({
    super.key,
    this.files = const [],
    this.onTap,
    this.onRemove,
    this.disabled = false,
    this.title = '上传文件',
    this.hint = '点击选择文件，或将文件拖到这里',
  });

  final List<AnimalUploadFile> files;
  final VoidCallback? onTap;
  final ValueChanged<AnimalUploadFile>? onRemove;
  final bool disabled;
  final String title;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final enabled = !disabled && onTap != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _UploadDropArea(
          enabled: enabled,
          disabled: disabled,
          title: title,
          hint: hint,
          onTap: onTap,
        ),
        if (files.isNotEmpty) ...[
          const SizedBox(height: 12),
          for (final file in files)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _UploadFileRow(
                file: file,
                onRemove: onRemove == null ? null : () => onRemove!(file),
              ),
            ),
        ],
      ],
    );
  }
}

class _UploadDropArea extends StatefulWidget {
  const _UploadDropArea({
    required this.enabled,
    required this.disabled,
    required this.title,
    required this.hint,
    this.onTap,
  });

  final bool enabled;
  final bool disabled;
  final String title;
  final String hint;
  final VoidCallback? onTap;

  @override
  State<_UploadDropArea> createState() => _UploadDropAreaState();
}

class _UploadDropAreaState extends State<_UploadDropArea> {
  var _hovered = false;
  var _focused = false;
  var _pressed = false;

  bool get _interactive => widget.enabled;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final emphasized = _interactive && (_hovered || _focused);
    final borderColor = widget.disabled
        ? theme.lightBorderColor
        : _pressed
            ? theme.primaryActiveColor
            : emphasized
                ? theme.primaryColor
                : theme.controlBorderColor;
    final background = emphasized
        ? theme.primaryBackgroundColor.withValues(alpha: 0.72)
        : theme.contentBackgroundColor;
    final iconBackground = emphasized || _pressed
        ? theme.elevatedBackgroundColor
        : theme.primaryBackgroundColor;

    return Semantics(
      button: _interactive,
      enabled: _interactive,
      label: widget.title,
      hint: widget.hint,
      child: FocusableActionDetector(
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
              if (_interactive) {
                widget.onTap?.call();
              }
              return null;
            },
          ),
        },
        child: Builder(
          builder: (context) {
            return MouseRegion(
              cursor: _interactive
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              onEnter: (_) => _setHovered(true),
              onExit: (_) {
                _setHovered(false);
                _setPressed(false);
              },
              child: GestureDetector(
                onTapDown: _interactive ? (_) => _setPressed(true) : null,
                onTapUp: _interactive ? (_) => _setPressed(false) : null,
                onTapCancel: _interactive ? () => _setPressed(false) : null,
                onTap: _interactive
                    ? () {
                        Focus.of(context).requestFocus();
                        widget.onTap?.call();
                      }
                    : null,
                child: Opacity(
                  opacity: widget.disabled ? 0.58 : 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOut,
                    transform: Matrix4.translationValues(
                      0,
                      _pressed ? 2 : 0,
                      0,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 22),
                    decoration: BoxDecoration(
                      color: background,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: theme.tactileShadowColor,
                          offset: Offset(0, _pressed ? 1 : 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: iconBackground,
                            shape: BoxShape.circle,
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Icon(
                            Icons.cloud_upload_rounded,
                            color: _pressed
                                ? theme.primaryActiveColor
                                : theme.primaryColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.title,
                          style: theme.textStyle(
                            size: 16,
                            weight: FontWeight.w900,
                            color: theme.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.hint,
                          textAlign: TextAlign.center,
                          style: theme.textStyle(
                            size: 12,
                            weight: FontWeight.w600,
                            color: theme.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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

class AnimalUploadFormField extends FormField<List<AnimalUploadFile>> {
  AnimalUploadFormField({
    super.key,
    this.files = const [],
    this.onTap,
    this.onRemove,
    this.onChanged,
    this.disabled = false,
    this.removable = true,
    this.title = '上传文件',
    this.hint = '点击选择文件，或将文件拖到这里',
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onSaved,
    super.validator,
    super.restorationId,
  }) : super(
          initialValue: List.unmodifiable(files),
          enabled: !disabled,
          builder: (field) {
            final widget = field.widget as AnimalUploadFormField;
            final current = field.value ?? const <AnimalUploadFile>[];
            return _StageFourFormFieldShell(
              errorText: field.errorText,
              child: AnimalUpload(
                files: current,
                disabled: widget.disabled,
                title: widget.title,
                hint: widget.hint,
                onTap: widget.onTap,
                onRemove: widget.disabled || !widget.removable
                    ? null
                    : (file) {
                        final next = current
                            .where((item) => !identical(item, file))
                            .toList(growable: false);
                        field.didChange(next);
                        widget.onRemove?.call(file);
                        widget.onChanged?.call(next);
                      },
              ),
            );
          },
        );

  final List<AnimalUploadFile> files;
  final VoidCallback? onTap;
  final ValueChanged<AnimalUploadFile>? onRemove;
  final ValueChanged<List<AnimalUploadFile>>? onChanged;
  final bool disabled;
  final bool removable;
  final String title;
  final String hint;

  @override
  FormFieldState<List<AnimalUploadFile>> createState() =>
      _AnimalUploadFormFieldState();
}

class _AnimalUploadFormFieldState
    extends FormFieldState<List<AnimalUploadFile>> {
  @override
  AnimalUploadFormField get widget => super.widget as AnimalUploadFormField;

  @override
  void didUpdateWidget(covariant AnimalUploadFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.files, oldWidget.files)) {
      setValue(List.unmodifiable(widget.files));
    }
  }
}

class AnimalTree<T> extends StatefulWidget {
  const AnimalTree({
    super.key,
    required this.nodes,
    this.selectedValue,
    this.defaultExpandedValues = const [],
    this.onChanged,
    this.onExpandedChanged,
  });

  final List<AnimalTreeNode<T>> nodes;
  final T? selectedValue;
  final List<T> defaultExpandedValues;
  final ValueChanged<T>? onChanged;
  final ValueChanged<List<T>>? onExpandedChanged;

  @override
  State<AnimalTree<T>> createState() => _AnimalTreeState<T>();
}

class _AnimalTreeState<T> extends State<AnimalTree<T>> {
  late Set<T> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = Set<T>.of(widget.defaultExpandedValues);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    if (widget.nodes.isEmpty) {
      return const AnimalEmpty(description: '暂无节点');
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: theme.contentBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.lightBorderColor, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final node in widget.nodes)
            _TreeNodeRow<T>(tree: this, node: node),
        ],
      ),
    );
  }

  bool _isExpanded(T value) => _expanded.contains(value);

  void _toggle(T value) {
    setState(() {
      if (_expanded.contains(value)) {
        _expanded.remove(value);
      } else {
        _expanded.add(value);
      }
    });
    widget.onExpandedChanged?.call(_expanded.toList(growable: false));
  }

  void _expand(T value) {
    if (_expanded.contains(value)) {
      return;
    }
    setState(() => _expanded.add(value));
    widget.onExpandedChanged?.call(_expanded.toList(growable: false));
  }

  void _collapse(T value) {
    if (!_expanded.contains(value)) {
      return;
    }
    setState(() => _expanded.remove(value));
    widget.onExpandedChanged?.call(_expanded.toList(growable: false));
  }
}

class AnimalTreeFormField<T> extends FormField<T> {
  AnimalTreeFormField({
    super.key,
    required this.nodes,
    this.selectedValue,
    this.defaultValue,
    this.defaultExpandedValues = const [],
    this.onChanged,
    this.onExpandedChanged,
    this.disabled = false,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onSaved,
    super.validator,
    super.restorationId,
  }) : super(
          initialValue: selectedValue ?? defaultValue,
          enabled: !disabled,
          builder: (field) {
            final widget = field.widget as AnimalTreeFormField<T>;
            return _StageFourFormFieldShell(
              errorText: field.errorText,
              child: Opacity(
                opacity: widget.disabled ? 0.58 : 1,
                child: IgnorePointer(
                  ignoring: widget.disabled,
                  child: AnimalTree<T>(
                    nodes: widget.nodes,
                    selectedValue: field.value,
                    defaultExpandedValues: widget.defaultExpandedValues,
                    onChanged: (next) {
                      field.didChange(next);
                      widget.onChanged?.call(next);
                    },
                    onExpandedChanged: widget.onExpandedChanged,
                  ),
                ),
              ),
            );
          },
        );

  final List<AnimalTreeNode<T>> nodes;
  final T? selectedValue;
  final T? defaultValue;
  final List<T> defaultExpandedValues;
  final ValueChanged<T>? onChanged;
  final ValueChanged<List<T>>? onExpandedChanged;
  final bool disabled;

  @override
  FormFieldState<T> createState() => _AnimalTreeFormFieldState<T>();
}

class _AnimalTreeFormFieldState<T> extends FormFieldState<T> {
  @override
  AnimalTreeFormField<T> get widget => super.widget as AnimalTreeFormField<T>;

  @override
  void didUpdateWidget(covariant AnimalTreeFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue &&
        widget.selectedValue != value) {
      setValue(widget.selectedValue);
    }
  }
}

class AnimalResult extends StatelessWidget {
  const AnimalResult({
    super.key,
    required this.title,
    this.description,
    this.status = AnimalResultStatus.info,
    this.extra,
    this.action,
  });

  final Widget title;
  final Widget? description;
  final AnimalResultStatus status;
  final Widget? extra;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final color = _resultColor(theme, status);
    final icon = _resultIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
      decoration: BoxDecoration(
        color: theme.elevatedBackgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.warmBorderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: theme.tactileShadowColor,
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
            ),
            child: Icon(icon, color: color, size: 38),
          ),
          const SizedBox(height: 16),
          DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            style: theme.textStyle(
              size: 20,
              weight: FontWeight.w900,
              color: theme.textColor,
            ),
            child: title,
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            DefaultTextStyle.merge(
              textAlign: TextAlign.center,
              style: theme.textStyle(
                size: 13,
                weight: FontWeight.w600,
                color: theme.secondaryTextColor,
              ),
              child: description!,
            ),
          ],
          if (extra != null) ...[
            const SizedBox(height: 18),
            extra!,
          ],
          if (action != null) ...[
            const SizedBox(height: 20),
            action!,
          ],
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Row(
      children: [
        _CalendarNavButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
        Expanded(
          child: Text(
            '${month.year} 年 ${month.month} 月',
            textAlign: TextAlign.center,
            style: theme.textStyle(
              size: 17,
              weight: FontWeight.w900,
              color: theme.textColor,
            ),
          ),
        ),
        _CalendarNavButton(icon: Icons.chevron_right_rounded, onTap: onNext),
      ],
    );
  }
}

class _CalendarNavButton extends StatefulWidget {
  const _CalendarNavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_CalendarNavButton> createState() => _CalendarNavButtonState();
}

class _CalendarNavButtonState extends State<_CalendarNavButton> {
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

    return FocusableActionDetector(
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
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: () {
            _focusNode.requestFocus();
            widget.onTap();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: active
                  ? theme.primaryBackgroundColor
                  : theme.contentBackgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: active ? theme.primaryColor : theme.controlBorderColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.tactileShadowColor.withValues(alpha: 0.45),
                  offset: Offset(0, _pressed ? 0 : 1),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Icon(widget.icon, color: color, size: 22),
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

class _CalendarDayCell extends StatefulWidget {
  const _CalendarDayCell({
    required this.day,
    required this.currentMonth,
    required this.selected,
    required this.today,
    required this.disabled,
    required this.onTap,
  });

  final DateTime day;
  final bool currentMonth;
  final bool selected;
  final bool today;
  final bool disabled;
  final VoidCallback onTap;

  @override
  State<_CalendarDayCell> createState() => _CalendarDayCellState();
}

class _CalendarDayCellState extends State<_CalendarDayCell> {
  final _focusNode = FocusNode();
  var _hovered = false;
  var _focused = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final enabled = !widget.disabled;
    final selected = widget.selected;
    final highlighted = enabled && (_hovered || _focused || widget.today);
    final color = selected
        ? Colors.white
        : widget.currentMonth
            ? theme.bodyTextColor
            : theme.disabledTextColor;

    return Semantics(
      button: enabled,
      selected: selected,
      enabled: enabled,
      label:
          '${widget.day.year}年${widget.day.month}月${widget.day.day}日${widget.today ? '，今天' : ''}',
      child: FocusableActionDetector(
        focusNode: _focusNode,
        enabled: enabled,
        mouseCursor:
            enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
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
              if (enabled) {
                widget.onTap();
              }
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: enabled
                ? () {
                    _focusNode.requestFocus();
                    widget.onTap();
                  }
                : null,
            child: Opacity(
              opacity: enabled ? 1 : 0.42,
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        selected ? theme.primarySolidColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: highlighted && !selected
                        ? Border.all(
                            color: widget.today
                                ? theme.primaryColor
                                : theme.controlBorderColor,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Text(
                    '${widget.day.day}',
                    style: theme.textStyle(
                      size: 13,
                      weight: selected ? FontWeight.w900 : FontWeight.w700,
                      color: color,
                      height: 1,
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
}

class _UploadFileRow extends StatelessWidget {
  const _UploadFileRow({required this.file, this.onRemove});

  final AnimalUploadFile file;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final color = _uploadStatusColor(theme, file.status);
    final progress = file.progress.clamp(0, 1).toDouble();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: theme.subtleBackgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.lightBorderColor),
      ),
      child: Row(
        children: [
          Icon(_uploadStatusIcon(file.status), color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        file.name,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyle(
                          size: 13,
                          weight: FontWeight.w800,
                          color: theme.bodyTextColor,
                        ),
                      ),
                    ),
                    if (file.size != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        file.size!,
                        style: theme.textStyle(
                          size: 11,
                          weight: FontWeight.w700,
                          color: theme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ],
                ),
                if (file.status == AnimalUploadStatus.uploading) ...[
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      backgroundColor: theme.controlBorderColor,
                      color: color,
                    ),
                  ),
                ],
                if (file.message != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    file.message!,
                    style: theme.textStyle(
                      size: 11,
                      weight: FontWeight.w700,
                      color: file.status == AnimalUploadStatus.error
                          ? theme.errorColor
                          : theme.secondaryTextColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            _UploadRemoveButton(onTap: onRemove!),
          ],
        ],
      ),
    );
  }
}

class _UploadRemoveButton extends StatefulWidget {
  const _UploadRemoveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_UploadRemoveButton> createState() => _UploadRemoveButtonState();
}

class _UploadRemoveButtonState extends State<_UploadRemoveButton> {
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
    final color = _pressed
        ? theme.errorColor
        : highlighted
            ? theme.primaryActiveColor
            : theme.disabledTextColor;

    return Semantics(
      button: true,
      enabled: true,
      label: '移除文件',
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
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            onTap: () {
              _focusNode.requestFocus();
              widget.onTap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: highlighted
                    ? theme.elevatedBackgroundColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: highlighted
                      ? theme.controlBorderColor
                      : Colors.transparent,
                ),
                boxShadow: highlighted
                    ? [
                        BoxShadow(
                          color: theme.tactileShadowColor.withValues(
                            alpha: 0.36,
                          ),
                          offset: Offset(0, _pressed ? 0 : 2),
                          blurRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Icon(Icons.close_rounded, color: color, size: 18),
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

class _TreeNodeRow<T> extends StatefulWidget {
  const _TreeNodeRow({
    required this.tree,
    required this.node,
    this.depth = 0,
  });

  final _AnimalTreeState<T> tree;
  final AnimalTreeNode<T> node;
  final int depth;

  @override
  State<_TreeNodeRow<T>> createState() => _TreeNodeRowState<T>();
}

class _TreeNodeRowState<T> extends State<_TreeNodeRow<T>> {
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
    final hasChildren = widget.node.children.isNotEmpty;
    final expanded = widget.tree._isExpanded(widget.node.value);
    final selected = widget.tree.widget.selectedValue == widget.node.value;
    final enabled = !widget.node.disabled;
    final highlighted = enabled && (_hovered || _focused);
    final emphasized = highlighted || selected || (enabled && _pressed);
    final rowBorderColor = selected
        ? theme.primaryColor
        : emphasized
            ? theme.controlBorderColor
            : Colors.transparent;
    final iconColor = selected
        ? theme.primaryActiveColor
        : highlighted
            ? theme.primaryColor
            : theme.mutedIconColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: enabled,
          selected: selected,
          enabled: enabled,
          expanded: hasChildren ? expanded : null,
          child: FocusableActionDetector(
            focusNode: _focusNode,
            enabled: enabled,
            mouseCursor:
                enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
            onShowFocusHighlight: (value) {
              if (mounted) {
                setState(() => _focused = value);
              }
            },
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.arrowRight):
                  _TreeExpandIntent(),
              SingleActivator(LogicalKeyboardKey.arrowLeft):
                  _TreeCollapseIntent(),
            },
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (intent) {
                  _activate(enabled, hasChildren);
                  return null;
                },
              ),
              _TreeExpandIntent: CallbackAction<_TreeExpandIntent>(
                onInvoke: (intent) {
                  if (enabled && hasChildren) {
                    widget.tree._expand(widget.node.value);
                  }
                  return null;
                },
              ),
              _TreeCollapseIntent: CallbackAction<_TreeCollapseIntent>(
                onInvoke: (intent) {
                  if (enabled && hasChildren) {
                    widget.tree._collapse(widget.node.value);
                  }
                  return null;
                },
              ),
            },
            child: MouseRegion(
                cursor: enabled
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                onEnter: (_) => _setHovered(true),
                onExit: (_) {
                  _setHovered(false);
                  _setPressed(false);
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: enabled ? (_) => _setPressed(true) : null,
                  onTapUp: enabled ? (_) => _setPressed(false) : null,
                  onTapCancel: enabled ? () => _setPressed(false) : null,
                  onTap: () {
                    if (enabled) {
                      _focusNode.requestFocus();
                    }
                    _activate(enabled, hasChildren);
                  },
                  child: Opacity(
                    opacity: enabled ? 1 : 0.48,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOut,
                      transform: Matrix4.translationValues(
                        0,
                        _pressed ? 1 : 0,
                        0,
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      padding: EdgeInsets.fromLTRB(
                        8 + widget.depth * 18,
                        7,
                        10,
                        7,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? theme.primaryBackgroundColor
                            : highlighted
                                ? theme.subtleBackgroundColor
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: rowBorderColor, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: hasChildren
                                ? Icon(
                                    expanded
                                        ? Icons.expand_more_rounded
                                        : Icons.chevron_right_rounded,
                                    size: 20,
                                    color: iconColor,
                                  )
                                : Icon(
                                    Icons.eco_rounded,
                                    size: 15,
                                    color: highlighted
                                        ? theme.primaryColor
                                        : theme.disabledTextColor,
                                  ),
                          ),
                          if (widget.node.icon != null) ...[
                            IconTheme.merge(
                              data: IconThemeData(
                                size: 17,
                                color: iconColor,
                              ),
                              child: widget.node.icon!,
                            ),
                            const SizedBox(width: 7),
                          ],
                          Expanded(
                            child: DefaultTextStyle.merge(
                              style: theme.textStyle(
                                size: 13,
                                weight: selected
                                    ? FontWeight.w900
                                    : FontWeight.w700,
                                color: selected
                                    ? theme.primaryActiveColor
                                    : theme.bodyTextColor,
                              ),
                              child: widget.node.label,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ),
        if (hasChildren && expanded)
          for (final child in widget.node.children)
            _TreeNodeRow<T>(
              tree: widget.tree,
              node: child,
              depth: widget.depth + 1,
            ),
      ],
    );
  }

  void _activate(bool enabled, bool hasChildren) {
    if (!enabled) {
      return;
    }
    if (hasChildren) {
      widget.tree._toggle(widget.node.value);
    }
    widget.tree.widget.onChanged?.call(widget.node.value);
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

class _StageFourFormFieldShell extends StatelessWidget {
  const _StageFourFormFieldShell({
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

class _TreeExpandIntent extends Intent {
  const _TreeExpandIntent();
}

class _TreeCollapseIntent extends Intent {
  const _TreeCollapseIntent();
}

class _CalendarMoveIntent extends Intent {
  const _CalendarMoveIntent(this.days);

  final int days;
}

class _CalendarMonthIntent extends Intent {
  const _CalendarMonthIntent(this.months);

  final int months;
}

List<DateTime> _calendarDays(DateTime month) {
  final firstDay = DateTime(month.year, month.month);
  final start = firstDay.subtract(Duration(days: firstDay.weekday % 7));
  return List.generate(
      42, (index) => _dateOnly(start.add(Duration(days: index))));
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

DateTime _monthOnly(DateTime value) {
  return DateTime(value.year, value.month);
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

bool _isSameMonth(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month;
}

Color _resultColor(AnimalThemeData theme, AnimalResultStatus status) {
  return switch (status) {
    AnimalResultStatus.success => theme.successColor,
    AnimalResultStatus.warning => theme.warningColor,
    AnimalResultStatus.error => theme.errorColor,
    AnimalResultStatus.info => theme.primaryColor,
  };
}

IconData _resultIcon(AnimalResultStatus status) {
  return switch (status) {
    AnimalResultStatus.success => Icons.check_rounded,
    AnimalResultStatus.warning => Icons.priority_high_rounded,
    AnimalResultStatus.error => Icons.close_rounded,
    AnimalResultStatus.info => Icons.info_outline_rounded,
  };
}

Color _uploadStatusColor(AnimalThemeData theme, AnimalUploadStatus status) {
  return switch (status) {
    AnimalUploadStatus.ready => theme.secondaryTextColor,
    AnimalUploadStatus.uploading => theme.primaryColor,
    AnimalUploadStatus.done => theme.successColor,
    AnimalUploadStatus.error => theme.errorColor,
  };
}

IconData _uploadStatusIcon(AnimalUploadStatus status) {
  return switch (status) {
    AnimalUploadStatus.ready => Icons.insert_drive_file_rounded,
    AnimalUploadStatus.uploading => Icons.sync_rounded,
    AnimalUploadStatus.done => Icons.check_circle_rounded,
    AnimalUploadStatus.error => Icons.error_rounded,
  };
}
