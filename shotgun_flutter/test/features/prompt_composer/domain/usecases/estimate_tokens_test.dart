import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/usecases/estimate_tokens.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late EstimateTokens usecase;
  late MockPromptRepository mockRepository;

  setUp(() {
    mockRepository = MockPromptRepository();
    usecase = EstimateTokens(mockRepository);
  });

  const tText = 'This is a test prompt with some content';
  const tTokenCount = 10;

  group('EstimateTokens', () {
    test('should estimate tokens from repository', () async {
      // arrange
      when(mockRepository.estimateTokens(any))
          .thenAnswer((_) async => const Right(tTokenCount));

      // act
      final result = await usecase(tText);

      // assert
      expect(result, const Right(tTokenCount));
      verify(mockRepository.estimateTokens(tText));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository fails', () async {
      // arrange
      const tFailure = CacheFailure('Failed to estimate');
      when(mockRepository.estimateTokens(any))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase(tText);

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.estimateTokens(tText));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should handle empty text', () async {
      // arrange
      const tEmptyText = '';
      const tZeroTokens = 0;
      when(mockRepository.estimateTokens(any))
          .thenAnswer((_) async => const Right(tZeroTokens));

      // act
      final result = await usecase(tEmptyText);

      // assert
      expect(result, const Right(tZeroTokens));
      verify(mockRepository.estimateTokens(tEmptyText));
    });

    test('should handle very long text', () async {
      // arrange
      final tLongText = 'a' * 100000;
      const tLargeTokenCount = 25000;
      when(mockRepository.estimateTokens(any))
          .thenAnswer((_) async => const Right(tLargeTokenCount));

      // act
      final result = await usecase(tLongText);

      // assert
      expect(result, const Right(tLargeTokenCount));
      verify(mockRepository.estimateTokens(tLongText));
    });
  });
}
