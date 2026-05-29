class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;

  const ApiResponse({
    this.data,
    this.message,
    this.statusCode,
  });

  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic>)? fromJsonT,
    List<T> Function(List<dynamic>)? fromJsonList,
  }) {
    dynamic rawData = json['data'];
    T? parsedData;

    if (fromJsonT != null && rawData is Map<String, dynamic>) {
      parsedData = fromJsonT(rawData);
    } else if (fromJsonList != null && rawData is List) {
      final list = fromJsonList(rawData);
      parsedData = list as T;
    } else {
      parsedData = rawData as T?;
    }

    return ApiResponse<T>(
      data: parsedData,
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int? ?? json['status_code'] as int?,
    );
  }
}
