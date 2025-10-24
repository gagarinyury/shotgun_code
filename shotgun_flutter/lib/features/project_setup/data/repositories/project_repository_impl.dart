import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/file_node.dart';
import '../../domain/entities/shotgun_context.dart';
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

  @override
  Stream<Either<Failure, ShotgunContext>> generateContext({
    required String rootDir,
    required List<String> excludedPaths,
  }) async* {
    try {
      // Call backend data source streaming method
      final stream = backendDataSource.generateContextStream(
        rootDir: rootDir,
        excludedPaths: excludedPaths,
      );

      await for (final data in stream) {
        // Check if this is the final result (contains 'context' key)
        if (data.containsKey('context')) {
          // Parse final context
          final context = ShotgunContext(
            projectPath: rootDir,
            context: data['context'] as String,
            sizeBytes: (data['sizeBytes'] as num?)?.toInt() ?? 0,
            generatedAt: DateTime.now(),
          );
          yield Right(context);
        }
        // Note: Progress updates would be handled here if backend sends them
      }
    } on BackendException catch (e) {
      yield Left(BackendFailure(e.message));
    } catch (e) {
      yield Left(BackendFailure('Context generation failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setUseGitignore(bool value) async {
    try {
      await backendDataSource.setUseGitignore(value);
      return const Right(null);
    } on BackendException catch (e) {
      return Left(BackendFailure(e.message));
    } catch (e) {
      return Left(BackendFailure('Failed to set gitignore: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setUseCustomIgnore(bool value) async {
    try {
      await backendDataSource.setUseCustomIgnore(value);
      return const Right(null);
    } on BackendException catch (e) {
      return Left(BackendFailure(e.message));
    } catch (e) {
      return Left(BackendFailure('Failed to set custom ignore: $e'));
    }
  }
}
