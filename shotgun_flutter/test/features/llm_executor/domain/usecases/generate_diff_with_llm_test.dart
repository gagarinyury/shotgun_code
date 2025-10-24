import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_config.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_provider_type.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/repositories/llm_repository.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/usecases/generate_diff_with_llm.dart';

import 'generate_diff_with_llm_test.mocks.dart';

@GenerateMocks([LLMRepository])
void main() {
  late GenerateDiffWithLLM usecase;
  late MockLLMRepository mockRepository;

  setUp(() {
    mockRepository = MockLLMRepository();
    usecase = GenerateDiffWithLLM(mockRepository);
  });

  const tConfig = LLMConfig(
    provider: LLMProviderType.gemini,
    apiKey: 'test-key',
    model: 'gemini-2.0-flash-exp',
    temperature: 0.1,
  );

  const tPrompt = 'Generate a diff for adding a new feature';

  group('GenerateDiffWithLLM', () {
    test('should forward call to repository', () async {
      // Arrange
      final tStream = Stream<Either<Failure, String>>.fromIterable([
        const Right('chunk1'),
        const Right('chunk2'),
        const Right('chunk3'),
      ]);

      when(mockRepository.generateDiff(
        prompt: anyNamed('prompt'),
        config: anyNamed('config'),
      )).thenAnswer((_) => tStream);

      // Act
      final result = usecase(prompt: tPrompt, config: tConfig);

      // Assert
      expect(result, tStream);
      verify(mockRepository.generateDiff(
        prompt: tPrompt,
        config: tConfig,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should emit all chunks from stream', () async {
      // Arrange
      final tChunks = ['chunk1', 'chunk2', 'chunk3'];
      final tStream = Stream<Either<Failure, String>>.fromIterable(
        tChunks.map((chunk) => Right(chunk)),
      );

      when(mockRepository.generateDiff(
        prompt: anyNamed('prompt'),
        config: anyNamed('config'),
      )).thenAnswer((_) => tStream);

      // Act
      final result = usecase(prompt: tPrompt, config: tConfig);

      // Assert
      final emittedChunks = <String>[];
      await for (final either in result) {
        either.fold(
          (failure) => fail('Should not emit failure'),
          (chunk) => emittedChunks.add(chunk),
        );
      }

      expect(emittedChunks, tChunks);
    });

    test('should emit failure from stream', () async {
      // Arrange
      const tFailure = ServerFailure('Connection error');
      final tStream = Stream<Either<Failure, String>>.fromIterable([
        const Left(tFailure),
      ]);

      when(mockRepository.generateDiff(
        prompt: anyNamed('prompt'),
        config: anyNamed('config'),
      )).thenAnswer((_) => tStream);

      // Act
      final result = usecase(prompt: tPrompt, config: tConfig);

      // Assert
      await expectLater(
        result,
        emits(const Left(tFailure)),
      );
    });

    test('should handle empty stream', () async {
      // Arrange
      const tStream = Stream<Either<Failure, String>>.empty();

      when(mockRepository.generateDiff(
        prompt: anyNamed('prompt'),
        config: anyNamed('config'),
      )).thenAnswer((_) => tStream);

      // Act
      final result = usecase(prompt: tPrompt, config: tConfig);

      // Assert
      await expectLater(result, emitsDone);
    });

    test('should work with different configurations', () async {
      // Arrange
      const tConfig2 = LLMConfig(
        provider: LLMProviderType.openai,
        apiKey: 'openai-key',
        model: 'gpt-4-turbo',
        temperature: 0.5,
      );

      final tStream = Stream<Either<Failure, String>>.fromIterable([
        const Right('response'),
      ]);

      when(mockRepository.generateDiff(
        prompt: anyNamed('prompt'),
        config: anyNamed('config'),
      )).thenAnswer((_) => tStream);

      // Act
      usecase(prompt: tPrompt, config: tConfig2);

      // Assert
      verify(mockRepository.generateDiff(
        prompt: tPrompt,
        config: tConfig2,
      ));
    });
  });
}
