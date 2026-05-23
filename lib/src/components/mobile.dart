import 'dart:math' as math;
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../animal_theme.dart';
import 'button.dart';
import 'stage_four.dart';

enum AnimalMobileBottomSheetHandle { visible, hidden }

enum AnimalPullRefreshStyle { animal, material }

const double _animalPullRefreshVisibleProgress = 0.06;

enum AnimalMobileCouponStatus { available, claimed, expired }

enum AnimalMobileNoticeType { info, success, warning, error }

enum AnimalMobileTimelineStatus {
  defaultStatus,
  success,
  warning,
  error,
  processing,
}

typedef AnimalPullRefreshIndicatorBuilder = Widget Function(
  BuildContext context,
  RefreshIndicatorStatus? status,
);

@immutable
class AnimalBottomBarItem {
  const AnimalBottomBarItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badge,
  });

  final Widget icon;
  final Widget label;
  final Widget? activeIcon;
  final Widget? badge;
}

@immutable
class AnimalActionSheetAction<T> {
  const AnimalActionSheetAction({
    required this.value,
    required this.label,
    this.icon,
    this.destructive = false,
    this.disabled = false,
  });

  final T value;
  final Widget label;
  final Widget? icon;
  final bool destructive;
  final bool disabled;
}

@immutable
class AnimalPickerOption<T> {
  const AnimalPickerOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
    this.disabled = false,
  });

  final T value;
  final Widget label;
  final Widget? subtitle;
  final Widget? leading;
  final bool disabled;
}

@immutable
class AnimalSwipeActionItem {
  const AnimalSwipeActionItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
    this.destructive = false,
    this.disabled = false,
  });

  final Widget label;
  final VoidCallback onTap;
  final Widget? icon;
  final Color? color;
  final bool destructive;
  final bool disabled;
}

@immutable
class AnimalMobileStatItem {
  const AnimalMobileStatItem({
    required this.label,
    required this.value,
    this.icon,
    this.description,
    this.color,
    this.onTap,
  });

  final Widget label;
  final Widget value;
  final Widget? icon;
  final Widget? description;
  final Color? color;
  final VoidCallback? onTap;
}

@immutable
class AnimalMobileOrderItem {
  const AnimalMobileOrderItem({
    required this.title,
    this.subtitle,
    this.quantity,
    this.price,
    this.leading,
  });

  final Widget title;
  final Widget? subtitle;
  final int? quantity;
  final Widget? price;
  final Widget? leading;
}

@immutable
class AnimalMobilePriceItem {
  const AnimalMobilePriceItem({
    required this.label,
    required this.value,
    this.emphasized = false,
    this.color,
  });

  final Widget label;
  final Widget value;
  final bool emphasized;
  final Color? color;
}

@immutable
class AnimalMobileTimelineItem {
  const AnimalMobileTimelineItem({
    required this.title,
    this.description,
    this.time,
    this.icon,
    this.status = AnimalMobileTimelineStatus.defaultStatus,
    this.onTap,
    this.disabled = false,
  });

  final Widget title;
  final Widget? description;
  final Widget? time;
  final Widget? icon;
  final AnimalMobileTimelineStatus status;
  final VoidCallback? onTap;
  final bool disabled;
}

