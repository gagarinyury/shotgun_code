import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/usecases/save_custom_rules.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveCustomRules usecase;
  late MockPromptRepository mockRepository;

  setUp(() {
    mockRepository = MockPromptRepository();
    usecase = SaveCustomRules(mockRepository);
  });

  const tRules = 'Rule 1\nRule 2\nRule 3';

  group('SaveCustomRules', () {
    test('should save custom rules via repository', () async {
      // arrange
      when(mockRepository.saveCustomRules(any))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(tRules);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.saveCustomRules(tRules));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const tFailure = CacheFailure('Failed to save rules');
      when(mockRepository.saveCustomRules(any))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase(tRules);

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.saveCustomRules(tRules));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle empty rules', () async {
      // arrange
      const tEmptyRules = '';
      when(mockRepository.saveCustomRules(any))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(tEmptyRules);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.saveCustomRules(tEmptyRules));
    });

    test('should handle very long rules', () async {
      // arrange
      final tLongRules = 'Rule ' * 10000;
      when(mockRepository.saveCustomRules(any))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(tLongRules);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.saveCustomRules(tLongRules));
    });
  });
}
