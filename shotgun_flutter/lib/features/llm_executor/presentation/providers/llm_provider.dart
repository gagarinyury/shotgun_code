import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_config.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/usecases/cancel_generation.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/usecases/generate_diff_with_llm.dart';

part 'llm_provider.freezed.dart';
part 'llm_provider.g.dart';

/// State for LLM generation
@freezed
class LLMState with _$LLMState {
  const factory LLMState.initial() = _InitialState;
  const factory LLMState.generating({required String response}) =
      _GeneratingState;
  const factory LLMState.completed({required String diff}) = _CompletedState;
  const factory LLMState.cancelled() = _CancelledState;
  const factory LLMState.error({required String message}) = _ErrorState;
}

/// Provider for LLM generation state management
@riverpod
class LLMNotifier extends _$LLMNotifier {
  StreamSubscription<dynamic>? _subscription;
  final StringBuffer _accumulatedResponse = StringBuffer();

  @override
  FutureOr<LLMState> build() {
    // Clean up subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    return const LLMState.initial();
  }

  /// Start generating diff with the given prompt and config
  Future<void> startGeneration({
    required String prompt,
    required LLMConfig config,
  }) async {
    // Cancel any existing generation
    await _cancelExisting();

    // Reset accumulated response
    _accumulatedResponse.clear();
    state = const AsyncValue.data(LLMState.generating(response: ''));

    // Get use case from dependency injection
    // Note: This needs to be injected via constructor or provider
    // For now, we'll assume it's available via ref
    final generateUseCase = ref.read(generateDiffWithLLMProvider);

    final stream = generateUseCase(prompt: prompt, config: config);

    _subscription = stream.listen(
      (result) {
        result.fold(
          (failure) {
            final message = _getFailureMessage(failure);
            state = AsyncValue.data(LLMState.error(message: message));
            _subscription?.cancel();
          },
          (chunk) {
            _accumulatedResponse.write(chunk);
            state = AsyncValue.data(
              LLMState.generating(response: _accumulatedResponse.toString()),
            );
          },
        );
      },
      onDone: () {
        state = AsyncValue.data(
          LLMState.completed(diff: _accumulatedResponse.toString()),
        );
      },
      onError: (error) {
        state = AsyncValue.data(
          LLMState.error(message: 'Unexpected error: $error'),
        );
      },
    );
  }

  /// Cancel the current generation
  Future<void> cancel() async {
    await _cancelExisting();

    final cancelUseCase = ref.read(cancelGenerationProvider);
    await cancelUseCase();

    state = const AsyncValue.data(LLMState.cancelled());
  }

  /// Internal method to cancel existing subscription
  Future<void> _cancelExisting() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  /// Convert Failure to user-friendly message
  String _getFailureMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server error: ${failure.message}';
    } else if (failure is CacheFailure) {
      return 'Cache error: ${failure.message}';
    } else if (failure is NetworkFailure) {
      return 'Network error: ${failure.message}';
    } else {
      return 'Error: ${failure.message}';
    }
  }
}

// Placeholder providers - these will be properly injected
@riverpod
GenerateDiffWithLLM generateDiffWithLLM(Ref ref) {
  throw UnimplementedError('GenerateDiffWithLLM provider not implemented');
}

@riverpod
CancelGeneration cancelGeneration(Ref ref) {
  throw UnimplementedError('CancelGeneration provider not implemented');
}
