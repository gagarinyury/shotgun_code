import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/prompt_repository.dart';

/// Use case for loading custom rules.
///
/// This use case encapsulates the business logic for retrieving the user's
/// saved custom rules that should be included in prompts.
///
/// Following Clean Architecture, use cases:
/// - Contain application-specific business rules
/// - Are independent of frameworks and UI
/// - Depend only on entities and repository interfaces
class LoadCustomRules {
  final PromptRepository repository;

  /// Creates a new [LoadCustomRules] use case.
  ///
  /// Parameters:
  /// - [repository]: The repository to load rules from
  LoadCustomRules(this.repository);

  /// Executes the use case.
  ///
  /// Returns:
  /// - `Right(String)`: The custom rules text (empty if none saved)
  /// - `Left(Failure)`: Failure object on error
  Future<Either<Failure, String>> call() async {
    return await repository.loadCustomRules();
  }
}
