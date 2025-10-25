import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'shared/widgets/global_shortcuts_wrapper.dart';
import 'shared/widgets/app_menu_bar.dart';
import 'shared/services/keyboard_shortcut_service.dart';
import 'shared/domain/entities/keyboard_shortcut.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/project_setup/presentation/providers/recent_projects_provider.dart'
    as project_setup;
import 'core/performance/battery_optimizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        project_setup.sharedPreferencesProvider.overrideWithValue(
          sharedPreferences,
        ),
      ],
      child: const MyApp(),
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
  final BatteryOptimizer _batteryOptimizer = BatteryOptimizer();

  @override
  void initState() {
    super.initState();
    _setupRouter();
    _registerShortcuts();
    _batteryOptimizer.init();
  }

  @override
  void dispose() {
    _batteryOptimizer.dispose();
    super.dispose();
  }

  void _setupRouter() {
    _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Next Step (Cmd+Enter)')));
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
      children: const [Text('Cross-platform Flutter UI for Shotgun Code')],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = _batteryOptimizer.getRecommendedSettings();

    return GlobalShortcutsWrapper(
      child: MaterialApp.router(
        title: 'Shotgun Code',
        routerConfig: _router,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          pageTransitionsTheme: PageTransitionsTheme(
            builders: settings.enableAnimations
                ? const {
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                  }
                : const {
                    TargetPlatform.iOS: NoAnimationPageTransitionsBuilder(),
                    TargetPlatform.android: NoAnimationPageTransitionsBuilder(),
                  },
          ),
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

class ProjectSetupPlaceholder extends ConsumerStatefulWidget {
  const ProjectSetupPlaceholder({super.key});

  @override
  ConsumerState<ProjectSetupPlaceholder> createState() =>
      _ProjectSetupPlaceholderState();
}

class _ProjectSetupPlaceholderState
    extends ConsumerState<ProjectSetupPlaceholder> {
  bool _dragging = false;

  String _getProjectName(String path) {
    return path.split('/').last;
  }

  Future<void> _loadProject(String path) async {
    // Add to recent projects
    final dataSource = ref.read(project_setup.recentProjectsDataSourceProvider);
    await dataSource.addRecentProject(path);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Loading project: $path')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentProjects = ref.watch(project_setup.recentProjectsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Project Setup')),
      body: DropTarget(
        onDragEntered: (details) {
          setState(() {
            _dragging = true;
          });
        },
        onDragExited: (details) {
          setState(() {
            _dragging = false;
          });
        },
        onDragDone: (details) async {
          setState(() {
            _dragging = false;
          });

          if (details.files.isNotEmpty) {
            final file = details.files.first;
            await _loadProject(file.path);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: _dragging ? Border.all(color: Colors.blue, width: 2) : null,
            color: _dragging ? Colors.blue.withValues(alpha: 0.1) : null,
          ),
          child: Column(
            children: [
              // Drag and drop hint
              if (_dragging)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.withValues(alpha: 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.upload_file,
                        size: 32,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Drop folder here',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              // Recent projects
              if (recentProjects.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Projects',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...recentProjects.take(5).map((path) {
                        return ListTile(
                          leading: const Icon(Icons.folder),
                          title: Text(_getProjectName(path)),
                          subtitle: Text(path),
                          onTap: () => _loadProject(path),
                        );
                      }),
                    ],
                  ),
                ),

              // Center content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file,
                        size: 64,
                        color: _dragging ? Colors.blue : Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _dragging
                            ? 'Drop folder here'
                            : 'Drag and drop project folder',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text('or', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 16),
                      // Open project button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Open Project'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Open project dialog (Phase 7+)'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child; // No animation
  }
}
