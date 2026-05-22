import 'package:flutter/material.dart';

import '../animal_theme.dart';

enum AnimalFormLayout { vertical, horizontal, inline }

class AnimalForm extends StatelessWidget {
  const AnimalForm({
    super.key,
    required this.child,
    this.formKey,
    this.layout = AnimalFormLayout.vertical,
    this.labelWidth = 112,
    this.spacing = 16,
    this.autovalidateMode,
    this.onChanged,
  });

  final Widget child;
  final GlobalKey<FormState>? formKey;
  final AnimalFormLayout layout;
  final double labelWidth;
  final double spacing;
  final AutovalidateMode? autovalidateMode;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return _AnimalFormScope(
      layout: layout,
      labelWidth: labelWidth,
      spacing: spacing,
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        onChanged: onChanged,
        child: child,
      ),
    );
  }
}

class AnimalFormItem extends StatelessWidget {
  const AnimalFormItem({
    super.key,
    required this.child,
    this.label,
    this.required = false,
    this.help,
    this.errorText,
    this.layout,
    this.labelWidth,
    this.margin,
  });

  final Widget child;
  final Widget? label;
  final bool required;
  final Widget? help;
  final String? errorText;
  final AnimalFormLayout? layout;
  final double? labelWidth;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final scope = _AnimalFormScope.maybeOf(context);
    final effectiveLayout =
        layout ?? scope?.layout ?? AnimalFormLayout.vertical;
    final effectiveLabelWidth = labelWidth ?? scope?.labelWidth ?? 112;
    final effectiveMargin =
        margin ?? EdgeInsets.only(bottom: scope?.spacing ?? 16);

    return Padding(
      padding: effectiveMargin,
      child: switch (effectiveLayout) {
        AnimalFormLayout.horizontal => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: effectiveLabelWidth,
                child: Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: _FormItemLabel(label: label, required: required),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: _FormItemBody(
                      help: help, errorText: errorText, child: child)),
            ],
          ),
        AnimalFormLayout.inline => Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _FormItemLabel(label: label, required: required),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 180, maxWidth: 360),
                child: _FormItemBody(
                    help: help, errorText: errorText, child: child),
              ),
            ],
          ),
        AnimalFormLayout.vertical => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null) ...[
                _FormItemLabel(label: label, required: required),
                const SizedBox(height: 8),
              ],
              _FormItemBody(help: help, errorText: errorText, child: child),
            ],
          ),
      },
    );
  }
}

class _FormItemLabel extends StatelessWidget {
  const _FormItemLabel({required this.label, required this.required});

  final Widget? label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return const SizedBox.shrink();
    }
    final theme = AnimalTheme.of(context);
    return DefaultTextStyle.merge(
      style: theme.textStyle(
        size: 13,
        weight: FontWeight.w900,
        color: theme.bodyTextColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (required) ...[
            Text(
              '*',
              style: theme.textStyle(
                size: 13,
                weight: FontWeight.w900,
                color: theme.errorColor,
              ),
            ),
            const SizedBox(width: 3),
          ],
          Flexible(child: label!),
        ],
      ),
    );
  }
}

class _FormItemBody extends StatelessWidget {
  const _FormItemBody({
    required this.child,
    this.help,
    this.errorText,
  });

  final Widget child;
  final Widget? help;
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
          Text(
            errorText!,
            style: theme.textStyle(
              size: 12,
              weight: FontWeight.w800,
              color: theme.errorColor,
              height: 1.2,
            ),
          ),
        ] else if (help != null) ...[
          const SizedBox(height: 6),
          DefaultTextStyle.merge(
            style: theme.textStyle(
              size: 12,
              weight: FontWeight.w600,
              color: theme.secondaryTextColor,
              height: 1.25,
            ),
            child: help!,
          ),
        ],
      ],
    );
  }
}

class _AnimalFormScope extends InheritedWidget {
  const _AnimalFormScope({
    required super.child,
    required this.layout,
    required this.labelWidth,
    required this.spacing,
  });

  final AnimalFormLayout layout;
  final double labelWidth;
  final double spacing;

  static _AnimalFormScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AnimalFormScope>();
  }

  @override
  bool updateShouldNotify(covariant _AnimalFormScope oldWidget) {
    return oldWidget.layout != layout ||
        oldWidget.labelWidth != labelWidth ||
        oldWidget.spacing != spacing;
  }
}
