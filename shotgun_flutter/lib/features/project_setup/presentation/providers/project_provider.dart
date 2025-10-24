import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/platform/backend_bridge.dart';
import '../../data/datasources/backend_datasource.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../domain/entities/file_node.dart';
import '../../domain/entities/shotgun_context.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/usecases/generate_context.dart';
import '../../domain/usecases/list_files.dart';

part 'project_provider.g.dart';

// ===== Infrastructure Providers =====

/// Provides the BackendBridge singleton instance.
@riverpod
BackendBridge backendBridge(Ref ref) {
  return BackendBridge();
}

/// Provides the BackendDataSource implementation.
@riverpod
BackendDataSource backendDataSource(Ref ref) {
  final bridge = ref.watch(backendBridgeProvider);
  return BackendDataSourceImpl(bridge: bridge);
}

/// Provides the ProjectRepository implementation.
@riverpod
ProjectRepository projectRepository(Ref ref) {
  final dataSource = ref.watch(backendDataSourceProvider);
  return ProjectRepositoryImpl(backendDataSource: dataSource);
}

// ===== Use Case Providers =====

/// Provides the ListFiles use case.
@riverpod
ListFiles listFiles(Ref ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ListFiles(repository);
}

/// Provides the GenerateContext use case.
@riverpod
GenerateContext generateContext(Ref ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return GenerateContext(repository);
}

// ===== State Providers =====

/// Sealed class representing the project setup state.
sealed class ProjectState {
  const ProjectState();
}

/// Initial state before any project is loaded.
class ProjectStateInitial extends ProjectState {
  const ProjectStateInitial();
}

/// State when project files are loaded.
class ProjectStateLoaded extends ProjectState {
  final String projectPath;
  final List<FileNode> fileTree;
  final ShotgunContext? context;
  final Set<String> excludedPaths;

  const ProjectStateLoaded({
    required this.projectPath,
    required this.fileTree,
    this.context,
    this.excludedPaths = const {},
  });

  ProjectStateLoaded copyWith({
    String? projectPath,
    List<FileNode>? fileTree,
    ShotgunContext? context,
    Set<String>? excludedPaths,
  }) {
    return ProjectStateLoaded(
      projectPath: projectPath ?? this.projectPath,
      fileTree: fileTree ?? this.fileTree,
      context: context ?? this.context,
      excludedPaths: excludedPaths ?? this.excludedPaths,
    );
  }
}

/// State when context is being generated.
class ProjectStateGenerating extends ProjectState {
  final String projectPath;
  final List<FileNode> fileTree;
  final Set<String> excludedPaths;

  const ProjectStateGenerating({
    required this.projectPath,
    required this.fileTree,
    required this.excludedPaths,
  });
}

/// State when an error occurs.
class ProjectStateError extends ProjectState {
  final String message;

  const ProjectStateError(this.message);
}

/// Notifier for managing project state.
@riverpod
class ProjectNotifier extends _$ProjectNotifier {
  @override
  ProjectState build() {
    return const ProjectStateInitial();
  }

  /// Loads a project from the specified path.
  Future<void> loadProject(String path) async {
    state = const ProjectStateInitial();

    final listFilesUseCase = ref.read(listFilesProvider);
    final result = await listFilesUseCase(path);

    result.fold(
      (failure) {
        state = ProjectStateError(failure.message);
      },
      (files) {
        state = ProjectStateLoaded(
          projectPath: path,
          fileTree: files,
          excludedPaths: {},
        );
        // Auto-start context generation
        _startContextGeneration(path, {});
      },
    );
  }

  /// Toggles exclusion of a file or directory.
  void toggleExclusion(FileNode node) {
    final currentState = state;
    if (currentState is! ProjectStateLoaded) return;

    final excludedPaths = Set<String>.from(currentState.excludedPaths);
    if (excludedPaths.contains(node.path)) {
      excludedPaths.remove(node.path);
    } else {
      excludedPaths.add(node.path);
    }

    state = currentState.copyWith(excludedPaths: excludedPaths);

    // Restart context generation with new exclusions
    _startContextGeneration(currentState.projectPath, excludedPaths);
  }

  /// Starts context generation in the background.
  Future<void> _startContextGeneration(
    String projectPath,
    Set<String> excludedPaths,
  ) async {
    final currentState = state;
    if (currentState is! ProjectStateLoaded) return;

    // Update state to generating
    state = ProjectStateGenerating(
      projectPath: projectPath,
      fileTree: currentState.fileTree,
      excludedPaths: excludedPaths,
    );

    final generateContextUseCase = ref.read(generateContextProvider);
    final stream = generateContextUseCase(
      rootDir: projectPath,
      excludedPaths: excludedPaths.toList(),
    );

    await for (final result in stream) {
      result.fold(
        (failure) {
          state = ProjectStateError(failure.message);
        },
        (context) {
          state = ProjectStateLoaded(
            projectPath: projectPath,
            fileTree: currentState.fileTree,
            context: context,
            excludedPaths: excludedPaths,
          );
        },
      );
    }
  }
}
