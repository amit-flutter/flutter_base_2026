import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static bool _enabled = true;

  static set enabled(bool value) {
    _enabled = value;
  }

  static void debug(String message, {String tag = ''}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  static void info(String message, {String tag = ''}) {
    _log(LogLevel.info, message, tag: tag);
  }

  static void warning(String message, {String tag = ''}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  static void error(
    String message, {
    String tag = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message, tag: tag, error: error);
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }

  static void request(String message, {String tag = ''}) {
    _log(LogLevel.request, message, tag: tag);
  }

  static void response(String message, {String tag = ''}) {
    _log(LogLevel.response, message, tag: tag);
  }

  static void _log(
    LogLevel level,
    String message, {
    String tag = '',
    Object? error,
  }) {
    if (!_enabled && level != LogLevel.error) return;

    final tagStr = tag.isNotEmpty ? ' [$tag]' : '';
    final errorStr = error != null ? ' | $error' : '';
    final output = '$level.emoji$tagStr $message$errorStr';

    if (level == LogLevel.error) {
      debugPrint('🚨$tagStr $message$errorStr');
    } else {
      debugPrint(output);
    }
  }
}

enum LogLevel {
  debug('🐛'),
  info('ℹ️'),
  warning('⚠️'),
  error('🚨'),
  request('>>>>'),
  response('✅ <<<<');

  final String emoji;
  const LogLevel(this.emoji);
}
