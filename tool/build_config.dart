class FlavorConfig {
  const FlavorConfig({
    required this.name,
    required this.appName,
    required this.bundleId,
    required this.dartDefines,
    required this.androidObfuscate,
    required this.webHostingTarget,
    this.firebaseProject,
    this.iosExportMethod = 'development',
    this.debugSymbolsPath,
    this.androidSplitPerAbi = false,
  });

  final String name;
  final String appName;
  final String bundleId;
  final Map<String, String> dartDefines;
  final bool androidObfuscate;
  final String? firebaseProject;
  final String webHostingTarget;
  final String iosExportMethod;
  final String? debugSymbolsPath;
  final bool androidSplitPerAbi;

  List<String> get dartDefineArgs {
    return dartDefines.entries.map((e) => '--dart-define=${e.key}=${e.value}').toList();
  }

  List<String> get flavorArgs => ['--flavor', name.toLowerCase()];
}

class BuildConfig {
  const BuildConfig._();

  static const flavors = {
    'dev': FlavorConfig(
      name: 'Dev',
      appName: 'NextGen Tools [DEV]',
      bundleId: 'com.nextgentools.dev',
      firebaseProject: 'next-gen-tools',
      webHostingTarget: 'dev',
      iosExportMethod: 'development',
      androidObfuscate: false,
      dartDefines: {
        'API_BASE_URL': 'https://api.dev.nextgentools.com',
        'APP_ENV': 'dev',
      },
    ),
    'staging': FlavorConfig(
      name: 'Staging',
      appName: 'NextGen Tools [STAGING]',
      bundleId: 'com.nextgentools.staging',
      firebaseProject: 'next-gen-tools',
      webHostingTarget: 'staging',
      iosExportMethod: 'ad-hoc',
      androidObfuscate: true,
      androidSplitPerAbi: true,
      debugSymbolsPath: 'build/debug-info/staging',
      dartDefines: {
        'API_BASE_URL': 'https://api.staging.nextgentools.com',
        'APP_ENV': 'staging',
      },
    ),
    'prod': FlavorConfig(
      name: 'Production',
      appName: 'NextGen Tools',
      bundleId: 'com.nextgentools.app',
      firebaseProject: 'next-gen-tools',
      webHostingTarget: 'prod',
      iosExportMethod: 'app-store',
      androidObfuscate: true,
      androidSplitPerAbi: true,
      debugSymbolsPath: 'build/debug-info/prod',
      dartDefines: {
        'API_BASE_URL': 'https://api.nextgentools.com',
        'APP_ENV': 'prod',
      },
    ),
  };

  static FlavorConfig get(String name) {
    final flavor = flavors[name.toLowerCase()];
    if (flavor == null) {
      throw ArgumentError('Unknown flavor: $name. Available: ${flavors.keys.join(', ')}');
    }
    return flavor;
  }

  static const defaultFlavor = 'dev';
}
