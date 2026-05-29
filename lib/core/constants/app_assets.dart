class AppAssets {
  AppAssets._();

  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';
  static const String _animations = 'assets/animations';
  static const String _configs = 'assets/configs';

  // ── Images ──
  static const String logo = '$_images/logo.png';
  static const String placeholder = '$_images/placeholder.png';
  static const String emptyState = '$_images/empty_state.png';
  static const String errorState = '$_images/error_state.png';

  // ── Icons (SVG) ──
  static const String iconBell = '$_icons/bell.svg';
  static const String iconSettings = '$_icons/settings.svg';
  static const String iconUser = '$_icons/user.svg';
  static const String iconHome = '$_icons/home.svg';

  // ── Animations ──
  static const String loadingAnimation = '$_animations/loading.json';
  static const String successAnimation = '$_animations/success.json';
  static const String errorAnimation = '$_animations/error.json';

  // ── Configs ──
  static const String devConfig = '$_configs/dev.json';
  static const String stagingConfig = '$_configs/staging.json';
  static const String prodConfig = '$_configs/prod.json';
}
