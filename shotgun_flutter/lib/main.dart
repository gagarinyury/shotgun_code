import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'shared/widgets/global_shortcuts_wrapper.dart';
import 'shared/widgets/app_menu_bar.dart';
import 'shared/services/keyboard_shortcut_service.dart';
import 'shared/domain/entities/keyboard_shortcut.dart';
import 'features/settings/presentation/screens/settings_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _setupRouter();
    _registerShortcuts();
  }

  void _setupRouter() {
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/project-setup',
          builder: (context, state) => const ProjectSetupPlaceholder(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
  }

  void _registerShortcuts() {
    final service = ref.read(keyboardShortcutServiceProvider);

    // Register handlers
    service.registerHandler(ShortcutAction.openProject, () {
      // Navigate to project setup
      _router.go('/project-setup');
    });

    service.registerHandler(ShortcutAction.nextStep, () {
      // Navigate to next step
      // Logic based on current route
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Next Step (Cmd+Enter)')),
        );
      }
    });

    service.registerHandler(ShortcutAction.copyContext, () {
      // Copy context to clipboard
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Copy Context (Cmd+Shift+C)')),
        );
      }
    });
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Shotgun Code',
      applicationVersion: '0.1.0',
      applicationIcon: const Icon(Icons.code, size: 48),
      children: const [
        Text('Cross-platform Flutter UI for Shotgun Code'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlobalShortcutsWrapper(
      child: MaterialApp.router(
        title: 'Shotgun Code',
        routerConfig: _router,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        builder: (context, child) {
          return Column(
            children: [
              AppMenuBar(
                onOpenProject: () => _router.go('/project-setup'),
                onSettings: () => _router.go('/settings'),
                onAbout: () => _showAboutDialog(context),
              ),
              Expanded(child: child ?? const SizedBox()),
            ],
          );
        },
      ),
    );
  }
}

// Placeholder screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shotgun Code')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Shotgun Code'),
            SizedBox(height: 16),
            Text('Try Cmd+O to open project'),
          ],
        ),
      ),
    );
  }
}

class ProjectSetupPlaceholder extends StatelessWidget {
  const ProjectSetupPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Setup')),
      body: const Center(
        child: Text('Project Setup Screen'),
      ),
    );
  }
}