class AnimalMobileNavBar extends StatelessWidget {
  const AnimalMobileNavBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.onBack,
    this.showBackButton = false,
    this.safeAreaTop = true,
    this.height = 56,
  });

  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onBack;
  final bool showBackButton;
  final bool safeAreaTop;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final top = safeAreaTop ? MediaQuery.paddingOf(context).top : 0.0;
    final resolvedLeading = leading ??
        (showBackButton
            ? _MobileIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: onBack ?? () => Navigator.maybePop(context),
              )
            : null);

    return Container(
      padding: EdgeInsets.fromLTRB(12, top + 8, 12, 8),
      decoration: BoxDecoration(
        color: theme.elevatedBackgroundColor,
        border: Border(
          bottom: BorderSide(color: theme.controlBorderColor, width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.tactileShadowColor.withValues(alpha: 0.16),
            offset: const Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: Align(
                alignment: Alignment.centerLeft,
                child: resolvedLeading,
              ),
            ),
            Expanded(
              child: Center(
                child: DefaultTextStyle.merge(
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyle(
                    size: 17,
                    weight: FontWeight.w900,
                    color: theme.textColor,
                    height: 1.1,
                  ),
                  child: title,
                ),
              ),
            ),
            SizedBox(
              width: 44,
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimalBottomBar extends StatelessWidget {
  const AnimalBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onChanged,
    this.safeAreaBottom = true,
  });

  final List<AnimalBottomBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;
  final bool safeAreaBottom;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final bottom = safeAreaBottom ? MediaQuery.paddingOf(context).bottom : 0.0;

    return Container(
      padding: EdgeInsets.fromLTRB(10, 8, 10, bottom + 8),
      decoration: BoxDecoration(
        color: theme.elevatedBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.controlBorderColor, width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.tactileShadowColor.withValues(alpha: 0.18),
            offset: const Offset(0, -3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          for (final indexed in items.indexed)
            Expanded(
              child: _BottomBarButton(
                item: indexed.$2,
                selected: indexed.$1 == currentIndex,
                onTap: () => onChanged(indexed.$1),
              ),
            ),
        ],
      ),
    );
  }
}

class AnimalBottomSheet extends StatelessWidget {
  const AnimalBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.footer,
    this.handle = AnimalMobileBottomSheetHandle.visible,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 20),
    this.maxHeightFactor = 0.84,
  });

  final Widget child;
  final Widget? title;
  final Widget? footer;
  final AnimalMobileBottomSheetHandle handle;
  final EdgeInsetsGeometry padding;
  final double maxHeightFactor;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    Widget? title,
    Widget? footer,
    AnimalMobileBottomSheetHandle handle =
        AnimalMobileBottomSheetHandle.visible,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(20, 8, 20, 20),
    double maxHeightFactor = 0.84,
    bool barrierDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: barrierDismissible,
      enableDrag: barrierDismissible,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnimalBottomSheet(
          title: title,
          footer: footer,
          handle: handle,
          padding: padding,
          maxHeightFactor: maxHeightFactor,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFactor;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: bottom),
          decoration: BoxDecoration(
            color: theme.elevatedBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: theme.controlBorderColor, width: 2),
            boxShadow: theme.shadowLarge,
          ),
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (handle == AnimalMobileBottomSheetHandle.visible)
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: theme.controlBorderColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                if (title != null) ...[
                  DefaultTextStyle.merge(
                    style: theme.textStyle(
                      size: 18,
                      weight: FontWeight.w900,
                      color: theme.textColor,
                    ),
                    child: title!,
                  ),
                  const SizedBox(height: 14),
                ],
                Flexible(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: child,
                  ),
                ),
                if (footer != null) ...[
                  const SizedBox(height: 16),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimalActionSheet<T> extends StatelessWidget {
  const AnimalActionSheet({
    super.key,
    required this.actions,
    this.title,
    this.message,
    this.cancelText = const Text('取消'),
    this.onSelected,
  });

  final List<AnimalActionSheetAction<T>> actions;
  final Widget? title;
  final Widget? message;
  final Widget cancelText;
  final ValueChanged<T>? onSelected;

  static Future<T?> show<T>({
    required BuildContext context,
    required List<AnimalActionSheetAction<T>> actions,
    Widget? title,
    Widget? message,
    Widget cancelText = const Text('取消'),
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnimalActionSheet<T>(
          title: title,
          message: message,
          actions: actions,
          cancelText: cancelText,
          onSelected: (value) => Navigator.of(context).pop(value),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimalBottomSheet(
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (message != null) ...[
            DefaultTextStyle.merge(
              style: AnimalTheme.of(context).textStyle(
                size: 13,
                weight: FontWeight.w700,
                color: AnimalTheme.of(context).secondaryTextColor,
              ),
              child: message!,
            ),
            const SizedBox(height: 12),
          ],
          AnimalCellGroup(
            children: [
              for (final action in actions)
                AnimalListTile(
                  leading: action.icon,
                  title: action.label,
                  disabled: action.disabled,
                  destructive: action.destructive,
                  showChevron: false,
                  onTap: action.disabled
                      ? null
                      : () {
                          onSelected?.call(action.value);
                        },
                ),
            ],
          ),
          const SizedBox(height: 12),
          AnimalListTile(
            title: cancelText,
            showChevron: false,
            textAlign: TextAlign.center,
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }
}

class AnimalCellGroup extends StatelessWidget {
  const AnimalCellGroup({
    super.key,
    required this.children,
    this.margin = EdgeInsets.zero,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Container(
      margin: margin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.contentBackgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.controlBorderColor, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final indexed in children.indexed) ...[
            indexed.$2,
            if (indexed.$1 != children.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: theme.controlBorderColor.withValues(alpha: 0.55),
                indent: 16,
                endIndent: 16,
              ),
          ],
        ],
      ),
    );
  }
}

class AnimalListTile extends StatefulWidget {
  const AnimalListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.disabled = false,
    this.destructive = false,
    this.showChevron = true,
    this.minHeight = 54,
    this.textAlign = TextAlign.start,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool disabled;
  final bool destructive;
  final bool showChevron;
  final double minHeight;
  final TextAlign textAlign;

  @override
  State<AnimalListTile> createState() => _AnimalListTileState();
}

class _AnimalListTileState extends State<AnimalListTile> {
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => !widget.disabled && widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final active = _enabled && (_pressed || _focused);
    final titleColor = widget.disabled
        ? theme.disabledTextColor
        : widget.destructive
            ? theme.errorColor
            : theme.textColor;

    return Semantics(
      button: widget.onTap != null,
      enabled: _enabled,
      child: FocusableActionDetector(
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
              widget.onTap?.call();
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor:
              _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
            onTapCancel:
                _enabled ? () => setState(() => _pressed = false) : null,
            onTapUp: _enabled
                ? (_) {
                    setState(() => _pressed = false);
                    widget.onTap?.call();
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              constraints: BoxConstraints(minHeight: widget.minHeight),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              color: active
                  ? theme.primaryBackgroundColor.withValues(alpha: 0.7)
                  : Colors.transparent,
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    IconTheme.merge(
                      data: IconThemeData(color: titleColor, size: 22),
                      child: widget.leading!,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: widget.textAlign == TextAlign.center
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        DefaultTextStyle.merge(
                          textAlign: widget.textAlign,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textStyle(
                            size: 15,
                            weight: FontWeight.w900,
                            color: titleColor,
                          ),
                          child: widget.title,
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 3),
                          DefaultTextStyle.merge(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textStyle(
                              size: 12,
                              weight: FontWeight.w700,
                              color: theme.secondaryTextColor,
                            ),
                            child: widget.subtitle!,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (widget.trailing != null) ...[
                    const SizedBox(width: 12),
                    widget.trailing!,
                  ] else if (widget.showChevron) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: widget.disabled
                          ? theme.disabledTextColor
                          : theme.primaryColor,
                      size: 23,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimalMobileSearchBar extends StatefulWidget {
  const AnimalMobileSearchBar({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText = '搜索',
    this.enabled = true,
    this.autofocus = false,
    this.showCancel = false,
    this.cancelText = const Text('取消'),
    this.onChanged,
    this.onSubmitted,
    this.onSearch,
    this.onClear,
    this.onCancel,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String hintText;
  final bool enabled;
  final bool autofocus;
  final bool showCancel;
  final Widget cancelText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onClear;
  final VoidCallback? onCancel;

  @override
  State<AnimalMobileSearchBar> createState() => _AnimalMobileSearchBarState();
}

class _AnimalMobileSearchBarState extends State<AnimalMobileSearchBar> {
  late final TextEditingController _innerController;
  final _focusNode = FocusNode();
  bool _focused = false;

  TextEditingController get _controller =>
      widget.controller ?? _innerController;

  @override
  void initState() {
    super.initState();
    _innerController = TextEditingController(text: widget.initialValue);
    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant AnimalMobileSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _innerController).removeListener(
        _handleTextChanged,
      );
      _controller.addListener(_handleTextChanged);
    }
    if (widget.controller == null &&
        widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _innerController.text) {
      _innerController.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    _innerController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() => _focused = _focusNode.hasFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final hasText = _controller.text.isNotEmpty;

    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: widget.enabled
                  ? theme.contentBackgroundColor
                  : theme.disabledBackgroundColor,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: _focused ? theme.primaryColor : theme.controlBorderColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.tactileShadowColor.withValues(alpha: 0.12),
                  offset: const Offset(0, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: _focused ? theme.primaryColor : theme.placeholderColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    autofocus: widget.autofocus,
                    textInputAction: TextInputAction.search,
                    style: theme.textStyle(
                      size: 14,
                      weight: FontWeight.w800,
                      color: theme.bodyTextColor,
                    ),
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: theme.textStyle(
                        size: 14,
                        weight: FontWeight.w700,
                        color: theme.placeholderColor,
                      ),
                    ),
                    onChanged: widget.onChanged,
                    onSubmitted: (value) {
                      widget.onSubmitted?.call(value);
                      widget.onSearch?.call(value);
                    },
                  ),
                ),
                if (hasText)
                  _MobileCircleAction(
                    icon: Icons.close_rounded,
                    size: 26,
                    iconSize: 16,
                    onTap: widget.enabled
                        ? () {
                            _controller.clear();
                            widget.onChanged?.call('');
                            widget.onClear?.call();
                          }
                        : null,
                  ),
              ],
            ),
          ),
        ),
        if (widget.showCancel) ...[
          const SizedBox(width: 10),
          _MobileTextAction(
            onTap: widget.enabled
                ? () {
                    _focusNode.unfocus();
                    widget.onCancel?.call();
                  }
                : null,
            child: widget.cancelText,
          ),
        ],
      ],
    );
  }
}

class AnimalPicker<T> extends StatelessWidget {
  const AnimalPicker({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.closeOnSelect = false,
  });

  final List<AnimalPickerOption<T>> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final bool closeOnSelect;

  static Future<T?> show<T>({
    required BuildContext context,
    required List<AnimalPickerOption<T>> options,
    T? value,
    Widget? title,
    Widget? message,
    Widget cancelText = const Text('取消'),
  }) {
    return AnimalBottomSheet.show<T>(
      context: context,
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (message != null) ...[
            DefaultTextStyle.merge(
              style: AnimalTheme.of(context).textStyle(
                size: 13,
                weight: FontWeight.w700,
                color: AnimalTheme.of(context).secondaryTextColor,
              ),
              child: message,
            ),
            const SizedBox(height: 12),
          ],
          AnimalPicker<T>(
            options: options,
            value: value,
            onChanged: (next) => Navigator.of(context).pop(next),
          ),
          const SizedBox(height: 12),
          AnimalListTile(
            title: cancelText,
            showChevron: false,
            textAlign: TextAlign.center,
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    if (options.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        decoration: BoxDecoration(
          color: theme.contentBackgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: theme.controlBorderColor, width: 2),
        ),
        child: Text(
          '暂无可选项',
          textAlign: TextAlign.center,
          style: theme.textStyle(
            size: 14,
            weight: FontWeight.w800,
            color: theme.secondaryTextColor,
          ),
        ),
      );
    }

    return AnimalCellGroup(
      children: [
        for (final option in options)
          AnimalListTile(
            leading: option.leading,
            title: option.label,
            subtitle: option.subtitle,
            disabled: option.disabled,
            showChevron: false,
            trailing: option.value == value
                ? Icon(
                    Icons.check_circle_rounded,
                    color: theme.primaryColor,
                    size: 22,
                  )
                : null,
            onTap: option.disabled
                ? null
                : () {
                    onChanged(option.value);
                    if (closeOnSelect) {
                      Navigator.of(context).maybePop();
                    }
                  },
          ),
      ],
    );
  }
}

class AnimalMobileDatePicker extends StatefulWidget {
  const AnimalMobileDatePicker({
    super.key,
    this.value,
    this.defaultValue,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.showActions = true,
    this.confirmText = '确定',
    this.cancelText = '取消',
  });

  final DateTime? value;
  final DateTime? defaultValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onChanged;
  final bool showActions;
  final String confirmText;
  final String cancelText;

  static Future<DateTime?> show({
    required BuildContext context,
    DateTime? value,
    DateTime? defaultValue,
    DateTime? firstDate,
    DateTime? lastDate,
    Widget? title = const Text('选择日期'),
  }) {
    return AnimalBottomSheet.show<DateTime>(
      context: context,
      title: title,
      child: AnimalMobileDatePicker(
        value: value,
        defaultValue: defaultValue,
        firstDate: firstDate,
        lastDate: lastDate,
        onChanged: (date) => Navigator.of(context).pop(date),
      ),
    );
  }

  @override
  State<AnimalMobileDatePicker> createState() => _AnimalMobileDatePickerState();
}

class _AnimalMobileDatePickerState extends State<AnimalMobileDatePicker> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected =
        _dateOnly(widget.value ?? widget.defaultValue ?? DateTime.now());
  }

  @override
  void didUpdateWidget(covariant AnimalMobileDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && !_isSameDay(widget.value!, _selected)) {
      _selected = _dateOnly(widget.value!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: AnimalCalendar(
            value: _selected,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            onChanged: (date) => setState(() => _selected = date),
          ),
        ),
        if (widget.showActions) ...[
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AnimalButton(
                  block: true,
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(widget.cancelText),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimalButton(
                  type: AnimalButtonType.primary,
                  block: true,
                  onPressed: () => widget.onChanged?.call(_selected),
                  child: Text(widget.confirmText),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class AnimalMobileStepper extends StatefulWidget {
  const AnimalMobileStepper({
    super.key,
    this.value,
    this.defaultValue = 0,
    this.min,
    this.max,
    this.step = 1,
    this.disabled = false,
    this.onChanged,
    this.formatter,
  });

  final num? value;
  final num defaultValue;
  final num? min;
  final num? max;
  final num step;
  final bool disabled;
  final ValueChanged<num>? onChanged;
  final String Function(num value)? formatter;

  @override
  State<AnimalMobileStepper> createState() => _AnimalMobileStepperState();
}

class _AnimalMobileStepperState extends State<AnimalMobileStepper> {
  late num _innerValue;

  bool get _controlled => widget.value != null;
  num get _value => _clampValue(widget.value ?? _innerValue);

  @override
  void initState() {
    super.initState();
    _innerValue = _clampValue(widget.value ?? widget.defaultValue);
  }

  @override
  void didUpdateWidget(covariant AnimalMobileStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null) {
      _innerValue = _clampValue(widget.value!);
    }
  }

  num _clampValue(num value) {
    var next = value;
    final min = widget.min;
    final max = widget.max;
    if (min != null && next < min) {
      next = min;
    }
    if (max != null && next > max) {
      next = max;
    }
    return next;
  }

  void _change(num delta) {
    if (widget.disabled) {
      return;
    }
    final next = _clampValue(_value + delta);
    if (!_controlled) {
      setState(() => _innerValue = next);
    }
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final valueText = widget.formatter?.call(_value) ?? _formatNumber(_value);
    final canDecrease = !widget.disabled &&
        widget.onChanged != null &&
        (widget.min == null || _value > widget.min!);
    final canIncrease = !widget.disabled &&
        widget.onChanged != null &&
        (widget.max == null || _value < widget.max!);

    return Semantics(
      value: valueText,
      increasedValue: _formatNumber(_clampValue(_value + widget.step)),
      decreasedValue: _formatNumber(_clampValue(_value - widget.step)),
      onIncrease: canIncrease ? () => _change(widget.step) : null,
      onDecrease: canDecrease ? () => _change(-widget.step) : null,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: widget.disabled
              ? theme.disabledBackgroundColor
              : theme.contentBackgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: theme.controlBorderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: theme.tactileShadowColor.withValues(alpha: 0.12),
              offset: const Offset(0, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MobileCircleAction(
              icon: Icons.remove_rounded,
              onTap: canDecrease ? () => _change(-widget.step) : null,
            ),
            SizedBox(
              width: 58,
              child: Text(
                valueText,
                textAlign: TextAlign.center,
                style: theme.textStyle(
                  size: 15,
                  weight: FontWeight.w900,
                  color: widget.disabled
                      ? theme.disabledTextColor
                      : theme.bodyTextColor,
                ),
              ),
            ),
            _MobileCircleAction(
              icon: Icons.add_rounded,
              onTap: canIncrease ? () => _change(widget.step) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class AnimalSwipeAction extends StatefulWidget {
  const AnimalSwipeAction({
    super.key,
    required this.child,
    required this.actions,
    this.actionExtent = 82,
    this.enabled = true,
  });

  final Widget child;
  final List<AnimalSwipeActionItem> actions;
  final double actionExtent;
  final bool enabled;

  @override
  State<AnimalSwipeAction> createState() => _AnimalSwipeActionState();
}

class _AnimalSwipeActionState extends State<AnimalSwipeAction> {
  var _offset = 0.0;

  double get _maxOffset => widget.actionExtent * widget.actions.length;

  void _close() {
    if (mounted) {
      setState(() => _offset = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final enabled = widget.enabled && widget.actions.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final action in widget.actions)
                    _SwipeActionButton(
                      action: action,
                      width: widget.actionExtent,
                      onClose: _close,
                    ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: enabled
                ? (details) {
                    setState(() {
                      _offset =
                          (_offset - details.delta.dx).clamp(0.0, _maxOffset);
                    });
                  }
                : null,
            onHorizontalDragEnd: enabled
                ? (_) {
                    setState(() {
                      _offset = _offset > _maxOffset * 0.45 ? _maxOffset : 0;
                    });
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(-_offset, 0, 0),
              decoration: BoxDecoration(
                color: theme.contentBackgroundColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimalPullRefresh extends StatefulWidget {
  const AnimalPullRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.displacement = 58,
    this.edgeOffset = 0,
    this.style = AnimalPullRefreshStyle.animal,
    this.indicatorBuilder,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final Widget child;
  final RefreshCallback onRefresh;
  final double displacement;
  final double edgeOffset;
  final AnimalPullRefreshStyle style;
  final AnimalPullRefreshIndicatorBuilder? indicatorBuilder;
  final RefreshIndicatorTriggerMode triggerMode;
  final ScrollNotificationPredicate notificationPredicate;
  final String? semanticsLabel;
  final String? semanticsValue;

  @override
  State<AnimalPullRefresh> createState() => _AnimalPullRefreshState();
}

class _AnimalPullRefreshState extends State<AnimalPullRefresh> {
  RefreshIndicatorStatus? _status;
  double _pullProgress = 0;
  double _dragExtent = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final scrollBehavior = ScrollConfiguration.of(context);
    final dragDevices = <PointerDeviceKind>{
      ...scrollBehavior.dragDevices,
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
      PointerDeviceKind.stylus,
      PointerDeviceKind.trackpad,
    };

    return ScrollConfiguration(
      behavior: scrollBehavior.copyWith(dragDevices: dragDevices),
      child: widget.style == AnimalPullRefreshStyle.material
          ? RefreshIndicator(
              onRefresh: widget.onRefresh,
              displacement: widget.displacement,
              edgeOffset: widget.edgeOffset,
              triggerMode: widget.triggerMode,
              notificationPredicate: widget.notificationPredicate,
              semanticsLabel: widget.semanticsLabel,
              semanticsValue: widget.semanticsValue,
              color: theme.primaryColor,
              backgroundColor: theme.elevatedBackgroundColor,
              strokeWidth: 3,
              child: widget.child,
            )
          : Stack(
              clipBehavior: Clip.none,
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: _handleScrollNotification,
                  child: RefreshIndicator.noSpinner(
                    onRefresh: widget.onRefresh,
                    onStatusChange: _handleStatusChange,
                    triggerMode: widget.triggerMode,
                    notificationPredicate: widget.notificationPredicate,
                    semanticsLabel: widget.semanticsLabel,
                    semanticsValue: widget.semanticsValue,
                    child: widget.child,
                  ),
                ),
                Positioned(
                  top: widget.edgeOffset + 10,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: _AnimalPullRefreshIndicator(
                      status: _status,
                      progress: _pullProgress,
                      displacement: widget.displacement,
                      builder: widget.indicatorBuilder,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _handleStatusChange(RefreshIndicatorStatus? status) {
    if (_status == status) {
      return;
    }

    setState(() {
      _status = status;
      if (status == null ||
          status == RefreshIndicatorStatus.done ||
          status == RefreshIndicatorStatus.canceled) {
        _dragExtent = 0;
        _pullProgress = 0;
      } else if (status == RefreshIndicatorStatus.snap ||
          status == RefreshIndicatorStatus.refresh ||
          status == RefreshIndicatorStatus.armed) {
        _pullProgress = 1;
      }
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) {
      return false;
    }

    final metrics = notification.metrics;
    if (metrics.axis != Axis.vertical) {
      return false;
    }

    final pullsFromTop = metrics.axisDirection == AxisDirection.down;
    final pullsFromBottom = metrics.axisDirection == AxisDirection.up;
    if (!pullsFromTop && !pullsFromBottom) {
      return false;
    }

    final atRefreshEdge =
        pullsFromTop ? metrics.extentBefore == 0 : metrics.extentAfter == 0;
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null &&
        atRefreshEdge) {
      _dragExtent = 0;
      _setPullProgress(0);
      return false;
    }

    if (_status == RefreshIndicatorStatus.drag ||
        _status == RefreshIndicatorStatus.armed ||
        _dragExtent > 0 ||
        atRefreshEdge) {
      var delta = 0.0;
      if (notification is ScrollUpdateNotification &&
          notification.dragDetails != null) {
        delta = pullsFromTop
            ? -(notification.scrollDelta ?? 0)
            : (notification.scrollDelta ?? 0);
      } else if (notification is OverscrollNotification) {
        delta =
            pullsFromTop ? -notification.overscroll : notification.overscroll;
      }

      if (delta != 0) {
        _dragExtent = math.max(0, _dragExtent + delta);
        final triggerExtent = math.max(1, metrics.viewportDimension * 0.22);
        _setPullProgress((_dragExtent / triggerExtent).clamp(0.0, 1.0));
      }
    } else if (notification is ScrollEndNotification && _status == null) {
      _dragExtent = 0;
      _setPullProgress(0);
    }

    return false;
  }

  void _setPullProgress(double value) {
    final progress = value.clamp(0.0, 1.0);
    if ((progress - _pullProgress).abs() < 0.025 &&
        progress != 0 &&
        progress != 1) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() => _pullProgress = progress);
  }
}

class _AnimalPullRefreshIndicator extends StatefulWidget {
  const _AnimalPullRefreshIndicator({
    required this.status,
    required this.progress,
    required this.displacement,
    required this.builder,
  });

  final RefreshIndicatorStatus? status;
  final double progress;
  final double displacement;
  final AnimalPullRefreshIndicatorBuilder? builder;

  @override
  State<_AnimalPullRefreshIndicator> createState() =>
      _AnimalPullRefreshIndicatorState();
}

class _AnimalPullRefreshIndicatorState
    extends State<_AnimalPullRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
    _syncController();
  }

  @override
  void didUpdateWidget(covariant _AnimalPullRefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncController() {
    final visible = _isAnimalRefreshIndicatorVisible(
      widget.status,
      widget.progress,
    );

    if (visible) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.status;
    final visible = _isAnimalRefreshIndicatorVisible(
      status,
      widget.progress,
    );

    return Visibility(
      visible: visible,
      maintainState: true,
      maintainAnimation: true,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 160),
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, -0.28),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: widget.builder?.call(context, status) ??
              _DefaultAnimalRefreshIndicator(
                status: status,
                progress: widget.progress,
                displacement: widget.displacement,
                spin: _controller,
              ),
        ),
      ),
    );
  }
}

bool _isAnimalRefreshIndicatorVisible(
  RefreshIndicatorStatus? status,
  double progress,
) {
  if (status == null ||
      status == RefreshIndicatorStatus.done ||
      status == RefreshIndicatorStatus.canceled) {
    return false;
  }

  return status == RefreshIndicatorStatus.armed ||
      status == RefreshIndicatorStatus.snap ||
      status == RefreshIndicatorStatus.refresh ||
      progress >= _animalPullRefreshVisibleProgress;
}

class _DefaultAnimalRefreshIndicator extends StatelessWidget {
  const _DefaultAnimalRefreshIndicator({
    required this.status,
    required this.progress,
    required this.displacement,
    required this.spin,
  });

  final RefreshIndicatorStatus? status;
  final double progress;
  final double displacement;
  final Animation<double> spin;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final armed = status == RefreshIndicatorStatus.armed ||
        status == RefreshIndicatorStatus.snap;
    final refreshing = status == RefreshIndicatorStatus.refresh;
    final label = refreshing
        ? '岛风正在同步'
        : armed
            ? '松开刷新岛屿'
            : '下拉唤醒岛屿';
    final caption = refreshing
        ? '海风带回新内容'
        : armed
            ? '松手让海风送达'
            : '再拉一点就出发';
    final iconColor =
        refreshing || armed ? theme.primaryColor : const Color(0xFF8A7652);
    final activeProgress = refreshing || armed ? 1.0 : progress.clamp(0.0, 1.0);
    final indicatorHeight = displacement.clamp(52, 76).toDouble();

    return AnimatedBuilder(
      animation: spin,
      builder: (context, child) {
        final motion = spin.value;
        final loop = status == null ? activeProgress * 0.35 : motion;
        final bob = math.sin(motion * math.pi * 2) *
            (refreshing ? 3.2 : 2.1 * activeProgress);
        return Center(
          child: Transform.translate(
            offset: Offset(0, -4 * activeProgress + bob),
            child: Transform.scale(
              scale: 0.94 + activeProgress * 0.06,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 198,
                  minHeight: indicatorHeight,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.elevatedBackgroundColor,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: refreshing || armed
                          ? theme.primaryColor.withValues(alpha: 0.55)
                          : theme.warmBorderColor,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.tactileShadowColor.withValues(alpha: 0.30),
                        offset: const Offset(0, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: CustomPaint(
                      painter: _AnimalRefreshPondPainter(
                        progress: activeProgress,
                        phase: loop,
                        primaryColor: theme.primaryColor,
                        sandColor: const Color(0xFFFFE7A6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 7, 13, 7),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _AnimalRefreshBadge(
                              color: iconColor,
                              refreshing:
                                  refreshing || armed || activeProgress >= 0.98,
                              progress: activeProgress,
                              spin: spin,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  label,
                                  style: theme.textStyle(
                                    size: 13,
                                    weight: FontWeight.w900,
                                    color: const Color(0xFF6B5132),
                                    height: 1.04,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  caption,
                                  style: theme.textStyle(
                                    size: 10,
                                    weight: FontWeight.w800,
                                    color: theme.bodyTextColor
                                        .withValues(alpha: 0.72),
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            _AnimalRefreshStatusDots(
                              color: iconColor,
                              progress: activeProgress,
                              phase: loop,
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
      },
    );
  }
}

class _AnimalRefreshBadge extends StatelessWidget {
  const _AnimalRefreshBadge({
    required this.color,
    required this.refreshing,
    required this.progress,
    required this.spin,
  });

  final Color color;
  final bool refreshing;
  final double progress;
  final Animation<double> spin;

  @override
  Widget build(BuildContext context) {
    final badge = SizedBox(
      width: 42,
      height: 42,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
              border:
                  Border.all(color: color.withValues(alpha: 0.72), width: 2),
            ),
            child: const SizedBox.expand(),
          ),
          Positioned(
            bottom: 4,
            child: Container(
              width: 27,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xFFBAE4F0).withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(
              math.sin(spin.value * math.pi * 2) * progress * 1.4,
              4 -
                  progress * 6 +
                  math.cos(spin.value * math.pi * 2) * progress * 2.0,
            ),
            child: Transform.rotate(
              angle: math.sin(spin.value * math.pi * 2) * progress * 0.11,
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                'assets/animal_island/img/loading/loading-island.svg',
                package: 'animal_island_flutter',
                width: 30,
                height: 34,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -1,
            child: _AnimalRefreshMiniAction(
              color: color,
              refreshing: refreshing,
              spin: spin,
            ),
          ),
        ],
      ),
    );

    return badge;
  }
}

class _AnimalRefreshMiniAction extends StatelessWidget {
  const _AnimalRefreshMiniAction({
    required this.color,
    required this.refreshing,
    required this.spin,
  });

  final Color color;
  final bool refreshing;
  final Animation<double> spin;

  @override
  Widget build(BuildContext context) {
    final icon = DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: SizedBox(
        width: 18,
        height: 18,
        child: Icon(
          refreshing ? Icons.sync_rounded : Icons.eco_rounded,
          color: color,
          size: 12,
        ),
      ),
    );

    if (!refreshing) {
      return icon;
    }

    return RotationTransition(
      turns: spin,
      child: icon,
    );
  }
}

class _AnimalRefreshStatusDots extends StatelessWidget {
  const _AnimalRefreshStatusDots({
    required this.color,
    required this.progress,
    required this.phase,
  });

  final Color color;
  final double progress;
  final double phase;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final wave = (math.sin((phase * math.pi * 2) + index * 0.9) + 1) / 2;
        final opacity = 0.34 + progress * 0.38 + wave * 0.28;
        return Container(
          width: 5.5 + wave * 2.4,
          height: 5.5 + wave * 2.4,
          margin: EdgeInsets.only(left: index == 0 ? 0 : 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: opacity.clamp(0.20, 0.92)),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class _AnimalRefreshPondPainter extends CustomPainter {
  const _AnimalRefreshPondPainter({
    required this.progress,
    required this.phase,
    required this.primaryColor,
    required this.sandColor,
  });

  final double progress;
  final double phase;
  final Color primaryColor;
  final Color sandColor;

  @override
  void paint(Canvas canvas, Size size) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final wavePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.08 + clampedProgress * 0.08)
      ..style = PaintingStyle.fill;
    final waveAccentPaint = Paint()
      ..color = const Color(0xFFBAE4F0).withValues(
        alpha: 0.30 + clampedProgress * 0.28,
      )
      ..style = PaintingStyle.fill;
    final sandPaint = Paint()
      ..color = sandColor.withValues(alpha: 0.28 + clampedProgress * 0.18)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.20, size.height * 0.78),
        width: 58 + clampedProgress * 14,
        height: 12 + clampedProgress * 5,
      ),
      sandPaint,
    );

    _drawWave(
      canvas,
      size,
      y: size.height * (0.70 - clampedProgress * 0.08),
      amplitude: 2.5 + clampedProgress * 2.5,
      phase: phase,
      paint: wavePaint,
    );
    _drawWave(
      canvas,
      size,
      y: size.height * (0.78 - clampedProgress * 0.05),
      amplitude: 2 + clampedProgress * 2,
      phase: phase + 0.35,
      paint: waveAccentPaint,
    );

    final sparklePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.42 + clampedProgress * 0.32);
    for (var i = 0; i < 3; i += 1) {
      final dx = size.width * (0.70 + i * 0.07);
      final dy =
          size.height * (0.35 + math.sin(phase * math.pi * 2 + i) * 0.04);
      canvas.drawCircle(Offset(dx, dy), 1.5 + i * 0.25, sparklePaint);
    }
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double y,
    required double amplitude,
    required double phase,
    required Paint paint,
  }) {
    final path = Path()..moveTo(0, size.height);
    path.lineTo(0, y);
    for (var x = 0.0; x <= size.width + 8; x += 8) {
      final waveY = y + math.sin((x / 18) + phase * math.pi * 2) * amplitude;
      path.lineTo(x, waveY);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AnimalRefreshPondPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.phase != phase ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.sandColor != sandColor;
  }
}

class AnimalMobileSection extends StatelessWidget {
  const AnimalMobileSection({
    super.key,
    required this.child,
    this.title,
    this.extra,
    this.margin = const EdgeInsets.only(bottom: 16),
  });

  final Widget child;
  final Widget? title;
  final Widget? extra;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || extra != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: DefaultTextStyle.merge(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyle(
                          size: 16,
                          weight: FontWeight.w900,
                          color: theme.textColor,
                        ),
                        child: title!,
                      ),
                    )
                  else
                    const Spacer(),
                  if (extra != null)
                    DefaultTextStyle.merge(
                      style: theme.textStyle(
                        size: 12,
                        weight: FontWeight.w800,
                        color: theme.primaryColor,
                      ),
                      child: extra!,
                    ),
                ],
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class AnimalMobileProductCard extends StatelessWidget {
  const AnimalMobileProductCard({
    super.key,
    required this.title,
    this.subtitle,
    this.price,
    this.image,
    this.tag,
    this.action,
    this.onTap,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? price;
  final Widget? image;
  final Widget? tag;
  final Widget? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return _MobileCardShell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: theme.primaryBackgroundColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.controlBorderColor, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: image ??
                Icon(
                  Icons.shopping_bag_rounded,
                  color: theme.primaryColor,
                  size: 34,
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DefaultTextStyle.merge(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyle(
                          size: 15,
                          weight: FontWeight.w900,
                          color: theme.textColor,
                        ),
                        child: title,
                      ),
                    ),
                    if (tag != null) ...[
                      const SizedBox(width: 8),
                      tag!,
                    ],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  DefaultTextStyle.merge(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyle(
                      size: 12,
                      weight: FontWeight.w700,
                      color: theme.secondaryTextColor,
                    ),
                    child: subtitle!,
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (price != null)
                      Expanded(
                        child: DefaultTextStyle.merge(
                          style: theme.textStyle(
                            size: 16,
                            weight: FontWeight.w900,
                            color: theme.errorColor,
                          ),
                          child: price!,
                        ),
                      )
                    else
                      const Spacer(),
                    if (action != null) action!,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimalMobileOrderCard extends StatelessWidget {
  const AnimalMobileOrderCard({
    super.key,
    required this.orderNo,
    required this.status,
    this.items = const [],
    this.total,
    this.footer,
    this.onTap,
  });

  final Widget orderNo;
  final Widget status;
  final List<AnimalMobileOrderItem> items;
  final Widget? total;
  final Widget? footer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return _MobileCardShell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: DefaultTextStyle.merge(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyle(
                    size: 14,
                    weight: FontWeight.w900,
                    color: theme.textColor,
                  ),
                  child: orderNo,
                ),
              ),
              DefaultTextStyle.merge(
                style: theme.textStyle(
                  size: 13,
                  weight: FontWeight.w900,
                  color: theme.primaryColor,
                ),
                child: status,
              ),
            ],
          ),
          if (items.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (final item in items.indexed) ...[
              _OrderItemRow(item.$2),
              if (item.$1 != items.length - 1) const SizedBox(height: 10),
            ],
          ],
          if (total != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: DefaultTextStyle.merge(
                style: theme.textStyle(
                  size: 15,
                  weight: FontWeight.w900,
                  color: theme.textColor,
                ),
                child: total!,
              ),
            ),
          ],
          if (footer != null) ...[
            const SizedBox(height: 14),
            footer!,
          ],
        ],
      ),
    );
  }
}

class AnimalMobileProfileHeader extends StatelessWidget {
  const AnimalMobileProfileHeader({
    super.key,
    required this.name,
    this.avatar,
    this.subtitle,
    this.actions = const [],
    this.stats = const [],
  });

  final Widget name;
  final Widget? avatar;
  final Widget? subtitle;
  final List<Widget> actions;
  final List<AnimalMobileStatItem> stats;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.elevatedBackgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.controlBorderColor, width: 2),
        boxShadow: theme.shadowBase,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: theme.primaryBackgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.primaryColor, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: avatar ??
                    Icon(
                      Icons.person_rounded,
                      color: theme.primaryColor,
                      size: 36,
                    ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle.merge(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle(
                        size: 20,
                        weight: FontWeight.w900,
                        color: theme.textColor,
                      ),
                      child: name,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 5),
                      DefaultTextStyle.merge(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyle(
                          size: 13,
                          weight: FontWeight.w700,
                          color: theme.secondaryTextColor,
                        ),
                        child: subtitle!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (stats.isNotEmpty) ...[
            const SizedBox(height: 16),
            AnimalMobileStatsGrid(items: stats),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: actions,
            ),
          ],
        ],
      ),
    );
  }
}

class AnimalMobileStatsGrid extends StatelessWidget {
  const AnimalMobileStatsGrid({
    super.key,
    required this.items,
    this.crossAxisCount = 3,
  });

  final List<AnimalMobileStatItem> items;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    final count = crossAxisCount.clamp(1, 4);
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 10.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (count - 1)) / count;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth.isFinite ? itemWidth : 110,
                child: _MobileStatCard(item: item),
              ),
          ],
        );
      },
    );
  }
}

