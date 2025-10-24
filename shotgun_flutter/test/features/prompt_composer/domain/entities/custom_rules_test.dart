import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/entities/custom_rules.dart';

void main() {
  group('CustomRules', () {
    final tCreatedAt = DateTime(2024, 1, 1);
    final tUpdatedAt = DateTime(2024, 1, 2);
    const tId = 'rule-1';
    const tName = 'My Rules';
    const tContent = 'Rule 1\nRule 2\nRule 3';

    test('should be a subclass of Equatable', () {
      // arrange
      final rules = CustomRules(
        id: tId,
        name: tName,
        content: tContent,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      // assert
      expect(rules.props, isNotEmpty);
    });

    test('should be equal when all properties are the same', () {
      // arrange
      final rules1 = CustomRules(
        id: tId,
        name: tName,
        content: tContent,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );
      final rules2 = CustomRules(
        id: tId,
        name: tName,
        content: tContent,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      // assert
      expect(rules1, equals(rules2));
    });

    test('should not be equal when id differs', () {
      // arrange
      final rules1 = CustomRules(
        id: 'id-1',
        name: tName,
        content: tContent,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );
      final rules2 = CustomRules(
        id: 'id-2',
        name: tName,
        content: tContent,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      // assert
      expect(rules1, isNot(equals(rules2)));
    });

    test('should not be equal when content differs', () {
      // arrange
      final rules1 = CustomRules(
        id: tId,
        name: tName,
        content: 'content1',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );
      final rules2 = CustomRules(
        id: tId,
        name: tName,
        content: 'content2',
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      // assert
      expect(rules1, isNot(equals(rules2)));
    });

    test('should not be equal when dates differ', () {
      // arrange
      final rules1 = CustomRules(
        id: tId,
        name: tName,
        content: tContent,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: tUpdatedAt,
      );
      final rules2 = CustomRules(
        id: tId,
        name: tName,
        content: tContent,
        createdAt: DateTime(2024, 1, 3),
        updatedAt: tUpdatedAt,
      );

      // assert
      expect(rules1, isNot(equals(rules2)));
    });

    test('copyWith should create a new instance with updated fields', () {
      // arrange
      final rules = CustomRules(
        id: tId,
        name: tName,
        content: tContent,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );
      final newUpdatedAt = DateTime(2024, 1, 5);

      // act
      final updated = rules.copyWith(
        name: 'Updated Name',
        updatedAt: newUpdatedAt,
      );

      // assert
      expect(updated.id, equals(tId));
      expect(updated.name, equals('Updated Name'));
      expect(updated.content, equals(tContent));
      expect(updated.createdAt, equals(tCreatedAt));
      expect(updated.updatedAt, equals(newUpdatedAt));
      expect(updated, isNot(same(rules)));
    });

    test('copyWith with no parameters should return equal instance', () {
      // arrange
      final rules = CustomRules(
        id: tId,
        name: tName,
        content: tContent,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      // act
      final copy = rules.copyWith();

      // assert
      expect(copy, equals(rules));
      expect(copy, isNot(same(rules)));
    });

    test('toString should return readable string with metrics', () {
      // arrange
      final rules = CustomRules(
        id: tId,
        name: tName,
        content: tContent,
        createdAt: tCreatedAt,
        updatedAt: tUpdatedAt,
      );

      // act
      final result = rules.toString();

      // assert
      expect(result, contains('CustomRules'));
      expect(result, contains('id: $tId'));
      expect(result, contains('name: $tName'));
      expect(result, contains('length: ${tContent.length}'));
    });
  });
}
