import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/shared/widgets/swipe_detector.dart';

void main() {
  group('SwipeDetector', () {
    testWidgets('should call onSwipeLeft', (tester) async {
      var swipedLeft = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwipeDetector(
              onSwipeLeft: () {
                swipedLeft = true;
              },
              child: const Text('Swipe me'),
            ),
          ),
        ),
      );

      // Simulate swipe left with fling
      await tester.fling(find.text('Swipe me'), const Offset(-200, 0), 1000);
      await tester.pumpAndSettle();

      expect(swipedLeft, true);
    });

    testWidgets('should call onSwipeRight', (tester) async {
      var swipedRight = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwipeDetector(
              onSwipeRight: () {
                swipedRight = true;
              },
              child: const Text('Swipe me'),
            ),
          ),
        ),
      );

      // Simulate swipe right with fling
      await tester.fling(find.text('Swipe me'), const Offset(200, 0), 1000);
      await tester.pumpAndSettle();

      expect(swipedRight, true);
    });

    testWidgets('should call onSwipeUp', (tester) async {
      var swipedUp = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwipeDetector(
              onSwipeUp: () {
                swipedUp = true;
              },
              child: const Text('Swipe me'),
            ),
          ),
        ),
      );

      // Simulate swipe up with fling
      await tester.fling(find.text('Swipe me'), const Offset(0, -200), 1000);
      await tester.pumpAndSettle();

      expect(swipedUp, true);
    });

    testWidgets('should call onSwipeDown', (tester) async {
      var swipedDown = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwipeDetector(
              onSwipeDown: () {
                swipedDown = true;
              },
              child: const Text('Swipe me'),
            ),
          ),
        ),
      );

      // Simulate swipe down with fling
      await tester.fling(find.text('Swipe me'), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();

      expect(swipedDown, true);
    });

    testWidgets('should not call callback when swipe distance is too small', (
      tester,
    ) async {
      var swipedLeft = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwipeDetector(
              onSwipeLeft: () {
                swipedLeft = true;
              },
              minSwipeDistance: 100.0,
              child: const Text('Swipe me'),
            ),
          ),
        ),
      );

      // Simulate small swipe left with fling (less than minSwipeDistance)
      await tester.fling(find.text('Swipe me'), const Offset(-50, 0), 100);
      await tester.pumpAndSettle();

      expect(swipedLeft, false);
    });

    testWidgets('should not call callback when callback is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SwipeDetector(child: Text('Swipe me'))),
        ),
      );

      // Simulate swipe left with fling (should not crash)
      await tester.fling(find.text('Swipe me'), const Offset(-200, 0), 1000);
      await tester.pumpAndSettle();

      // If we get here without crashing, the test passes
      expect(find.text('Swipe me'), findsOneWidget);
    });
  });
}
