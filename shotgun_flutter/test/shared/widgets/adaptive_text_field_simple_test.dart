import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/shared/widgets/adaptive_text_field.dart';

void main() {
  group('AdaptiveTextField', () {
    testWidgets('should create widget without errors', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveTextField(
              controller: controller,
              hintText: 'Test hint',
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(AdaptiveTextField), findsOneWidget);
    });

    testWidgets('should pass through properties', (tester) async {
      final controller = TextEditingController();
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveTextField(
              controller: controller,
              hintText: 'Test hint',
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              onChanged: (value) => changedValue = value,
              obscureText: true,
            ),
          ),
        ),
      );

      // Verify properties
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller, controller);
      expect(textField.maxLines, 3);
      expect(textField.keyboardType, TextInputType.multiline);
      expect(textField.obscureText, true);

      // Test onChanged callback
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();
      expect(changedValue, 'test');
    });
  });
}
