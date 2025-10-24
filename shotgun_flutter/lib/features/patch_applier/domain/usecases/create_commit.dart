import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/git_repository.dart';

/// Use case for creating a Git commit
class CreateCommit {
  final GitRepository repository;

  CreateCommit(this.repository);

  /// Create a commit with the given message
  ///
  /// [message] - The commit message
  Future<Either<Failure, void>> call(String message) async {
    return await repository.createCommit(message);
  }
}
