import 'package:flutter/foundation.dart';

enum Flavor { dev, staging, prod }

Flavor detectFlavor() {
  const flavor = String.fromEnvironment('flavor');
  if (flavor.isNotEmpty) {
    return Flavor.values.firstWhere(
      (f) => f.name == flavor,
      orElse: () => Flavor.dev,
    );
  }
  if (kReleaseMode) return Flavor.prod;
  if (kProfileMode) return Flavor.staging;
  return Flavor.dev;
}
