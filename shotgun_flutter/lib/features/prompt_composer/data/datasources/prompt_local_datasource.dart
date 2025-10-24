import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/error/exceptions.dart';

/// Local data source for prompt composer using Hive for persistence.
///
/// Stores:
/// - Custom rules (simple string)
/// - Prompt templates (JSON objects stored as Maps)
///
/// This class handles all local storage operations and throws exceptions
/// on failures, which will be converted to Failures at the repository layer.
class PromptLocalDataSource {
  static const String _rulesBoxName = 'custom_rules';
  static const String _templatesBoxName = 'prompt_templates';
  static const String _defaultRulesKey = 'default';

  Box<String>? _rulesBox;
  Box<Map<dynamic, dynamic>>? _templatesBox;

  /// Initializes the data source by opening Hive boxes.
  ///
  /// Should be called before any other operations.
  ///
  /// Throws [CacheException] if initialization fails.
  Future<void> init() async {
    try {
      _rulesBox = await Hive.openBox<String>(_rulesBoxName);
      _templatesBox = await Hive.openBox<Map<dynamic, dynamic>>(_templatesBoxName);
    } catch (e) {
      throw CacheException('Failed to initialize local storage: ${e.toString()}');
    }
  }

  /// Saves custom rules to local storage.
  ///
  /// Parameters:
  /// - [rules]: The custom rules text to save
  ///
  /// Throws [CacheException] if save fails.
  Future<void> saveCustomRules(String rules) async {
    try {
      if (_rulesBox == null) {
        await init();
      }
      await _rulesBox!.put(_defaultRulesKey, rules);
    } catch (e) {
      throw CacheException('Failed to save custom rules: ${e.toString()}');
    }
  }

  /// Loads custom rules from local storage.
  ///
  /// Returns:
  /// - The saved custom rules, or empty string if none saved
  ///
  /// Throws [CacheException] if load fails.
  Future<String> loadCustomRules() async {
    try {
      if (_rulesBox == null) {
        await init();
      }
      return _rulesBox!.get(_defaultRulesKey, defaultValue: '') ?? '';
    } catch (e) {
      throw CacheException('Failed to load custom rules: ${e.toString()}');
    }
  }

  /// Saves a prompt template to local storage.
  ///
  /// Parameters:
  /// - [id]: The template ID (used as key)
  /// - [templateData]: The template data as a map
  ///
  /// Throws [CacheException] if save fails.
  Future<void> saveTemplate(String id, Map<String, dynamic> templateData) async {
    try {
      if (_templatesBox == null) {
        await init();
      }
      await _templatesBox!.put(id, templateData);
    } catch (e) {
      throw CacheException('Failed to save template: ${e.toString()}');
    }
  }

  /// Loads a specific template by ID.
  ///
  /// Parameters:
  /// - [id]: The template ID to load
  ///
  /// Returns:
  /// - The template data as a map, or null if not found
  ///
  /// Throws [CacheException] if load fails.
  Future<Map<String, dynamic>?> loadTemplate(String id) async {
    try {
      if (_templatesBox == null) {
        await init();
      }
      final data = _templatesBox!.get(id);
      if (data == null) return null;
      return Map<String, dynamic>.from(data);
    } catch (e) {
      throw CacheException('Failed to load template: ${e.toString()}');
    }
  }

  /// Loads all saved templates.
  ///
  /// Returns:
  /// - A list of all template data maps
  ///
  /// Throws [CacheException] if load fails.
  Future<List<Map<String, dynamic>>> loadAllTemplates() async {
    try {
      if (_templatesBox == null) {
        await init();
      }
      return _templatesBox!.values
          .map((data) => Map<String, dynamic>.from(data))
          .toList();
    } catch (e) {
      throw CacheException('Failed to load templates: ${e.toString()}');
    }
  }

  /// Deletes a template by ID.
  ///
  /// Parameters:
  /// - [id]: The template ID to delete
  ///
  /// Throws [CacheException] if delete fails.
  Future<void> deleteTemplate(String id) async {
    try {
      if (_templatesBox == null) {
        await init();
      }
      await _templatesBox!.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete template: ${e.toString()}');
    }
  }

  /// Closes the Hive boxes.
  ///
  /// Should be called when the data source is no longer needed.
  Future<void> close() async {
    await _rulesBox?.close();
    await _templatesBox?.close();
    _rulesBox = null;
    _templatesBox = null;
  }

  /// Clears all data (for testing purposes).
  ///
  /// Throws [CacheException] if clear fails.
  Future<void> clearAll() async {
    try {
      if (_rulesBox == null || _templatesBox == null) {
        await init();
      }
      await _rulesBox!.clear();
      await _templatesBox!.clear();
    } catch (e) {
      throw CacheException('Failed to clear data: ${e.toString()}');
    }
  }
}
