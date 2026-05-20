import 'package:flutter/material.dart';

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
    this.onChanged,
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
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  @override
  State<AnimalInput> createState() => _AnimalInputState();
}

class _AnimalInputState extends State<AnimalInput> {
  late TextEditingController _controller;
  bool _ownsController = false;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _controller.addListener(_handleTextChanged);
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
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChanged() {
    setState(() {});
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
        ? const Color(0xFFD4C9B4)
        : statusColor ??
            (_hovered ? const Color(0xFFA89878) : theme.disabledTextColor);
    final shadowColor = switch (widget.status) {
      AnimalInputStatus.error => const Color(0xFFC94444),
      AnimalInputStatus.warning => const Color(0xFFDBA90E),
      null => _hovered ? const Color(0xFFC4B89E) : const Color(0xFFD4C9B4),
    };

    return MouseRegion(
      cursor:
          widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: metrics.height,
        padding: metrics.padding,
        decoration: BoxDecoration(
          color: widget.enabled
              ? const Color(0xFFF7F3DF)
              : theme.disabledBackgroundColor,
          border: Border.all(
            color: borderColor,
            width: metrics.borderWidth,
          ),
          borderRadius: BorderRadius.circular(50),
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
            children: [
              if (widget.prefix != null) ...[
                IconTheme.merge(
                  data: const IconThemeData(color: Color(0xFFA0936E)),
                  child: widget.prefix!,
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChanged,
                  style: theme.textStyle(
                    size: metrics.fontSize,
                    weight: FontWeight.w500,
                    color: const Color(0xFF725D42),
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
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (widget.allowClear &&
                  _controller.text.isNotEmpty &&
                  widget.enabled)
                _InputClearButton(
                  onTap: () {
                    _controller.clear();
                    widget.onClear?.call();
                    widget.onChanged?.call('');
                  },
                ),
              if (widget.suffix != null) ...[
                const SizedBox(width: 6),
                IconTheme.merge(
                  data: const IconThemeData(color: Color(0xFFA0936E)),
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

class _InputClearButton extends StatefulWidget {
  const _InputClearButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_InputClearButton> createState() => _InputClearButtonState();
}

class _InputClearButtonState extends State<_InputClearButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(left: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF725D42).withValues(alpha: 0.10)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            '×',
            style: TextStyle(
              color:
                  _hovered ? const Color(0xFF725D42) : const Color(0xFFC4B89E),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

_InputMetrics _inputMetricsFor(AnimalThemeData theme, AnimalInputSize size) {
  switch (size) {
    case AnimalInputSize.small:
      return _InputMetrics(
        height: theme.heightSmall,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        fontSize: 12,
        borderWidth: 2,
        shadowOffset: 2,
      );
    case AnimalInputSize.middle:
      return _InputMetrics(
        height: theme.height,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        fontSize: 14,
        borderWidth: 2,
        shadowOffset: 3,
      );
    case AnimalInputSize.large:
      return _InputMetrics(
        height: theme.heightLarge,
        padding: const EdgeInsets.symmetric(horizontal: 22),
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
    required this.fontSize,
    required this.borderWidth,
    required this.shadowOffset,
  });

  final double height;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double borderWidth;
  final double shadowOffset;
}
