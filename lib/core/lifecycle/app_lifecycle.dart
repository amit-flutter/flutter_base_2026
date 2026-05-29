import 'package:flutter/material.dart';

enum AppLifecycleStateEx { foreground, background }

class AppLifecycleObserver with WidgetsBindingObserver {
  final void Function(AppLifecycleStateEx state)? onStateChanged;

  AppLifecycleObserver({this.onStateChanged}) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onStateChanged?.call(AppLifecycleStateEx.foreground);
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        onStateChanged?.call(AppLifecycleStateEx.background);
      default:
        break;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
