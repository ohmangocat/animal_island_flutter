import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animal_theme.dart';

enum AnimalButtonType { primary, defaultType, dashed, text, link }

enum AnimalButtonSize { small, middle, large }

class AnimalButton extends StatefulWidget {
  const AnimalButton({
    super.key,
    required this.child,
    this.onPressed,
    this.type = AnimalButtonType.defaultType,
    this.size = AnimalButtonSize.middle,
    this.danger = false,
    this.ghost = false,
    this.block = false,
    this.loading = false,
    this.disabled = false,
    this.icon,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final AnimalButtonType type;
  final AnimalButtonSize size;
  final bool danger;
  final bool ghost;
  final bool block;
  final bool loading;
  final bool disabled;
  final Widget? icon;

  @override
  State<AnimalButton> createState() => _AnimalButtonState();
}

class _AnimalButtonState extends State<AnimalButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loadingController;
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled =>
      widget.onPressed != null && !widget.disabled && !widget.loading;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    if (widget.loading) {
      _loadingController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimalButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading && !_loadingController.isAnimating) {
      _loadingController.repeat();
    } else if (!widget.loading && _loadingController.isAnimating) {
      _loadingController.stop();
      _loadingController.value = 0;
    }
    if (!_enabled) {
      _hovered = false;
      _pressed = false;
      _focused = false;
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final metrics = _metricsFor(theme, widget.size);
    final colors = _colorsFor(theme);
    final highlighted = _hovered || _focused;
    final bottomShadow =
        _enabled ? (_pressed ? 1.0 : (highlighted ? 6.0 : 5.0)) : 5.0;
    final yOffset =
        _enabled ? (_pressed ? 2.0 : (highlighted ? -1.0 : 0.0)) : 0.0;
    final showBottomShadow =
        widget.type == AnimalButtonType.primary && !widget.ghost;

    final buttonTextStyle = theme.textStyle(
      size: metrics.fontSize,
      weight: FontWeight.w600,
      color: widget.disabled ? theme.disabledTextColor : colors.foreground,
    );
    final buttonChild = DefaultTextStyle.merge(
      style: theme
          .textStyle(
            size: metrics.fontSize,
            weight: FontWeight.w600,
            color:
                widget.disabled ? theme.disabledTextColor : colors.foreground,
          )
          .copyWith(overflow: TextOverflow.ellipsis),
      child: IconTheme.merge(
        data: IconThemeData(
          color: widget.disabled ? theme.disabledTextColor : colors.foreground,
          size: metrics.fontSize + 2,
        ),
        child: Row(
          mainAxisSize: widget.block ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!widget.loading && widget.icon != null) ...[
              widget.icon!,
              const SizedBox(width: 8),
            ],
            if (widget.block)
              Flexible(child: widget.child)
            else
              Flexible(
                fit: FlexFit.loose,
                child: DefaultTextStyle.merge(
                  style: buttonTextStyle.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                  child: widget.child,
                ),
              ),
          ],
        ),
      ),
    );

