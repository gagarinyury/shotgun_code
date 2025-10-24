/// Supported LLM provider types
enum LLMProviderType {
  /// Google Gemini (gemini-2.0-flash-exp, etc.)
  gemini,

  /// OpenAI (gpt-4, gpt-4-turbo, etc.)
  openai,

  /// DeepSeek (deepseek-chat, deepseek-coder, etc.)
  deepseek,

  /// Anthropic Claude (claude-3-5-sonnet, etc.)
  claude,
}
