import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/shared/services/haptic_service.dart';

void main() {
  group('HapticService', () {
    testWidgets('should call lightImpact', (tester) async {
      await HapticService.lightImpact();
      // If we get here without exception, test passes
      expect(true, true);
    });

    testWidgets('should call mediumImpact', (tester) async {
      await HapticService.mediumImpact();
      // If we get here without exception, test passes
      expect(true, true);
    });

    testWidgets('should call heavyImpact', (tester) async {
      await HapticService.heavyImpact();
      // If we get here without exception, test passes
      expect(true, true);
    });

    testWidgets('should call selectionClick', (tester) async {
      await HapticService.selectionClick();
      // If we get here without exception, test passes
      expect(true, true);
    });

    testWidgets('should call vibrate', (tester) async {
      await HapticService.vibrate();
      // If we get here without exception, test passes
      expect(true, true);
    });
  });
}
