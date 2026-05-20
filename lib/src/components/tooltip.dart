import 'package:flutter/material.dart';

import '../animal_theme.dart';

class AnimalTooltip extends StatelessWidget {
  const AnimalTooltip({
    super.key,
    required this.message,
    required this.child,
    this.preferBelow = false,
    this.waitDuration = const Duration(milliseconds: 350),
    this.showDuration = const Duration(seconds: 3),
  });

  final String message;
  final Widget child;
  final bool preferBelow;
  final Duration waitDuration;
  final Duration showDuration;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      waitDuration: waitDuration,
      showDuration: showDuration,
      textStyle: theme.textStyle(
        size: 12,
        weight: FontWeight.w700,
        color: const Color(0xFF794F27),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8D6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD9C889), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 3),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );
  }
}
