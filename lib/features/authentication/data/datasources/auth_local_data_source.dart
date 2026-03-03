import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_app/core/constants/cache_constants.dart';
import 'package:streaming_app/core/error/exceptions.dart';
import 'package:streaming_app/features/authentication/data/models/user_model.dart';

/// Local data source for authentication
/// Handles caching user data and tokens
abstract class AuthLocalDataSource {
  /// Get cached user
  Future<UserModel?> getCachedUser();

  /// Cache user
  Future<void> cacheUser(UserModel user);

  /// Clear cached user
  Future<void> clearCachedUser();

  /// Save auth token
  Future<void> saveAuthToken(String token);

  /// Get auth token
  String? getAuthToken();

  /// Save refresh token
  Future<void> saveRefreshToken(String token);

  /// Get refresh token
  String? getRefreshToken();

  /// Clear all auth data
  Future<void> clearAuthData();

  /// Check if user is logged in
  bool isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Box usersBox;

  static const String _currentUserKey = 'current_user';

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.usersBox,
  });

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userId = sharedPreferences.getString(CacheConstants.userIdKey);
      if (userId == null) return null;

      final user = usersBox.get(_currentUserKey) as UserModel?;
      return user;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached user: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await usersBox.put(_currentUserKey, user);
      await sharedPreferences.setString(CacheConstants.userIdKey, user.id);
      await sharedPreferences.setBool(CacheConstants.isLoggedInKey, true);
    } catch (e) {
      throw CacheException(message: 'Failed to cache user: $e');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await usersBox.delete(_currentUserKey);
      await sharedPreferences.remove(CacheConstants.userIdKey);
      await sharedPreferences.setBool(CacheConstants.isLoggedInKey, false);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached user: $e');
    }
  }

  @override
  Future<void> saveAuthToken(String token) async {
    try {
      await sharedPreferences.setString(CacheConstants.authTokenKey, token);
    } catch (e) {
      throw CacheException(message: 'Failed to save auth token: $e');
    }
  }

  @override
  String? getAuthToken() {
    return sharedPreferences.getString(CacheConstants.authTokenKey);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await sharedPreferences.setString(CacheConstants.refreshTokenKey, token);
    } catch (e) {
      throw CacheException(message: 'Failed to save refresh token: $e');
    }
  }

  @override
  String? getRefreshToken() {
    return sharedPreferences.getString(CacheConstants.refreshTokenKey);
  }

  @override
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        clearCachedUser(),
        sharedPreferences.remove(CacheConstants.authTokenKey),
        sharedPreferences.remove(CacheConstants.refreshTokenKey),
      ]);
    } catch (e) {
      throw CacheException(message: 'Failed to clear auth data: $e');
    }
  }

  @override
  bool isLoggedIn() {
    return sharedPreferences.getBool(CacheConstants.isLoggedInKey) ?? false;
  }
}
