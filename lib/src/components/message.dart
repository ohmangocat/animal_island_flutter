import 'package:flutter/material.dart';

import '../animal_theme.dart';

enum AnimalMessageType { info, success, warning, error }

class AnimalMessage {
  const AnimalMessage._();

  static OverlayEntry show(
    BuildContext context, {
    required Widget child,
    AnimalMessageType type = AnimalMessageType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _AnimalMessageOverlay(
        type: type,
        duration: duration,
        onDone: () {
          if (entry.mounted) {
            entry.remove();
          }
        },
        child: child,
      ),
    );
    overlay.insert(entry);
    return entry;
  }

  static OverlayEntry info(
    BuildContext context,
    Widget child, {
    Duration duration = const Duration(seconds: 2),
  }) =>
      show(context, child: child, duration: duration);

  static OverlayEntry success(
    BuildContext context,
    Widget child, {
    Duration duration = const Duration(seconds: 2),
  }) =>
      show(context,
          child: child, type: AnimalMessageType.success, duration: duration);

  static OverlayEntry warning(
    BuildContext context,
    Widget child, {
    Duration duration = const Duration(seconds: 2),
  }) =>
      show(context,
          child: child, type: AnimalMessageType.warning, duration: duration);

  static OverlayEntry error(
    BuildContext context,
    Widget child, {
    Duration duration = const Duration(seconds: 2),
  }) =>
      show(context,
          child: child, type: AnimalMessageType.error, duration: duration);
}

class _AnimalMessageOverlay extends StatefulWidget {
  const _AnimalMessageOverlay({
    required this.child,
    required this.type,
    required this.duration,
    required this.onDone,
  });

  final Widget child;
  final AnimalMessageType type;
  final Duration duration;
  final VoidCallback onDone;

  @override
  State<_AnimalMessageOverlay> createState() => _AnimalMessageOverlayState();
}

class _AnimalMessageOverlayState extends State<_AnimalMessageOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
    )..forward();
    Future<void>.delayed(widget.duration, () async {
      await _dismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_closing || !mounted) {
      return;
    }
    _closing = true;
    await _controller.reverse();
    if (mounted) {
      widget.onDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 24,
      left: 16,
      right: 16,
      child: IgnorePointer(
        child: Center(
          child: FadeTransition(
            opacity:
                CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.2),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
              ),
              child: _AnimalMessageCard(type: widget.type, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimalMessageCard extends StatelessWidget {
  const _AnimalMessageCard({required this.type, required this.child});

  final AnimalMessageType type;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final color = _messageColor(theme, type);
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.elevatedBackgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: theme.tactileShadowColor,
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: DefaultTextStyle.merge(
            style: theme.textStyle(
              size: 14,
              weight: FontWeight.w700,
              color: theme.textColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_messageIcon(type)),
                const SizedBox(width: 8),
                Flexible(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _messageColor(AnimalThemeData theme, AnimalMessageType type) {
  return switch (type) {
    AnimalMessageType.info => theme.primaryColor,
    AnimalMessageType.success => theme.successColor,
    AnimalMessageType.warning => theme.warningColor,
    AnimalMessageType.error => theme.errorColor,
  };
}

String _messageIcon(AnimalMessageType type) {
  return switch (type) {
    AnimalMessageType.info => '💬',
    AnimalMessageType.success => '✓',
    AnimalMessageType.warning => '!',
    AnimalMessageType.error => '×',
  };
}
