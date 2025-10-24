import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/repositories/llm_repository.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/usecases/cancel_generation.dart';

import 'cancel_generation_test.mocks.dart';

@GenerateMocks([LLMRepository])
void main() {
  late CancelGeneration usecase;
  late MockLLMRepository mockRepository;

  setUp(() {
    mockRepository = MockLLMRepository();
    usecase = CancelGeneration(mockRepository);
  });

  group('CancelGeneration', () {
    test('should forward call to repository', () async {
      // Arrange
      when(mockRepository.cancelGeneration())
          .thenAnswer((_) async => const Right(null));

      // Act
      await usecase();

      // Assert
      verify(mockRepository.cancelGeneration());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Right(void) on successful cancellation', () async {
      // Arrange
      when(mockRepository.cancelGeneration())
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Right(null));
    });

    test('should return Left(Failure) when cancellation fails', () async {
      // Arrange
      const tFailure = ServerFailure('Failed to cancel');
      when(mockRepository.cancelGeneration())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(tFailure));
    });

    test('should handle multiple calls', () async {
      // Arrange
      when(mockRepository.cancelGeneration())
          .thenAnswer((_) async => const Right(null));

      // Act
      await usecase();
      await usecase();

      // Assert
      verify(mockRepository.cancelGeneration()).called(2);
    });

    test('should propagate different failure types', () async {
      // Arrange
      const tFailure = NetworkFailure('Network error');
      when(mockRepository.cancelGeneration())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase();

      // Assert
      expect(result, const Left(tFailure));
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });
}
