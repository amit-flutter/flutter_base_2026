///
/// Unified build & deploy tool.
/// Usage:
///   dart run tool/build.dart --flavor prod --mode aab
///   dart run tool/build.dart --flavor dev  --mode run
///   dart run tool/build.dart --flavor prod --mode web --deploy
///   dart run tool/build.dart --flavor all  --mode aab+ios+web --parallel
///
library;

import 'dart:io';

import 'build_config.dart';

// ──────────────────────────────────────────────
// Entry point
// ──────────────────────────────────────────────

Future<void> main(List<String> args) async {
  final cli = _CliOptions.parse(args);
  final runner = BuildRunner(cli);
  await runner.run();
}

// ──────────────────────────────────────────────
// CLI argument parsing
// ──────────────────────────────────────────────

class _CliOptions {
  _CliOptions({
    required this.flavorName,
    required this.targets,
    required this.modes,
    this.deploy = false,
    this.clean = true,
    this.parallel = false,
    this.analyzeFirst = false,
    this.updateBuildInfo = true,
    this.buildNumber,
  });

  final String flavorName;
  final List<String> targets;    // android, ios, web, macos, windows, linux
  final List<String> modes;      // apk, aab, archive, run, deploy, analyze, test
  final bool deploy;
  final bool clean;
  final bool parallel;
  final bool analyzeFirst;
  final bool updateBuildInfo;
  final String? buildNumber;

  static _CliOptions parse(List<String> args) {
    var flavorName = BuildConfig.defaultFlavor;
    var deploy = false;
    var clean = true;
    var parallel = false;
    var analyzeFirst = false;
    var updateBuildInfo = true;
    String? buildNumber;
    final targets = <String>[];
    final modes = <String>[];

    for (final arg in args) {
      final lower = arg.toLowerCase();

      if (arg.startsWith('--flavor=')) {
        flavorName = arg.split('=')[1];
      } else if (lower == '--flavor' || lower == '-f') {
        // handled in next iteration via index access
      } else if (arg.startsWith('--build-number=')) {
        buildNumber = arg.split('=')[1];
      } else if (lower == '--no-clean' || lower == '-nc') {
        clean = false;
      } else if (lower == '--deploy' || lower == '-d') {
        deploy = true;
      } else if (lower == '--parallel' || lower == '-p') {
        parallel = true;
      } else if (lower == '--analyze' || lower == '--test') {
        modes.add(lower.replaceAll('--', ''));
      } else if (lower == '--no-build-info') {
        updateBuildInfo = false;
      } else if (lower == '--apk' || lower == '-a') {
        modes.add('apk');
        targets.add('android');
      } else if (lower == '--aab' || lower == '--appbundle') {
        modes.add('aab');
        targets.add('android');
      } else if (lower == '--ios') {
        targets.add('ios');
      } else if (lower == '--web' || lower == '-w') {
        targets.add('web');
      } else if (lower == '--macos') {
        targets.add('macos');
      } else if (lower == '--windows') {
        targets.add('windows');
      } else if (lower == '--linux') {
        targets.add('linux');
      } else if (lower == '--mode') {
        // handled in next iteration
      } else if (lower == '--all' || lower == '--all-platforms') {
        targets.addAll(['android', 'ios', 'web']);
      } else if (lower == '--run') {
        modes.add('run');
      } else if (lower == '--archive') {
        modes.add('archive');
        targets.add('ios');
      }
    }

    // Handle flavor value after --flavor flag
    for (var i = 0; i < args.length; i++) {
      if ((args[i] == '--flavor' || args[i] == '-f') && i + 1 < args.length) {
        flavorName = args[i + 1];
      }
      if (args[i] == '--mode' && i + 1 < args.length) {
        modes.add(args[i + 1]);
      }
      if (args[i] == '--build-number' && i + 1 < args.length) {
        buildNumber = args[i + 1];
      }
    }

    // Default: if no target specified, build all
    if (targets.isEmpty && modes.isEmpty) {
      targets.addAll(['android', 'web']);
      modes.add('release');
    }

    // Default mode per target if not specified
    if (modes.isEmpty) {
      if (targets.contains('android')) modes.add('aab');
      if (targets.contains('ios')) modes.add('archive');
      if (targets.contains('web')) modes.add('release');
    }

    return _CliOptions(
      flavorName: flavorName,
      targets: targets.toSet().toList(),
      modes: modes.toSet().toList(),
      deploy: deploy,
      clean: clean,
      parallel: parallel,
      analyzeFirst: analyzeFirst,
      updateBuildInfo: updateBuildInfo,
      buildNumber: buildNumber,
    );
  }
}

