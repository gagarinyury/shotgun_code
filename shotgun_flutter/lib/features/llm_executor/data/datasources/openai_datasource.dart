import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:shotgun_flutter/core/error/exceptions.dart';
import 'package:shotgun_flutter/features/llm_executor/data/datasources/llm_datasource.dart';

/// OpenAI LLM data source implementation
class OpenAIDataSource implements LLMDataSource {
  StreamSubscription<OpenAIStreamChatCompletionModel>? _subscription;

  @override
  Stream<String> generateDiff({
    required String prompt,
    required String apiKey,
    required String model,
    required double temperature,
  }) async* {
    try {
      // Set API key
      OpenAI.apiKey = apiKey;

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
      throw ServerException('OpenAI generation failed: $e');
    } finally {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  @override
  void cancel() {
    _subscription?.cancel();
    _subscription = null;
  }
}
