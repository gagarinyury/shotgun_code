import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/usecases/load_custom_rules.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late LoadCustomRules usecase;
  late MockPromptRepository mockRepository;

  setUp(() {
    mockRepository = MockPromptRepository();
    usecase = LoadCustomRules(mockRepository);
  });

  const tRules = 'Rule 1\nRule 2\nRule 3';

  group('LoadCustomRules', () {
    test('should load custom rules from repository', () async {
      // arrange
      when(mockRepository.loadCustomRules())
          .thenAnswer((_) async => const Right(tRules));

      // act
      final result = await usecase();

      // assert
      expect(result, const Right(tRules));
      verify(mockRepository.loadCustomRules());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const tFailure = CacheFailure('Failed to load rules');
      when(mockRepository.loadCustomRules())
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase();

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.loadCustomRules());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle empty rules', () async {
      // arrange
      const tEmptyRules = '';
      when(mockRepository.loadCustomRules())
          .thenAnswer((_) async => const Right(tEmptyRules));

      // act
      final result = await usecase();

      // assert
      expect(result, const Right(tEmptyRules));
      verify(mockRepository.loadCustomRules());
    });
  });
}
