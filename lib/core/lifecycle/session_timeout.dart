import 'dart:async';
import 'package:flutter/foundation.dart';

class SessionTimeout {
  final Duration timeout;
  final VoidCallback onTimeout;
  Timer? _timer;

  SessionTimeout({
    required this.timeout,
    required this.onTimeout,
  });

  void start() {
    _timer?.cancel();
    _timer = Timer(timeout, onTimeout);
  }

  void reset() {
    _timer?.cancel();
    _timer = Timer(timeout, onTimeout);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stop();
  }
}
