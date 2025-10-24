import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/core/error/failures.dart';

void main() {
  group('Failures', () {
    test('ServerFailure should be equal when messages are the same', () {
      const failure1 = ServerFailure('error');
      const failure2 = ServerFailure('error');

      expect(failure1, equals(failure2));
    });

    test('ServerFailure should not be equal when messages differ', () {
      const failure1 = ServerFailure('error1');
      const failure2 = ServerFailure('error2');

      expect(failure1, isNot(equals(failure2)));
    });

    test('CacheFailure should be equal when messages are the same', () {
      const failure1 = CacheFailure('cache error');
      const failure2 = CacheFailure('cache error');

      expect(failure1, equals(failure2));
    });

    test('NetworkFailure should be equal when messages are the same', () {
      const failure1 = NetworkFailure('network error');
      const failure2 = NetworkFailure('network error');

      expect(failure1, equals(failure2));
    });

    test('BackendFailure should be equal when messages are the same', () {
      const failure1 = BackendFailure('backend error');
      const failure2 = BackendFailure('backend error');

      expect(failure1, equals(failure2));
    });

    test('Different failure types should not be equal', () {
      const failure1 = ServerFailure('error');
      const failure2 = CacheFailure('error');

      expect(failure1, isNot(equals(failure2)));
    });
  });
}
