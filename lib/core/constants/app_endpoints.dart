class AppEndpoints {
  AppEndpoints._();

  static const String baseUrl = 'baseUrl';

  // ── Auth ──
  static const String login = '/auth/login';
  static const String signUp = '/auth/signup';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // ── User ──
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';

  // ── Generic ──
  static String paginated(String path, {int page = 1, int limit = 20}) =>
      '$path?page=$page&limit=$limit';

  static String byId(String path, String id) => '$path/$id';
}
