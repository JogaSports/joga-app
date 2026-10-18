import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Pulsing placeholder blocks shown while a screen loads, instead of a
/// spinner, so the layout appears straight away. Still when the device asks
/// for reduced motion.
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, required this.child});

  final Widget child;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 1).animate(_controller),
      child: widget.child,
    );
  }
}

/// One grey block.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = Radii.md,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Generic screen skeleton: heading, a row of tiles and a few cards. Good
/// enough for every screen in the app.
class ScreenSkeleton extends StatelessWidget {
  const ScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading',
      child: Skeleton(
        // shrinkWrap so it also works inside another list (unbounded
        // height), e.g. a section that loads inside a screen.
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            Space.gutter,
            Space.lg,
            Space.gutter,
            Space.xl,
          ),
          children: const [
            SkeletonBox(width: 120, height: 14, radius: Radii.sm),
            SizedBox(height: Space.sm),
            SkeletonBox(width: 200, height: 30, radius: Radii.sm),
            SizedBox(height: Space.lg),
            Row(
              children: [
                Expanded(child: SkeletonBox(height: 70)),
                SizedBox(width: Space.sm),
                Expanded(child: SkeletonBox(height: 70)),
                SizedBox(width: Space.sm),
                Expanded(child: SkeletonBox(height: 70)),
              ],
            ),
            SizedBox(height: Space.lg),
            SkeletonBox(height: 170),
            SizedBox(height: Space.md),
            SkeletonBox(height: 100),
            SizedBox(height: Space.md),
            SkeletonBox(height: 100),
          ],
        ),
      ),
    );
  }
}
