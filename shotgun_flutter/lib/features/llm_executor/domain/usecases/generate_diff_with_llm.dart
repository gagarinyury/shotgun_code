import 'package:dartz/dartz.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_config.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/repositories/llm_repository.dart';

/// Use case for generating diff using LLM
class GenerateDiffWithLLM {
  final LLMRepository repository;

  GenerateDiffWithLLM(this.repository);

  /// Generate diff from prompt using specified LLM configuration
  ///
  /// Returns a stream of text chunks as the LLM generates the response
  Stream<Either<Failure, String>> call({
    required String prompt,
    required LLMConfig config,
  }) {
    return repository.generateDiff(prompt: prompt, config: config);
  }
}
