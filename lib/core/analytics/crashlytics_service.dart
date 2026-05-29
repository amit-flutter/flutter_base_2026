import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../config/env_config.dart';
import '../utils/logger.dart';

class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics;

  CrashlyticsService({
    required EnvConfig env,
    FirebaseCrashlytics? crashlytics,
  }) : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) {
    AppLogger.error(
      reason ?? 'Crash reported',
      error: exception,
      stackTrace: stack,
      tag: 'Crashlytics',
    );
    return _crashlytics.recordError(exception, stack, fatal: fatal);
  }

  Future<void> log(String message) {
    return _crashlytics.log(message);
  }

  Future<void> setUserId(String userId) {
    return _crashlytics.setUserIdentifier(userId);
  }

  Future<void> setCustomKey(String key, String value) {
    return _crashlytics.setCustomKey(key, value);
  }
}
