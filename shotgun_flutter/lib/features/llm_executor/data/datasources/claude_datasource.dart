import 'dart:async';

import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import 'package:shotgun_flutter/core/error/exceptions.dart';
import 'package:shotgun_flutter/features/llm_executor/data/datasources/llm_datasource.dart';

/// Anthropic Claude LLM data source implementation
class ClaudeDataSource implements LLMDataSource {
  StreamSubscription<MessageStreamEvent>? _subscription;
  AnthropicClient? _client;

  @override
  Stream<String> generateDiff({
    required String prompt,
    required String apiKey,
    required String model,
    required double temperature,
  }) async* {
    try {
      // Create Anthropic client
      _client = AnthropicClient(apiKey: apiKey);

      // Create message stream
      final stream = _client!.createMessageStream(
        request: CreateMessageRequest(
          model: Model.modelId(model),
          maxTokens: 8192,
          messages: [
            Message(
              role: MessageRole.user,
              content: MessageContent.text(prompt),
            ),
          ],
          temperature: temperature,
        ),
      );

      // Track subscription for cancellation
      _subscription = stream.listen(null);

      await for (final event in stream) {
        // Handle different event types - extract text from delta events
        final eventData = event.map(
          messageStart: (_) => null,
          messageDelta: (_) => null,
          messageStop: (_) => null,
          contentBlockStart: (_) => null,
          contentBlockDelta: (e) => e.delta.mapOrNull(
            textDelta: (delta) => delta.text,
          ),
          contentBlockStop: (_) => null,
          ping: (_) => null,
          error: (e) => throw ServerException('Claude error: ${e.error}'),
        );

        if (eventData != null && eventData.isNotEmpty) {
          yield eventData;
        }
      }
    } catch (e) {
      throw ServerException('Claude generation failed: $e');
    } finally {
      _subscription?.cancel();
      _subscription = null;
      _client = null;
    }
  }

  @override
  void cancel() {
    _subscription?.cancel();
    _subscription = null;
    _client = null;
  }
}