class AnimalMobileCouponCard extends StatelessWidget {
  const AnimalMobileCouponCard({
    super.key,
    required this.amount,
    required this.title,
    this.description,
    this.status = AnimalMobileCouponStatus.available,
    this.actionText = '领取',
    this.onTap,
  });

  final Widget amount;
  final Widget title;
  final Widget? description;
  final AnimalMobileCouponStatus status;
  final String actionText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final available = status == AnimalMobileCouponStatus.available;
    final accent = switch (status) {
      AnimalMobileCouponStatus.available => theme.errorColor,
      AnimalMobileCouponStatus.claimed => theme.successColor,
      AnimalMobileCouponStatus.expired => theme.disabledTextColor,
    };

    return Opacity(
      opacity: status == AnimalMobileCouponStatus.expired ? 0.68 : 1,
      child: _MobileCardShell(
        onTap: available ? onTap : null,
        child: Row(
          children: [
            Container(
              width: 86,
              height: 86,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: accent, width: 2),
              ),
              child: DefaultTextStyle.merge(
                textAlign: TextAlign.center,
                style: theme.textStyle(
                  size: 22,
                  weight: FontWeight.w900,
                  color: accent,
                ),
                child: amount,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle.merge(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyle(
                      size: 16,
                      weight: FontWeight.w900,
                      color: theme.textColor,
                    ),
                    child: title,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 5),
                    DefaultTextStyle.merge(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle(
                        size: 12,
                        weight: FontWeight.w700,
                        color: theme.secondaryTextColor,
                      ),
                      child: description!,
                    ),
                  ],
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimalButton(
                      type: available
                          ? AnimalButtonType.primary
                          : AnimalButtonType.defaultType,
                      size: AnimalButtonSize.small,
                      disabled: !available,
                      onPressed: available ? onTap : null,
                      child: Text(switch (status) {
                        AnimalMobileCouponStatus.available => actionText,
                        AnimalMobileCouponStatus.claimed => '已领取',
                        AnimalMobileCouponStatus.expired => '已过期',
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimalMobileNoticeBar extends StatelessWidget {
  const AnimalMobileNoticeBar({
    super.key,
    required this.child,
    this.type = AnimalMobileNoticeType.info,
    this.icon,
    this.action,
    this.onTap,
    this.showChevron = false,
  });

  final Widget child;
  final AnimalMobileNoticeType type;
  final Widget? icon;
  final Widget? action;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final colors = _mobileNoticeColors(theme, type);
    final defaultIcon = switch (type) {
      AnimalMobileNoticeType.info => Icons.campaign_rounded,
      AnimalMobileNoticeType.success => Icons.check_circle_rounded,
      AnimalMobileNoticeType.warning => Icons.error_rounded,
      AnimalMobileNoticeType.error => Icons.warning_rounded,
    };

    return _MobileCardShell(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      radius: 18,
      backgroundColor: colors.background,
      borderColor: colors.border,
      child: Row(
        children: [
          IconTheme.merge(
            data: IconThemeData(color: colors.foreground, size: 20),
            child: icon ?? Icon(defaultIcon),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: DefaultTextStyle.merge(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyle(
                size: 13,
                weight: FontWeight.w900,
                color: colors.foreground,
                height: 1.25,
              ),
              child: child,
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 10),
            DefaultTextStyle.merge(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyle(
                size: 12,
                weight: FontWeight.w900,
                color: colors.foreground,
                height: 1.1,
              ),
              child: action!,
            ),
          ],
          if (showChevron) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              size: 19,
              color: colors.foreground,
            ),
          ],
        ],
      ),
    );
  }
}

class AnimalMobileAddressCard extends StatelessWidget {
  const AnimalMobileAddressCard({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    this.tag,
    this.leading,
    this.trailing,
    this.onTap,
    this.selected = false,
  });

  final Widget name;
  final Widget phone;
  final Widget address;
  final Widget? tag;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return _MobileCardShell(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      radius: 24,
      borderColor: selected ? theme.primaryColor : null,
      backgroundColor: selected
          ? theme.primaryBackgroundColor
          : theme.elevatedBackgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.subtleBackgroundColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? theme.primaryColor : theme.controlBorderColor,
                width: 2,
              ),
            ),
            child: leading ??
                Icon(
                  Icons.place_rounded,
                  color: selected ? theme.primaryColor : theme.mutedIconColor,
                  size: 22,
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    DefaultTextStyle.merge(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle(
                        size: 15,
                        weight: FontWeight.w900,
                        color: theme.textColor,
                        height: 1.15,
                      ),
                      child: name,
                    ),
                    DefaultTextStyle.merge(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle(
                        size: 13,
                        weight: FontWeight.w800,
                        color: theme.secondaryTextColor,
                        height: 1.15,
                      ),
                      child: phone,
                    ),
                    if (tag != null) tag!,
                  ],
                ),
                const SizedBox(height: 7),
                DefaultTextStyle.merge(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyle(
                    size: 13,
                    weight: FontWeight.w800,
                    color: theme.bodyTextColor,
                    height: 1.28,
                  ),
                  child: address,
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ] else if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.mutedIconColor,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }
}

class AnimalMobilePriceSummary extends StatelessWidget {
  const AnimalMobilePriceSummary({
    super.key,
    required this.items,
    this.totalLabel,
    this.total,
    this.footer,
  });

