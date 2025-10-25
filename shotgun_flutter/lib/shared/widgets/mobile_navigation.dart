import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileNavigation extends StatelessWidget {
  final int currentIndex;

  const MobileNavigation({required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go('/project-setup');
            break;
          case 1:
            context.go('/prompt-composer');
            break;
          case 2:
            context.go('/llm-executor');
            break;
          case 3:
            context.go('/patch-applier');
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.folder_outlined),
          selectedIcon: Icon(Icons.folder),
          label: 'Project',
        ),
        NavigationDestination(
          icon: Icon(Icons.edit_outlined),
          selectedIcon: Icon(Icons.edit),
          label: 'Compose',
        ),
        NavigationDestination(
          icon: Icon(Icons.auto_awesome_outlined),
          selectedIcon: Icon(Icons.auto_awesome),
          label: 'Execute',
        ),
        NavigationDestination(
          icon: Icon(Icons.check_circle_outline),
          selectedIcon: Icon(Icons.check_circle),
          label: 'Apply',
        ),
      ],
    );
  }
}
