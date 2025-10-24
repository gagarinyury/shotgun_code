import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/exceptions.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/prompt_composer/data/datasources/prompt_local_datasource.dart';
import 'package:shotgun_flutter/features/prompt_composer/data/repositories/prompt_repository_impl.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/entities/prompt_template.dart';

import 'prompt_repository_impl_test.mocks.dart';

@GenerateMocks([PromptLocalDataSource])
void main() {
  late PromptRepositoryImpl repository;
  late MockPromptLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPromptLocalDataSource();
    repository = PromptRepositoryImpl(localDataSource: mockDataSource);
  });

  group('composePrompt', () {
    const tTemplate = PromptTemplate(
      id: '1',
      name: 'Basic',
      template: '{context}\n\nTASK: {task}\n\nRULES: {rules}',
    );

    test('should compose prompt using template', () async {
      // arrange
      const context = 'ctx';
      const task = 'my task';
      const rules = 'my rules';

      // act
      final result = await repository.composePrompt(
        context: context,
        task: task,
        rules: rules,
        template: tTemplate,
      );

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (prompt) {
          expect(prompt, 'ctx\n\nTASK: my task\n\nRULES: my rules');
        },
      );
    });
  });

  group('estimateTokens', () {
    test('should estimate tokens correctly', () async {
      // arrange
      const text = 'test'; // 4 chars = 1 token

      // act
      final result = await repository.estimateTokens(text);

      // assert
      expect(result, const Right(1));
    });

    test('should handle empty text', () async {
      // act
      final result = await repository.estimateTokens('');

      // assert
      expect(result, const Right(0));
    });
  });

  group('loadTemplates', () {
    test('should load default templates when no custom templates', () async {
      // arrange
      when(mockDataSource.loadAllTemplates())
          .thenAnswer((_) async => []);

      // act
      final result = await repository.loadTemplates();

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (templates) {
          expect(templates.length, 3); // 3 default templates
          expect(templates.any((t) => t.id == 'basic'), true);
          expect(templates.any((t) => t.id == 'detailed'), true);
          expect(templates.any((t) => t.id == 'structured'), true);
        },
      );
      verify(mockDataSource.loadAllTemplates());
    });

    test('should load default and custom templates', () async {
      // arrange
      when(mockDataSource.loadAllTemplates()).thenAnswer(
        (_) async => [
          {
            'id': 'custom-1',
            'name': 'Custom',
            'template': '{context}',
          },
        ],
      );

      // act
      final result = await repository.loadTemplates();

      // assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (templates) {
          expect(templates.length, 4); // 3 default + 1 custom
          expect(templates.any((t) => t.id == 'custom-1'), true);
        },
      );
    });

    test('should return failure when data source fails', () async {
      // arrange
      when(mockDataSource.loadAllTemplates())
          .thenThrow(const CacheException('Load failed'));

      // act
      final result = await repository.loadTemplates();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (templates) => fail('Should fail'),
      );
    });
  });

  group('saveTemplate', () {
    test('should save custom template', () async {
      // arrange
      const template = PromptTemplate(
        id: 'custom-1',
        name: 'Custom',
        template: '{context}',
      );
      when(mockDataSource.saveTemplate(any, any))
          .thenAnswer((_) async => {});

      // act
      final result = await repository.saveTemplate(template);

      // assert
      expect(result, const Right(null));
      verify(mockDataSource.saveTemplate('custom-1', any));
    });

    test('should not allow overwriting built-in templates', () async {
      // arrange
      const template = PromptTemplate(
        id: 'basic', // Built-in template
        name: 'Basic Modified',
        template: '{context}',
      );

      // act
      final result = await repository.saveTemplate(template);

      // assert
      expect(result.isLeft(), true);
      verifyNever(mockDataSource.saveTemplate(any, any));
    });

    test('should return failure when data source fails', () async {
      // arrange
      const template = PromptTemplate(
        id: 'custom-1',
        name: 'Custom',
        template: '{context}',
      );
      when(mockDataSource.saveTemplate(any, any))
          .thenThrow(const CacheException('Save failed'));

      // act
      final result = await repository.saveTemplate(template);

      // assert
      expect(result.isLeft(), true);
    });
  });

  group('loadCustomRules', () {
    test('should load custom rules from data source', () async {
      // arrange
      const rules = 'Rule 1\nRule 2';
      when(mockDataSource.loadCustomRules())
          .thenAnswer((_) async => rules);

      // act
      final result = await repository.loadCustomRules();

      // assert
      expect(result, const Right(rules));
      verify(mockDataSource.loadCustomRules());
    });

    test('should return failure when data source fails', () async {
      // arrange
      when(mockDataSource.loadCustomRules())
          .thenThrow(const CacheException('Load failed'));

      // act
      final result = await repository.loadCustomRules();

      // assert
      expect(result.isLeft(), true);
    });
  });

  group('saveCustomRules', () {
    test('should save custom rules via data source', () async {
      // arrange
      const rules = 'Rule 1\nRule 2';
      when(mockDataSource.saveCustomRules(any))
          .thenAnswer((_) async => {});

      // act
      final result = await repository.saveCustomRules(rules);

      // assert
      expect(result, const Right(null));
      verify(mockDataSource.saveCustomRules(rules));
    });

    test('should return failure when data source fails', () async {
      // arrange
      const rules = 'Rule 1';
      when(mockDataSource.saveCustomRules(any))
          .thenThrow(const CacheException('Save failed'));

      // act
      final result = await repository.saveCustomRules(rules);

      // assert
      expect(result.isLeft(), true);
    });
  });
}
