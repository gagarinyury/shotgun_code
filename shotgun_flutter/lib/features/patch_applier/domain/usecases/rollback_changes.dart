import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/git_repository.dart';

/// Use case for rolling back uncommitted changes
class RollbackChanges {
  final GitRepository repository;

  RollbackChanges(this.repository);

  /// Rollback all uncommitted changes
  Future<Either<Failure, void>> call() async {
    return await repository.rollback();
  }
}
