import 'package:equatable/equatable.dart';

/// Domain entity representing a composed prompt.
///
/// This is the result of composing a prompt from context, task, rules,
/// and a template. It includes the final prompt text and estimated token count.
class Prompt extends Equatable {
  /// The project context (generated from files)
  final String context;

  /// The user's task description
  final String task;

  /// Custom rules to apply
  final String rules;

  /// The final composed prompt text
  final String finalPrompt;

  /// Estimated number of tokens in the final prompt
  final int estimatedTokens;

  const Prompt({
    required this.context,
    required this.task,
    required this.rules,
    required this.finalPrompt,
    required this.estimatedTokens,
  });

  @override
  List<Object?> get props => [
        context,
        task,
        rules,
        finalPrompt,
        estimatedTokens,
      ];

  /// Creates a copy of this Prompt with updated fields
  Prompt copyWith({
    String? context,
    String? task,
    String? rules,
    String? finalPrompt,
    int? estimatedTokens,
  }) {
    return Prompt(
      context: context ?? this.context,
      task: task ?? this.task,
      rules: rules ?? this.rules,
      finalPrompt: finalPrompt ?? this.finalPrompt,
      estimatedTokens: estimatedTokens ?? this.estimatedTokens,
    );
  }

  @override
  String toString() {
    return 'Prompt(tokens: $estimatedTokens, taskLength: ${task.length}, '
        'contextLength: ${context.length})';
  }
}
