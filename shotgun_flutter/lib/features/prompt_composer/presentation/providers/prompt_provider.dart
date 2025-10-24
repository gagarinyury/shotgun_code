import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/prompt_local_datasource.dart';
import '../../data/repositories/prompt_repository_impl.dart';
import '../../domain/entities/prompt_template.dart';
import '../../domain/repositories/prompt_repository.dart';
import '../../domain/usecases/compose_prompt.dart';
import '../../domain/usecases/estimate_tokens.dart';
import '../../domain/usecases/load_custom_rules.dart';
import '../../domain/usecases/load_templates.dart';
import '../../domain/usecases/save_custom_rules.dart';

part 'prompt_provider.freezed.dart';
part 'prompt_provider.g.dart';

// ===== Infrastructure Providers =====

/// Provides the PromptLocalDataSource singleton instance.
@riverpod
PromptLocalDataSource promptLocalDataSource(Ref ref) {
  return PromptLocalDataSource();
}

/// Provides the PromptRepository implementation.
@riverpod
PromptRepository promptRepository(Ref ref) {
  final dataSource = ref.watch(promptLocalDataSourceProvider);
  return PromptRepositoryImpl(localDataSource: dataSource);
}

// ===== Use Case Providers =====

/// Provides the ComposePrompt use case.
@riverpod
ComposePrompt composePrompt(Ref ref) {
  final repository = ref.watch(promptRepositoryProvider);
  return ComposePrompt(repository);
}

/// Provides the EstimateTokens use case.
@riverpod
EstimateTokens estimateTokens(Ref ref) {
  final repository = ref.watch(promptRepositoryProvider);
  return EstimateTokens(repository);
}

/// Provides the LoadTemplates use case.
@riverpod
LoadTemplates loadTemplates(Ref ref) {
  final repository = ref.watch(promptRepositoryProvider);
  return LoadTemplates(repository);
}

/// Provides the LoadCustomRules use case.
@riverpod
LoadCustomRules loadCustomRules(Ref ref) {
  final repository = ref.watch(promptRepositoryProvider);
  return LoadCustomRules(repository);
}

/// Provides the SaveCustomRules use case.
@riverpod
SaveCustomRules saveCustomRules(Ref ref) {
  final repository = ref.watch(promptRepositoryProvider);
  return SaveCustomRules(repository);
}

// ===== State Class =====

/// State for the Prompt Composer feature.
@freezed
class PromptState with _$PromptState {
  const factory PromptState({
    /// The project context (generated from files)
    @Default('') String context,

    /// The user's task description
    @Default('') String task,

    /// Custom rules to apply
    @Default('') String customRules,

    /// Available templates
    @Default([]) List<PromptTemplate> templates,

    /// Currently selected template
    PromptTemplate? selectedTemplate,

    /// The final composed prompt
    @Default('') String finalPrompt,

    /// Estimated token count
    @Default(0) int estimatedTokens,

    /// Error message if any
    String? errorMessage,
  }) = _PromptState;

  /// Creates an initial state.
  factory PromptState.initial() {
    return const PromptState();
  }
}

// ===== State Notifier =====

/// Notifier for managing prompt composition state.
@riverpod
class PromptNotifier extends _$PromptNotifier {
  @override
  Future<PromptState> build() async {
    // Load templates and custom rules on initialization
    final templatesResult = await ref.read(loadTemplatesProvider).call();
    final rulesResult = await ref.read(loadCustomRulesProvider).call();

    final templates = templatesResult.getOrElse(() => []);
    final rules = rulesResult.getOrElse(() => '');

    return PromptState(
      templates: templates,
      selectedTemplate: templates.isNotEmpty ? templates.first : null,
      customRules: rules,
    );
  }

  /// Updates the context from project files.
  Future<void> updateContext(String context) async {
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(context: context));
      _recomposePrompt();
    });
  }

  /// Updates the task description.
  Future<void> updateTask(String task) async {
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(task: task));
      _recomposePrompt();
    });
  }

  /// Updates the custom rules.
  Future<void> updateCustomRules(String rules) async {
    state.whenData((data) async {
      state = AsyncValue.data(data.copyWith(customRules: rules));

      // Save rules to storage
      final saveUseCase = ref.read(saveCustomRulesProvider);
      await saveUseCase(rules);

      _recomposePrompt();
    });
  }

  /// Selects a different template.
  Future<void> selectTemplate(PromptTemplate template) async {
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(selectedTemplate: template));
      _recomposePrompt();
    });
  }

  /// Recomposes the prompt and updates token count.
  Future<void> _recomposePrompt() async {
    state.whenData((data) async {
      if (data.selectedTemplate == null) return;

      final composeUseCase = ref.read(composePromptProvider);
      final result = await composeUseCase(
        context: data.context,
        task: data.task,
        rules: data.customRules,
        template: data.selectedTemplate!,
      );

      result.fold(
        (failure) {
          state = AsyncValue.data(
            data.copyWith(errorMessage: failure.message),
          );
        },
        (composedPrompt) async {
          // Estimate tokens for the composed prompt
          final estimateUseCase = ref.read(estimateTokensProvider);
          final tokensResult = await estimateUseCase(composedPrompt);

          tokensResult.fold(
            (failure) {
              state = AsyncValue.data(
                data.copyWith(
                  finalPrompt: composedPrompt,
                  errorMessage: 'Failed to estimate tokens: ${failure.message}',
                ),
              );
            },
            (tokens) {
              state = AsyncValue.data(
                data.copyWith(
                  finalPrompt: composedPrompt,
                  estimatedTokens: tokens,
                  errorMessage: null,
                ),
              );
            },
          );
        },
      );
    });
  }
}
