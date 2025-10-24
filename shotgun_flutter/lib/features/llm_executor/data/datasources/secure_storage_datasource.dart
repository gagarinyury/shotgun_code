import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shotgun_flutter/core/error/exceptions.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_provider_type.dart';

/// Data source for securely storing and retrieving API keys
class SecureStorageDataSource {
  final FlutterSecureStorage _storage;

  SecureStorageDataSource({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Save API key for a specific provider
  Future<void> saveApiKey(LLMProviderType provider, String apiKey) async {
    try {
      await _storage.write(
        key: '${provider.name}_api_key',
        value: apiKey,
      );
    } catch (e) {
      throw CacheException('Failed to save API key: $e');
    }
  }

  /// Get API key for a specific provider
  Future<String?> getApiKey(LLMProviderType provider) async {
    try {
      return await _storage.read(key: '${provider.name}_api_key');
    } catch (e) {
      throw CacheException('Failed to read API key: $e');
    }
  }

  /// Delete API key for a specific provider
  Future<void> deleteApiKey(LLMProviderType provider) async {
    try {
      await _storage.delete(key: '${provider.name}_api_key');
    } catch (e) {
      throw CacheException('Failed to delete API key: $e');
    }
  }

  /// Check if API key exists for a specific provider
  Future<bool> hasApiKey(LLMProviderType provider) async {
    try {
      final key = await getApiKey(provider);
      return key != null && key.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Delete all API keys
  Future<void> deleteAllApiKeys() async {
    try {
      for (final provider in LLMProviderType.values) {
        await deleteApiKey(provider);
      }
    } catch (e) {
      throw CacheException('Failed to delete all API keys: $e');
    }
  }
}
