import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme setting
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Light, Dark, or System'),
            trailing: DropdownButton<ThemeMode>(
              value: ThemeMode.system,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
              ],
              onChanged: (value) {
                // Update theme - will be implemented with state management
              },
            ),
          ),

          const Divider(),

          // Default LLM provider
          ListTile(
            title: const Text('Default LLM Provider'),
            subtitle: const Text('Gemini, OpenAI, Claude, or Mistral'),
            trailing: DropdownButton<String>(
              value: 'gemini',
              items: const [
                DropdownMenuItem(value: 'gemini', child: Text('Gemini')),
                DropdownMenuItem(value: 'openai', child: Text('OpenAI')),
                DropdownMenuItem(value: 'claude', child: Text('Claude')),
                DropdownMenuItem(value: 'mistral', child: Text('Mistral')),
              ],
              onChanged: (value) {
                // Update provider - will be implemented with state management
              },
            ),
          ),

          const Divider(),

          // Font size
          ListTile(
            title: const Text('Font Size'),
            subtitle: Slider(
              value: 14,
              min: 10,
              max: 20,
              divisions: 10,
              label: '14',
              onChanged: (value) {
                // Update font size - will be implemented with state management
              },
            ),
          ),

          const Divider(),

          // Auto-save
          SwitchListTile(
            title: const Text('Auto-save preferences'),
            subtitle: const Text('Automatically save settings'),
            value: true,
            onChanged: (value) {
              // Toggle auto-save - will be implemented with state management
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
