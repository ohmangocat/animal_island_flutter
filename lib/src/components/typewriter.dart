import 'dart:async';

import 'package:flutter/material.dart';

class AnimalTypewriter extends StatefulWidget {
  const AnimalTypewriter({
    super.key,
    required this.text,
    this.speed = const Duration(milliseconds: 90),
    this.trigger,
    this.autoPlay = true,
    this.style,
    this.onDone,
  });

  final String text;
  final Duration speed;
  final Object? trigger;
  final bool autoPlay;
  final TextStyle? style;
  final VoidCallback? onDone;

  @override
  State<AnimalTypewriter> createState() => _AnimalTypewriterState();
}

class _AnimalTypewriterState extends State<AnimalTypewriter> {
  Timer? _timer;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void didUpdateWidget(covariant AnimalTypewriter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger || oldWidget.text != widget.text) {
      _start();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = widget.autoPlay
        ? widget.text.characters.take(_count).toString()
        : widget.text;
    return Text(visible, style: widget.style);
  }

  void _start() {
    _timer?.cancel();
    if (!widget.autoPlay) {
      setState(() => _count = widget.text.characters.length);
      return;
    }
    setState(() => _count = 0);
    _timer = Timer.periodic(widget.speed, (timer) {
      if (_count >= widget.text.characters.length) {
        timer.cancel();
        widget.onDone?.call();
      } else {
        setState(() => _count += 1);
      }
    });
  }
}
