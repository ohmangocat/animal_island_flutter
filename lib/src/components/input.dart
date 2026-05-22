import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animal_theme.dart';

enum AnimalInputSize { small, middle, large }

enum AnimalInputStatus { error, warning }

class AnimalInput extends StatefulWidget {
  const AnimalInput({
    super.key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.size = AnimalInputSize.middle,
    this.prefix,
    this.suffix,
    this.allowClear = false,
    this.status,
    this.shadow = false,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onClear,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final AnimalInputSize size;
  final Widget? prefix;
  final Widget? suffix;
  final bool allowClear;
  final AnimalInputStatus? status;
  final bool shadow;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onClear;

  @override
  State<AnimalInput> createState() => _AnimalInputState();
}

class _AnimalInputState extends State<AnimalInput> {
  late TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _ownsController = false;
  bool _hovered = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _controller.addListener(_handleTextChanged);
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant AnimalInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_handleTextChanged);
      if (_ownsController) {
        _controller.dispose();
      }
      _ownsController = widget.controller == null;
      final nextController =
          widget.controller ?? TextEditingController(text: widget.initialValue);
      _controller = nextController;
      _controller.addListener(_handleTextChanged);
    } else if (_ownsController &&
        oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null &&
        widget.initialValue != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.initialValue!,
        selection: TextSelection.collapsed(offset: widget.initialValue!.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
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
    final metrics = _inputMetricsFor(theme, widget.size);
    final statusColor = switch (widget.status) {
      AnimalInputStatus.error => theme.errorColor,
      AnimalInputStatus.warning => theme.warningColor,
      null => null,
    };
    final borderColor = !widget.enabled
        ? theme.controlBorderColor
        : statusColor ??
            (_hovered || _focused
                ? theme.borderHoverColor
                : theme.disabledTextColor);
    final shadowColor = switch (widget.status) {
      AnimalInputStatus.error => const Color(0xFFC94444),
      AnimalInputStatus.warning => const Color(0xFFDBA90E),
      null => _hovered ? theme.tactileShadowColor : theme.controlBorderColor,
    };
    final effectiveMaxLines = widget.obscureText ? 1 : widget.maxLines;
    final multiline = (effectiveMaxLines ?? 1) > 1;
    final padding = multiline ? metrics.textareaPadding : metrics.padding;

    return MouseRegion(
      cursor:
          widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: multiline ? null : metrics.height,
        constraints: BoxConstraints(
          minHeight: metrics.height,
        ),
        padding: padding,
        decoration: BoxDecoration(
          color: widget.enabled
              ? theme.contentBackgroundColor
              : theme.disabledBackgroundColor,
          border: Border.all(
            color: borderColor,
            width: metrics.borderWidth,
          ),
          borderRadius: BorderRadius.circular(multiline ? 24 : 50),
          boxShadow: widget.enabled && widget.shadow
              ? [
                  BoxShadow(
                    color: shadowColor,
                    offset: Offset(0, metrics.shadowOffset),
                    blurRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Opacity(
          opacity: widget.enabled ? 1 : 0.6,
          child: Row(
            crossAxisAlignment: multiline
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (widget.prefix != null) ...[
                IconTheme.merge(
                  data: IconThemeData(color: theme.mutedIconColor),
                  child: widget.prefix!,
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  textCapitalization: widget.textCapitalization,
                  autofillHints: widget.autofillHints,
                  maxLines: effectiveMaxLines,
                  maxLength: widget.maxLength,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  onEditingComplete: widget.onEditingComplete,
                  style: theme.textStyle(
                    size: metrics.fontSize,
                    weight: FontWeight.w500,
                    color: theme.bodyTextColor,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: theme.textStyle(
                      size: metrics.fontSize,
                      weight: FontWeight.w400,
                      color: theme.disabledTextColor,
                    ),
                    contentPadding: EdgeInsets.only(top: multiline ? 2 : 0),
                    counterText: '',
                  ),
                ),
              ),
              if (widget.allowClear &&
                  _controller.text.isNotEmpty &&
                  widget.enabled)
                _InputClearButton(
                  margin: EdgeInsets.only(
                    left: 4,
                    top: multiline ? 2 : 0,
                  ),
                  onTap: () {
                    _controller.clear();
                    widget.onClear?.call();
                    widget.onChanged?.call('');
                  },
                ),
              if (widget.suffix != null) ...[
                const SizedBox(width: 6),
                IconTheme.merge(
                  data: IconThemeData(color: theme.mutedIconColor),
                  child: widget.suffix!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AnimalInputFormField extends FormField<String> {
  AnimalInputFormField({
    super.key,
    String? initialValue,
    TextEditingController? controller,
    String? hintText,
    AnimalInputSize size = AnimalInputSize.middle,
    Widget? prefix,
    Widget? suffix,
    bool allowClear = false,
    AnimalInputStatus? status,
    bool shadow = false,
    super.enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Iterable<String>? autofillHints,
    int? maxLines = 1,
    int? maxLength,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onEditingComplete,
    VoidCallback? onClear,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onSaved,
    super.validator,
    super.restorationId,
  }) : super(
          initialValue: controller == null ? initialValue : controller.text,
          builder: (field) {
            final theme = AnimalTheme.of(field.context);
            final hasError = field.hasError;
            final effectiveStatus = hasError ? AnimalInputStatus.error : status;
            final effectiveSuffix = hasError
                ? Tooltip(
                    message: field.errorText ?? '',
                    child: Icon(
                      Icons.error_rounded,
                      color: theme.errorColor,
                      size: 18,
                    ),
                  )
                : suffix;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimalInput(
                  controller: controller,
                  initialValue: field.value,
                  hintText: hintText,
                  size: size,
                  prefix: prefix,
                  suffix: effectiveSuffix,
                  allowClear: allowClear,
                  status: effectiveStatus,
                  shadow: shadow,
                  enabled: enabled,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  textCapitalization: textCapitalization,
                  autofillHints: autofillHints,
                  maxLines: maxLines,
                  maxLength: maxLength,
                  onChanged: (value) {
                    field.didChange(value);
                    onChanged?.call(value);
                  },
                  onSubmitted: onSubmitted,
                  onEditingComplete: onEditingComplete,
                  onClear: () {
                    field.didChange('');
                    onClear?.call();
                    onChanged?.call('');
                  },
                ),
                if (field.hasError) ...[
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Text(
                      field.errorText!,
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
          },
        );
}

class _InputClearButton extends StatefulWidget {
  const _InputClearButton({
    required this.onTap,
    this.margin = const EdgeInsets.only(left: 4),
  });

  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;

  @override
  State<_InputClearButton> createState() => _InputClearButtonState();
}

class _InputClearButtonState extends State<_InputClearButton> {
  final _focusNode = FocusNode();
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final highlighted = _hovered || _focused;

    return Semantics(
      button: true,
      enabled: true,
      label: '清除输入',
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
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            onTap: () {
              _focusNode.requestFocus();
              widget.onTap();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
              width: 20,
              height: 20,
              margin: widget.margin,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: highlighted
                    ? theme.bodyTextColor.withValues(alpha: 0.10)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '×',
                style: TextStyle(
                  color: highlighted
                      ? theme.bodyTextColor
                      : theme.disabledTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
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

_InputMetrics _inputMetricsFor(AnimalThemeData theme, AnimalInputSize size) {
  switch (size) {
    case AnimalInputSize.small:
      return _InputMetrics(
        height: theme.heightSmall,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        textareaPadding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
        fontSize: 12,
        borderWidth: 2,
        shadowOffset: 2,
      );
    case AnimalInputSize.middle:
      return _InputMetrics(
        height: theme.height,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        textareaPadding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
        fontSize: 14,
        borderWidth: 2,
        shadowOffset: 3,
      );
    case AnimalInputSize.large:
      return _InputMetrics(
        height: theme.heightLarge,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        textareaPadding: const EdgeInsets.fromLTRB(22, 16, 16, 16),
        fontSize: 16,
        borderWidth: 2.5,
        shadowOffset: 4,
      );
  }
}

class _InputMetrics {
  const _InputMetrics({
    required this.height,
    required this.padding,
    required this.textareaPadding,
    required this.fontSize,
    required this.borderWidth,
    required this.shadowOffset,
  });

  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry textareaPadding;
  final double fontSize;
  final double borderWidth;
  final double shadowOffset;
}
