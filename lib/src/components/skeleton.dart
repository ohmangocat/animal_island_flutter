import 'package:flutter/material.dart';

import '../animal_theme.dart';

class AnimalSkeleton extends StatefulWidget {
  const AnimalSkeleton({
    super.key,
    this.active = true,
    this.rows = 3,
    this.width,
    this.lineHeight = 14,
    this.child,
  });

  final bool active;
  final int rows;
  final double? width;
  final double lineHeight;
  final Widget? child;

  @override
  State<AnimalSkeleton> createState() => _AnimalSkeletonState();
}

class _AnimalSkeletonState extends State<AnimalSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    if (widget.active) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimalSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.active && widget.child != null) {
      return widget.child!;
    }

    final rows = widget.rows.clamp(1, 8);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < rows; index++) ...[
          _SkeletonBar(
            animation: _controller,
            height: widget.lineHeight,
            widthFactor: index == rows - 1 ? 0.68 : 1,
            width: widget.width,
          ),
          if (index != rows - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({
    required this.animation,
    required this.height,
    required this.widthFactor,
    this.width,
  });

  final Animation<double> animation;
  final double height;
  final double widthFactor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);
    return FractionallySizedBox(
      widthFactor: width == null ? widthFactor : null,
      child: SizedBox(
        width: width == null ? null : width! * widthFactor,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final progress = animation.value;
            return Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height),
                border: Border.all(color: theme.lightBorderColor, width: 1),
                gradient: LinearGradient(
                  begin: Alignment(-1.6 + progress * 3.2, 0),
                  end: Alignment(-0.6 + progress * 3.2, 0),
                  colors: [
                    theme.secondaryBackgroundColor,
                    theme.elevatedBackgroundColor,
                    theme.secondaryBackgroundColor,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