  final List<AnimalMobilePriceItem> items;
  final Widget? totalLabel;
  final Widget? total;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return _MobileCardShell(
      padding: const EdgeInsets.all(14),
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final indexed in items.indexed) ...[
            _PriceSummaryRow(item: indexed.$2),
            if (indexed.$1 != items.length - 1) const SizedBox(height: 10),
          ],
          if (total != null || totalLabel != null) ...[
            const SizedBox(height: 13),
            Divider(height: 1, thickness: 1, color: theme.lightBorderColor),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DefaultTextStyle.merge(
                    style: theme.textStyle(
                      size: 14,
                      weight: FontWeight.w900,
                      color: theme.textColor,
                    ),
                    child: totalLabel ?? const Text('合计'),
                  ),
                ),
                if (total != null)
                  DefaultTextStyle.merge(
                    style: theme.textStyle(
                      size: 19,
                      weight: FontWeight.w900,
                      color: theme.errorColor,
                      height: 1.1,
                    ),
                    child: total!,
                  ),
              ],
            ),
          ],
          if (footer != null) ...[
            const SizedBox(height: 12),
            footer!,
          ],
        ],
      ),
    );
  }
}

class AnimalMobileCheckoutBar extends StatelessWidget {
  const AnimalMobileCheckoutBar({
    super.key,
    required this.total,
    required this.action,
    this.label,
    this.extra,
    this.safeAreaBottom = true,
    this.padding = const EdgeInsets.fromLTRB(14, 10, 14, 10),
  });

