import 'package:equatable/equatable.dart';

import 'conflict.dart';

/// Result of applying a patch to a project
class ApplyResult extends Equatable {
  /// Whether the patch was applied successfully
  final bool success;

  /// List of conflicts encountered (empty if successful)
  final List<Conflict> conflicts;

  /// Human-readable message about the result
  final String message;

  const ApplyResult({
    required this.success,
    this.conflicts = const [],
    required this.message,
  });

  /// Factory for successful application
  factory ApplyResult.success() {
    return const ApplyResult(
      success: true,
      message: 'Patch applied successfully',
    );
  }

  /// Factory for failed application with conflicts
  factory ApplyResult.failure({required List<Conflict> conflicts}) {
    return ApplyResult(
      success: false,
      conflicts: conflicts,
      message: 'Patch has ${conflicts.length} conflict(s)',
    );
  }

  @override
  List<Object?> get props => [success, conflicts, message];

  @override
  String toString() {
    return 'ApplyResult(success: $success, conflicts: ${conflicts.length})';
  }
}
