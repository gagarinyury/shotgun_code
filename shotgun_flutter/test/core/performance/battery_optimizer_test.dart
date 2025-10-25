import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/core/performance/battery_optimizer.dart';
import 'dart:async';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('BatteryOptimizer', () {
    late BatteryOptimizer batteryOptimizer;

    setUp(() {
      batteryOptimizer = BatteryOptimizer();
    });

    tearDown(() {
      batteryOptimizer.dispose();
    });

    test('should initialize with default values', () {
      expect(batteryOptimizer.isLowPowerMode, false);
      expect(batteryOptimizer.batteryState, null);
      expect(batteryOptimizer.batteryLevel, null);
    });

    test('should return performance settings based on battery state', () {
      // Test with default (not low power mode)
      final settings = batteryOptimizer.getRecommendedSettings();
      expect(settings.enableAnimations, true);
      expect(settings.reducedRefreshRate, false);
      expect(settings.backgroundTasksDisabled, false);
    });

    test('should dispose timer correctly', () {
      // Should not throw when disposing (even without init)
      expect(() => batteryOptimizer.dispose(), returnsNormally);
    });
  });

  group('PerformanceSettings', () {
    test('should create performance settings with correct values', () {
      final settings = PerformanceSettings(
        enableAnimations: false,
        reducedRefreshRate: true,
        backgroundTasksDisabled: true,
      );

      expect(settings.enableAnimations, false);
      expect(settings.reducedRefreshRate, true);
      expect(settings.backgroundTasksDisabled, true);
    });
  });
}