  final Widget total;
  final Widget action;
  final Widget? label;
  final Widget? extra;
  final bool safeAreaBottom;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final bottom = safeAreaBottom ? MediaQuery.paddingOf(context).bottom : 0.0;

    return Container(
      padding: padding.add(EdgeInsets.only(bottom: bottom)),
      decoration: BoxDecoration(
        color: theme.elevatedBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.controlBorderColor, width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.tactileShadowColor.withValues(alpha: 0.20),
            offset: const Offset(0, -3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle.merge(
                  style: theme.textStyle(
                    size: 12,
                    weight: FontWeight.w900,
                    color: theme.secondaryTextColor,
                    height: 1.1,
                  ),
                  child: label ?? const Text('合计'),
                ),
                const SizedBox(height: 3),
                DefaultTextStyle.merge(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyle(
                    size: 21,
                    weight: FontWeight.w900,
                    color: theme.errorColor,
                    height: 1.05,
                  ),
                  child: total,
                ),
                if (extra != null) ...[
                  const SizedBox(height: 3),
                  DefaultTextStyle.merge(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyle(
                      size: 11,
                      weight: FontWeight.w800,
                      color: theme.secondaryTextColor,
                      height: 1.1,
                    ),
                    child: extra!,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          action,
        ],
      ),
    );
  }
}

class AnimalMobileCartItem extends StatelessWidget {
  const AnimalMobileCartItem({
    super.key,
    required this.title,
    this.subtitle,
    this.price,
    this.image,
    this.quantity,
    this.onQuantityChanged,
    this.selected = false,
    this.onSelectedChanged,
    this.action,
    this.tag,
    this.disabled = false,
    this.disabledText,
    this.onTap,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? price;
  final Widget? image;
  final num? quantity;
  final ValueChanged<num>? onQuantityChanged;
  final bool selected;
  final ValueChanged<bool>? onSelectedChanged;
  final Widget? action;
  final Widget? tag;
  final bool disabled;
  final Widget? disabledText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final interactive = !disabled;

    return Opacity(
      opacity: disabled ? 0.62 : 1,
      child: _MobileCardShell(
        onTap: interactive ? onTap : null,
        padding: const EdgeInsets.all(12),
        radius: 24,
        borderColor: selected ? theme.primaryColor : null,
        backgroundColor: selected
            ? theme.primaryBackgroundColor
            : theme.elevatedBackgroundColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (onSelectedChanged != null) ...[
              _MobileSelectionButton(
                selected: selected,
                enabled: interactive,
                onTap: () => onSelectedChanged?.call(!selected),
              ),
              const SizedBox(width: 10),
            ],
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: theme.primaryBackgroundColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.controlBorderColor, width: 2),
              ),
              clipBehavior: Clip.antiAlias,
              child: image ??
                  Icon(
                    Icons.shopping_bag_rounded,
                    color: theme.primaryColor,
                    size: 34,
                  ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DefaultTextStyle.merge(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textStyle(
                            size: 15,
                            weight: FontWeight.w900,
                            color: theme.textColor,
                            height: 1.18,
                          ),
                          child: title,
                        ),
                      ),
                      if (tag != null) ...[
                        const SizedBox(width: 8),
                        tag!,
                      ],
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    DefaultTextStyle.merge(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle(
                        size: 12,
                        weight: FontWeight.w700,
                        color: theme.secondaryTextColor,
                        height: 1.2,
                      ),
                      child: subtitle!,
                    ),
                  ],
                  if (disabledText != null) ...[
                    const SizedBox(height: 6),
                    DefaultTextStyle.merge(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle(
                        size: 12,
                        weight: FontWeight.w900,
                        color: theme.errorColor,
                        height: 1.1,
                      ),
                      child: disabledText!,
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (price != null)
                        Expanded(
                          child: DefaultTextStyle.merge(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textStyle(
                              size: 16,
                              weight: FontWeight.w900,
                              color: disabled
                                  ? theme.disabledTextColor
                                  : theme.errorColor,
                              height: 1.1,
                            ),
                            child: price!,
                          ),
                        )
                      else
                        const Spacer(),
                      if (quantity != null && onQuantityChanged != null)
                        AnimalMobileStepper(
                          value: quantity,
                          min: 0,
                          max: 999,
                          disabled: disabled,
                          onChanged: onQuantityChanged,
                        )
                      else if (quantity != null)
                        Text(
                          'x${_formatNumber(quantity!)}',
                          style: theme.textStyle(
                            size: 13,
                            weight: FontWeight.w900,
                            color: theme.secondaryTextColor,
                          ),
                        )
                      else if (action != null)
                        action!,
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimalMobileOrderTimeline extends StatelessWidget {
  const AnimalMobileOrderTimeline({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.all(14),
  });

  final List<AnimalMobileTimelineItem> items;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return _MobileCardShell(
      padding: padding,
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final indexed in items.indexed)
            _MobileTimelineRow(
              item: indexed.$2,
              first: indexed.$1 == 0,
              last: indexed.$1 == items.length - 1,
            ),
        ],
      ),
    );
  }
}

class AnimalMobilePaymentMethodCard extends StatelessWidget {
  const AnimalMobilePaymentMethodCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.selected = false,
    this.disabled = false,
    this.onTap,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? icon;
  final Widget? trailing;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final enabled = !disabled;

