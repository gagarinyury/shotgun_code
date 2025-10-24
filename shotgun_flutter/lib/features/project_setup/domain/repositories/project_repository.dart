import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/file_node.dart';
import '../entities/shotgun_context.dart';

/// Domain repository interface for project operations.
///
/// This abstract class defines the contract for project-related operations
/// without any implementation details. It uses `Either<Failure, Success>` pattern
/// for error handling, following Clean Architecture principles.
///
/// All methods return Either to explicitly handle both success and failure cases:
/// - `Left(Failure)`: An error occurred
/// - `Right(Success)`: Operation completed successfully
abstract class ProjectRepository {
  /// Lists all files and directories in the given path.
  ///
  /// Returns a tree structure starting from the specified [path].
  /// The result respects .gitignore and custom ignore rules.
  ///
  /// Returns:
  /// - `Right(List\<FileNode\>)`: List of file/directory nodes (usually single root)
  /// - `Left(Failure)`: If path doesn't exist, access denied, or backend error
  Future<Either<Failure, List<FileNode>>> listFiles(String path);

  /// Generates context from selected files in the project.
  ///
  /// Streams progress updates as files are processed, then returns the final
  /// [ShotgunContext] when complete.
  ///
  /// Parameters:
  /// - [rootDir]: The root directory of the project
  /// - [excludedPaths]: List of paths to exclude from context generation
  ///
  /// Returns a stream that emits:
  /// - `Left(Failure)`: If an error occurs during generation
  /// - `Right(ShotgunContext)`: The final generated context
  Stream<Either<Failure, ShotgunContext>> generateContext({
    required String rootDir,
    required List<String> excludedPaths,
  });

  /// Sets whether to use .gitignore rules for file exclusion.
  ///
  /// When enabled, files matching .gitignore patterns will be excluded
  /// from the file tree and context generation.
  ///
  /// Returns:
  /// - `Right(void)`: Setting updated successfully
  /// - `Left(Failure)`: If update fails
  Future<Either<Failure, void>> setUseGitignore(bool value);

  /// Sets whether to use custom ignore rules for file exclusion.
  ///
  /// When enabled, files matching custom ignore patterns will be excluded
  /// from the file tree and context generation.
  ///
  /// Returns:
  /// - `Right(void)`: Setting updated successfully
  /// - `Left(Failure)`: If update fails
  Future<Either<Failure, void>> setUseCustomIgnore(bool value);
}
