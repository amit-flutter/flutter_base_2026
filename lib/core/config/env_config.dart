import 'dart:convert';
import 'package:flutter/services.dart';
import 'flavor.dart';

class EnvConfig {
  final String appName;
  final String baseUrl;
  final String sentryDsn;
  final String firebaseProjectId;
  final bool enableLogging;
  final bool enableCrashReporting;

  const EnvConfig({
    required this.appName,
    required this.baseUrl,
    required this.sentryDsn,
    required this.firebaseProjectId,
    required this.enableLogging,
    required this.enableCrashReporting,
  });

  factory EnvConfig.fromJson(Map<String, dynamic> json) => EnvConfig(
        appName: json['appName'] as String? ?? '',
        baseUrl: json['baseUrl'] as String? ?? '',
        sentryDsn: json['sentryDsn'] as String? ?? '',
        firebaseProjectId: json['firebaseProjectId'] as String? ?? '',
        enableLogging: json['enableLogging'] as bool? ?? false,
        enableCrashReporting: json['enableCrashReporting'] as bool? ?? false,
      );

  static Future<EnvConfig> load(Flavor flavor) async {
    final jsonString = await rootBundle.loadString(
      'assets/configs/${flavor.name}.json',
    );
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return EnvConfig.fromJson(json);
  }
}
