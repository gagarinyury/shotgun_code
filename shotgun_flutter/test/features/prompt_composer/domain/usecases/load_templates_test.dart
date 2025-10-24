import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/entities/prompt_template.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/usecases/load_templates.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LoadTemplates usecase;
  late MockPromptRepository mockRepository;

  setUp(() {
    mockRepository = MockPromptRepository();
    usecase = LoadTemplates(mockRepository);
  });

  final tTemplates = [
    const PromptTemplate(
      id: '1',
      name: 'Basic',
      template: '{context}\n\nTASK: {task}',
    ),
    const PromptTemplate(
      id: '2',
      name: 'Detailed',
      template: '{context}\n\nTASK: {task}\n\nRULES: {rules}',
    ),
  ];

  group('LoadTemplates', () {
    test('should load templates from repository', () async {
      // arrange
      when(mockRepository.loadTemplates())
          .thenAnswer((_) async => Right(tTemplates));

      // act
      final result = await usecase();

      // assert
      expect(result, Right(tTemplates));
      verify(mockRepository.loadTemplates());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const tFailure = CacheFailure('Failed to load templates');
      when(mockRepository.loadTemplates())
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.loadTemplates());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle empty template list', () async {
      // arrange
      const tEmptyList = <PromptTemplate>[];
      when(mockRepository.loadTemplates())
          .thenAnswer((_) async => const Right(tEmptyList));

      // act
      final result = await usecase();

      // assert
      expect(result, const Right(tEmptyList));
      verify(mockRepository.loadTemplates());
    });
  });
}
