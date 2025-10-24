import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_config.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_provider_type.dart';

void main() {
  group('LLMConfig', () {
    const tConfig = LLMConfig(
      provider: LLMProviderType.gemini,
      apiKey: 'test-api-key',
      model: 'gemini-2.0-flash-exp',
      temperature: 0.1,
    );

    test('should be a subclass of Equatable', () {
      expect(tConfig, isA<Object>());
    });

    test('should have correct default temperature', () {
      const config = LLMConfig(
        provider: LLMProviderType.openai,
        apiKey: 'key',
        model: 'gpt-4',
      );

      expect(config.temperature, 0.1);
    });

    test('should support value equality', () {
      const config1 = LLMConfig(
        provider: LLMProviderType.gemini,
        apiKey: 'test-api-key',
        model: 'gemini-2.0-flash-exp',
        temperature: 0.1,
      );

      const config2 = LLMConfig(
        provider: LLMProviderType.gemini,
        apiKey: 'test-api-key',
        model: 'gemini-2.0-flash-exp',
        temperature: 0.1,
      );

      expect(config1, equals(config2));
    });

    test('should not be equal with different values', () {
      const config1 = LLMConfig(
        provider: LLMProviderType.gemini,
        apiKey: 'key1',
        model: 'model1',
      );

      const config2 = LLMConfig(
        provider: LLMProviderType.openai,
        apiKey: 'key2',
        model: 'model2',
      );

      expect(config1, isNot(equals(config2)));
    });

    test('copyWith should return new instance with updated values', () {
      final newConfig = tConfig.copyWith(
        provider: LLMProviderType.openai,
        temperature: 0.5,
      );

      expect(newConfig.provider, LLMProviderType.openai);
      expect(newConfig.temperature, 0.5);
      expect(newConfig.apiKey, tConfig.apiKey);
      expect(newConfig.model, tConfig.model);
    });

    test('copyWith should preserve original values when null', () {
      final newConfig = tConfig.copyWith();

      expect(newConfig.provider, tConfig.provider);
      expect(newConfig.apiKey, tConfig.apiKey);
      expect(newConfig.model, tConfig.model);
      expect(newConfig.temperature, tConfig.temperature);
    });

    test('should work with all provider types', () {
      for (final provider in LLMProviderType.values) {
        final config = LLMConfig(
          provider: provider,
          apiKey: 'test-key',
          model: 'test-model',
        );

        expect(config.provider, provider);
      }
    });
  });
}
