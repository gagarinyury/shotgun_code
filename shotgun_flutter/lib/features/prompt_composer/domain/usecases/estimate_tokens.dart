import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/prompt_repository.dart';

/// Use case for estimating token count of text.
///
/// This use case encapsulates the business logic for calculating the
/// approximate number of tokens in a given text. This helps users understand
/// if their prompt will fit within LLM context limits.
///
/// Following Clean Architecture, use cases:
/// - Contain application-specific business rules
/// - Are independent of frameworks and UI
/// - Depend only on entities and repository interfaces
class EstimateTokens {
  final PromptRepository repository;

  /// Creates a new [EstimateTokens] use case.
  ///
  /// Parameters:
  /// - [repository]: The repository to estimate tokens with
  EstimateTokens(this.repository);

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [text]: The text to estimate tokens for
  ///
  /// Returns:
  /// - `Right(int)`: Estimated token count on success
  /// - `Left(Failure)`: Failure object on error
  Future<Either<Failure, int>> call(String text) async {
    return await repository.estimateTokens(text);
  }
}
