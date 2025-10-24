import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/settings_datasource.dart';
import '../../domain/entities/app_settings.dart';
import '../../../llm_executor/domain/entities/llm_provider_type.dart';

// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

// Provider for SettingsDataSource
final settingsDataSourceProvider = Provider<SettingsDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsDataSource(prefs: prefs);
});

// Provider for current settings
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((
  ref,
) {
  final dataSource = ref.watch(settingsDataSourceProvider);
  return SettingsNotifier(dataSource);
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsDataSource _dataSource;

  SettingsNotifier(this._dataSource) : super(_dataSource.getSettings());

  /// Update theme mode
  void updateThemeMode(ThemeMode themeMode) {
    final newSettings = state.copyWith(themeMode: themeMode);
    state = newSettings;
    _saveSettings(newSettings);
  }

  /// Update default LLM provider
  void updateLLMProvider(LLMProviderType provider) {
    final newSettings = state.copyWith(defaultLLMProvider: provider);
    state = newSettings;
    _saveSettings(newSettings);
  }

  /// Update font size
  void updateFontSize(double fontSize) {
    final newSettings = state.copyWith(fontSize: fontSize);
    state = newSettings;
    _saveSettings(newSettings);
  }

  /// Update auto-save setting
  void updateAutoSave(bool autoSave) {
    final newSettings = state.copyWith(autoSave: autoSave);
    state = newSettings;
    _saveSettings(newSettings);
  }

  /// Save settings to storage
  Future<void> _saveSettings(AppSettings settings) async {
    await _dataSource.saveSettings(settings);
  }

  /// Reset all settings to defaults
  void resetToDefaults() {
    const defaultSettings = AppSettings();
    state = defaultSettings;
    _saveSettings(defaultSettings);
  }
}
