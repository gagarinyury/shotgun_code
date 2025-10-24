import 'package:equatable/equatable.dart';

/// Represents a code patch that can be applied to a project
class Patch extends Equatable {
  /// The raw diff content
  final String content;

  /// The project path where this patch should be applied
  final String projectPath;

  /// Number of files changed in this patch
  final int filesChanged;

  /// Number of lines added
  final int linesAdded;

  /// Number of lines removed
  final int linesRemoved;

  const Patch({
    required this.content,
    required this.projectPath,
    required this.filesChanged,
    required this.linesAdded,
    required this.linesRemoved,
  });

  @override
  List<Object?> get props => [
        content,
        projectPath,
        filesChanged,
        linesAdded,
        linesRemoved,
      ];

  @override
  String toString() {
    return 'Patch(files: $filesChanged, +$linesAdded, -$linesRemoved)';
  }
}
