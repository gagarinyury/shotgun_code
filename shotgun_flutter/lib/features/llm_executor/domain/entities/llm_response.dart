import 'package:equatable/equatable.dart';

/// Response from LLM generation
class LLMResponse extends Equatable {
  /// Generated diff content
  final String diff;

  /// Total tokens used (input + output)
  final int tokensUsed;

  /// Timestamp when generation completed
  final DateTime completedAt;

  const LLMResponse({
    required this.diff,
    required this.tokensUsed,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [diff, tokensUsed, completedAt];
}
