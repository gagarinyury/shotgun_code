import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/platform/backend_bridge.dart';
import '../../data/repositories/git_repository_impl.dart';
import '../../data/repositories/patch_repository_impl.dart';
import '../../domain/repositories/git_repository.dart';
import '../../domain/repositories/patch_repository.dart';
import '../../domain/usecases/apply_patch.dart';
import '../../domain/usecases/create_commit.dart';
import '../../domain/usecases/rollback_changes.dart';
import '../../domain/usecases/split_patch.dart';

part 'patch_applier_providers.g.dart';

// =============================================================================
// Infrastructure
// =============================================================================

@riverpod
BackendBridge backendBridge(Ref ref) {
  return BackendBridge();
}

// =============================================================================
// Repositories
// =============================================================================

@riverpod
PatchRepository patchRepository(Ref ref) {
  final bridge = ref.watch(backendBridgeProvider);
  return PatchRepositoryImpl(bridge: bridge);
}

@riverpod
GitRepository gitRepository(Ref ref, String projectPath) {
  return GitRepositoryImpl(projectPath: projectPath);
}

// =============================================================================
// Use Cases
// =============================================================================

@riverpod
ApplyPatch applyPatchUseCase(Ref ref) {
  final repository = ref.watch(patchRepositoryProvider);
  return ApplyPatch(repository);
}

@riverpod
SplitPatch splitPatchUseCase(Ref ref) {
  final repository = ref.watch(patchRepositoryProvider);
  return SplitPatch(repository);
}

@riverpod
CreateCommit createCommitUseCase(Ref ref, String projectPath) {
  final repository = ref.watch(gitRepositoryProvider(projectPath));
  return CreateCommit(repository);
}

@riverpod
RollbackChanges rollbackChangesUseCase(
  Ref ref,
  String projectPath,
) {
  final repository = ref.watch(gitRepositoryProvider(projectPath));
  return RollbackChanges(repository);
}
