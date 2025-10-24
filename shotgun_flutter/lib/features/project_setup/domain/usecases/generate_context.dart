import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/shotgun_context.dart';
import '../repositories/project_repository.dart';

/// Use case for generating context from project files.
///
/// This use case handles the business logic for generating a concatenated
/// context from selected files in a project. It:
/// - Validates input parameters
/// - Delegates to repository for actual generation
/// - Returns a stream of progress updates and final result
class GenerateContext {
  final ProjectRepository repository;

  /// Creates a new [GenerateContext] use case.
  ///
  /// Parameters:
  /// - [repository]: The repository to perform context generation
  GenerateContext(this.repository);

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [rootDir]: The root directory of the project
  /// - [excludedPaths]: List of paths to exclude from context generation
  ///
  /// Returns:
  /// - Stream emitting `Right(ShotgunContext)` on success
  /// - Stream emitting `Left(Failure)` on error
  Stream<Either<Failure, ShotgunContext>> call({
    required String rootDir,
    required List<String> excludedPaths,
  }) {
    // Validate inputs
    if (rootDir.isEmpty) {
      return Stream.value(
        const Left(BackendFailure('Root directory cannot be empty')),
      );
    }

    // Delegate to repository
    return repository.generateContext(
      rootDir: rootDir,
      excludedPaths: excludedPaths,
    );
  }
}
