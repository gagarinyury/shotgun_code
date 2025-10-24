import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/git_repository.dart';

/// Implementation of [GitRepository] using git command line
///
/// Note: This is a simplified implementation using git CLI.
/// For production, consider using libgit2dart with proper API integration.
class GitRepositoryImpl implements GitRepository {
  final String projectPath;

  GitRepositoryImpl({required this.projectPath});

  @override
  Future<Either<Failure, void>> createCommit(String message) async {
    try {
      // Stage all changes
      final addResult = await Process.run(
        'git',
        ['add', '.'],
        workingDirectory: projectPath,
      );

      if (addResult.exitCode != 0) {
        return Left(ServerFailure('Failed to stage changes: ${addResult.stderr}'));
      }

      // Create commit
      final commitResult = await Process.run(
        'git',
        ['commit', '-m', message],
        workingDirectory: projectPath,
      );

      if (commitResult.exitCode != 0) {
        return Left(ServerFailure('Failed to create commit: ${commitResult.stderr}'));
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to create commit: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createBranch(String name) async {
    try {
      final result = await Process.run(
        'git',
        ['branch', name],
        workingDirectory: projectPath,
      );

      if (result.exitCode != 0) {
        return Left(ServerFailure('Failed to create branch: ${result.stderr}'));
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to create branch: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> rollback() async {
    try {
      final result = await Process.run(
        'git',
        ['reset', '--hard', 'HEAD'],
        workingDirectory: projectPath,
      );

      if (result.exitCode != 0) {
        return Left(ServerFailure('Failed to rollback: ${result.stderr}'));
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to rollback: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasUncommittedChanges() async {
    try {
      final result = await Process.run(
        'git',
        ['status', '--porcelain'],
        workingDirectory: projectPath,
      );

      if (result.exitCode != 0) {
        return Left(ServerFailure('Failed to check status: ${result.stderr}'));
      }

      // If output is not empty, there are uncommitted changes
      return Right((result.stdout as String).trim().isNotEmpty);
    } catch (e) {
      return Left(ServerFailure('Failed to check status: $e'));
    }
  }
}
