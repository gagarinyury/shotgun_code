import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/apply_result.dart';
import '../entities/patch.dart';
import '../repositories/patch_repository.dart';

/// Use case for applying a patch to the project
class ApplyPatch {
  final PatchRepository repository;

  ApplyPatch(this.repository);

  /// Apply the patch
  ///
  /// [patch] - The patch to apply
  /// [dryRun] - If true, only check if patch can be applied
  Future<Either<Failure, ApplyResult>> call(
    Patch patch, {
    bool dryRun = false,
  }) async {
    return await repository.applyPatch(patch, dryRun: dryRun);
  }
}
