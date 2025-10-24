import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/prompt_repository.dart';

/// Use case for saving custom rules.
///
/// This use case encapsulates the business logic for persisting the user's
/// custom rules. These rules will be included in future prompts.
///
/// Following Clean Architecture, use cases:
/// - Contain application-specific business rules
/// - Are independent of frameworks and UI
/// - Depend only on entities and repository interfaces
class SaveCustomRules {
  final PromptRepository repository;

  /// Creates a new [SaveCustomRules] use case.
  ///
  /// Parameters:
  /// - [repository]: The repository to save rules with
  SaveCustomRules(this.repository);

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [rules]: The custom rules text to save
  ///
  /// Returns:
  /// - `Right(void)`: Rules saved successfully
  /// - `Left(Failure)`: Failure object on error
  Future<Either<Failure, void>> call(String rules) async {
    return await repository.saveCustomRules(rules);
  }
}
