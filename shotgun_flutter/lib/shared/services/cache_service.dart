import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static const String _contextsBoxName = 'contexts_cache';
  static const String _settingsBoxName = 'settings_cache';
  static const int _maxCacheSize = 100 * 1024 * 1024; // 100MB

  late Box<String> _contextsBox;
  late Box<String> _settingsBox;

  /// Initialize the cache service
  Future<void> init() async {
    await Hive.initFlutter();
    _contextsBox = await Hive.openBox<String>(_contextsBoxName);
    _settingsBox = await Hive.openBox<String>(_settingsBoxName);
  }

  /// Cache a context for a project
  Future<void> cacheContext({
    required String projectPath,
    required String context,
  }) async {
    await _contextsBox.put(projectPath, context);
  }

  /// Get cached context for a project
  String? getCachedContext(String projectPath) {
    return _contextsBox.get(projectPath);
  }

  /// Check if context is cached
  bool isContextCached(String projectPath) {
    return _contextsBox.containsKey(projectPath);
  }

  /// Clear cache for a specific project
  Future<void> clearProjectCache(String projectPath) async {
    await _contextsBox.delete(projectPath);
  }

  /// Clear all cached contexts
  Future<void> clearAllCache() async {
    await _contextsBox.clear();
  }

  /// Get total cache size in bytes
  int getCacheSize() {
    int totalSize = 0;
    for (final key in _contextsBox.keys) {
      final value = _contextsBox.get(key);
      if (value != null) {
        totalSize += value.length;
      }
    }
    return totalSize;
  }

  /// Check if cache exceeds maximum size
  bool isCacheExceeded() {
    return getCacheSize() > _maxCacheSize;
  }

  /// Clean up old cache entries if cache is exceeded
  Future<void> cleanupCache() async {
    if (isCacheExceeded()) {
      // Simple LRU: remove oldest entries until size is acceptable
      final keys = _contextsBox.keys.toList();
      keys.sort(); // Sort by key (assuming newer keys are at the end)

      int currentSize = getCacheSize();
      int removeIndex = 0;

      while (currentSize > _maxCacheSize && removeIndex < keys.length) {
        final key = keys[removeIndex];
        final value = _contextsBox.get(key);
        if (value != null) {
          currentSize -= value.length;
        }
        await _contextsBox.delete(key);
        removeIndex++;
      }
    }
  }

  /// Cache settings
  Future<void> cacheSettings(Map<String, dynamic> settings) async {
    final settingsJson = jsonEncode(settings);
    await _settingsBox.put('app_settings', settingsJson);
  }

  /// Get cached settings
  Map<String, dynamic>? getCachedSettings() {
    final settingsJson = _settingsBox.get('app_settings');
    if (settingsJson != null) {
      final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>?;
      return settingsMap ?? <String, dynamic>{};
    }
    return null;
  }

  /// Export cache to file for backup
  Future<void> exportCache(String filePath) async {
    final file = File(filePath);
    final cacheData = <String, dynamic>{
      'contexts': _contextsBox.toMap(),
      'settings': _settingsBox.toMap(),
    };

    await file.writeAsString(jsonEncode(cacheData));
  }

  /// Import cache from file
  Future<void> importCache(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      final content = await file.readAsString();
      final cacheData = jsonDecode(content) as Map<String, dynamic>;

      // Import contexts
      if (cacheData.containsKey('contexts')) {
        final contexts = cacheData['contexts'] as Map;
        for (final entry in contexts.entries) {
          await _contextsBox.put(entry.key, entry.value as String);
        }
      }

      // Import settings
      if (cacheData.containsKey('settings')) {
        final settings = cacheData['settings'] as Map;
        for (final entry in settings.entries) {
          await _settingsBox.put(entry.key, entry.value as String);
        }
      }
    }
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'totalSize': getCacheSize(),
      'maxSize': _maxCacheSize,
      'isExceeded': isCacheExceeded(),
      'contextCount': _contextsBox.length,
    };
  }
}
