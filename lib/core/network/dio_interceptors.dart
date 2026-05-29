import 'package:dio/dio.dart';
import '../utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.request(
      '${options.method} ${options.path}',
      tag: 'DIO',
    );
    if (options.data != null) {
      AppLogger.debug('Body: ${options.data}', tag: 'DIO');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.response(
      '${response.statusCode} ${response.requestOptions.path}',
      tag: 'DIO',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '${err.response?.statusCode} ${err.requestOptions.path}',
      tag: 'DIO',
      error: err.message,
    );
    handler.next(err);
  }
}

class AuthInterceptor extends Interceptor {
  final String? Function() getToken;
  final Future<void> Function()? onUnauthorized;

  AuthInterceptor({
    required this.getToken,
    this.onUnauthorized,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      AppLogger.warning('Unauthorized request', tag: 'DIO');
      await onUnauthorized?.call();
    }
    handler.next(err);
  }
}

class RetryInterceptor extends Interceptor {
  final int maxRetries;

  RetryInterceptor({this.maxRetries = 3});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && (err.requestOptions.extra['retryCount'] as int? ?? 0) < maxRetries) {
      final retryCount = (err.requestOptions.extra['retryCount'] as int? ?? 0) + 1;
      err.requestOptions.extra['retryCount'] = retryCount;

      await Future.delayed(Duration(seconds: retryCount * 2));

      AppLogger.info(
        'Retry $retryCount/$maxRetries for ${err.requestOptions.path}',
        tag: 'DIO',
      );

      try {
        final response = await Dio().fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } on DioException catch (_) {
        handler.next(err);
        return;
      }
    }
    handler.next(err);
  }

  bool _shouldRetry(DioException err) =>
      err.type == DioExceptionType.connectionTimeout ||
      err.type == DioExceptionType.sendTimeout ||
      err.type == DioExceptionType.receiveTimeout ||
      err.type == DioExceptionType.connectionError;
}

class ConnectivityInterceptor extends Interceptor {
  final Future<bool> Function() isConnected;

  ConnectivityInterceptor({required this.isConnected});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final connected = await isConnected();
    if (!connected) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'No internet connection',
        ),
      );
      return;
    }
    handler.next(options);
  }
}
