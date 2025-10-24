import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/entities/prompt_template.dart';

void main() {
  group('PromptTemplate', () {
    const tId = 'template-1';
    const tName = 'Basic Template';
    const tTemplate = '{context}\n\nTASK: {task}\n\nRULES: {rules}';

    test('should be a subclass of Equatable', () {
      // arrange
      const template = PromptTemplate(
        id: tId,
        name: tName,
        template: tTemplate,
      );

      // assert
      expect(template.props, isNotEmpty);
    });

    test('should render template correctly with all placeholders', () {
      // arrange
      const template = PromptTemplate(
        id: tId,
        name: tName,
        template: tTemplate,
      );
      const context = 'Project context here';
      const task = 'Implement feature X';
      const rules = 'Follow coding standards';

      // act
      final result = template.render(
        context: context,
        task: task,
        rules: rules,
      );

      // assert
      expect(result, contains(context));
      expect(result, contains('TASK: $task'));
      expect(result, contains('RULES: $rules'));
      expect(result, equals('$context\n\nTASK: $task\n\nRULES: $rules'));
    });

    test('should render template correctly with empty values', () {
      // arrange
      const template = PromptTemplate(
        id: tId,
        name: tName,
        template: tTemplate,
      );

      // act
      final result = template.render(
        context: '',
        task: '',
        rules: '',
      );

      // assert
      expect(result, equals('\n\nTASK: \n\nRULES: '));
    });

    test('should render template with only context placeholder', () {
      // arrange
      const template = PromptTemplate(
        id: 'simple',
        name: 'Simple',
        template: '{context}',
      );
      const context = 'ctx';

      // act
      final result = template.render(
        context: context,
        task: '',
        rules: '',
      );

      // assert
      expect(result, equals('ctx'));
    });

    test('should be equal when all properties are the same', () {
      // arrange
      const template1 = PromptTemplate(
        id: tId,
        name: tName,
        template: tTemplate,
      );
      const template2 = PromptTemplate(
        id: tId,
        name: tName,
        template: tTemplate,
      );

      // assert
      expect(template1, equals(template2));
    });

    test('should not be equal when id differs', () {
      // arrange
      const template1 = PromptTemplate(
        id: 'id-1',
        name: tName,
        template: tTemplate,
      );
      const template2 = PromptTemplate(
        id: 'id-2',
        name: tName,
        template: tTemplate,
      );

      // assert
      expect(template1, isNot(equals(template2)));
    });

    test('should not be equal when name differs', () {
      // arrange
      const template1 = PromptTemplate(
        id: tId,
        name: 'Name 1',
        template: tTemplate,
      );
      const template2 = PromptTemplate(
        id: tId,
        name: 'Name 2',
        template: tTemplate,
      );

      // assert
      expect(template1, isNot(equals(template2)));
    });

    test('should not be equal when template differs', () {
      // arrange
      const template1 = PromptTemplate(
        id: tId,
        name: tName,
        template: '{context}',
      );
      const template2 = PromptTemplate(
        id: tId,
        name: tName,
        template: '{task}',
      );

      // assert
      expect(template1, isNot(equals(template2)));
    });

    test('copyWith should create a new instance with updated fields', () {
      // arrange
      const template = PromptTemplate(
        id: tId,
        name: tName,
        template: tTemplate,
      );

      // act
      final updated = template.copyWith(name: 'Updated Name');

      // assert
      expect(updated.id, equals(tId));
      expect(updated.name, equals('Updated Name'));
      expect(updated.template, equals(tTemplate));
      expect(updated, isNot(same(template)));
    });

    test('copyWith with no parameters should return equal instance', () {
      // arrange
      const template = PromptTemplate(
        id: tId,
        name: tName,
        template: tTemplate,
      );

      // act
      final copy = template.copyWith();

      // assert
      expect(copy, equals(template));
      expect(copy, isNot(same(template)));
    });

    test('toString should return readable string', () {
      // arrange
      const template = PromptTemplate(
        id: tId,
        name: tName,
        template: tTemplate,
      );

      // act
      final result = template.toString();

      // assert
      expect(result, contains('PromptTemplate'));
      expect(result, contains(tId));
      expect(result, contains(tName));
    });
  });
}
