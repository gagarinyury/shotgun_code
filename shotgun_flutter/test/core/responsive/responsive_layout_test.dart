import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/core/responsive/responsive_layout.dart';

void main() {
  group('ResponsiveLayout', () {
    testWidgets('should show mobile widget on small screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: ResponsiveLayout(
              mobile: const Text('Mobile'),
              desktop: const Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Desktop'), findsNothing);
    });

    testWidgets('should show desktop widget on large screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1400, 900)),
            child: ResponsiveLayout(
              mobile: const Text('Mobile'),
              desktop: const Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsNothing);
      expect(find.text('Desktop'), findsOneWidget);
    });

    testWidgets('should show tablet widget on medium screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 900)),
            child: ResponsiveLayout(
              mobile: const Text('Mobile'),
              tablet: const Text('Tablet'),
              desktop: const Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsNothing);
      expect(find.text('Tablet'), findsOneWidget);
      expect(find.text('Desktop'), findsNothing);
    });

    testWidgets('should fallback to mobile widget when tablet is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 900)),
            child: ResponsiveLayout(
              mobile: const Text('Mobile'),
              desktop: const Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Desktop'), findsNothing);
    });
  });

  group('DeviceType detection', () {
    testWidgets('should return mobile for width < 600', (tester) async {
      BuildContext? capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(500, 800)),
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return Container();
              },
            ),
          ),
        ),
      );

      expect(capturedContext, isNotNull);
      expect(
        ResponsiveLayout.getDeviceType(capturedContext!),
        DeviceType.mobile,
      );
      expect(ResponsiveLayout.isMobile(capturedContext!), true);
      expect(ResponsiveLayout.isTablet(capturedContext!), false);
      expect(ResponsiveLayout.isDesktop(capturedContext!), false);
    });

    testWidgets('should return tablet for width between 600 and 1200', (
      tester,
    ) async {
      BuildContext? capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 900)),
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return Container();
              },
            ),
          ),
        ),
      );

      expect(capturedContext, isNotNull);
      expect(
        ResponsiveLayout.getDeviceType(capturedContext!),
        DeviceType.tablet,
      );
      expect(ResponsiveLayout.isMobile(capturedContext!), false);
      expect(ResponsiveLayout.isTablet(capturedContext!), true);
      expect(ResponsiveLayout.isDesktop(capturedContext!), false);
    });

    testWidgets('should return desktop for width >= 1200', (tester) async {
      BuildContext? capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1400, 900)),
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return Container();
              },
            ),
          ),
        ),
      );

      expect(capturedContext, isNotNull);
      expect(
        ResponsiveLayout.getDeviceType(capturedContext!),
        DeviceType.desktop,
      );
      expect(ResponsiveLayout.isMobile(capturedContext!), false);
      expect(ResponsiveLayout.isTablet(capturedContext!), false);
      expect(ResponsiveLayout.isDesktop(capturedContext!), true);
    });
  });

  group('ResponsiveValue extension', () {
    testWidgets('should return mobile value on mobile device', (tester) async {
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(500, 800)),
            child: Builder(
              builder: (context) {
                result = context.responsive(
                  mobile: 'mobile',
                  tablet: 'tablet',
                  desktop: 'desktop',
                );
                return Container();
              },
            ),
          ),
        ),
      );

      expect(result, 'mobile');
    });

    testWidgets('should return tablet value on tablet device', (tester) async {
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 900)),
            child: Builder(
              builder: (context) {
                result = context.responsive(
                  mobile: 'mobile',
                  tablet: 'tablet',
                  desktop: 'desktop',
                );
                return Container();
              },
            ),
          ),
        ),
      );

      expect(result, 'tablet');
    });

    testWidgets('should fallback to mobile when tablet is null', (
      tester,
    ) async {
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 900)),
            child: Builder(
              builder: (context) {
                result = context.responsive(
                  mobile: 'mobile',
                  desktop: 'desktop',
                );
                return Container();
              },
            ),
          ),
        ),
      );

      expect(result, 'mobile');
    });

    testWidgets('should return desktop value on desktop device', (
      tester,
    ) async {
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1400, 900)),
            child: Builder(
              builder: (context) {
                result = context.responsive(
                  mobile: 'mobile',
                  tablet: 'tablet',
                  desktop: 'desktop',
                );
                return Container();
              },
            ),
          ),
        ),
      );

      expect(result, 'desktop');
    });
  });
}
