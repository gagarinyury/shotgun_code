import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shotgun_flutter/core/error/exceptions.dart' as core_exceptions;
import 'package:shotgun_flutter/features/llm_executor/data/datasources/llm_datasource.dart';

/// Google Gemini LLM data source implementation
class GeminiDataSource implements LLMDataSource {
  StreamSubscription<GenerateContentResponse>? _subscription;

  @override
  Stream<String> generateDiff({
    required String prompt,
    required String apiKey,
    required String model,
    required double temperature,
  }) async* {
    try {
      final generativeModel = GenerativeModel(
        model: model,
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: temperature,
          maxOutputTokens: 8192,
        ),
      );

      final content = [Content.text(prompt)];
      final responseStream = generativeModel.generateContentStream(content);

      // Track subscription for cancellation
      _subscription = responseStream.listen(null);

      await for (final chunk in responseStream) {
        final text = chunk.text;
        if (text != null && text.isNotEmpty) {
          yield text;
        }
      }
    } catch (e) {
      throw core_exceptions.ServerException('Gemini generation failed: $e');
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