    Widget content = widget.loading
        ? AnimatedBuilder(
            animation: _loadingController,
            child: buttonChild,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                height: metrics.height,
                width: widget.block ? double.infinity : null,
                transform: Matrix4.translationValues(0, yOffset, 0),
                child: DecoratedBox(
                  decoration: _ButtonLoadingStripeDecoration(
                    progress: _loadingController.value,
                    borderColor: colors.border,
                    backgroundColor: colors.background,
                    stripeColor: theme.primaryStripeColor,
                  ),
                  child: Padding(
                    padding: metrics.padding,
                    child: child,
                  ),
                ),
              );
            },
          )
        : AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: metrics.height,
            width: widget.block ? double.infinity : null,
            transform: Matrix4.translationValues(0, yOffset, 0),
            padding: metrics.padding,
            decoration: _buttonDecoration(
              theme: theme,
              metrics: metrics,
              colors: colors,
              showBottomShadow: showBottomShadow,
              bottomShadow: bottomShadow,
            ),
            foregroundDecoration: widget.type == AnimalButtonType.dashed
                ? ShapeDecoration(
                    shape: _DashedStadiumBorder(
                      color: colors.border,
                      width: theme.borderWidth,
                    ),
                  )
                : null,
            child: buttonChild,
          );

    final interactive = MouseRegion(
      cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
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
              if (_enabled) {
                widget.onPressed?.call();
              }
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
          onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
          onTapUp: _enabled
              ? (_) {
                  setState(() => _pressed = false);
                  widget.onPressed?.call();
                }
              : null,
          child: Opacity(
            opacity: widget.disabled ? 0.5 : 1,
            child: content,
          ),
        ),
      ),
    );

    if (widget.block) {
      return SizedBox(width: double.infinity, child: interactive);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.hasBoundedWidth &&
            constraints.maxWidth.isFinite &&
            constraints.maxWidth <
                metrics.height + metrics.padding.horizontal) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: interactive,
          );
        }

        return UnconstrainedBox(
          alignment: Alignment.centerLeft,
          constrainedAxis: Axis.vertical,
          child: interactive,
        );
      },
    );
  }

  Decoration _buttonDecoration({
    required AnimalThemeData theme,
    required _ButtonMetrics metrics,
    required _ButtonColors colors,
    required bool showBottomShadow,
    required double bottomShadow,
  }) {
    final borderRadius = BorderRadius.circular(metrics.radius);
    return BoxDecoration(
      color: colors.background,
      borderRadius: borderRadius,
      border: widget.type == AnimalButtonType.dashed
          ? null
          : Border.all(
              color: colors.border,
              width: theme.borderWidth,
            ),
      boxShadow: widget.type == AnimalButtonType.text ||
              widget.type == AnimalButtonType.link ||
              widget.ghost ||
              widget.disabled
          ? null
          : showBottomShadow
              ? [
                  BoxShadow(
                    color: widget.danger
                        ? const Color(0xFFC94444)
                        : theme.tactileShadowColor,
                    offset: Offset(0, bottomShadow),
                    blurRadius: 0,
                  ),
                ]
              : (_hovered || _focused ? theme.shadowBase : theme.shadowSmall),
    );
  }

  _ButtonColors _colorsFor(AnimalThemeData theme) {
    if (widget.loading) {
      return _ButtonColors(
        background: theme.primaryStripeBackgroundColor,
        foreground: Colors.white,
        border: theme.primaryStripeBorderColor,
      );
    }

    if (widget.ghost && widget.type == AnimalButtonType.primary) {
      return _ButtonColors(
        background: _hovered || _focused
            ? theme.primaryColor.withValues(alpha: 0.08)
            : Colors.transparent,
        foreground:
            _hovered || _focused ? theme.primaryHoverColor : theme.primaryColor,
        border: _hovered || _focused
            ? theme.primaryHoverColor
            : theme.backgroundColor,
      );
    }

    if (widget.type == AnimalButtonType.primary && widget.danger) {
      return _ButtonColors(
        background: widget.ghost ? Colors.transparent : theme.errorColor,
        foreground: Colors.white,
        border: widget.ghost ? theme.errorColor : theme.errorColor,
      );
    }

    if (widget.danger &&
        (widget.type == AnimalButtonType.defaultType ||
            widget.type == AnimalButtonType.dashed)) {
      return _ButtonColors(
        background: theme.backgroundColor,
        foreground: theme.errorColor,
        border: theme.errorColor,
      );
    }

    switch (widget.type) {
      case AnimalButtonType.primary:
        return _ButtonColors(
          background: widget.ghost ? Colors.transparent : theme.backgroundColor,
          foreground: widget.ghost ? theme.primaryColor : theme.textColor,
          border: widget.ghost ? theme.primaryColor : theme.backgroundColor,
        );
      case AnimalButtonType.defaultType:
        return _ButtonColors(
          background: theme.backgroundColor,
          foreground:
              _hovered || _focused ? theme.primaryColor : theme.textColor,
          border: _hovered || _focused ? theme.primaryColor : theme.borderColor,
        );
      case AnimalButtonType.dashed:
        return _ButtonColors(
          background: theme.backgroundColor,
          foreground:
              _hovered || _focused ? theme.primaryColor : theme.textColor,
          border: _hovered || _focused ? theme.primaryColor : theme.borderColor,
        );
      case AnimalButtonType.text:
        return _ButtonColors(
          background: _hovered || _focused
              ? theme.secondaryBackgroundColor
              : Colors.transparent,
          foreground: widget.danger ? Colors.white : theme.textColor,
          border: Colors.transparent,
        );
      case AnimalButtonType.link:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: widget.danger ? Colors.white : theme.primaryColor,
          border: Colors.transparent,
        );
    }
  }
}

