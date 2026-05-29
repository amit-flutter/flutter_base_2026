import 'package:flutter/widgets.dart';
import 'config/config.dart';
import 'utils/logger.dart';

class Bootstrap {
  Bootstrap._();

  static Future<AppConfig> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    final appConfig = await loadAppConfig();

    AppLogger.enabled = appConfig.env.enableLogging;

    AppLogger.info('App initialized in ${appConfig.flavor.name} mode', tag: 'Boot');

    return appConfig;
  }
}
