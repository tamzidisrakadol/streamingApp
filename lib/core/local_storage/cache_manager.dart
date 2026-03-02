import 'package:hive/hive.dart';
import 'package:streaming_app/core/constants/cache_constants.dart';

/// Manages cache TTL (Time To Live) for different data types
class CacheManager {
  final Box _settingsBox;

  CacheManager({required Box settingsBox}) : _settingsBox = settingsBox;

  /// Check if cached data is still valid based on TTL
  bool isCacheValid(String key, {Duration? ttl}) {
    final cachedAt = _settingsBox.get('${key}_cached_at') as String?;

    if (cachedAt == null) return false;

    final cachedTime = DateTime.parse(cachedAt);
    final expiryDuration = ttl ?? CacheConstants.streamsCacheTTL;

    return DateTime.now().difference(cachedTime) < expiryDuration;
  }

  /// Mark data as cached with current timestamp
  Future<void> markCached(String key) async {
    await _settingsBox.put('${key}_cached_at', DateTime.now().toIso8601String());
  }

  /// Invalidate cache for a specific key
  Future<void> invalidateCache(String key) async {
    await _settingsBox.delete('${key}_cached_at');
  }

  /// Clear all cache timestamps
  Future<void> clearAllTimestamps() async {
    final keys = _settingsBox.keys
        .where((key) => key.toString().endsWith('_cached_at'))
        .toList();

    for (final key in keys) {
      await _settingsBox.delete(key);
    }
  }

  /// Get the last cached time for a key
  DateTime? getLastCachedTime(String key) {
    final cachedAt = _settingsBox.get('${key}_cached_at') as String?;
    return cachedAt != null ? DateTime.parse(cachedAt) : null;
  }

  /// Check if cache exists for a key (regardless of TTL)
  bool cacheExists(String key) {
    return _settingsBox.containsKey('${key}_cached_at');
  }
}
