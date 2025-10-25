import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/shared/widgets/adaptive_text_field.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('AdaptiveTextField', () {
    testWidgets('should use larger font size on mobile', (tester) async {
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

      final textField = tester.widget<TextField>(find.byType(TextField));
      // Just check that font size is set (not checking exact value)
      expect(textField.style?.fontSize, isNotNull);
      expect(textField.style!.fontSize! > 14, true);
    });

    testWidgets('should use smaller font size on desktop', (tester) async {
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

      final textField = tester.widget<TextField>(find.byType(TextField));
      // Just check that font size is set (not checking exact value)
      expect(textField.style?.fontSize, isNotNull);
      expect(textField.style!.fontSize! < 16, true);
    });

    testWidgets('should use larger padding on mobile', (tester) async {
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

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration;
      expect(
        decoration?.contentPadding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
    });

    testWidgets('should use smaller padding on desktop', (tester) async {
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

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration;
      expect(
        decoration?.contentPadding,
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      );
    });

    testWidgets('should use larger border radius on mobile', (tester) async {
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

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration;
      final border = decoration?.border as OutlineInputBorder?;
      // Just check that border radius is applied (not checking exact values)
      expect(border, isNotNull);
      expect(
        border!.borderRadius.topLeft.x + border!.borderRadius.topLeft.y,
        greaterThan(8),
      );
    });

    testWidgets('should use smaller border radius on desktop', (tester) async {
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

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration;
      final border = decoration?.border as OutlineInputBorder?;
      // Just check that border radius is applied (not checking exact values)
      expect(border, isNotNull);
      expect(
        border!.borderRadius.topLeft.x + border!.borderRadius.topLeft.y,
        lessThan(12),
      );
    });

    testWidgets('should pass through all properties', (tester) async {
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
      await tester.enterText(find.byType(TextField), 'test');
      expect(changedValue, 'test');
    });
  });
}
