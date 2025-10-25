import 'dart:async';
import 'package:battery_plus/battery_plus.dart';

class BatteryOptimizer {
  final Battery _battery = Battery();
  Timer? _checkTimer;
  bool _isLowPowerMode = false;
  BatteryState? _batteryState;
  int? _batteryLevel;

  bool get isLowPowerMode => _isLowPowerMode;
  BatteryState? get batteryState => _batteryState;
  int? get batteryLevel => _batteryLevel;

  Future<void> init() async {
    // Check battery state periodically
    _checkTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkBatteryState();
    });

    await _checkBatteryState();
  }

  Future<void> _checkBatteryState() async {
    _batteryLevel = await _battery.batteryLevel;
    _batteryState = await _battery.batteryState;

    // Enable low power mode if battery < 20% or power saving mode
    _isLowPowerMode =
        (_batteryLevel != null && _batteryLevel! < 20) ||
        (_batteryState == BatteryState.charging &&
            _batteryLevel != null &&
            _batteryLevel! < 30);
  }

  void dispose() {
    _checkTimer?.cancel();
  }

  /// Get recommended settings based on battery
  PerformanceSettings getRecommendedSettings() {
    if (_isLowPowerMode) {
      return PerformanceSettings(
        enableAnimations: false,
        reducedRefreshRate: true,
        backgroundTasksDisabled: true,
      );
    }

    return PerformanceSettings(
      enableAnimations: true,
      reducedRefreshRate: false,
      backgroundTasksDisabled: false,
    );
  }
}

class PerformanceSettings {
  final bool enableAnimations;
  final bool reducedRefreshRate;
  final bool backgroundTasksDisabled;

  PerformanceSettings({
    required this.enableAnimations,
    required this.reducedRefreshRate,
    required this.backgroundTasksDisabled,
  });
}
