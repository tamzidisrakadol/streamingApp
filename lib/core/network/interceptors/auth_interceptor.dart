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
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401) {
      // Try to refresh the token
      final refreshed = await _refreshToken(err.requestOptions);

      if (refreshed) {
        // Retry the original request with new token
        try {
          final options = err.requestOptions;
          final response = await Dio().fetch(options);
          return handler.resolve(response);
        } catch (e) {
          // If retry fails, pass the error through
          return super.onError(err, handler);
        }
      }
    }

    super.onError(err, handler);
  }

  /// Attempt to refresh the authentication token
  Future<bool> _refreshToken(RequestOptions requestOptions) async {
    try {
      final refreshToken =
          sharedPreferences.getString(CacheConstants.refreshTokenKey);

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      // Create a new Dio instance to avoid interceptor loop
      final dio = Dio();
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.refreshToken}',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        // Save new tokens
        await sharedPreferences.setString(
          CacheConstants.authTokenKey,
          newToken,
        );
        await sharedPreferences.setString(
          CacheConstants.refreshTokenKey,
          newRefreshToken,
        );

        // Update the request with new token
        requestOptions.headers[ApiConstants.authHeader] = 'Bearer $newToken';

        return true;
      }

      return false;
    } catch (e) {
      // Token refresh failed
      print('[AuthInterceptor] Token refresh failed: $e');
      return false;
    }
  }
}
