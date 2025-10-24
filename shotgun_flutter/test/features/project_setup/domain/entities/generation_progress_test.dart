import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/project_setup/domain/entities/generation_progress.dart';

void main() {
  group('GenerationProgress', () {
    test('should calculate percentage correctly', () {
      const progress = GenerationProgress(current: 50, total: 100);
      expect(progress.percentage, 0.5);
    });

    test('should calculate 100% when current equals total', () {
      const progress = GenerationProgress(current: 100, total: 100);
      expect(progress.percentage, 1.0);
    });

    test('should calculate 0% when current is 0', () {
      const progress = GenerationProgress(current: 0, total: 100);
      expect(progress.percentage, 0.0);
    });

    test('should handle zero total without error', () {
      const progress = GenerationProgress(current: 0, total: 0);
      expect(progress.percentage, 0.0);
    });

    test('should handle zero total with non-zero current', () {
      const progress = GenerationProgress(current: 10, total: 0);
      expect(progress.percentage, 0.0);
    });

    test('should be equal when current and total are the same', () {
      const progress1 = GenerationProgress(current: 25, total: 100);
      const progress2 = GenerationProgress(current: 25, total: 100);
      expect(progress1, equals(progress2));
    });

    test('should not be equal when current differs', () {
      const progress1 = GenerationProgress(current: 25, total: 100);
      const progress2 = GenerationProgress(current: 50, total: 100);
      expect(progress1, isNot(equals(progress2)));
    });

    test('should not be equal when total differs', () {
      const progress1 = GenerationProgress(current: 25, total: 100);
      const progress2 = GenerationProgress(current: 25, total: 200);
      expect(progress1, isNot(equals(progress2)));
    });
  });
}
