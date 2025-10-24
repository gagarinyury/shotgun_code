import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/core/platform/backend_bridge.dart';

void main() {
  group('BackendBridge', () {
    test('should load library without throwing', () {
      expect(() => BackendBridge(), returnsNormally);
      final bridge = BackendBridge();
      bridge.dispose();
    });

    // Note: The following tests require Wails runtime context and are better suited
    // for integration tests. They are skipped in unit tests.
    test('should call listFiles and return JSON string', () {
      // Skipped: Requires Wails runtime context
    }, skip: 'Requires Wails runtime - run integration tests instead');

    test('should handle valid path and return parseable JSON', () {
      // Skipped: Requires Wails runtime context
    }, skip: 'Requires Wails runtime - run integration tests instead');
  });
}
