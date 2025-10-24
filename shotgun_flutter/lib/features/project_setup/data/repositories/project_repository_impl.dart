import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/file_node.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/backend_datasource.dart';

/// Implementation of [ProjectRepository] using backend data source.
///
/// This class implements the Clean Architecture pattern:
/// - Domain layer (repository interface) doesn't know about implementation details
/// - Data layer (this class) handles the actual data fetching and conversion
/// - Converts exceptions to failures (Either pattern)
/// - Converts data models to domain entities
///
/// Responsibilities:
/// - Call [BackendDataSource] to fetch data
/// - Convert [BackendException] to [BackendFailure]
/// - Convert [FileNodeModel] to [FileNode] entities
/// - Handle unexpected errors gracefully
class ProjectRepositoryImpl implements ProjectRepository {
  final BackendDataSource backendDataSource;

  /// Creates a new [ProjectRepositoryImpl].
  ///
  /// Parameters:
  /// - [backendDataSource]: The data source for backend operations
  ProjectRepositoryImpl({required this.backendDataSource});

  @override
  Future<Either<Failure, List<FileNode>>> listFiles(String path) async {
    try {
      // Fetch models from data source
      final models = await backendDataSource.listFiles(path);

      // Convert models to entities
      final entities = models.map((model) => model.toEntity()).toList();

      // Return success
      return Right(entities);
    } on BackendException catch (e) {
      // Convert backend exception to failure
      return Left(BackendFailure(e.message));
    } catch (e) {
      // Handle unexpected errors
      return Left(BackendFailure('Unexpected error: $e'));
    }
  }
}
