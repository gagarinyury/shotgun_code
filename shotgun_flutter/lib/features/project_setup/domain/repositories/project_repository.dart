import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/file_node.dart';

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
}
