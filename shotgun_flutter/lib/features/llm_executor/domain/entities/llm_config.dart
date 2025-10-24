import 'package:equatable/equatable.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_provider_type.dart';

/// Configuration for LLM API calls
class LLMConfig extends Equatable {
  /// The LLM provider to use
  final LLMProviderType provider;

  /// API key for authentication
  final String apiKey;

  /// Model identifier (e.g., 'gemini-2.0-flash-exp', 'gpt-4-turbo')
  final String model;

  /// Temperature for generation (0.0 = deterministic, 1.0 = creative)
  final double temperature;

  const LLMConfig({
    required this.provider,
    required this.apiKey,
    required this.model,
    this.temperature = 0.1,
  });

  /// Creates a copy with modified fields
  LLMConfig copyWith({
    LLMProviderType? provider,
    String? apiKey,
    String? model,
    double? temperature,
  }) {
    return LLMConfig(
      provider: provider ?? this.provider,
      apiKey: apiKey ?? this.apiKey,
      model: model ?? this.model,
      temperature: temperature ?? this.temperature,
    );
  }

  @override
  List<Object?> get props => [provider, apiKey, model, temperature];
}
