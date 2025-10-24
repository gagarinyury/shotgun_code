import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_response.dart';

void main() {
  group('LLMResponse', () {
    final tTimestamp = DateTime(2025, 1, 24, 12, 0, 0);
    final tResponse = LLMResponse(
      diff: 'diff content',
      tokensUsed: 1500,
      completedAt: tTimestamp,
    );

    test('should be a subclass of Equatable', () {
      expect(tResponse, isA<Object>());
    });

    test('should contain correct values', () {
      expect(tResponse.diff, 'diff content');
      expect(tResponse.tokensUsed, 1500);
      expect(tResponse.completedAt, tTimestamp);
    });

    test('should support value equality', () {
      final response1 = LLMResponse(
        diff: 'diff content',
        tokensUsed: 1500,
        completedAt: tTimestamp,
      );

      final response2 = LLMResponse(
        diff: 'diff content',
        tokensUsed: 1500,
        completedAt: tTimestamp,
      );

      expect(response1, equals(response2));
    });

    test('should not be equal with different values', () {
      final response1 = LLMResponse(
        diff: 'diff1',
        tokensUsed: 1000,
        completedAt: tTimestamp,
      );

      final response2 = LLMResponse(
        diff: 'diff2',
        tokensUsed: 2000,
        completedAt: tTimestamp,
      );

      expect(response1, isNot(equals(response2)));
    });

    test('should handle empty diff', () {
      final response = LLMResponse(
        diff: '',
        tokensUsed: 0,
        completedAt: tTimestamp,
      );

      expect(response.diff, isEmpty);
      expect(response.tokensUsed, 0);
    });

    test('should handle large token counts', () {
      final response = LLMResponse(
        diff: 'large response',
        tokensUsed: 100000,
        completedAt: tTimestamp,
      );

      expect(response.tokensUsed, 100000);
    });
  });
}
