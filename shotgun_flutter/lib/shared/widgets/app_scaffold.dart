import 'package:flutter/material.dart';
import 'package:shotgun_flutter/core/responsive/responsive_layout.dart';
import 'package:shotgun_flutter/shared/widgets/mobile_navigation.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final String? title;
  final List<Widget>? actions;

  const AppScaffold({
    required this.child,
    required this.currentIndex,
    this.title,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: Scaffold(
        appBar: title != null
            ? AppBar(title: Text(title!), actions: actions)
            : null,
        body: child,
        bottomNavigationBar: MobileNavigation(currentIndex: currentIndex),
      ),
      desktop: Scaffold(
        appBar: title != null
            ? AppBar(title: Text(title!), actions: actions)
            : null,
        body: Row(
          children: [
            // Desktop: Left sidebar with steps
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    // Navigate to project setup
                    break;
                  case 1:
                    // Navigate to prompt composer
                    break;
                  case 2:
                    // Navigate to LLM executor
                    break;
                  case 3:
                    // Navigate to patch applier
                    break;
                }
              },
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.folder_outlined),
                  selectedIcon: Icon(Icons.folder),
                  label: Text('Project'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.edit_outlined),
                  selectedIcon: Icon(Icons.edit),
                  label: Text('Compose'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.auto_awesome_outlined),
                  selectedIcon: Icon(Icons.auto_awesome),
                  label: Text('Execute'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.check_circle_outline),
                  selectedIcon: Icon(Icons.check_circle),
                  label: Text('Apply'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
