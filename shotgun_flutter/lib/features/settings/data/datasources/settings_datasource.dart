import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_settings.dart';
import '../../../llm_executor/domain/entities/llm_provider_type.dart';

class SettingsDataSource {
  static const String _themeKey = 'theme_mode';
  static const String _llmProviderKey = 'default_llm_provider';
  static const String _fontSizeKey = 'font_size';
  static const String _autoSaveKey = 'auto_save';

  final SharedPreferences prefs;

  SettingsDataSource({required this.prefs});

  /// Get current settings
  AppSettings getSettings() {
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    final themeMode = ThemeMode.values[themeIndex];

    final llmProviderIndex = prefs.getInt(_llmProviderKey) ?? 0;
    final llmProvider = LLMProviderType.values[llmProviderIndex];

    final fontSize = prefs.getDouble(_fontSizeKey) ?? 14.0;
    final autoSave = prefs.getBool(_autoSaveKey) ?? true;

    return AppSettings(
      themeMode: themeMode,
      defaultLLMProvider: llmProvider,
      fontSize: fontSize,
      autoSave: autoSave,
    );
  }

  /// Save settings
  Future<void> saveSettings(AppSettings settings) async {
    await prefs.setInt(_themeKey, settings.themeMode.index);
    await prefs.setInt(_llmProviderKey, settings.defaultLLMProvider.index);
    await prefs.setDouble(_fontSizeKey, settings.fontSize);
    await prefs.setBool(_autoSaveKey, settings.autoSave);
  }

  /// Clear all settings
  Future<void> clearSettings() async {
    await prefs.remove(_themeKey);
    await prefs.remove(_llmProviderKey);
    await prefs.remove(_fontSizeKey);
    await prefs.remove(_autoSaveKey);
  }
}
