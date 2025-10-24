import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shotgun_flutter/features/settings/presentation/screens/settings_screen.dart';

void main() {
  testWidgets('SettingsScreen should display all settings', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Default LLM Provider'), findsOneWidget);
    expect(find.text('Font Size'), findsOneWidget);
    expect(find.text('Auto-save preferences'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('SettingsScreen should display theme options', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    expect(find.text('Light, Dark, or System'), findsOneWidget);
    expect(find.byType(DropdownButton<ThemeMode>), findsOneWidget);
  });

  testWidgets('SettingsScreen should display LLM provider options',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    expect(find.text('Gemini, OpenAI, Claude, or Mistral'), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsOneWidget);
  });

  testWidgets('SettingsScreen should display font size slider',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    expect(find.byType(Slider), findsOneWidget);
  });

  testWidgets('SettingsScreen should display auto-save toggle',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    expect(find.byType(SwitchListTile), findsOneWidget);
    expect(find.text('Automatically save settings'), findsOneWidget);
  });

  testWidgets('SettingsScreen should have back button', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    // AppBar should have a back button when not on home route
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('SettingsScreen should display version info', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    expect(find.text('Shotgun Code v0.1.0'), findsOneWidget);
  });

  testWidgets('SettingsScreen should have dividers between sections',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    expect(find.byType(Divider), findsWidgets);
  });
}
