import 'package:equatable/equatable.dart';

/// Domain entity representing a file or directory node in the project tree.
///
/// This is a pure domain object with no dependencies on external frameworks
/// or implementation details. It represents the core business concept of a
/// file system node with gitignore and custom ignore status.
class FileNode extends Equatable {
  /// Name of the file or directory
  final String name;

  /// Absolute path to the file or directory
  final String path;

  /// Path relative to the selected project root
  final String relPath;

  /// Whether this is a directory (true) or a file (false)
  final bool isDir;

  /// Whether this path matches a .gitignore rule
  final bool isGitignored;

  /// Whether this path matches a custom ignore rule
  final bool isCustomIgnored;

  /// Child nodes (only for directories)
  final List<FileNode>? children;

  const FileNode({
    required this.name,
    required this.path,
    required this.relPath,
    required this.isDir,
    required this.isGitignored,
    required this.isCustomIgnored,
    this.children,
  });

  @override
  List<Object?> get props => [
        name,
        path,
        relPath,
        isDir,
        isGitignored,
        isCustomIgnored,
        children,
      ];

  /// Creates a copy of this FileNode with updated fields
  FileNode copyWith({
    String? name,
    String? path,
    String? relPath,
    bool? isDir,
    bool? isGitignored,
    bool? isCustomIgnored,
    List<FileNode>? children,
  }) {
    return FileNode(
      name: name ?? this.name,
      path: path ?? this.path,
      relPath: relPath ?? this.relPath,
      isDir: isDir ?? this.isDir,
      isGitignored: isGitignored ?? this.isGitignored,
      isCustomIgnored: isCustomIgnored ?? this.isCustomIgnored,
      children: children ?? this.children,
    );
  }

  @override
  String toString() {
    return 'FileNode(name: $name, path: $path, isDir: $isDir, '
        'isGitignored: $isGitignored, isCustomIgnored: $isCustomIgnored)';
  }
}
