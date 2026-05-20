import 'dart:async';

import 'package:flutter/material.dart';

import '../animal_theme.dart';

class AnimalTime extends StatefulWidget {
  const AnimalTime({
    super.key,
    this.now,
  });

  final DateTime? now;

  @override
  State<AnimalTime> createState() => _AnimalTimeState();
}

class _AnimalTimeState extends State<AnimalTime> {
  late DateTime _now;
  Timer? _timer;
  Timer? _blinkTimer;
  bool _colonVisible = true;

  @override
  void initState() {
    super.initState();
    _now = widget.now ?? DateTime.now();
    if (widget.now == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _now = DateTime.now());
      });
    }
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() => _colonVisible = !_colonVisible);
    });
  }

  @override
  void didUpdateWidget(covariant AnimalTime oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.now != null && widget.now != oldWidget.now) {
      setState(() => _now = widget.now!);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    final weekday = const [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ][_now.weekday - 1];
    final month = const [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][_now.month - 1];
    final monthDay = '$month ${_now.day}';
    final hour = _now.hour.toString().padLeft(2, '0');
    final minute = _now.minute.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF8F8F0)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4CFC3), width: 3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weekday,
                  style: theme
                      .textStyle(
                        size: 14,
                        weight: FontWeight.w900,
                        color: theme.successColor,
                      )
                      .copyWith(letterSpacing: 1.5),
                ),
                Text(
                  monthDay,
                  style: theme.textStyle(
                    size: 22,
                    weight: FontWeight.w900,
                    color: const Color(0xFF8B7355),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 3, height: 52, color: const Color(0x599F927D)),
          const SizedBox(width: 24),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: hour),
                TextSpan(
                  text: ':',
                  style: TextStyle(
                    color: const Color(0xFF8B7355)
                        .withValues(alpha: _colonVisible ? 1 : 0),
                    fontSize: 48,
                    height: 1,
                  ),
                ),
                TextSpan(text: minute),
              ],
            ),
            style: theme
                .textStyle(
                  size: 48,
                  weight: FontWeight.w900,
                  color: const Color(0xFF8B7355),
                )
                .copyWith(letterSpacing: 2),
          ),
        ],
      ),
    );
  }
}
