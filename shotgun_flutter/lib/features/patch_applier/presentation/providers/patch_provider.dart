import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/conflict.dart';
import '../../domain/entities/patch.dart';
import '../../domain/usecases/apply_patch.dart';
import '../../domain/usecases/create_commit.dart';
import '../../domain/usecases/split_patch.dart';

part 'patch_provider.freezed.dart';
part 'patch_provider.g.dart';

@freezed
class PatchState with _$PatchState {
  const factory PatchState.initial() = _InitialState;
  const factory PatchState.loading() = _LoadingState;
  const factory PatchState.loaded({
    required List<Patch> patches,
    @Default(false) bool isApplying,
    @Default([]) List<Conflict> conflicts,
  }) = _LoadedState;
  const factory PatchState.error(String message) = _ErrorState;
}

@riverpod
class PatchNotifier extends _$PatchNotifier {
  @override
  PatchState build() {
    return const PatchState.initial();
  }

  /// Load and split a diff into patches
  Future<void> loadDiff({
    required String diff,
    required int lineLimit,
    required SplitPatch splitUseCase,
  }) async {
    state = const PatchState.loading();

    final result = await splitUseCase(diff, lineLimit);

    result.fold(
      (failure) => state = PatchState.error(failure.message),
      (patches) => state = PatchState.loaded(patches: patches),
    );
  }

  /// Apply a single patch
  Future<void> applyPatch({
    required Patch patch,
    required ApplyPatch applyUseCase,
    bool dryRun = false,
  }) async {
    state.whenOrNull(
      loaded: (patches, isApplying, conflicts) async {
        state = PatchState.loaded(
          patches: patches,
          isApplying: true,
          conflicts: conflicts,
        );

        final result = await applyUseCase(patch, dryRun: dryRun);

        result.fold(
          (failure) {
            state = PatchState.error(failure.message);
          },
          (applyResult) {
            if (applyResult.success) {
              state = PatchState.loaded(
                patches: patches,
                isApplying: false,
              );
            } else {
              state = PatchState.loaded(
                patches: patches,
                isApplying: false,
                conflicts: applyResult.conflicts,
              );
            }
          },
        );
      },
    );
  }

  /// Create a Git commit
  Future<void> createCommit({
    required String message,
    required CreateCommit createCommitUseCase,
  }) async {
    final result = await createCommitUseCase(message);

    result.fold(
      (failure) => state = PatchState.error(failure.message),
      (_) {
        // Success - keep current state
      },
    );
  }
}
