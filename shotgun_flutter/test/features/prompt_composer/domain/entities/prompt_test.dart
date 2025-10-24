import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/entities/prompt.dart';

void main() {
  group('Prompt', () {
    const tContext = 'Project context';
    const tTask = 'Implement feature';
    const tRules = 'Follow standards';
    const tFinalPrompt = 'Complete prompt text';
    const tEstimatedTokens = 100;

    test('should be a subclass of Equatable', () {
      // arrange
      const prompt = Prompt(
        context: tContext,
        task: tTask,
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: tEstimatedTokens,
      );

      // assert
      expect(prompt.props, isNotEmpty);
    });

    test('should be equal when all properties are the same', () {
      // arrange
      const prompt1 = Prompt(
        context: tContext,
        task: tTask,
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: tEstimatedTokens,
      );
      const prompt2 = Prompt(
        context: tContext,
        task: tTask,
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: tEstimatedTokens,
      );

      // assert
      expect(prompt1, equals(prompt2));
    });

    test('should not be equal when context differs', () {
      // arrange
      const prompt1 = Prompt(
        context: 'context1',
        task: tTask,
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: tEstimatedTokens,
      );
      const prompt2 = Prompt(
        context: 'context2',
        task: tTask,
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: tEstimatedTokens,
      );

      // assert
      expect(prompt1, isNot(equals(prompt2)));
    });

    test('should not be equal when task differs', () {
      // arrange
      const prompt1 = Prompt(
        context: tContext,
        task: 'task1',
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: tEstimatedTokens,
      );
      const prompt2 = Prompt(
        context: tContext,
        task: 'task2',
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: tEstimatedTokens,
      );

      // assert
      expect(prompt1, isNot(equals(prompt2)));
    });

    test('should not be equal when estimatedTokens differs', () {
      // arrange
      const prompt1 = Prompt(
        context: tContext,
        task: tTask,
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: 100,
      );
      const prompt2 = Prompt(
        context: tContext,
        task: tTask,
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: 200,
      );

      // assert
      expect(prompt1, isNot(equals(prompt2)));
    });

    test('copyWith should create a new instance with updated fields', () {
      // arrange
      const prompt = Prompt(
        context: tContext,
        task: tTask,
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: tEstimatedTokens,
      );

      // act
      final updated = prompt.copyWith(
        task: 'New task',
        estimatedTokens: 200,
      );

      // assert
      expect(updated.context, equals(tContext));
      expect(updated.task, equals('New task'));
      expect(updated.rules, equals(tRules));
      expect(updated.finalPrompt, equals(tFinalPrompt));
      expect(updated.estimatedTokens, equals(200));
      expect(updated, isNot(same(prompt)));
    });

    test('copyWith with no parameters should return equal instance', () {
      // arrange
      const prompt = Prompt(
        context: tContext,
        task: tTask,
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: tEstimatedTokens,
      );

      // act
      final copy = prompt.copyWith();

      // assert
      expect(copy, equals(prompt));
      expect(copy, isNot(same(prompt)));
    });

    test('toString should return readable string with metrics', () {
      // arrange
      const prompt = Prompt(
        context: tContext,
        task: tTask,
        rules: tRules,
        finalPrompt: tFinalPrompt,
        estimatedTokens: tEstimatedTokens,
      );

      // act
      final result = prompt.toString();

      // assert
      expect(result, contains('Prompt'));
      expect(result, contains('tokens: $tEstimatedTokens'));
      expect(result, contains('taskLength: ${tTask.length}'));
      expect(result, contains('contextLength: ${tContext.length}'));
    });
  });
}
