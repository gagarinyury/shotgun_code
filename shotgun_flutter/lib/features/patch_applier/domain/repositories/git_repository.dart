import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

/// Repository for Git operations
abstract class GitRepository {
  /// Create a Git commit with all staged changes
  ///
  /// [message] - The commit message
  Future<Either<Failure, void>> createCommit(String message);

  /// Create a new Git branch
  ///
  /// [name] - The branch name
  Future<Either<Failure, void>> createBranch(String name);

  /// Rollback uncommitted changes
  ///
  /// Resets working directory to HEAD
  Future<Either<Failure, void>> rollback();

  /// Check if there are uncommitted changes
  ///
  /// Returns true if there are changes not yet committed
  Future<Either<Failure, bool>> hasUncommittedChanges();
}
