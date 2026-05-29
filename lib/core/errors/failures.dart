sealed class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure($code): $message';
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    super.message = 'Server error',
    this.statusCode,
    super.code,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code = 'NETWORK_ERROR',
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to load cached data',
    super.code = 'CACHE_ERROR',
  });
}

class ValidationFailure extends Failure {
  final Map<String, String>? errors;

  const ValidationFailure({
    super.message = 'Validation failed',
    this.errors,
    super.code = 'VALIDATION_ERROR',
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed',
    super.code,
  });
}

class UnknownFailure extends Failure {
  final Object? error;

  const UnknownFailure({
    super.message = 'An unknown error occurred',
    this.error,
    super.code = 'UNKNOWN_ERROR',
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out',
    super.code = 'TIMEOUT_ERROR',
  });
}
