import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/shared/widgets/mobile_navigation.dart';

void main() {
  group('MobileNavigation', () {
    testWidgets('should display 4 destinations', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: MobileNavigation(currentIndex: 0),
          ),
        ),
      );

      expect(find.text('Project'), findsOneWidget);
      expect(find.text('Compose'), findsOneWidget);
      expect(find.text('Execute'), findsOneWidget);
      expect(find.text('Apply'), findsOneWidget);
    });

    testWidgets('should highlight selected item', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: MobileNavigation(currentIndex: 1),
          ),
        ),
      );

      // Check that second item is selected
      final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(navBar.selectedIndex, 1);
    });

    testWidgets('should have navigation destinations', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: MobileNavigation(currentIndex: 0),
          ),
        ),
      );

      // Check for NavigationDestination widgets
      expect(find.byType(NavigationDestination), findsNWidgets(4));

      // Check that each destination has an icon
      final destinations = tester.widgetList<NavigationDestination>(
        find.byType(NavigationDestination),
      );
      for (final destination in destinations) {
        expect(destination.icon, isNotNull);
        expect(destination.selectedIcon, isNotNull);
      }
    });
  });
}
