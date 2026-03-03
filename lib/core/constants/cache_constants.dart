/// Cache-related constants
class CacheConstants {
  CacheConstants._();

  // Hive box names
  static const String streamsBox = 'streams';
  static const String usersBox = 'users';
  static const String messagesBox = 'messages';
  static const String settingsBox = 'settings';

  // Hive type IDs (must be unique across the app)
  static const int streamModelTypeId = 0;
  static const int userModelTypeId = 1;
  static const int messageModelTypeId = 2;

  // SharedPreferences keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String isLoggedInKey = 'is_logged_in';
  static const String lastSyncTimeKey = 'last_sync_time';

  // Cache TTL (Time To Live)
  static const Duration streamsCacheTTL = Duration(minutes: 5);
  static const Duration profileCacheTTL = Duration(hours: 1);
  static const Duration messageCacheTTL = Duration(minutes: 30);
}
