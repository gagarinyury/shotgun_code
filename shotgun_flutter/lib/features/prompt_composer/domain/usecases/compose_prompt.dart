import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prompt_template.dart';
import '../repositories/prompt_repository.dart';

/// Use case for composing a final prompt from components.
///
/// This use case encapsulates the business logic for creating a complete
/// prompt by combining context, task, rules, and a template. It delegates
/// to the repository layer while remaining independent of implementation details.
///
/// Following Clean Architecture, use cases:
/// - Contain application-specific business rules
/// - Are independent of frameworks and UI
/// - Depend only on entities and repository interfaces
class ComposePrompt {
  final PromptRepository repository;

  /// Creates a new [ComposePrompt] use case.
  ///
  /// Parameters:
  /// - [repository]: The repository to compose prompts with
  ComposePrompt(this.repository);

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [context]: The project context (file contents)
  /// - [task]: The user's task description
  /// - [rules]: Custom rules to apply
  /// - [template]: The template to use for composition
  ///
  /// Returns:
  /// - `Right(String)`: Composed prompt on success
  /// - `Left(Failure)`: Failure object on error
  Future<Either<Failure, String>> call({
    required String context,
    required String task,
    required String rules,
    required PromptTemplate template,
  }) async {
    return await repository.composePrompt(
      context: context,
      task: task,
      rules: rules,
      template: template,
    );
  }
}
