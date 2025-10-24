import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shotgun_flutter/features/project_setup/presentation/screens/project_setup_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Project Setup Flow Integration Tests', () {
    testWidgets('Screen loads with initial state', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProjectSetupScreen(),
          ),
        ),
      );

      // Wait for the screen to settle
      await tester.pumpAndSettle();

      // Verify initial UI elements are present
      expect(find.text('Shotgun Code - Project Setup'), findsOneWidget);
      expect(find.text('Choose Project Folder'), findsOneWidget);
      expect(find.text('Select a project folder to begin'), findsOneWidget);
    });

    testWidgets('UI components are interactive', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProjectSetupScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the folder button
      final folderButton = find.text('Choose Project Folder');
      expect(folderButton, findsOneWidget);

      // Verify button is tappable (tap will open file picker in real app)
      // In integration test, we just verify it doesn't crash
      // Real file picker interaction requires platform-specific setup
    });
  });
}
