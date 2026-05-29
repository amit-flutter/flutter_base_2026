import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app.dart';
import 'core/bootstrap.dart';

void main() async {
  final appConfig = await Bootstrap.init();
  runApp(
    ProviderScope(
      child: App(appConfig: appConfig),
    ),
  );
}
