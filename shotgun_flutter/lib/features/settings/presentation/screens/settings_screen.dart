import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../../../llm_executor/domain/entities/llm_provider_type.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.watch(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme setting
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Light, Dark, or System'),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              items: const [
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  settingsNotifier.updateThemeMode(value);
                }
              },
            ),
          ),

          const Divider(),

          // Default LLM provider
          ListTile(
            title: const Text('Default LLM Provider'),
            subtitle: const Text('Gemini, OpenAI, Claude, or DeepSeek'),
            trailing: DropdownButton<LLMProviderType>(
              value: settings.defaultLLMProvider,
              items: const [
                DropdownMenuItem(
                  value: LLMProviderType.gemini,
                  child: Text('Gemini'),
                ),
                DropdownMenuItem(
                  value: LLMProviderType.openai,
                  child: Text('OpenAI'),
                ),
                DropdownMenuItem(
                  value: LLMProviderType.claude,
                  child: Text('Claude'),
                ),
                DropdownMenuItem(
                  value: LLMProviderType.deepseek,
                  child: Text('DeepSeek'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  settingsNotifier.updateLLMProvider(value);
                }
              },
            ),
          ),

          const Divider(),

          // Font size
          ListTile(
            title: const Text('Font Size'),
            subtitle: Slider(
              value: settings.fontSize,
              min: 10,
              max: 20,
              divisions: 10,
              label: settings.fontSize.round().toString(),
              onChanged: (value) {
                settingsNotifier.updateFontSize(value);
              },
            ),
          ),

          const Divider(),

          // Auto-save
          SwitchListTile(
            title: const Text('Auto-save preferences'),
            subtitle: const Text('Automatically save settings'),
            value: settings.autoSave,
            onChanged: (value) {
              settingsNotifier.updateAutoSave(value);
            },
          ),

          const Divider(),

          // Reset button
          ListTile(
            title: const Text('Reset to Defaults'),
            leading: const Icon(Icons.restore),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Settings'),
                  content: const Text(
                    'Are you sure you want to reset all settings to their default values?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        settingsNotifier.resetToDefaults();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(),

          // About section
          const ListTile(
            title: Text('About'),
            subtitle: Text('Shotgun Code v0.1.0'),
          ),
        ],
      ),
    );
  }
}
