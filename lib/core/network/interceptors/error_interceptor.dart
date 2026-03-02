import 'package:dio/dio.dart';

/// Interceptor for handling and logging errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log error details
    print('[ErrorInterceptor] Error Type: ${err.type}');
    print('[ErrorInterceptor] Error Message: ${err.message}');
    print('[ErrorInterceptor] Status Code: ${err.response?.statusCode}');
    print('[ErrorInterceptor] Response Data: ${err.response?.data}');

    // You can add custom error handling logic here
    // For example, show a toast for specific error codes
    // or redirect to login on authentication errors

    super.onError(err, handler);
  }
}
