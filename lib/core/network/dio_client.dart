import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/config.dart';
import '../errors/failures.dart';
import '../utils/logger.dart';
import 'dio_interceptors.dart';

Dio createDioClient(Ref ref) {
  final config = ref.watch(appConfigProvider).asData?.value;
  final baseUrl = config?.env.baseUrl ?? '';
  final enableLogging = config?.env.enableLogging ?? true;

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    if (enableLogging) LoggingInterceptor(),
    AuthInterceptor(
      getToken: () => null,
      onUnauthorized: () async {
        AppLogger.warning('Session expired', tag: 'DIO');
      },
    ),
    RetryInterceptor(),
    ConnectivityInterceptor(
      isConnected: () async => true,
    ),
  ]);

  return dio;
}

final dioProvider = Provider<Dio>(createDioClient);

Failure mapDioErrorToFailure(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      final message = responseData is Map ? responseData['message'] as String? : null;

      if (statusCode == 401) {
        return AuthFailure(message: message ?? 'Unauthorized');
      }
      if (statusCode == 403) {
        return AuthFailure(message: message ?? 'Forbidden');
      }
      if (statusCode == 404) {
        return ServerFailure(
          message: message ?? 'Resource not found',
          statusCode: statusCode,
        );
      }
      if (statusCode != null && statusCode >= 500) {
        return ServerFailure(
          message: message ?? 'Server error',
          statusCode: statusCode,
        );
      }
      return ServerFailure(
        message: message ?? 'Unexpected error',
        statusCode: statusCode,
      );
    case DioExceptionType.cancel:
      return const UnknownFailure(message: 'Request cancelled');
    default:
      return UnknownFailure(message: error.message ?? 'Unknown error');
  }
}
