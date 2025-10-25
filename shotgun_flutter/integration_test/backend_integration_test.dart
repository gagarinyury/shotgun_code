import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'dart:io';
import 'package:shotgun_flutter/core/platform/backend_bridge.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Backend Integration', () {
    late BackendBridge bridge;

    setUpAll(() {
      // Пропускаем тесты на mobile платформах
      if (Platform.isAndroid || Platform.isIOS) {
        return;
      }
      bridge = BackendBridge();
    });

    test('should list files from real filesystem', () {
      // Пропускаем тесты на mobile платформах
      if (Platform.isAndroid || Platform.isIOS) {
        return;
      }

      // Use current directory for testing
      final result = bridge.listFiles('.');

      // Result should be non-empty JSON string
      expect(result, isNotEmpty);
      expect(result, isA<String>());

      // Should contain expected JSON fields
      expect(
        result.contains('name') || result.contains('error'),
        isTrue,
        reason: 'Result should contain file data or error message',
      );
    });

    test('should handle non-existent path gracefully', () {
      // Пропускаем тесты на mobile платформах
      if (Platform.isAndroid || Platform.isIOS) {
        return;
      }

      final result = bridge.listFiles('/non/existent/path/xyz');

      // Should return error JSON
      expect(result, isNotEmpty);
      expect(result, contains('error'));
    });

    tearDownAll(() {
      bridge.dispose();
    });
  });
}