    return Opacity(
      opacity: disabled ? 0.58 : 1,
      child: _MobileCardShell(
        onTap: enabled ? onTap : null,
        padding: const EdgeInsets.all(14),
        radius: 22,
        borderColor: selected ? theme.primaryColor : null,
        backgroundColor: selected
            ? theme.primaryBackgroundColor
            : theme.elevatedBackgroundColor,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.subtleBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      selected ? theme.primaryColor : theme.controlBorderColor,
                  width: 2,
                ),
              ),
              child: IconTheme.merge(
                data: IconThemeData(
                  color: selected ? theme.primaryColor : theme.mutedIconColor,
                  size: 23,
                ),
                child: icon ?? const Icon(Icons.payments_rounded),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle.merge(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyle(
                      size: 15,
                      weight: FontWeight.w900,
                      color: theme.textColor,
                      height: 1.15,
                    ),
                    child: title,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    DefaultTextStyle.merge(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle(
                        size: 12,
                        weight: FontWeight.w700,
                        color: theme.secondaryTextColor,
                        height: 1.2,
                      ),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            trailing ??
                Icon(
                  selected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color:
                      selected ? theme.primaryColor : theme.disabledTextColor,
                  size: 23,
                ),
          ],
        ),
      ),
    );
  }
}

class AnimalMobileEmptyAction extends StatelessWidget {
  const AnimalMobileEmptyAction({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.padding = const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
  });

  final Widget title;
  final Widget? description;
  final Widget? icon;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    return _MobileCardShell(
      padding: padding,
      radius: 28,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.primaryBackgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: theme.primaryColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: theme.tactileShadowColor.withValues(alpha: 0.20),
                  offset: const Offset(0, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: IconTheme.merge(
              data: IconThemeData(color: theme.primaryColor, size: 36),
              child: icon ?? const Icon(Icons.inbox_rounded),
            ),
          ),
          const SizedBox(height: 14),
          DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textStyle(
              size: 18,
              weight: FontWeight.w900,
              color: theme.textColor,
              height: 1.18,
            ),
            child: title,
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            DefaultTextStyle.merge(
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyle(
                size: 13,
                weight: FontWeight.w700,
                color: theme.secondaryTextColor,
                height: 1.28,
              ),
              child: description!,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: 16),
            action!,
          ],
        ],
      ),
    );
  }
}

