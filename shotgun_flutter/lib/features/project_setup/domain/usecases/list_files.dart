import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/file_node.dart';
import '../repositories/project_repository.dart';

/// Use case for listing files in a directory.
///
/// This use case encapsulates the business logic for retrieving a file tree
/// from a specified path. It delegates to the repository layer while remaining
/// independent of implementation details.
///
/// Following Clean Architecture, use cases:
/// - Contain application-specific business rules
/// - Are independent of frameworks and UI
/// - Depend only on entities and repository interfaces
class ListFiles {
  final ProjectRepository repository;

  /// Creates a new [ListFiles] use case.
  ///
  /// Parameters:
  /// - [repository]: The repository to fetch files from
  ListFiles(this.repository);

  /// Executes the use case.
  ///
  /// Parameters:
  /// - [path]: Absolute path to the directory to list
  ///
  /// Returns:
  /// - `Right(List<FileNode>)`: List of files/directories on success
  /// - `Left(Failure)`: Failure object on error
  Future<Either<Failure, List<FileNode>>> call(String path) async {
    return await repository.listFiles(path);
  }
}
