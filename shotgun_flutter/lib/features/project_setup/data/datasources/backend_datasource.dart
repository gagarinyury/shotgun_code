import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../core/platform/backend_bridge.dart';
import '../models/file_node_model.dart';

/// Abstract data source interface for backend operations.
///
/// This interface defines the contract for communicating with the Go backend.
/// Implementations should handle the actual FFI calls and JSON parsing.
abstract class BackendDataSource {
  /// Lists all files and directories in the given path.
  ///
  /// Parameters:
  /// - [path]: Absolute path to the directory to list
  ///
  /// Returns:
  /// - List of `FileNodeModel` representing the file tree
  ///
  /// Throws:
  /// - [BackendException] if the backend returns an error
  Future<List<FileNodeModel>> listFiles(String path);
}

/// Implementation of [BackendDataSource] using FFI bridge to Go backend.
///
/// This class:
/// - Calls Go functions via [BackendBridge]
/// - Parses JSON responses from Go
/// - Converts JSON to [FileNodeModel] objects
/// - Handles errors from the backend
///
/// Error handling:
/// - Go backend returns `{"error": "message"}` on failure
/// - This class detects the error field and throws [BackendException]
class BackendDataSourceImpl implements BackendDataSource {
  final BackendBridge bridge;

  /// Creates a new [BackendDataSourceImpl].
  ///
  /// Parameters:
  /// - [bridge]: The FFI bridge to communicate with Go backend
  BackendDataSourceImpl({required this.bridge});

  @override
  Future<List<FileNodeModel>> listFiles(String path) async {
    try {
      // Call Go backend via FFI
      final jsonString = bridge.listFiles(path);

      // Parse JSON response
      final decoded = jsonDecode(jsonString);

      // Check for error response
      if (decoded is Map && decoded.containsKey('error')) {
        throw BackendException(decoded['error'] as String);
      }

      // Parse array of FileNodes
      if (decoded is List) {
        return decoded
            .map((item) => FileNodeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw BackendException('Unexpected response format: ${decoded.runtimeType}');
    } on BackendException {
      // Re-throw backend exceptions
      rethrow;
    } catch (e) {
      // Wrap other exceptions
      throw BackendException('Failed to list files: $e');
    }
  }
}
