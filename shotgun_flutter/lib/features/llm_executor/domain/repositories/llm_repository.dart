import 'package:dartz/dartz.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_config.dart';

/// Repository interface for LLM operations
abstract class LLMRepository {
  /// Generate diff from prompt using specified LLM configuration
  ///
  /// Returns a stream of `Either<Failure, String>` where:
  /// - `Left(Failure)`: Error occurred during generation
  /// - `Right(String)`: Chunk of generated text (streaming)
  ///
  /// The stream will emit multiple chunks as the LLM generates text,
  /// allowing for real-time display of the response.
  Stream<Either<Failure, String>> generateDiff({
    required String prompt,
    required LLMConfig config,
  });

  /// Cancel the current generation
  ///
  /// Returns `Either<Failure, void>` where:
  /// - `Left(Failure)`: Failed to cancel
  /// - `Right(void)`: Successfully cancelled
  Future<Either<Failure, void>> cancelGeneration();
}
