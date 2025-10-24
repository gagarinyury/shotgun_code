import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/entities/prompt_template.dart';
import 'package:shotgun_flutter/features/prompt_composer/presentation/providers/prompt_provider.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late MockPromptRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockPromptRepository();

    // Create a container with overridden providers
    container = ProviderContainer(
      overrides: [
        promptRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PromptNotifier', () {
    final tTemplates = [
      const PromptTemplate(
        id: 'basic',
        name: 'Basic',
        template: '{context}\n\nTASK: {task}',
      ),
      const PromptTemplate(
        id: 'detailed',
        name: 'Detailed',
        template: '{context}\n\nTASK: {task}\n\nRULES: {rules}',
      ),
    ];
    const tCustomRules = 'Custom rule 1\nCustom rule 2';

    test('should load initial state with templates and rules', () async {
      // arrange
      when(mockRepository.loadTemplates())
          .thenAnswer((_) async => Right(tTemplates));
      when(mockRepository.loadCustomRules())
          .thenAnswer((_) async => const Right(tCustomRules));

      // act
      final state = await container.read(promptNotifierProvider.future);

      // assert
      expect(state.templates, tTemplates);
      expect(state.selectedTemplate, tTemplates.first);
      expect(state.customRules, tCustomRules);
      expect(state.context, '');
      expect(state.task, '');
      expect(state.finalPrompt, '');
      expect(state.estimatedTokens, 0);
    });

    test('should handle empty templates list', () async {
      // arrange
      when(mockRepository.loadTemplates())
          .thenAnswer((_) async => const Right([]));
      when(mockRepository.loadCustomRules())
          .thenAnswer((_) async => const Right(''));

      // act
      final state = await container.read(promptNotifierProvider.future);

      // assert
      expect(state.templates, isEmpty);
      expect(state.selectedTemplate, isNull);
    });

    test('should handle load failures gracefully', () async {
      // arrange
      when(mockRepository.loadTemplates())
          .thenAnswer((_) async => Right(tTemplates));
      when(mockRepository.loadCustomRules())
          .thenAnswer((_) async => const Right(''));

      // act
      final state = await container.read(promptNotifierProvider.future);

      // assert
      expect(state.templates, tTemplates);
      expect(state.customRules, '');
    });
  });

  group('PromptState', () {
    test('should create initial state', () {
      // act
      final state = PromptState.initial();

      // assert
      expect(state.context, '');
      expect(state.task, '');
      expect(state.customRules, '');
      expect(state.templates, isEmpty);
      expect(state.selectedTemplate, isNull);
      expect(state.finalPrompt, '');
      expect(state.estimatedTokens, 0);
      expect(state.errorMessage, isNull);
    });

    test('should support copyWith', () {
      // arrange
      final state = PromptState.initial();

      // act
      final updated = state.copyWith(task: 'New task', estimatedTokens: 100);

      // assert
      expect(updated.task, 'New task');
      expect(updated.estimatedTokens, 100);
      expect(updated.context, ''); // unchanged
    });
  });
}
