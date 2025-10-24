import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/project_setup/presentation/screens/project_setup_screen.dart';

void main() {
  group('ProjectSetupScreen', () {
    testWidgets('should display initial state with folder picker', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProjectSetupScreen(),
          ),
        ),
      );

      // Should show the screen title
      expect(find.text('Shotgun Code - Project Setup'), findsOneWidget);

      // Should show the folder picker button
      expect(find.text('Choose Project Folder'), findsOneWidget);

      // Should show initial message
      expect(find.text('Select a project folder to begin'), findsOneWidget);
      expect(find.byIcon(Icons.folder_outlined), findsOneWidget);
    });
  });
}