// ──────────────────────────────────────────────
// Build runner
// ──────────────────────────────────────────────

class BuildRunner {
  BuildRunner(this._cli);

  final _CliOptions _cli;
  late final FlavorConfig _flavor = BuildConfig.get(_cli.flavorName);
  final _startTime = DateTime.now();

  Future<void> run() async {
    _printHeader();

    try {
      // Step 1: Generate build info
      if (_cli.updateBuildInfo) {
        _generateBuildInfo();
      }

      // Step 2: Clean
      if (_cli.clean) {
        await _runCmd('flutter', ['clean'], label: 'Cleaning');
        await _runCmd('flutter', ['pub', 'get'], label: 'Getting packages');
      }

      // Step 3: Analyze (optional)
      if (_cli.analyzeFirst) {
        await _runCmd('flutter', ['analyze'], label: 'Analyzing');
      }

      // Step 4: Build
      final builds = <Future<void>>[];

      for (final target in _cli.targets) {
        for (final mode in _cli.modes) {
          final task = _buildTarget(target, mode);
          if (_cli.parallel) {
            builds.add(task);
          } else {
            await task;
          }
        }
      }

      if (builds.isNotEmpty) {
        await Future.wait(builds);
      }

      // Step 5: Deploy
      if (_cli.deploy) {
        await _deploy();
      }

      _printSummary();
    } catch (e) {
      _printError(e);
      exit(1);
    }
  }

  Future<void> _buildTarget(String target, String mode) async {
    switch (target) {
      case 'android':
        await _buildAndroid(mode);
      case 'ios':
        await _buildIos(mode);
      case 'web':
        await _buildWeb(mode);
      case 'macos':
        await _runCmd('flutter', ['build', 'macos', '--release', ..._baseArgs], label: 'Building macOS');
      case 'windows':
        await _runCmd('flutter', ['build', 'windows', '--release', ..._baseArgs], label: 'Building Windows');
      case 'linux':
        await _runCmd('flutter', ['build', 'linux', '--release', ..._baseArgs], label: 'Building Linux');
    }
  }

  // ── Android ──

  Future<void> _buildAndroid(String mode) async {
    if (mode == 'apk') {
      await _runCmd('flutter', ['build', 'apk', ..._androidArgs], label: 'Building APK');
    } else if (mode == 'aab') {
      await _runCmd('flutter', ['build', 'appbundle', ..._androidArgs], label: 'Building App Bundle');
    } else {
      await _runCmd('flutter', ['build', 'appbundle', ..._androidArgs], label: 'Building App Bundle');
    }

    if (_cli.deploy) {
      _log('🚀  Deploy Android not yet implemented (use --deploy only for web)');
    }
  }

  List<String> get _androidArgs {
    final args = [..._baseArgs];
    if (_flavor.androidObfuscate) {
      args.addAll(['--obfuscate', '--split-debug-info=${_flavor.debugSymbolsPath ?? "build/debug-info"}']);
    }
    if (_flavor.androidSplitPerAbi) {
      args.add('--split-per-abi');
    }
    args.add('--target-platform');
    args.add('android-arm,android-arm64');
    return args;
  }

  // ── iOS ──

