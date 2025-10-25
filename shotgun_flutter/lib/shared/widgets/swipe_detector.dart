import 'package:flutter/material.dart';

class SwipeDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final double minSwipeDistance;

  const SwipeDetector({
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
    this.minSwipeDistance = 50.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (details) {
        final velocity = details.velocity.pixelsPerSecond;

        // Check horizontal swipe
        if (velocity.dx.abs() > velocity.dy.abs()) {
          if (velocity.dx < -minSwipeDistance && onSwipeLeft != null) {
            onSwipeLeft!();
          } else if (velocity.dx > minSwipeDistance && onSwipeRight != null) {
            onSwipeRight!();
          }
        }
        // Check vertical swipe
        else {
          if (velocity.dy < -minSwipeDistance && onSwipeUp != null) {
            onSwipeUp!();
          } else if (velocity.dy > minSwipeDistance && onSwipeDown != null) {
            onSwipeDown!();
          }
        }
      },
      child: child,
    );
  }
}