class _BottomBarButton extends StatefulWidget {
  const _BottomBarButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AnimalBottomBarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_BottomBarButton> createState() => _BottomBarButtonState();
}

class _BottomBarButtonState extends State<_BottomBarButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final active = widget.selected || _hovered || _focused;
    final color =
        widget.selected ? theme.primaryColor : theme.secondaryTextColor;

    return Semantics(
      button: true,
      selected: widget.selected,
      child: FocusableActionDetector(
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
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() {
            _hovered = false;
            _pressed = false;
          }),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) {
              setState(() => _pressed = false);
              widget.onTap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(
                color: widget.selected
                    ? theme.primaryBackgroundColor.withValues(alpha: 0.75)
                    : active
                        ? theme.subtleBackgroundColor
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                border: active
                    ? Border.all(
                        color: widget.selected
                            ? theme.primaryColor
                            : theme.controlBorderColor,
                        width: 1.5,
                      )
                    : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconTheme.merge(
                        data: IconThemeData(color: color, size: 23),
                        child: widget.selected
                            ? (widget.item.activeIcon ?? widget.item.icon)
                            : widget.item.icon,
                      ),
                      if (widget.item.badge != null)
                        Positioned(
                          right: -12,
                          top: -8,
                          child: widget.item.badge!,
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  DefaultTextStyle.merge(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyle(
                      size: 11,
                      weight:
                          widget.selected ? FontWeight.w900 : FontWeight.w800,
                      color: color,
                      height: 1,
                    ),
                    child: widget.item.label,
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

class _MobileIconButton extends StatefulWidget {
  const _MobileIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  State<_MobileIconButton> createState() => _MobileIconButtonState();
}

class _MobileIconButtonState extends State<_MobileIconButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final active = _enabled && (_hovered || _focused);
    return Semantics(
      button: true,
      enabled: _enabled,
      child: FocusableActionDetector(
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
              widget.onTap?.call();
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor:
              _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onEnter: _enabled ? (_) => setState(() => _hovered = true) : null,
          onExit: _enabled
              ? (_) => setState(() {
                    _hovered = false;
                    _pressed = false;
                  })
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
            onTapCancel:
                _enabled ? () => setState(() => _pressed = false) : null,
            onTapUp: _enabled
                ? (_) {
                    setState(() => _pressed = false);
                    widget.onTap?.call();
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              width: 40,
              height: 40,
              transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
              decoration: BoxDecoration(
                color: _enabled
                    ? (active ? theme.subtleBackgroundColor : Colors.white)
                    : theme.disabledBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: active ? theme.primaryColor : theme.controlBorderColor,
                  width: 2,
                ),
              ),
              child: Icon(
                widget.icon,
                size: 21,
                color: _enabled ? theme.textColor : theme.disabledTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileCircleAction extends StatefulWidget {
  const _MobileCircleAction({
    required this.icon,
    required this.onTap,
    this.size = 34,
    this.iconSize = 18,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;

  @override
  State<_MobileCircleAction> createState() => _MobileCircleActionState();
}

class _MobileCircleActionState extends State<_MobileCircleAction> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onTap != null;

  void _tap() {
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final active = _enabled && (_hovered || _focused);

    return Semantics(
      button: true,
      enabled: _enabled,
      child: FocusableActionDetector(
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
              _tap();
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor:
              _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onEnter: _enabled ? (_) => setState(() => _hovered = true) : null,
          onExit: _enabled
              ? (_) => setState(() {
                    _hovered = false;
                    _pressed = false;
                  })
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
            onTapCancel:
                _enabled ? () => setState(() => _pressed = false) : null,
            onTapUp: _enabled
                ? (_) {
                    setState(() => _pressed = false);
                    _tap();
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              width: widget.size,
              height: widget.size,
              transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
              decoration: BoxDecoration(
                color: _enabled
                    ? (active
                        ? theme.primaryBackgroundColor
                        : theme.subtleBackgroundColor)
                    : theme.disabledBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: active ? theme.primaryColor : theme.controlBorderColor,
                  width: 2,
                ),
              ),
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: _enabled ? theme.textColor : theme.disabledTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileTextAction extends StatefulWidget {
  const _MobileTextAction({
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<_MobileTextAction> createState() => _MobileTextActionState();
}

class _MobileTextActionState extends State<_MobileTextAction> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onTap != null;

  void _tap() {
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final active = _enabled && (_hovered || _focused);

    return Semantics(
      button: true,
      enabled: _enabled,
      child: FocusableActionDetector(
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
              _tap();
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor:
              _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onEnter: _enabled ? (_) => setState(() => _hovered = true) : null,
          onExit: _enabled
              ? (_) => setState(() {
                    _hovered = false;
                    _pressed = false;
                  })
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
            onTapCancel:
                _enabled ? () => setState(() => _pressed = false) : null,
            onTapUp: _enabled
                ? (_) {
                    setState(() => _pressed = false);
                    _tap();
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: active ? theme.primaryBackgroundColor : null,
                borderRadius: BorderRadius.circular(999),
              ),
              child: DefaultTextStyle.merge(
                style: theme.textStyle(
                  size: 14,
                  weight: FontWeight.w900,
                  color:
                      _enabled ? theme.primaryColor : theme.disabledTextColor,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SwipeActionButton extends StatelessWidget {
  const _SwipeActionButton({
    required this.action,
    required this.width,
    required this.onClose,
  });

  final AnimalSwipeActionItem action;
  final double width;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final background = action.color ??
        (action.destructive ? theme.errorColor : theme.primaryColor);
    final foreground =
        action.disabled ? Colors.white.withValues(alpha: 0.62) : Colors.white;

    return SizedBox(
      width: width,
      height: double.infinity,
      child: FocusableActionDetector(
        enabled: !action.disabled,
        mouseCursor: action.disabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              if (!action.disabled) {
                action.onTap();
                onClose();
              }
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor: action.disabled
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: action.disabled
                ? null
                : () {
                    action.onTap();
                    onClose();
                  },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: action.disabled
                    ? theme.disabledTextColor
                    : background.withValues(alpha: 0.94),
                border: Border(
                  left: BorderSide(
                    color: theme.controlBorderColor.withValues(alpha: 0.75),
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (action.icon != null) ...[
                      IconTheme.merge(
                        data: IconThemeData(color: foreground, size: 20),
                        child: action.icon!,
                      ),
                      const SizedBox(height: 4),
                    ],
                    DefaultTextStyle.merge(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle(
                        size: 12,
                        weight: FontWeight.w900,
                        color: foreground,
                        height: 1.1,
                      ),
                      child: action.label,
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
}

class _MobileCardShell extends StatefulWidget {
  const _MobileCardShell({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(14),
    this.radius = 24,
    this.backgroundColor,
    this.borderColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  State<_MobileCardShell> createState() => _MobileCardShellState();
}

class _MobileCardShellState extends State<_MobileCardShell> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onTap != null;

  void _tap() {
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final active = _enabled && (_hovered || _focused);

    return Semantics(
      button: _enabled,
      enabled: _enabled,
      child: FocusableActionDetector(
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
              _tap();
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor:
              _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onEnter: _enabled ? (_) => setState(() => _hovered = true) : null,
          onExit: _enabled
              ? (_) => setState(() {
                    _hovered = false;
                    _pressed = false;
                  })
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
            onTapCancel:
                _enabled ? () => setState(() => _pressed = false) : null,
            onTapUp: _enabled
                ? (_) {
                    setState(() => _pressed = false);
                    _tap();
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(
                0,
                _enabled ? (_pressed ? 2 : (active ? -1 : 0)) : 0,
                0,
              ),
              padding: widget.padding,
              decoration: BoxDecoration(
                color: widget.backgroundColor ??
                    (active
                        ? theme.subtleBackgroundColor
                        : theme.elevatedBackgroundColor),
                borderRadius: BorderRadius.circular(widget.radius),
                border: Border.all(
                  color: widget.borderColor ??
                      (active ? theme.primaryColor : theme.controlBorderColor),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.tactileShadowColor.withValues(alpha: 0.18),
                    offset: Offset(0, _pressed ? 1 : 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  const _OrderItemRow(this.item);

  final AnimalMobileOrderItem item;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.primaryBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.controlBorderColor, width: 2),
          ),
          clipBehavior: Clip.antiAlias,
          child: item.leading ??
              Icon(
                Icons.inventory_2_rounded,
                color: theme.primaryColor,
                size: 24,
              ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle.merge(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyle(
                  size: 13,
                  weight: FontWeight.w900,
                  color: theme.textColor,
                ),
                child: item.title,
              ),
              if (item.subtitle != null) ...[
                const SizedBox(height: 2),
                DefaultTextStyle.merge(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyle(
                    size: 12,
                    weight: FontWeight.w700,
                    color: theme.secondaryTextColor,
                  ),
                  child: item.subtitle!,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (item.price != null)
              DefaultTextStyle.merge(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyle(
                  size: 13,
                  weight: FontWeight.w900,
                  color: theme.textColor,
                ),
                child: item.price!,
              ),
            if (item.quantity != null) ...[
              const SizedBox(height: 2),
              Text(
                'x${item.quantity}',
                style: theme.textStyle(
                  size: 12,
                  weight: FontWeight.w800,
                  color: theme.secondaryTextColor,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _MobileSelectionButton extends StatefulWidget {
  const _MobileSelectionButton({
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  State<_MobileSelectionButton> createState() => _MobileSelectionButtonState();
}

class _MobileSelectionButtonState extends State<_MobileSelectionButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final active = widget.enabled && (_hovered || _focused || widget.selected);

    return Semantics(
      button: true,
      checked: widget.selected,
      enabled: widget.enabled,
      child: FocusableActionDetector(
        enabled: widget.enabled,
        mouseCursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
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
              if (widget.enabled) {
                widget.onTap();
              }
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor: widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter:
              widget.enabled ? (_) => setState(() => _hovered = true) : null,
          onExit: widget.enabled
              ? (_) => setState(() {
                    _hovered = false;
                    _pressed = false;
                  })
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.enabled ? widget.onTap : null,
            onTapDown:
                widget.enabled ? (_) => setState(() => _pressed = true) : null,
            onTapCancel:
                widget.enabled ? () => setState(() => _pressed = false) : null,
            onTapUp:
                widget.enabled ? (_) => setState(() => _pressed = false) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: widget.selected
                    ? theme.primaryColor
                    : active
                        ? theme.primaryBackgroundColor
                        : theme.subtleBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: active ? theme.primaryColor : theme.controlBorderColor,
                  width: 2,
                ),
              ),
              child: widget.selected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 18)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileTimelineRow extends StatelessWidget {
  const _MobileTimelineRow({
    required this.item,
    required this.first,
    required this.last,
  });

  final AnimalMobileTimelineItem item;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final colors = _mobileTimelineColors(theme, item.status);
    final enabled = item.onTap != null && !item.disabled;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: first ? Colors.transparent : colors.line,
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.foreground, width: 2),
                  ),
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color: colors.foreground,
                      size: item.icon == null ? 13 : 15,
                    ),
                    child: item.icon ?? const Icon(Icons.circle),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: last ? Colors.transparent : colors.line,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 14),
              child: _MobileTimelineContent(
                item: item,
                colors: colors,
                enabled: enabled,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileTimelineContent extends StatefulWidget {
  const _MobileTimelineContent({
    required this.item,
    required this.colors,
    required this.enabled,
  });

  final AnimalMobileTimelineItem item;
  final _MobileTimelineColors colors;
  final bool enabled;

  @override
  State<_MobileTimelineContent> createState() => _MobileTimelineContentState();
}

class _MobileTimelineContentState extends State<_MobileTimelineContent> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final active = widget.enabled && (_hovered || _focused);

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color:
            active ? theme.primaryBackgroundColor : theme.subtleBackgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? theme.primaryColor : theme.lightBorderColor,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DefaultTextStyle.merge(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyle(
                    size: 14,
                    weight: FontWeight.w900,
                    color: widget.item.disabled
                        ? theme.disabledTextColor
                        : theme.textColor,
                    height: 1.18,
                  ),
                  child: widget.item.title,
                ),
              ),
              if (widget.item.time != null) ...[
                const SizedBox(width: 10),
                DefaultTextStyle.merge(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textStyle(
                    size: 11,
                    weight: FontWeight.w800,
                    color: theme.secondaryTextColor,
                    height: 1.15,
                  ),
                  child: widget.item.time!,
                ),
              ],
            ],
          ),
          if (widget.item.description != null) ...[
            const SizedBox(height: 5),
            DefaultTextStyle.merge(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyle(
                size: 12,
                weight: FontWeight.w700,
                color: theme.secondaryTextColor,
                height: 1.25,
              ),
              child: widget.item.description!,
            ),
          ],
        ],
      ),
    );

    return Semantics(
      button: widget.enabled,
      enabled: widget.enabled,
      child: FocusableActionDetector(
        enabled: widget.enabled,
        mouseCursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
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
              widget.item.onTap?.call();
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor: widget.enabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter:
              widget.enabled ? (_) => setState(() => _hovered = true) : null,
          onExit: widget.enabled
              ? (_) => setState(() {
                    _hovered = false;
                    _pressed = false;
                  })
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.enabled ? widget.item.onTap : null,
            onTapDown:
                widget.enabled ? (_) => setState(() => _pressed = true) : null,
            onTapCancel:
                widget.enabled ? () => setState(() => _pressed = false) : null,
            onTapUp:
                widget.enabled ? (_) => setState(() => _pressed = false) : null,
            child: content,
          ),
        ),
      ),
    );
  }
}

class _PriceSummaryRow extends StatelessWidget {
  const _PriceSummaryRow({required this.item});

  final AnimalMobilePriceItem item;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final valueColor = item.color ??
        (item.emphasized ? theme.errorColor : theme.bodyTextColor);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: DefaultTextStyle.merge(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textStyle(
              size: item.emphasized ? 14 : 13,
              weight: item.emphasized ? FontWeight.w900 : FontWeight.w800,
              color:
                  item.emphasized ? theme.textColor : theme.secondaryTextColor,
              height: 1.2,
            ),
            child: item.label,
          ),
        ),
        const SizedBox(width: 12),
        DefaultTextStyle.merge(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textStyle(
            size: item.emphasized ? 15 : 13,
            weight: FontWeight.w900,
            color: valueColor,
            height: 1.2,
          ),
          child: item.value,
        ),
      ],
    );
  }
}

class _MobileStatCard extends StatelessWidget {
  const _MobileStatCard({required this.item});

  final AnimalMobileStatItem item;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final accent = item.color ?? theme.primaryColor;

    return _MobileCardShell(
      onTap: item.onTap,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      radius: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null) ...[
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.55)),
              ),
              child: IconTheme.merge(
                data: IconThemeData(color: accent, size: 18),
                child: item.icon!,
              ),
            ),
            const SizedBox(height: 7),
          ],
          DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textStyle(
              size: 18,
              weight: FontWeight.w900,
              color: theme.textColor,
              height: 1.05,
            ),
            child: item.value,
          ),
          const SizedBox(height: 4),
          DefaultTextStyle.merge(
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textStyle(
              size: 11,
              weight: FontWeight.w800,
              color: theme.secondaryTextColor,
              height: 1.1,
            ),
            child: item.label,
          ),
          if (item.description != null) ...[
            const SizedBox(height: 4),
            DefaultTextStyle.merge(
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyle(
                size: 10,
                weight: FontWeight.w700,
                color: accent,
                height: 1.1,
              ),
              child: item.description!,
            ),
          ],
        ],
      ),
    );
  }
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String _formatNumber(num value) {
  if (value is int || value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
}

_MobileNoticeColors _mobileNoticeColors(
  AnimalThemeData theme,
  AnimalMobileNoticeType type,
) {
  return switch (type) {
    AnimalMobileNoticeType.info => _MobileNoticeColors(
        background: theme.primaryBackgroundColor,
        foreground: theme.primaryActiveColor,
        border: theme.primaryColor,
      ),
    AnimalMobileNoticeType.success => const _MobileNoticeColors(
        background: Color(0xFFEAF7D8),
        foreground: Color(0xFF5A9E1E),
        border: Color(0xFF9DD56E),
      ),
    AnimalMobileNoticeType.warning => const _MobileNoticeColors(
        background: Color(0xFFFFF3C2),
        foreground: Color(0xFF9A7410),
        border: Color(0xFFF5C31C),
      ),
    AnimalMobileNoticeType.error => const _MobileNoticeColors(
        background: Color(0xFFFFE0DD),
        foreground: Color(0xFFE05A5A),
        border: Color(0xFFFFA19A),
      ),
  };
}

class _MobileNoticeColors {
  const _MobileNoticeColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

_MobileTimelineColors _mobileTimelineColors(
  AnimalThemeData theme,
  AnimalMobileTimelineStatus status,
) {
  return switch (status) {
    AnimalMobileTimelineStatus.defaultStatus => _MobileTimelineColors(
        background: theme.disabledBackgroundColor,
        foreground: theme.secondaryTextColor,
        line: theme.lightBorderColor,
      ),
    AnimalMobileTimelineStatus.success => const _MobileTimelineColors(
        background: Color(0xFFEAF7D8),
        foreground: Color(0xFF5A9E1E),
        line: Color(0xFFB7D995),
      ),
    AnimalMobileTimelineStatus.warning => const _MobileTimelineColors(
        background: Color(0xFFFFF3C2),
        foreground: Color(0xFF9A7410),
        line: Color(0xFFE6CF78),
      ),
    AnimalMobileTimelineStatus.error => const _MobileTimelineColors(
        background: Color(0xFFFFE0DD),
        foreground: Color(0xFFE05A5A),
        line: Color(0xFFEAA59E),
      ),
    AnimalMobileTimelineStatus.processing => _MobileTimelineColors(
        background: theme.primaryBackgroundColor,
        foreground: theme.primaryActiveColor,
        line: theme.primaryColor.withValues(alpha: 0.45),
      ),
  };
}

class _MobileTimelineColors {
  const _MobileTimelineColors({
    required this.background,
    required this.foreground,
    required this.line,
  });

  final Color background;
  final Color foreground;
  final Color line;
}
