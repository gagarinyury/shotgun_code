import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/entities/patch.dart';

void main() {
  group('Patch', () {
    test('should be a subclass of Equatable', () {
      // Arrange
      const patch = Patch(
        content: 'diff --git a/file.dart b/file.dart',
        projectPath: '/path/to/project',
        filesChanged: 1,
        linesAdded: 10,
        linesRemoved: 5,
      );

      // Assert
      expect(patch.props, isNotEmpty);
    });

    test('should contain correct values', () {
      // Arrange
      const content = 'diff --git a/file.dart b/file.dart';
      const projectPath = '/path/to/project';
      const filesChanged = 2;
      const linesAdded = 15;
      const linesRemoved = 7;

      // Act
      const patch = Patch(
        content: content,
        projectPath: projectPath,
        filesChanged: filesChanged,
        linesAdded: linesAdded,
        linesRemoved: linesRemoved,
      );

      // Assert
      expect(patch.content, content);
      expect(patch.projectPath, projectPath);
      expect(patch.filesChanged, filesChanged);
      expect(patch.linesAdded, linesAdded);
      expect(patch.linesRemoved, linesRemoved);
    });

    test('should support value equality', () {
      // Arrange
      const patch1 = Patch(
        content: 'diff content',
        projectPath: '/path',
        filesChanged: 1,
        linesAdded: 10,
        linesRemoved: 5,
      );

      const patch2 = Patch(
        content: 'diff content',
        projectPath: '/path',
        filesChanged: 1,
        linesAdded: 10,
        linesRemoved: 5,
      );

      // Assert
      expect(patch1, equals(patch2));
    });

    test('should not be equal with different values', () {
      // Arrange
      const patch1 = Patch(
        content: 'diff content 1',
        projectPath: '/path',
        filesChanged: 1,
        linesAdded: 10,
        linesRemoved: 5,
      );

      const patch2 = Patch(
        content: 'diff content 2',
        projectPath: '/path',
        filesChanged: 1,
        linesAdded: 10,
        linesRemoved: 5,
      );

      // Assert
      expect(patch1, isNot(equals(patch2)));
    });

    test('toString should return readable string', () {
      // Arrange
      const patch = Patch(
        content: 'diff content',
        projectPath: '/path',
        filesChanged: 3,
        linesAdded: 20,
        linesRemoved: 10,
      );

      // Act
      final result = patch.toString();

      // Assert
      expect(result, contains('3'));
      expect(result, contains('20'));
      expect(result, contains('10'));
    });
  });
}
