import 'failures.dart';

sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) =>
      switch (this) {
        Success<T>(data: final d) => success(d),
        Fail<T>(failure: final f) => failure(f),
      };

  R? whenOrNull<R>({
    R Function(T data)? onSuccess,
    R Function(Failure failure)? onFailure,
  }) =>
      switch (this) {
        Success<T>(data: final d) => onSuccess?.call(d),
        Fail<T>(failure: final f) => onFailure?.call(f),
      };

  Result<R> map<R>(R Function(T data) transform) => when(
        success: (data) => Success(transform(data)),
        failure: (f) => Fail(f),
      );

  T getOrElse(T Function() defaultValue) =>
      when(success: (data) => data, failure: (_) => defaultValue());

  T? getOrNull() => whenOrNull(onSuccess: (data) => data);

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Fail<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Fail<T> extends Result<T> {
  final Failure failure;
  const Fail(this.failure);
}

extension AsyncResult<T> on Future<Result<T>> {
  Future<R> whenAsync<R>({
    required Future<R> Function(T data) success,
    required Future<R> Function(Failure failure) failure,
  }) =>
      then((result) => result.when(success: success, failure: failure));
}
