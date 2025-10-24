import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/project_setup/domain/entities/shotgun_context.dart';

void main() {
  group('ShotgunContext', () {
    final tDateTime = DateTime(2024, 1, 1);
    final tContext = ShotgunContext(
      projectPath: '/test',
      context: 'test context',
      sizeBytes: 1024,
      generatedAt: tDateTime,
    );

    test('should be equal when all fields are the same', () {
      final context2 = ShotgunContext(
        projectPath: '/test',
        context: 'test context',
        sizeBytes: 1024,
        generatedAt: tDateTime,
      );

      expect(tContext, equals(context2));
    });

    test('should not be equal when projectPath differs', () {
      final context2 = ShotgunContext(
        projectPath: '/other',
        context: 'test context',
        sizeBytes: 1024,
        generatedAt: tDateTime,
      );

      expect(tContext, isNot(equals(context2)));
    });

    test('should not be equal when context differs', () {
      final context2 = ShotgunContext(
        projectPath: '/test',
        context: 'different context',
        sizeBytes: 1024,
        generatedAt: tDateTime,
      );

      expect(tContext, isNot(equals(context2)));
    });

    test('should not be equal when sizeBytes differs', () {
      final context2 = ShotgunContext(
        projectPath: '/test',
        context: 'test context',
        sizeBytes: 2048,
        generatedAt: tDateTime,
      );

      expect(tContext, isNot(equals(context2)));
    });

    test('should not be equal when generatedAt differs', () {
      final context2 = ShotgunContext(
        projectPath: '/test',
        context: 'test context',
        sizeBytes: 1024,
        generatedAt: DateTime(2024, 1, 2),
      );

      expect(tContext, isNot(equals(context2)));
    });
  });
}
