import 'package:equatable/equatable.dart';

/// Represents the generated context for a project.
///
/// This entity holds the full context text along with metadata about when
/// it was generated and its size. Used in Step 1 after context generation completes.
class ShotgunContext extends Equatable {
  /// The root path of the project this context was generated from.
  final String projectPath;

  /// The generated context text (concatenation of all selected files).
  final String context;

  /// Size of the context in bytes.
  final int sizeBytes;

  /// When this context was generated.
  final DateTime generatedAt;

  const ShotgunContext({
    required this.projectPath,
    required this.context,
    required this.sizeBytes,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [projectPath, context, sizeBytes, generatedAt];
}
