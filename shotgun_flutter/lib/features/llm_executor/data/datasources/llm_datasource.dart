/// Abstract interface for LLM data sources
///
/// All LLM provider implementations (Gemini, OpenAI, DeepSeek, Claude)
/// must implement this interface
abstract class LLMDataSource {
  /// Generate diff with streaming support
  ///
  /// Returns a stream of text chunks as the LLM generates the response
  Stream<String> generateDiff({
    required String prompt,
    required String apiKey,
    required String model,
    required double temperature,
  });

  /// Cancel the current generation
  void cancel();
}
