/// Utility class for estimating token count in text.
///
/// Uses a simple approximation: ~4 characters = 1 token.
/// This is based on the general rule of thumb for English text
/// with GPT models, where 1 token ≈ 4 characters or ≈ 0.75 words.
///
/// Note: This is an approximation. Actual token counts may vary
/// depending on the specific tokenizer used by the LLM.
class TokenEstimator {
  /// The number of characters that approximately equal one token
  static const int charsPerToken = 4;

  /// Estimates the number of tokens in the given [text].
  ///
  /// Uses the formula: tokens ≈ text.length / 4
  ///
  /// Parameters:
  /// - [text]: The text to estimate tokens for
  ///
  /// Returns:
  /// - The estimated number of tokens (rounded up)
  ///
  /// Examples:
  /// ```dart
  /// TokenEstimator.estimate('Hello') // returns 2 (5 chars / 4 = 1.25 → 2)
  /// TokenEstimator.estimate('Test') // returns 1 (4 chars / 4 = 1)
  /// TokenEstimator.estimate('') // returns 0
  /// ```
  static int estimate(String text) {
    if (text.isEmpty) {
      return 0;
    }
    return (text.length / charsPerToken).ceil();
  }

  /// Estimates tokens with additional metadata.
  ///
  /// Returns a map with estimated tokens and character count.
  ///
  /// Parameters:
  /// - [text]: The text to analyze
  ///
  /// Returns:
  /// - A map with 'tokens' and 'characters' keys
  static Map<String, int> estimateWithMetadata(String text) {
    return {
      'tokens': estimate(text),
      'characters': text.length,
    };
  }
}
