import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  static void log(String message, {LogLevel level = LogLevel.info}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final prefix = _getPrefix(level);
      debugPrint('[$timestamp] $prefix $message');
    }
  }

  static String _getPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍 DEBUG:';
      case LogLevel.info:
        return 'ℹ️ INFO:';
      case LogLevel.warning:
        return '⚠️ WARNING:';
      case LogLevel.error:
        return '❌ ERROR:';
    }
  }

  static void debug(String message) => log(message, level: LogLevel.debug);
  static void info(String message) => log(message, level: LogLevel.info);
  static void warning(String message) => log(message, level: LogLevel.warning);
  static void error(String message) => log(message, level: LogLevel.error);
}
