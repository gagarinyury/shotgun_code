import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/prompt_composer/data/utils/token_estimator.dart';

void main() {
  group('TokenEstimator', () {
    test('should return 0 for empty string', () {
      // arrange
      const text = '';

      // act
      final result = TokenEstimator.estimate(text);

      // assert
      expect(result, 0);
    });

    test('should estimate 1 token for 4 characters', () {
      // arrange
      const text = 'test';

      // act
      final result = TokenEstimator.estimate(text);

      // assert
      expect(result, 1);
    });

    test('should round up for partial tokens', () {
      // arrange
      const text = 'hello'; // 5 chars = 1.25 tokens → 2 tokens

      // act
      final result = TokenEstimator.estimate(text);

      // assert
      expect(result, 2);
    });

    test('should estimate correctly for longer text', () {
      // arrange
      const text = 'This is a test prompt with some content'; // 40 chars = 10 tokens

      // act
      final result = TokenEstimator.estimate(text);

      // assert
      expect(result, 10);
    });

    test('should handle very long text', () {
      // arrange
      final text = 'a' * 100000; // 100k chars = 25k tokens

      // act
      final result = TokenEstimator.estimate(text);

      // assert
      expect(result, 25000);
    });

    test('should handle text with newlines', () {
      // arrange
      const text = 'Line 1\nLine 2\nLine 3'; // 20 chars = 5 tokens

      // act
      final result = TokenEstimator.estimate(text);

      // assert
      expect(result, 5); // ceil(20/4) = 5
    });

    test('should handle text with special characters', () {
      // arrange
      const text = '!@#\$%^&*()'; // 11 chars = 3 tokens (rounded up from 2.75)

      // act
      final result = TokenEstimator.estimate(text);

      // assert
      expect(result, 3);
    });

    group('estimateWithMetadata', () {
      test('should return correct tokens and character count', () {
        // arrange
        const text = 'test prompt'; // 11 chars = 3 tokens

        // act
        final result = TokenEstimator.estimateWithMetadata(text);

        // assert
        expect(result['tokens'], 3);
        expect(result['characters'], 11);
      });

      test('should return 0 tokens and chars for empty string', () {
        // arrange
        const text = '';

        // act
        final result = TokenEstimator.estimateWithMetadata(text);

        // assert
        expect(result['tokens'], 0);
        expect(result['characters'], 0);
      });

      test('should handle large text', () {
        // arrange
        final text = 'a' * 1000; // 1000 chars = 250 tokens

        // act
        final result = TokenEstimator.estimateWithMetadata(text);

        // assert
        expect(result['tokens'], 250);
        expect(result['characters'], 1000);
      });
    });
  });
}
