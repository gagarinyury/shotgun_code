import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/file_node.dart';

part 'file_node_model.freezed.dart';
part 'file_node_model.g.dart';

/// Data model for FileNode with JSON serialization support.
///
/// This model is responsible for:
/// - JSON serialization/deserialization (from Go backend)
/// - Conversion to domain entity
/// - Immutability through Freezed
///
/// The structure matches the Go backend's FileNode struct.
@freezed
class FileNodeModel with _$FileNodeModel {
  const FileNodeModel._();

  const factory FileNodeModel({
    required String name,
    required String path,
    required String relPath,
    required bool isDir,
    required bool isGitignored,
    required bool isCustomIgnored,
    List<FileNodeModel>? children,
  }) = _FileNodeModel;

  /// Creates a FileNodeModel from JSON response.
  ///
  /// This is used when parsing the JSON string returned by the Go backend
  /// via FFI calls.
  factory FileNodeModel.fromJson(Map<String, dynamic> json) =>
      _$FileNodeModelFromJson(json);

  /// Converts this model to a domain entity.
  ///
  /// This method ensures the data layer doesn't leak into the domain layer.
  /// All children are recursively converted to entities as well.
  FileNode toEntity() {
    return FileNode(
      name: name,
      path: path,
      relPath: relPath,
      isDir: isDir,
      isGitignored: isGitignored,
      isCustomIgnored: isCustomIgnored,
      children: children?.map((c) => c.toEntity()).toList(),
    );
  }

  /// Creates a FileNodeModel from a domain entity.
  ///
  /// This is useful for testing or when you need to serialize
  /// an entity back to JSON.
  factory FileNodeModel.fromEntity(FileNode entity) {
    return FileNodeModel(
      name: entity.name,
      path: entity.path,
      relPath: entity.relPath,
      isDir: entity.isDir,
      isGitignored: entity.isGitignored,
      isCustomIgnored: entity.isCustomIgnored,
      children: entity.children
          ?.map((c) => FileNodeModel.fromEntity(c))
          .toList(),
    );
  }
}
