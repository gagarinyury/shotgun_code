import 'package:equatable/equatable.dart';

/// Represents a merge conflict when applying a patch
class Conflict extends Equatable {
  /// The file path where the conflict occurred
  final String filePath;

  /// Line number of the conflict
  final int lineNumber;

  /// The version from the patch (their version)
  final String theirVersion;

  /// The current version in the file (our version)
  final String ourVersion;

  const Conflict({
    required this.filePath,
    required this.lineNumber,
    required this.theirVersion,
    required this.ourVersion,
  });

  @override
  List<Object?> get props => [filePath, lineNumber, theirVersion, ourVersion];

  @override
  String toString() {
    return 'Conflict(file: $filePath, line: $lineNumber)';
  }
}
