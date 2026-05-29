class SslPinningConfig {
  final String host;
  final List<String> fingerprints;
  final bool isEnabled;

  const SslPinningConfig({
    required this.host,
    this.fingerprints = const [],
    this.isEnabled = false,
  });
}
