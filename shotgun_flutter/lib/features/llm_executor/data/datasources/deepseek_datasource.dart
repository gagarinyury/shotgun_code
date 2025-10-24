import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:shotgun_flutter/core/error/exceptions.dart';
import 'package:shotgun_flutter/features/llm_executor/data/datasources/llm_datasource.dart';

/// DeepSeek LLM data source implementation
///
/// DeepSeek uses OpenAI-compatible API, so we reuse dart_openai
/// with a custom base URL
class DeepSeekDataSource implements LLMDataSource {
  StreamSubscription<OpenAIStreamChatCompletionModel>? _subscription;

  @override
  Stream<String> generateDiff({
    required String prompt,
    required String apiKey,
    required String model,
    required double temperature,
  }) async* {
    try {
      // Set API key and custom base URL for DeepSeek
      OpenAI.apiKey = apiKey;
      OpenAI.baseUrl = 'https://api.deepseek.com';

      // Create chat completion stream
      final stream = OpenAI.instance.chat.createStream(
        model: model,
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
            ],
          ),
        ],
        temperature: temperature,
        maxTokens: 8192,
      );

      // Track subscription for cancellation
      _subscription = stream.listen(null);

      await for (final chunk in stream) {
        final delta = chunk.choices.first.delta;
        final content = delta.content;

        if (content != null && content.isNotEmpty) {
          // Extract text from content items
          for (final item in content) {
            if (item?.type == 'text') {
              final text = (item as OpenAIChatCompletionChoiceMessageContentItemModel).text;
              if (text != null && text.isNotEmpty) {
                yield text;
              }
            }
          }
        }
      }
    } catch (e) {
      throw ServerException('DeepSeek generation failed: $e');
    } finally {
      _subscription?.cancel();
      _subscription = null;
      // Reset to default OpenAI base URL
      OpenAI.baseUrl = 'https://api.openai.com';
    }
  }

  @override
  void cancel() {
    _subscription?.cancel();
    _subscription = null;
  }
}
