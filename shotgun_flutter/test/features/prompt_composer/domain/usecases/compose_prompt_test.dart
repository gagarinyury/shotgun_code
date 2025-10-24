import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/entities/prompt_template.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/usecases/compose_prompt.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late ComposePrompt usecase;
  late MockPromptRepository mockRepository;

  setUp(() {
    mockRepository = MockPromptRepository();
    usecase = ComposePrompt(mockRepository);
  });

  const tContext = 'Project context';
  const tTask = 'Implement feature X';
  const tRules = 'Follow best practices';
  const tTemplate = PromptTemplate(
    id: '1',
    name: 'Basic',
    template: '{context}\n\nTASK: {task}\n\nRULES: {rules}',
  );
  const tComposedPrompt =
      'Project context\n\nTASK: Implement feature X\n\nRULES: Follow best practices';

  group('ComposePrompt', () {
    test('should compose prompt from repository', () async {
      // arrange
      when(mockRepository.composePrompt(
        context: anyNamed('context'),
        task: anyNamed('task'),
        rules: anyNamed('rules'),
        template: anyNamed('template'),
      )).thenAnswer((_) async => const Right(tComposedPrompt));

      // act
      final result = await usecase(
        context: tContext,
        task: tTask,
        rules: tRules,
        template: tTemplate,
      );

      // assert
      expect(result, const Right(tComposedPrompt));
      verify(mockRepository.composePrompt(
        context: tContext,
        task: tTask,
        rules: tRules,
        template: tTemplate,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const tFailure = CacheFailure('Failed to compose');
      when(mockRepository.composePrompt(
        context: anyNamed('context'),
        task: anyNamed('task'),
        rules: anyNamed('rules'),
        template: anyNamed('template'),
      )).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase(
        context: tContext,
        task: tTask,
        rules: tRules,
        template: tTemplate,
      );

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.composePrompt(
        context: tContext,
        task: tTask,
        rules: tRules,
        template: tTemplate,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass all parameters correctly to repository', () async {
      // arrange
      when(mockRepository.composePrompt(
        context: anyNamed('context'),
        task: anyNamed('task'),
        rules: anyNamed('rules'),
        template: anyNamed('template'),
      )).thenAnswer((_) async => const Right('result'));

      // act
      await usecase(
        context: tContext,
        task: tTask,
        rules: tRules,
        template: tTemplate,
      );

      // assert
      verify(mockRepository.composePrompt(
        context: tContext,
        task: tTask,
        rules: tRules,
        template: tTemplate,
      )).called(1);
    });
  });
}
