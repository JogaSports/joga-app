import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A short burst of confetti for big moments (booking confirmed, streak
/// milestones). Drawn in code, no package. Skipped entirely when the device
/// or the app's settings ask for reduced motion.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({super.key, this.particles = 70});

  final int particles;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );
  late final List<_Piece> _pieces;

  static const _colours = [
    AppColors.lime,
    AppColors.fire,
    AppColors.textPrimary,
    Color(0xFF7FB3D5),
  ];

  @override
  void initState() {
    super.initState();
    final random = math.Random(7);
    _pieces = [
      for (var i = 0; i < widget.particles; i++)
        _Piece(
          angle: -math.pi / 2 + (random.nextDouble() - 0.5) * math.pi * 0.9,
          speed: 0.55 + random.nextDouble() * 0.6,
          spin: (random.nextDouble() - 0.5) * 14,
          size: 5 + random.nextDouble() * 6,
          colour: _colours[i % _colours.length],
          delay: random.nextDouble() * 0.15,
        ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!MediaQuery.disableAnimationsOf(context) && !_controller.isAnimating) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return const SizedBox.shrink();
    return IgnorePointer(
      child: ExcludeSemantics(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(_pieces, _controller.value),
          ),
        ),
      ),
    );
  }
}

class _Piece {
  const _Piece({
    required this.angle,
    required this.speed,
    required this.spin,
    required this.size,
    required this.colour,
    required this.delay,
  });

  final double angle;
  final double speed;
  final double spin;
  final double size;
  final Color colour;
  final double delay;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, this.t);

  final List<_Piece> pieces;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, size.height * 0.32);
    final reach = size.height * 0.75;
    for (final p in pieces) {
      final local = ((t - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;
      final dx = math.cos(p.angle) * p.speed * reach * local;
      final dy = math.sin(p.angle) * p.speed * reach * local +
          0.9 * reach * local * local; // gravity
      final opacity = (1 - local).clamp(0.0, 1.0);
      final paint = Paint()..color = p.colour.withValues(alpha: opacity);
      canvas
        ..save()
        ..translate(origin.dx + dx, origin.dy + dy)
        ..rotate(p.spin * local)
        ..drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset.zero,
              width: p.size,
              height: p.size * 0.5,
            ),
            const Radius.circular(1.5),
          ),
          paint,
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.t != t;
}
