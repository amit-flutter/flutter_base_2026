import 'package:firebase_analytics/firebase_analytics.dart';
import '../config/env_config.dart';
import '../utils/logger.dart';

class AnalyticsService {
  final FirebaseAnalytics _firebase;

  AnalyticsService({
    required EnvConfig env,
    FirebaseAnalytics? firebase,
  }) : _firebase = firebase ?? FirebaseAnalytics.instance;

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) {
    AppLogger.info('Analytics event: $name', tag: 'Analytics');
    return _firebase.logEvent(name: name, parameters: parameters ?? {});
  }

  Future<void> setUserId(String? userId) {
    AppLogger.info('Analytics user: $userId', tag: 'Analytics');
    return _firebase.setUserId(id: userId);
  }

  Future<void> setUserProperty(String name, String value) {
    return _firebase.setUserProperty(name: name, value: value);
  }

  Future<void> logScreenView({required String screenName}) {
    return _firebase.logScreenView(screenName: screenName);
  }
}