class _ButtonLoadingStripeDecoration extends Decoration {
  const _ButtonLoadingStripeDecoration({
    required this.progress,
    required this.borderColor,
    required this.backgroundColor,
    required this.stripeColor,
  });

  final double progress;
  final Color borderColor;
  final Color backgroundColor;
  final Color stripeColor;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _ButtonLoadingStripePainter(this, onChanged);
  }

  @override
  EdgeInsetsGeometry get padding => const EdgeInsets.all(4);
}

class _ButtonLoadingStripePainter extends BoxPainter {
  _ButtonLoadingStripePainter(this.decoration, super.onChanged);

  static const _borderWidth = 4.0;
  static const _stripePeriod = 28.28;
  static const _stripeWidth = _stripePeriod / 2;
  static const _animationDistance = _stripePeriod;

  final _ButtonLoadingStripeDecoration decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size == null) {
      return;
    }

    final rect = offset & size;
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(size.height / 2),
    );

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRRect(rrect, Paint()..color = decoration.backgroundColor);

    final stripePaint = Paint()..color = decoration.stripeColor;
    final shift = decoration.progress * _animationDistance;
    for (var x = rect.left - size.height * 2 - shift;
        x < rect.right + size.height * 2;
        x += _stripePeriod) {
      final stripePath = Path()
        ..moveTo(x, rect.bottom)
        ..lineTo(x + _stripeWidth, rect.bottom)
        ..lineTo(x + _stripeWidth + size.height, rect.top)
        ..lineTo(x + size.height, rect.top)
        ..close();
      canvas.drawPath(stripePath, stripePaint);
    }
    canvas.restore();

    canvas.drawRRect(
      rrect.deflate(_borderWidth / 2),
      Paint()
        ..color = decoration.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _borderWidth,
    );
  }
}

_ButtonMetrics _metricsFor(AnimalThemeData theme, AnimalButtonSize size) {
  switch (size) {
    case AnimalButtonSize.small:
      return _ButtonMetrics(
        height: theme.heightSmall,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        radius: theme.radiusSmall,
        fontSize: 12,
      );
    case AnimalButtonSize.middle:
      return const _ButtonMetrics(
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: 20),
        radius: 50,
        fontSize: 14,
      );
    case AnimalButtonSize.large:
      return _ButtonMetrics(
        height: theme.heightLarge,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        radius: theme.radiusLarge,
        fontSize: 16,
      );
  }
}

class _ButtonMetrics {
  const _ButtonMetrics({
    required this.height,
    required this.padding,
    required this.radius,
    required this.fontSize,
  });

  final double height;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double fontSize;
}

class _ButtonColors {
  const _ButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}

class _DashedStadiumBorder extends ShapeBorder {
  const _DashedStadiumBorder({
    required this.color,
    required this.width,
  });

  final Color color;
  final double width;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(_rrect(rect.deflate(width)));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(_rrect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final path = Path()..addRRect(_rrect(rect.deflate(width / 2)));
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + 6, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += 12;
      }
    }
  }

  @override
  ShapeBorder scale(double t) {
    return _DashedStadiumBorder(color: color, width: width * t);
  }

  RRect _rrect(Rect rect) {
    return RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2));
  }
}
