import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/apply_result.dart';
import '../entities/conflict.dart';
import '../entities/patch.dart';

/// Repository for patch operations
abstract class PatchRepository {
  /// Apply a patch to the project
  ///
  /// [patch] - The patch to apply
  /// [dryRun] - If true, only check if patch can be applied without actually applying it
  ///
  /// Returns [ApplyResult] with success status and any conflicts
  Future<Either<Failure, ApplyResult>> applyPatch(
    Patch patch, {
    bool dryRun = false,
  });

  /// Detect conflicts without applying the patch
  ///
  /// Returns list of conflicts that would occur if patch is applied
  Future<Either<Failure, List<Conflict>>> detectConflicts(Patch patch);

  /// Split a large diff into smaller patches
  ///
  /// [diff] - The raw diff content
  /// [lineLimit] - Maximum number of lines per patch
  ///
  /// Returns list of smaller patches
  Future<Either<Failure, List<Patch>>> splitPatch(
    String diff,
    int lineLimit,
  );
}
