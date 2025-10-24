import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/entities/apply_result.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/entities/conflict.dart';

void main() {
  group('ApplyResult', () {
    test('should be a subclass of Equatable', () {
      // Arrange
      final result = ApplyResult.success();

      // Assert
      expect(result.props, isNotEmpty);
    });

    test('success factory should create successful result', () {
      // Act
      final result = ApplyResult.success();

      // Assert
      expect(result.success, true);
      expect(result.conflicts, isEmpty);
      expect(result.message, contains('success'));
    });

    test('failure factory should create failed result with conflicts', () {
      // Arrange
      const conflicts = [
        Conflict(
          filePath: 'file1.dart',
          lineNumber: 10,
          theirVersion: 'their',
          ourVersion: 'ours',
        ),
        Conflict(
          filePath: 'file2.dart',
          lineNumber: 20,
          theirVersion: 'their2',
          ourVersion: 'ours2',
        ),
      ];

      // Act
      final result = ApplyResult.failure(conflicts: conflicts);

      // Assert
      expect(result.success, false);
      expect(result.conflicts, conflicts);
      expect(result.message, contains('2'));
      expect(result.message, contains('conflict'));
    });

    test('should support value equality', () {
      // Arrange
      final result1 = ApplyResult.success();
      final result2 = ApplyResult.success();

      // Assert
      expect(result1, equals(result2));
    });

    test('should not be equal with different conflicts', () {
      // Arrange
      final result1 = ApplyResult.failure(conflicts: const []);
      final result2 = ApplyResult.failure(
        conflicts: const [
          Conflict(
            filePath: 'file.dart',
            lineNumber: 1,
            theirVersion: 'their',
            ourVersion: 'ours',
          ),
        ],
      );

      // Assert
      expect(result1, isNot(equals(result2)));
    });

    test('toString should return readable string', () {
      // Arrange
      final result = ApplyResult.failure(
        conflicts: const [
          Conflict(
            filePath: 'file.dart',
            lineNumber: 1,
            theirVersion: 'their',
            ourVersion: 'ours',
          ),
        ],
      );

      // Act
      final str = result.toString();

      // Assert
      expect(str, contains('success: false'));
      expect(str, contains('conflicts: 1'));
    });
  });
}
