import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/patch.dart';
import '../repositories/patch_repository.dart';

/// Use case for splitting a large diff into smaller patches
class SplitPatch {
  final PatchRepository repository;

  SplitPatch(this.repository);

  /// Split the diff into smaller patches
  ///
  /// [diff] - The raw diff content
  /// [lineLimit] - Maximum lines per patch (default: 500)
  Future<Either<Failure, List<Patch>>> call(
    String diff,
    int lineLimit,
  ) async {
    return await repository.splitPatch(diff, lineLimit);
  }
}
