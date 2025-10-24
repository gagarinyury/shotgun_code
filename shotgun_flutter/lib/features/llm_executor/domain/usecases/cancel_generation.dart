import 'package:dartz/dartz.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/repositories/llm_repository.dart';

/// Use case for canceling LLM generation
class CancelGeneration {
  final LLMRepository repository;

  CancelGeneration(this.repository);

  /// Cancel the current LLM generation
  Future<Either<Failure, void>> call() async {
    return await repository.cancelGeneration();
  }
}
