import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shotgun_flutter/shared/widgets/global_shortcuts_wrapper.dart';

void main() {
  testWidgets('GlobalShortcutsWrapper should wrap child', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: GlobalShortcutsWrapper(
            child: Text('Test Child'),
          ),
        ),
      ),
    );

    expect(find.text('Test Child'), findsOneWidget);
  });

  testWidgets('GlobalShortcutsWrapper should render without errors',
      (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: GlobalShortcutsWrapper(
              child: Text('Content'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Content'), findsOneWidget);
    expect(find.byType(GlobalShortcutsWrapper), findsOneWidget);
  });

  testWidgets('GlobalShortcutsWrapper should not interfere with child widgets',
      (tester) async {
    var buttonPressed = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: GlobalShortcutsWrapper(
              child: ElevatedButton(
                onPressed: () {
                  buttonPressed = true;
                },
                child: const Text('Press Me'),
              ),
            ),
          ),
        ),
      ),
    );

    // Verify button is rendered
    expect(find.text('Press Me'), findsOneWidget);

    // Tap the button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify button callback was called
    expect(buttonPressed, true);
  });

  testWidgets('GlobalShortcutsWrapper should work with complex widget tree',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: GlobalShortcutsWrapper(
            child: Scaffold(
              appBar: AppBar(title: const Text('App')),
              body: Column(
                children: [
                  const Text('Line 1'),
                  const Text('Line 2'),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text('Line 3'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('App'), findsOneWidget);
    expect(find.text('Line 1'), findsOneWidget);
    expect(find.text('Line 2'), findsOneWidget);
    expect(find.text('Line 3'), findsOneWidget);
  });
}
