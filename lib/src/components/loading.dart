import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../animal_theme.dart';

class AnimalLoading extends StatefulWidget {
  const AnimalLoading({
    super.key,
    this.size = 28,
    this.strokeWidth = 3,
    this.active = true,
    this.style = AnimalLoadingStyle.island,
  });

  final double size;
  final double strokeWidth;
  final bool active;
  final AnimalLoadingStyle style;

  @override
  State<AnimalLoading> createState() => _AnimalLoadingState();
}

class _AnimalLoadingState extends State<AnimalLoading>
    with TickerProviderStateMixin {
  late final AnimationController _motionController;
  late final AnimationController _revealController;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      value: widget.active ? 0 : 1,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && !widget.active) {
          _motionController.stop();
        }
      });
    if (widget.active) {
      _motionController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant AnimalLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active) {
      _revealController
        ..stop()
        ..value = 0;
      if (!_motionController.isAnimating) {
        _motionController.repeat();
      }
    } else if (oldWidget.active) {
      if (widget.style == AnimalLoadingStyle.island) {
        if (!_motionController.isAnimating) {
          _motionController.repeat();
        }
        _revealController.forward(from: 0);
      } else {
        _motionController.stop();
      }
    }
  }

  @override
  void dispose() {
    _motionController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AnimalTheme.of(context);

    final child = switch (widget.style) {
      AnimalLoadingStyle.island => _IslandLoading(
          motion: _motionController,
          reveal: _revealController,
        ),
      AnimalLoadingStyle.spinner => RotationTransition(
          turns: _motionController,
          child: SizedBox.square(
            dimension: widget.size,
            child: CircularProgressIndicator(
              strokeWidth: widget.strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
          ),
        ),
      AnimalLoadingStyle.stripes => SizedBox(
          width: widget.size * 2.4,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _motionController,
            builder: (context, _) {
              return CustomPaint(
                painter: _StripeLoadingPainter(
                  progress: _motionController.value,
                  borderColor: const Color(0xFF4DE2DA),
                ),
              );
            },
          ),
        ),
    };

    if (widget.style == AnimalLoadingStyle.island) {
      return child;
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: widget.active ? 1 : 0.45,
      child: child,
    );
  }
}

enum AnimalLoadingStyle { island, spinner, stripes }

class _IslandLoading extends StatelessWidget {
  const _IslandLoading({
    required this.motion,
    required this.reveal,
  });

  final Animation<double> motion;
  final Animation<double> reveal;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([motion, reveal]),
      builder: (context, child) {
        return ClipPath(
          clipper: _LoadingRevealClipper(progress: reveal.value),
          child: child,
        );
      },
      child: Container(
        color: Colors.black,
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.only(right: 20, bottom: 20),
        child: AnimatedBuilder(
          animation: motion,
          builder: (context, child) {
            final phase = math.sin(motion.value * math.pi * 2);
            return Transform.translate(
              offset: Offset(0, -7.5 - phase * 7.5),
              child: Transform.rotate(
                angle: phase * math.pi / 180,
                alignment: Alignment.bottomCenter,
                child: child,
              ),
            );
          },
          child: SvgPicture.asset(
            'assets/animal_island/img/loading/loading-island.svg',
            package: 'animal_island_flutter',
            width: 180,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _LoadingRevealClipper extends CustomClipper<Path> {
  const _LoadingRevealClipper({required this.progress});

  final double progress;

  @override
  Path getClip(Size size) {
    final rect = Path()..addRect(Offset.zero & size);
    if (progress <= 0) {
      return rect;
    }

    final radius =
        (math.sqrt(size.width * size.width + size.height * size.height) / 2 +
                50) *
            Curves.linear.transform(progress.clamp(0, 1));
    final cutout = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: radius,
        ),
      );
    return Path.combine(PathOperation.difference, rect, cutout);
  }

  @override
  bool shouldReclip(covariant _LoadingRevealClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

class _StripeLoadingPainter extends CustomPainter {
  const _StripeLoadingPainter({
    required this.progress,
    required this.borderColor,
  });

  final double progress;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height / 2);
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, radius);
    final clipPath = Path()..addRRect(rrect);

    canvas.save();
    canvas.clipPath(clipPath);
    canvas.drawRRect(
      rrect,
      Paint()..color = const Color(0xFF0EC4B6),
    );

    final stripePaint = Paint()..color = const Color(0xFF01B0A7);
    final spacing = 14.0;
    final offset = progress * spacing * 2;
    for (var x = -size.height * 2 - offset;
        x < size.width + size.height * 2;
        x += spacing * 2) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + spacing, size.height)
        ..lineTo(x + spacing + size.height, 0)
        ..lineTo(x + size.height, 0)
        ..close();
      canvas.drawPath(path, stripePaint);
    }
    canvas.restore();

    canvas.drawRRect(
      rrect.deflate(1.5),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.min(4, size.height / 5),
    );
  }

  @override
  bool shouldRepaint(covariant _StripeLoadingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.borderColor != borderColor;
  }
}
