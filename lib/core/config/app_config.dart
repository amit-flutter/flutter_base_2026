import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'env_config.dart';
import 'flavor.dart';

class AppConfig {
  final Flavor flavor;
  final EnvConfig env;

  const AppConfig({
    required this.flavor,
    required this.env,
  });

  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProd => flavor == Flavor.prod;
}

Future<AppConfig> loadAppConfig() async {
  final flavor = detectFlavor();
  final env = await EnvConfig.load(flavor);
  return AppConfig(flavor: flavor, env: env);
}

final appConfigProvider = FutureProvider<AppConfig>((ref) => loadAppConfig());
