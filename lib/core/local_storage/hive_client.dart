import 'package:hive_flutter/hive_flutter.dart';
import 'package:streaming_app/core/constants/cache_constants.dart';

/// Hive client for initializing and managing Hive boxes
class HiveClient {
  static bool _isInitialized = false;

  /// Initialize Hive and open all required boxes
  static Future<void> init() async {
    if (_isInitialized) return;

    // Initialize Hive
    await Hive.initFlutter();

    // Register type adapters
    // Note: Adapters will be registered when models are created with @HiveType
    // Hive.registerAdapter(StreamModelAdapter());
    // Hive.registerAdapter(UserModelAdapter());
    // Hive.registerAdapter(MessageModelAdapter());

    // Open boxes
    await Future.wait([
      Hive.openBox(CacheConstants.streamsBox),
      Hive.openBox(CacheConstants.usersBox),
      Hive.openBox(CacheConstants.messagesBox),
      Hive.openBox(CacheConstants.settingsBox),
    ]);

    _isInitialized = true;
  }

  /// Get a box by name
  static Box<T> getBox<T>(String name) {
    if (!_isInitialized) {
      throw Exception('HiveClient not initialized. Call init() first.');
    }
    return Hive.box<T>(name);
  }

  /// Get a typed box
  static Box getTypedBox(String name) {
    if (!_isInitialized) {
      throw Exception('HiveClient not initialized. Call init() first.');
    }
    return Hive.box(name);
  }

  /// Clear all data from a specific box
  static Future<void> clearBox(String boxName) async {
    final box = getTypedBox(boxName);
    await box.clear();
  }

  /// Clear all boxes
  static Future<void> clearAll() async {
    await Future.wait([
      clearBox(CacheConstants.streamsBox),
      clearBox(CacheConstants.usersBox),
      clearBox(CacheConstants.messagesBox),
      clearBox(CacheConstants.settingsBox),
    ]);
  }

  /// Close all boxes
  static Future<void> close() async {
    await Hive.close();
    _isInitialized = false;
  }

  /// Delete all data and close Hive
  static Future<void> deleteAll() async {
    await Hive.deleteFromDisk();
    _isInitialized = false;
  }
}
