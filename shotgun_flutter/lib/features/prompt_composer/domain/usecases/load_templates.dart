import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prompt_template.dart';
import '../repositories/prompt_repository.dart';

/// Use case for loading available prompt templates.
///
/// This use case encapsulates the business logic for retrieving all
/// prompt templates (both built-in and custom) available to the user.
///
/// Following Clean Architecture, use cases:
/// - Contain application-specific business rules
/// - Are independent of frameworks and UI
/// - Depend only on entities and repository interfaces
class LoadTemplates {
  final PromptRepository repository;

  /// Creates a new [LoadTemplates] use case.
  ///
  /// Parameters:
  /// - [repository]: The repository to load templates from
  LoadTemplates(this.repository);

  /// Executes the use case.
  ///
  /// Returns:
  /// - `Right(List<PromptTemplate>)`: List of available templates on success
  /// - `Left(Failure)`: Failure object on error
  Future<Either<Failure, List<PromptTemplate>>> call() async {
    return await repository.loadTemplates();
  }
}
