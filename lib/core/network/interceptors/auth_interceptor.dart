import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_app/core/constants/api_constants.dart';
import 'package:streaming_app/core/constants/cache_constants.dart';

/// Interceptor for adding authentication token to requests
/// and handling token refresh on 401 errors
class AuthInterceptor extends Interceptor {
  final SharedPreferences sharedPreferences;

  AuthInterceptor({required this.sharedPreferences});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Get auth token from SharedPreferences
    final token = sharedPreferences.getString(CacheConstants.authTokenKey);

    // Add token to headers if it exists
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.authHeader] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // handle 401 error later

    super.onError(err, handler);
  }

}
