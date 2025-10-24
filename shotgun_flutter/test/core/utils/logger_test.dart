import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/core/utils/logger.dart';

void main() {
  group('Logger', () {
    test('should log without throwing exceptions', () {
      expect(() => Logger.debug('test'), returnsNormally);
      expect(() => Logger.info('test'), returnsNormally);
      expect(() => Logger.warning('test'), returnsNormally);
      expect(() => Logger.error('test'), returnsNormally);
    });

    test('should log with custom level', () {
      expect(
        () => Logger.log('test', level: LogLevel.debug),
        returnsNormally,
      );
      expect(
        () => Logger.log('test', level: LogLevel.info),
        returnsNormally,
      );
      expect(
        () => Logger.log('test', level: LogLevel.warning),
        returnsNormally,
      );
      expect(
        () => Logger.log('test', level: LogLevel.error),
        returnsNormally,
      );
    });
  });
}
