import 'package:flutter/services.dart';
import 'dart:io';

class HapticService {
  /// Light impact (e.g., button tap)
  static Future<void> lightImpact() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await HapticFeedback.lightImpact();
    }
  }

  /// Medium impact (e.g., switch toggle)
  static Future<void> mediumImpact() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Heavy impact (e.g., confirmation)
  static Future<void> heavyImpact() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Selection changed (e.g., picker)
  static Future<void> selectionClick() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await HapticFeedback.selectionClick();
    }
  }

  /// Vibrate (Android)
  static Future<void> vibrate() async {
    if (Platform.isAndroid) {
      await HapticFeedback.vibrate();
    }
  }
}