  Future<void> _buildIos(String mode) async {
    if (mode == 'archive') {
      await _runCmd('flutter', ['build', 'ios', ..._baseArgs, '--no-codesign'], label: 'Building iOS');
      _log('ℹ️  Next: open ios/Runner.xcworkspace in Xcode and Archive');
      _log('   Or run: flutter build ipa --export-method ${_flavor.iosExportMethod}');
    } else if (mode == 'ipa') {
      await _runCmd('flutter', [
        'build', 'ipa',
        ..._baseArgs,
        '--export-method', _flavor.iosExportMethod,
      ], label: 'Building IPA');
    } else {
      await _runCmd('flutter', ['build', 'ios', ..._baseArgs], label: 'Building iOS');
    }
  }

  // ── Web ──

  Future<void> _buildWeb(String mode) async {
    await _runCmd('flutter', [
      'build', 'web',
      ..._baseArgs,
      '--pwa-strategy=none',
      '--source-maps',
    ], label: 'Building Web');

    if (_cli.deploy || mode == 'deploy') {
      await _deployWeb();
    }
  }

  Future<void> _deployWeb() async {
    if (_flavor.firebaseProject == null) {
      _log('⚠️  No Firebase project configured for flavor ${_flavor.name}');
      return;
    }
    await _runCmd('firebase', [
      'deploy',
      '--only', 'hosting:${_flavor.webHostingTarget}',
      '--project', _flavor.firebaseProject!,
    ], label: 'Deploying Web to Firebase');
  }

  // ── Deploy ──

  Future<void> _deploy() async {
    _log('🚀  Deploying ${_flavor.name}...');
    if (_cli.targets.contains('web')) {
      await _deployWeb();
    }
  }

  // ── Shared ──

  List<String> get _baseArgs {
    final args = <String>[
      ..._flavor.flavorArgs,
      ..._flavor.dartDefineArgs,
    ];
    if (_cli.buildNumber != null) {
      args.add('--build-number=${_cli.buildNumber}');
    }
    return args;
  }

  // ── Helpers ──

  void _generateBuildInfo() {
    final now = DateTime.now();
    final iso = now.toIso8601String();
    final content = '''
// GENERATED by tool/build.dart — do not edit manually.

const String buildDate = "$iso";
const String buildFlavor = "${_flavor.name}";
const String buildVersion = "${_getPubspecVersion()}";
''';
    final dir = Directory('lib/config');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    File('lib/config/build_info.dart').writeAsStringSync(content);
    _log('✅  build_info.dart generated ($iso)');
  }

  String _getPubspecVersion() {
    try {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final match = RegExp(r'version:\s*([\d.+\-]+)').firstMatch(pubspec);
      return match?.group(1) ?? 'unknown';
    } catch (_) {
      return 'unknown';
    }
  }

  Future<void> _runCmd(String command, List<String> cmdArgs, {String? label}) async {
    if (label != null) _log('📦  $label...');

    final process = await Process.start(command, cmdArgs, runInShell: true);
    await Future.wait([
      stdout.addStream(process.stdout),
      stderr.addStream(process.stderr),
    ]);

    final code = await process.exitCode;
    if (code != 0) {
      throw Exception('❌  Command failed (exit $code): $command ${cmdArgs.join(' ')}');
    }
  }

  void _log(String message) => print('   $message');

  void _printHeader() {
    print('\n══════════════════════════════════════════════');
    print('  MasterTool Build Tool');
    print('  Flavor : ${_flavor.name}');
    print('  Targets: ${_cli.targets.join(', ')}');
    print('  Modes  : ${_cli.modes.join(', ')}');
    print('  Deploy : ${_cli.deploy ? "YES" : "no"}');
    print('══════════════════════════════════════════════\n');
  }

  void _printSummary() {
    final elapsed = DateTime.now().difference(_startTime);
    print('\n══════════════════════════════════════════════');
    _log('✅  All tasks completed in ${elapsed.inSeconds}s');
    print('══════════════════════════════════════════════\n');
  }

  void _printError(Object e) {
    print('\n══════════════════════════════════════════════');
    print('❌  Error: $e');
    print('══════════════════════════════════════════════\n');
  }
}
