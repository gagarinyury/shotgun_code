import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/entities/conflict.dart';

void main() {
  group('Conflict', () {
    test('should be a subclass of Equatable', () {
      // Arrange
      const conflict = Conflict(
        filePath: 'lib/main.dart',
        lineNumber: 42,
        theirVersion: 'their code',
        ourVersion: 'our code',
      );

      // Assert
      expect(conflict.props, isNotEmpty);
    });

    test('should contain correct values', () {
      // Arrange
      const filePath = 'lib/features/test.dart';
      const lineNumber = 100;
      const theirVersion = 'their version';
      const ourVersion = 'our version';

      // Act
      const conflict = Conflict(
        filePath: filePath,
        lineNumber: lineNumber,
        theirVersion: theirVersion,
        ourVersion: ourVersion,
      );

      // Assert
      expect(conflict.filePath, filePath);
      expect(conflict.lineNumber, lineNumber);
      expect(conflict.theirVersion, theirVersion);
      expect(conflict.ourVersion, ourVersion);
    });

    test('should support value equality', () {
      // Arrange
      const conflict1 = Conflict(
        filePath: 'lib/main.dart',
        lineNumber: 42,
        theirVersion: 'their',
        ourVersion: 'ours',
      );

      const conflict2 = Conflict(
        filePath: 'lib/main.dart',
        lineNumber: 42,
        theirVersion: 'their',
        ourVersion: 'ours',
      );

      // Assert
      expect(conflict1, equals(conflict2));
    });

    test('should not be equal with different line numbers', () {
      // Arrange
      const conflict1 = Conflict(
        filePath: 'lib/main.dart',
        lineNumber: 42,
        theirVersion: 'their',
        ourVersion: 'ours',
      );

      const conflict2 = Conflict(
        filePath: 'lib/main.dart',
        lineNumber: 43,
        theirVersion: 'their',
        ourVersion: 'ours',
      );

      // Assert
      expect(conflict1, isNot(equals(conflict2)));
    });

    test('toString should return readable string', () {
      // Arrange
      const conflict = Conflict(
        filePath: 'lib/main.dart',
        lineNumber: 42,
        theirVersion: 'their',
        ourVersion: 'ours',
      );

      // Act
      final result = conflict.toString();

      // Assert
      expect(result, contains('lib/main.dart'));
      expect(result, contains('42'));
    });
  });
}
