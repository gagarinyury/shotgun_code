import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_provider_type.dart';

void main() {
  group('LLMProviderType', () {
    test('should contain all 4 providers', () {
      expect(LLMProviderType.values.length, 4);
      expect(LLMProviderType.values, contains(LLMProviderType.gemini));
      expect(LLMProviderType.values, contains(LLMProviderType.openai));
      expect(LLMProviderType.values, contains(LLMProviderType.deepseek));
      expect(LLMProviderType.values, contains(LLMProviderType.claude));
    });

    test('should have correct enum names', () {
      expect(LLMProviderType.gemini.name, 'gemini');
      expect(LLMProviderType.openai.name, 'openai');
      expect(LLMProviderType.deepseek.name, 'deepseek');
      expect(LLMProviderType.claude.name, 'claude');
    });

    test('should be able to iterate over all values', () {
      final providers = <LLMProviderType>[];
      for (final provider in LLMProviderType.values) {
        providers.add(provider);
      }

      expect(providers.length, 4);
    });

    test('should support equality comparison', () {
      const provider1 = LLMProviderType.gemini;
      const provider2 = LLMProviderType.gemini;
      const provider3 = LLMProviderType.openai;

      expect(provider1, equals(provider2));
      expect(provider1, isNot(equals(provider3)));
    });

    test('should be usable in switch statements', () {
      String getProviderName(LLMProviderType provider) {
        switch (provider) {
          case LLMProviderType.gemini:
            return 'Google Gemini';
          case LLMProviderType.openai:
            return 'OpenAI';
          case LLMProviderType.deepseek:
            return 'DeepSeek';
          case LLMProviderType.claude:
            return 'Anthropic Claude';
        }
      }

      expect(getProviderName(LLMProviderType.gemini), 'Google Gemini');
      expect(getProviderName(LLMProviderType.openai), 'OpenAI');
      expect(getProviderName(LLMProviderType.deepseek), 'DeepSeek');
      expect(getProviderName(LLMProviderType.claude), 'Anthropic Claude');
    });
  });
}
