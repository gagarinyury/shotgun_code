import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/platform/backend_bridge.dart';
import '../../domain/entities/apply_result.dart';
import '../../domain/entities/conflict.dart';
import '../../domain/entities/patch.dart';
import '../../domain/repositories/patch_repository.dart';

/// Implementation of [PatchRepository] using Go backend via FFI
class PatchRepositoryImpl implements PatchRepository {
  final BackendBridge bridge;

  PatchRepositoryImpl({required this.bridge});

  @override
  Future<Either<Failure, List<Patch>>> splitPatch(
    String diff,
    int lineLimit,
  ) async {
    try {
      final jsonString = bridge.splitDiff(diff, lineLimit);
      final decoded = jsonDecode(jsonString);

      // Check for error response
      if (decoded is Map && decoded.containsKey('error')) {
        throw BackendException(decoded['error'] as String);
      }

      // Parse array of patches
      if (decoded is List) {
        final patches = decoded.map((item) {
          final patchContent = item as String;
          return Patch(
            content: patchContent,
            projectPath: '',
            filesChanged: _countFiles(patchContent),
            linesAdded: _countAdditions(patchContent),
            linesRemoved: _countDeletions(patchContent),
          );
        }).toList();

        return Right(patches);
      }

      throw const BackendException('Unexpected response format');
    } on BackendException catch (e) {
      return Left(BackendFailure(e.message));
    } catch (e) {
      return Left(BackendFailure('Failed to split patch: $e'));
    }
  }

  @override
  Future<Either<Failure, ApplyResult>> applyPatch(
    Patch patch, {
    bool dryRun = false,
  }) async {
    try {
      final jsonString = bridge.applyPatch(
        patch.content,
        patch.projectPath,
        dryRun: dryRun,
      );
      final decoded = jsonDecode(jsonString);

      // Check for error response
      if (decoded is Map && decoded.containsKey('error')) {
        throw BackendException(decoded['error'] as String);
      }

      // Parse apply result
      if (decoded is Map) {
        final success = decoded['success'] as bool;
        final conflictsData = decoded['conflicts'] as List<dynamic>? ?? [];

        if (success) {
          return Right(ApplyResult.success());
        } else {
          // Parse conflicts from strings
          final conflicts = conflictsData
              .map((c) => Conflict(
                    filePath: 'unknown',
                    lineNumber: 0,
                    theirVersion: c.toString(),
                    ourVersion: '',
                  ))
              .toList();

          return Right(ApplyResult.failure(conflicts: conflicts));
        }
      }

      throw const BackendException('Unexpected response format');
    } on BackendException catch (e) {
      return Left(BackendFailure(e.message));
    } catch (e) {
      return Left(BackendFailure('Failed to apply patch: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Conflict>>> detectConflicts(Patch patch) async {
    try {
      // Use dry-run to detect conflicts
      final result = await applyPatch(patch, dryRun: true);

      return result.fold(
        (failure) => Left(failure),
        (applyResult) => Right(applyResult.conflicts),
      );
    } catch (e) {
      return Left(BackendFailure('Failed to detect conflicts: $e'));
    }
  }

  /// Count number of files changed in diff
  int _countFiles(String diff) {
    return 'diff --git'.allMatches(diff).length;
  }

  /// Count number of lines added
  int _countAdditions(String diff) {
    final lines = diff.split('\n');
    return lines.where((line) => line.startsWith('+')).length;
  }

  /// Count number of lines removed
  int _countDeletions(String diff) {
    final lines = diff.split('\n');
    return lines.where((line) => line.startsWith('-')).length;
  }
}
