# Phase 6: Cross-Platform Polish & Desktop Features

**Duration:** 2 weeks
**Goal:** Оптимизация для desktop, keyboard shortcuts, улучшение UX

---

## ⚠️ ВАЛИДАЦИЯ ПОСЛЕ КАЖДОГО ШАГА

```bash
# 1. Анализ кода
flutter analyze
# Должно быть: 0 issues found

# 2. Запустить тесты
flutter test
# Должно быть: All tests passed!

# 3. Проверить на desktop
flutter run -d macos    # или windows/linux
# Должно быть: app запускается, shortcuts работают

# 4. Проверить coverage
flutter test --coverage
lcov --summary coverage/lcov.info
# Должно быть: >85% для desktop features
```

**НЕ ПЕРЕХОДИ К СЛЕДУЮЩЕМУ ШАГУ, ПОКА:**
- ❌ Есть хотя бы одна ошибка в `flutter analyze`
- ❌ Есть failing tests
- ❌ Shortcuts не работают на всех платформах
- ❌ UI сломан на desktop

---

## Предварительные требования

- ✅ Phase 0-5 завершены
- ✅ Все 4 шага (Setup, Composer, Executor, Applier) работают
- ✅ Coverage >85% для всех features

**Проверить перед началом:**
```bash
cd shotgun_flutter

# 1. Все features готовы
flutter test test/features/  # All passed

# 2. App работает на desktop
flutter run -d macos
# Manual: пройти полный workflow (Step 1-4)

# 3. Проверить integration tests
flutter test integration_test/  # All passed
```

---

## Шаги выполнения

### 1. Keyboard Shortcuts - Domain Layer

**Создать:** `lib/shared/domain/entities/keyboard_shortcut.dart`

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

enum ShortcutAction {
  openProject,
  nextStep,
  copyContext,
  copyPrompt,
  undo,
  redo,
  save,
  search,
}

class KeyboardShortcut extends Equatable {
  final ShortcutAction action;
  final LogicalKeyboardKey key;
  final bool control;
  final bool shift;
  final bool alt;
  final bool meta;

  const KeyboardShortcut({
    required this.action,
    required this.key,
    this.control = false,
    this.shift = false,
    this.alt = false,
    this.meta = false,
  });

  /// Check if this shortcut matches the current key event
  bool matches(RawKeyEvent event) {
    return event.logicalKey == key &&
        event.isControlPressed == control &&
        event.isShiftPressed == shift &&
        event.isAltPressed == alt &&
        event.isMetaPressed == meta;
  }

  /// Get platform-specific label (Cmd on macOS, Ctrl on others)
  String get label {
    final modifiers = <String>[];
    if (control) modifiers.add('Ctrl');
    if (shift) modifiers.add('Shift');
    if (alt) modifiers.add('Alt');
    if (meta) modifiers.add('Cmd');

    modifiers.add(key.keyLabel);
    return modifiers.join('+');
  }

  @override
  List<Object?> get props => [action, key, control, shift, alt, meta];
}

/// Default shortcuts for the app
class DefaultShortcuts {
  static List<KeyboardShortcut> get all {
    return [
      const KeyboardShortcut(
        action: ShortcutAction.openProject,
        key: LogicalKeyboardKey.keyO,
        meta: true, // Cmd on macOS
      ),
      const KeyboardShortcut(
        action: ShortcutAction.nextStep,
        key: LogicalKeyboardKey.enter,
        meta: true,
      ),
      const KeyboardShortcut(
        action: ShortcutAction.copyContext,
        key: LogicalKeyboardKey.keyC,
        meta: true,
        shift: true,
      ),
      const KeyboardShortcut(
        action: ShortcutAction.undo,
        key: LogicalKeyboardKey.keyZ,
        meta: true,
      ),
      const KeyboardShortcut(
        action: ShortcutAction.search,
        key: LogicalKeyboardKey.keyF,
        meta: true,
      ),
    ];
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
ls lib/shared/domain/entities/keyboard_shortcut.dart
flutter analyze  # 0 issues
```

**Тесты:**
```dart
// test/shared/domain/entities/keyboard_shortcut_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:shotgun_flutter/shared/domain/entities/keyboard_shortcut.dart';

void main() {
  group('KeyboardShortcut', () {
    test('should match key event correctly', () {
      const shortcut = KeyboardShortcut(
        action: ShortcutAction.openProject,
        key: LogicalKeyboardKey.keyO,
        meta: true,
      );

      final event = RawKeyEvent.fromMessage({
        'type': 'keydown',
        'keyCode': LogicalKeyboardKey.keyO.keyId,
        'metaState': RawKeyEventDataMacOs.modifierMeta,
      });

      // Test would verify matching logic
      expect(shortcut.key, LogicalKeyboardKey.keyO);
      expect(shortcut.meta, true);
    });

    test('should generate correct label', () {
      const shortcut = KeyboardShortcut(
        action: ShortcutAction.copyContext,
        key: LogicalKeyboardKey.keyC,
        meta: true,
        shift: true,
      );

      expect(shortcut.label, 'Cmd+Shift+C');
    });

    test('DefaultShortcuts should contain all actions', () {
      final shortcuts = DefaultShortcuts.all;

      expect(shortcuts, isNotEmpty);
      expect(shortcuts.length, greaterThanOrEqualTo(5));
    });
  });
}
```

**Запустить:**
```bash
flutter test test/shared/domain/entities/keyboard_shortcut_test.dart
# Должно быть: All tests passed!
```

---

### 2. Shortcuts Service

**Создать:** `lib/shared/services/keyboard_shortcut_service.dart`

```dart
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/keyboard_shortcut.dart';

final keyboardShortcutServiceProvider = Provider<KeyboardShortcutService>((ref) {
  return KeyboardShortcutService();
});

class KeyboardShortcutService {
  final List<KeyboardShortcut> _shortcuts = DefaultShortcuts.all;
  final Map<ShortcutAction, VoidCallback> _handlers = {};

  /// Register a handler for a specific action
  void registerHandler(ShortcutAction action, VoidCallback handler) {
    _handlers[action] = handler;
  }

  /// Unregister a handler
  void unregisterHandler(ShortcutAction action) {
    _handlers.remove(action);
  }

  /// Handle a key event
  bool handleKeyEvent(RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return false;

    for (final shortcut in _shortcuts) {
      if (shortcut.matches(event)) {
        final handler = _handlers[shortcut.action];
        if (handler != null) {
          handler();
          return true; // Event consumed
        }
      }
    }

    return false; // Event not handled
  }

  /// Get all registered shortcuts
  List<KeyboardShortcut> get shortcuts => List.unmodifiable(_shortcuts);

  /// Get label for action
  String? getLabelForAction(ShortcutAction action) {
    final shortcut = _shortcuts.firstWhere(
      (s) => s.action == action,
      orElse: () => throw Exception('Shortcut not found'),
    );
    return shortcut.label;
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
ls lib/shared/services/keyboard_shortcut_service.dart
flutter analyze  # 0 issues
flutter test test/shared/services/keyboard_shortcut_service_test.dart  # All passed
```

**Тесты:**
```dart
// test/shared/services/keyboard_shortcut_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/shared/services/keyboard_shortcut_service.dart';
import 'package:shotgun_flutter/shared/domain/entities/keyboard_shortcut.dart';

void main() {
  late KeyboardShortcutService service;

  setUp(() {
    service = KeyboardShortcutService();
  });

  group('KeyboardShortcutService', () {
    test('should register and call handler', () {
      var called = false;

      service.registerHandler(ShortcutAction.openProject, () {
        called = true;
      });

      expect(called, false);

      // Simulate key event (mock implementation)
      // In real test, would use RawKeyEvent

      expect(service.shortcuts, isNotEmpty);
    });

    test('should unregister handler', () {
      service.registerHandler(ShortcutAction.openProject, () {});
      service.unregisterHandler(ShortcutAction.openProject);

      // Handler should no longer be called
    });

    test('should get label for action', () {
      final label = service.getLabelForAction(ShortcutAction.openProject);

      expect(label, isNotNull);
      expect(label, contains('O'));
    });
  });
}
```

---

### 3. Global Shortcuts Widget

**Создать:** `lib/shared/widgets/global_shortcuts_wrapper.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/keyboard_shortcut_service.dart';

class GlobalShortcutsWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalShortcutsWrapper({
    required this.child,
    super.key,
  });

  @override
  ConsumerState<GlobalShortcutsWrapper> createState() =>
      _GlobalShortcutsWrapperState();
}

class _GlobalShortcutsWrapperState
    extends ConsumerState<GlobalShortcutsWrapper> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortcutService = ref.watch(keyboardShortcutServiceProvider);

    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (event) {
        final handled = shortcutService.handleKeyEvent(event);
        if (handled) {
          // Prevent default behavior
        }
      },
      child: widget.child,
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
ls lib/shared/widgets/global_shortcuts_wrapper.dart
flutter analyze  # 0 issues
flutter test test/shared/widgets/global_shortcuts_wrapper_test.dart  # All passed
```

**Widget Test:**
```dart
// test/shared/widgets/global_shortcuts_wrapper_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shotgun_flutter/shared/widgets/global_shortcuts_wrapper.dart';

void main() {
  testWidgets('GlobalShortcutsWrapper should wrap child', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: GlobalShortcutsWrapper(
            child: Text('Test'),
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('GlobalShortcutsWrapper should handle key events', (tester) async {
    // Test shortcut handling
    // Would require mocking RawKeyEvent
  });
}
```

---

### 4. Integrate Shortcuts in Main App

**Обновить:** `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'shared/widgets/global_shortcuts_wrapper.dart';
import 'shared/services/keyboard_shortcut_service.dart';
import 'shared/domain/entities/keyboard_shortcut.dart';

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
        // Your routes
      ],
    );
  }

  void _registerShortcuts() {
    final service = ref.read(keyboardShortcutServiceProvider);

    // Register handlers
    service.registerHandler(ShortcutAction.openProject, () {
      // Navigate to project setup or open dialog
      _router.go('/project-setup');
    });

    service.registerHandler(ShortcutAction.nextStep, () {
      // Navigate to next step
      // Logic based on current route
    });

    service.registerHandler(ShortcutAction.copyContext, () {
      // Copy context to clipboard
      // Access current state and copy
    });
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
      ),
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter analyze  # 0 issues
flutter run -d macos
# Manual: нажать Cmd+O → должен открыть project setup
# Manual: нажать Cmd+Enter → должен перейти на следующий шаг
```

---

### 5. Menu Bar (macOS/Windows)

**Создать:** `lib/shared/widgets/app_menu_bar.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class AppMenuBar extends StatelessWidget {
  final VoidCallback onOpenProject;
  final VoidCallback onSettings;
  final VoidCallback onAbout;

  const AppMenuBar({
    required this.onOpenProject,
    required this.onSettings,
    required this.onAbout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Only show menu bar on desktop platforms
    if (!Platform.isMacOS && !Platform.isWindows && !Platform.isLinux) {
      return const SizedBox.shrink();
    }

    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: 'File',
          menus: [
            PlatformMenuItem(
              label: 'Open Project...',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyO,
                meta: true,
              ),
              onSelected: onOpenProject,
            ),
            const PlatformMenuItemGroup(
              members: [
                PlatformMenuItem(
                  label: 'Settings',
                  shortcut: SingleActivator(
                    LogicalKeyboardKey.comma,
                    meta: true,
                  ),
                ),
              ],
            ),
            if (Platform.isMacOS)
              const PlatformMenuItem(
                label: 'Quit',
                shortcut: SingleActivator(
                  LogicalKeyboardKey.keyQ,
                  meta: true,
                ),
              ),
          ],
        ),
        PlatformMenu(
          label: 'Edit',
          menus: [
            PlatformMenuItem(
              label: 'Undo',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyZ,
                meta: true,
              ),
              onSelected: () {
                // Undo logic
              },
            ),
            PlatformMenuItem(
              label: 'Redo',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyZ,
                meta: true,
                shift: true,
              ),
              onSelected: () {
                // Redo logic
              },
            ),
          ],
        ),
        PlatformMenu(
          label: 'Help',
          menus: [
            PlatformMenuItem(
              label: 'About Shotgun Code',
              onSelected: onAbout,
            ),
          ],
        ),
      ],
    );
  }
}
```

**Интегрировать в main.dart:**
```dart
@override
Widget build(BuildContext context) {
  return GlobalShortcutsWrapper(
    child: MaterialApp.router(
      title: 'Shotgun Code',
      routerConfig: _router,
      // Add menu bar
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
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d macos
# Manual: проверить что меню отображается в top bar
# Manual: File → Open Project работает
# Manual: Edit → Undo/Redo присутствуют
# Manual: Help → About открывает диалог
```

---

### 6. Settings Screen

**Создать:** `lib/features/settings/presentation/screens/settings_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme setting
          ListTile(
            title: const Text('Theme'),
            subtitle: const Text('Light, Dark, or System'),
            trailing: DropdownButton<ThemeMode>(
              value: ThemeMode.system,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
              ],
              onChanged: (value) {
                // Update theme
              },
            ),
          ),

          const Divider(),

          // Default LLM provider
          ListTile(
            title: const Text('Default LLM Provider'),
            subtitle: const Text('Gemini, OpenAI, or Claude'),
            trailing: DropdownButton<String>(
              value: 'gemini',
              items: const [
                DropdownMenuItem(value: 'gemini', child: Text('Gemini')),
                DropdownMenuItem(value: 'openai', child: Text('OpenAI')),
                DropdownMenuItem(value: 'claude', child: Text('Claude')),
              ],
              onChanged: (value) {
                // Update provider
              },
            ),
          ),

          const Divider(),

          // Font size
          ListTile(
            title: const Text('Font Size'),
            subtitle: Slider(
              value: 14,
              min: 10,
              max: 20,
              divisions: 10,
              label: '14',
              onChanged: (value) {
                // Update font size
              },
            ),
          ),

          const Divider(),

          // Auto-save
          SwitchListTile(
            title: const Text('Auto-save preferences'),
            subtitle: const Text('Automatically save settings'),
            value: true,
            onChanged: (value) {
              // Toggle auto-save
            },
          ),
        ],
      ),
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
ls lib/features/settings/presentation/screens/settings_screen.dart
flutter analyze  # 0 issues
flutter run -d macos
# Manual: открыть settings через menu или Cmd+,
# Manual: изменить theme → проверить что применяется
# Manual: изменить font size → проверить что применяется
```

**Widget Test:**
```dart
// test/features/settings/presentation/screens/settings_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shotgun_flutter/features/settings/presentation/screens/settings_screen.dart';

void main() {
  testWidgets('SettingsScreen should display all settings', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Default LLM Provider'), findsOneWidget);
    expect(find.text('Font Size'), findsOneWidget);
    expect(find.text('Auto-save preferences'), findsOneWidget);
  });
}
```

---

### 7. Search in File Tree

**Обновить:** `lib/features/project_setup/presentation/widgets/file_tree_widget.dart`

Добавить поиск:

```dart
class FileTreeWidget extends ConsumerStatefulWidget {
  final List<FileNode> nodes;
  final Function(FileNode) onToggle;

  const FileTreeWidget({
    required this.nodes,
    required this.onToggle,
    super.key,
  });

  @override
  ConsumerState<FileTreeWidget> createState() => _FileTreeWidgetState();
}

class _FileTreeWidgetState extends ConsumerState<FileTreeWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FileNode> _filterNodes(List<FileNode> nodes, String query) {
    if (query.isEmpty) return nodes;

    return nodes.where((node) {
      final matchesName = node.name.toLowerCase().contains(query.toLowerCase());
      final hasMatchingChildren = node.children != null &&
          _filterNodes(node.children!, query).isNotEmpty;

      return matchesName || hasMatchingChildren;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredNodes = _filterNodes(widget.nodes, _searchQuery);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search files... (Cmd+F)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),

        // File tree
        Expanded(
          child: ListView.builder(
            itemCount: filteredNodes.length,
            itemBuilder: (context, index) {
              return _buildFileNode(filteredNodes[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFileNode(FileNode node) {
    // Existing implementation...
    return ListTile(
      title: Text(node.name),
      // ...
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter analyze  # 0 issues
flutter run -d macos
# Manual: нажать Cmd+F в file tree
# Manual: ввести "test" → должны отфильтроваться файлы
# Manual: нажать X → должны вернуться все файлы
```

**Widget Test:**
```dart
testWidgets('FileTreeWidget should filter nodes on search', (tester) async {
  final nodes = [
    FileNode(name: 'test.dart', path: '/test.dart', ...),
    FileNode(name: 'main.dart', path: '/main.dart', ...),
  ];

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: FileTreeWidget(
            nodes: nodes,
            onToggle: (_) {},
          ),
        ),
      ),
    ),
  );

  // Enter search query
  await tester.enterText(find.byType(TextField), 'test');
  await tester.pump();

  // Should show only test.dart
  expect(find.text('test.dart'), findsOneWidget);
  expect(find.text('main.dart'), findsNothing);
});
```

---

### 8. Recent Projects List

**Создать:** `lib/features/project_setup/data/datasources/recent_projects_datasource.dart`

```dart
import 'package:shared_preferences/shared_preferences.dart';

class RecentProjectsDataSource {
  static const String _key = 'recent_projects';
  static const int _maxRecent = 10;

  final SharedPreferences prefs;

  RecentProjectsDataSource({required this.prefs});

  /// Get list of recent project paths
  List<String> getRecentProjects() {
    return prefs.getStringList(_key) ?? [];
  }

  /// Add a project to recent list
  Future<void> addRecentProject(String path) async {
    final recent = getRecentProjects();

    // Remove if already exists
    recent.remove(path);

    // Add to beginning
    recent.insert(0, path);

    // Keep only last N projects
    if (recent.length > _maxRecent) {
      recent.removeRange(_maxRecent, recent.length);
    }

    await prefs.setStringList(_key, recent);
  }

  /// Clear all recent projects
  Future<void> clearRecentProjects() async {
    await prefs.remove(_key);
  }
}
```

**Обновить:** `lib/features/project_setup/presentation/screens/project_setup_screen.dart`

```dart
class ProjectSetupScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentProjects = ref.watch(recentProjectsProvider);

    return Scaffold(
      body: Column(
        children: [
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
                      onTap: () {
                        ref.read(projectProvider.notifier).loadProject(path);
                      },
                    );
                  }),
                ],
              ),
            ),

          // Open project button
          ElevatedButton.icon(
            icon: const Icon(Icons.folder_open),
            label: const Text('Open Project'),
            onPressed: () => _pickFolder(ref),
          ),
        ],
      ),
    );
  }

  String _getProjectName(String path) {
    return path.split('/').last;
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d macos
# Manual: открыть проект A → закрыть app → открыть app
# Manual: проверить что проект A в Recent Projects
# Manual: открыть проект из Recent → должен загрузиться
```

---

### 9. Drag and Drop for Folder Selection

**Обновить:** `lib/features/project_setup/presentation/screens/project_setup_screen.dart`

```dart
import 'package:desktop_drop/desktop_drop.dart';

class ProjectSetupScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ProjectSetupScreen> createState() => _ProjectSetupScreenState();
}

class _ProjectSetupScreenState extends ConsumerState<ProjectSetupScreen> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Load project from dropped folder
            ref.read(projectProvider.notifier).loadProject(file.path);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: _dragging
                ? Border.all(color: Colors.blue, width: 2)
                : null,
            color: _dragging ? Colors.blue.withOpacity(0.1) : null,
          ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Добавить в pubspec.yaml:**
```yaml
dependencies:
  desktop_drop: ^0.4.0
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter pub get
flutter run -d macos
# Manual: перетащить папку в окно app
# Manual: проверить что папка загружается
# Manual: проверить что border меняется при drag
```

---

### 10. Performance Optimization

**Создать:** `test/performance/file_tree_performance_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/project_setup/domain/entities/file_node.dart';
import 'package:shotgun_flutter/features/project_setup/presentation/widgets/file_tree_widget.dart';

void main() {
  group('FileTree Performance', () {
    test('should render 10000 nodes in < 1 second', () async {
      final stopwatch = Stopwatch()..start();

      // Generate 10k nodes
      final nodes = List.generate(10000, (i) {
        return FileNode(
          name: 'file_$i.dart',
          path: '/path/file_$i.dart',
          relPath: 'file_$i.dart',
          isDir: false,
          isGitignored: false,
          isCustomIgnored: false,
        );
      });

      // Render
      final widget = FileTreeWidget(nodes: nodes, onToggle: (_) {});

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}
```

**Оптимизации:**

1. **Virtual scrolling** для file tree (использовать `ListView.builder`)
2. **Memoization** для тяжелых вычислений
3. **Debounce** для search input
4. **Lazy loading** для nested folders

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter test test/performance/  # All passed
flutter run --profile -d macos
# Manual: открыть проект с 10k+ файлами
# Manual: проверить что UI не тормозит
# Manual: scroll должен быть плавным (60fps)
```

---

## Критерии приемки Phase 6

### Обязательные

- ✅ Все keyboard shortcuts работают
- ✅ Menu bar отображается на macOS/Windows
- ✅ Settings screen работает, сохраняет настройки
- ✅ Search в file tree работает
- ✅ Recent projects list работает
- ✅ Drag and drop работает
- ✅ Performance: 10k+ файлов без лагов
- ✅ Все тесты проходят (unit/widget/performance)
- ✅ Coverage >85%
- ✅ flutter analyze = 0 issues

### Опциональные

- ⭐ Context menu (right-click) в file tree
- ⭐ Keyboard navigation в file tree (arrows)
- ⭐ Export context as file (.txt/.md)
- ⭐ Accessibility (screen reader support)

---

## Manual Testing Checklist

```
Desktop Shortcuts:
[ ] Cmd+O / Ctrl+O открывает project selection
[ ] Cmd+Enter переходит на next step
[ ] Cmd+Shift+C копирует context
[ ] Cmd+Z undo работает
[ ] Cmd+F фокусирует search

Menu Bar (macOS):
[ ] File → Open Project работает
[ ] File → Settings открывает settings
[ ] Edit → Undo/Redo присутствуют
[ ] Help → About показывает диалог

Settings:
[ ] Theme меняется (Light/Dark/System)
[ ] Default LLM provider сохраняется
[ ] Font size применяется к UI
[ ] Auto-save работает

Search:
[ ] Cmd+F в file tree открывает search
[ ] Ввод текста фильтрует файлы
[ ] Clear button очищает search
[ ] Результаты обновляются instantly

Recent Projects:
[ ] Недавние проекты показываются при запуске
[ ] Клик на recent project загружает его
[ ] Максимум 10 recent projects

Drag and Drop:
[ ] Перетаскивание папки работает
[ ] Border меняется при drag over
[ ] Drop загружает проект

Performance:
[ ] Проект с 10k+ файлами загружается < 5 сек
[ ] Scroll плавный (60fps)
[ ] Search не тормозит
[ ] Memory usage < 300MB для 10k файлов
```

---

## Потенциальные проблемы

### 1. Shortcuts не работают на Windows
**Решение:**
- Использовать `control: true` вместо `meta: true` для Windows/Linux
- Platform-specific логика:
```dart
final isMacOS = Platform.isMacOS;
final modifierKey = isMacOS ? LogicalKeyboardKey.meta : LogicalKeyboardKey.control;
```

### 2. Menu bar не отображается на Linux
**Решение:**
- `PlatformMenuBar` работает только на macOS/Windows
- Для Linux использовать custom app bar

### 3. Drag and drop не работает в debug mode
**Решение:**
- Тестировать в profile/release mode
- `flutter run --profile -d macos`

### 4. Performance issues с большими проектами
**Решение:**
- Использовать `ListView.builder` вместо `ListView`
- Lazy load children при expand folder
- Debounce search input (300ms)

### 5. Settings не сохраняются
**Решение:**
- Проверить что `SharedPreferences` инициализирован
- Добавить `await prefs.setString()` вместо синхронного вызова

---

## Checklist

```
[ ] 1. Keyboard Shortcuts - Domain Layer
[ ] 2. Shortcuts Service
[ ] 3. Global Shortcuts Widget
[ ] 4. Integrate in Main App
[ ] 5. Menu Bar (macOS/Windows)
[ ] 6. Settings Screen
[ ] 7. Search in File Tree
[ ] 8. Recent Projects List
[ ] 9. Drag and Drop
[ ] 10. Performance Optimization
[ ] ✅ Все критерии приемки выполнены
[ ] ✅ Manual testing checklist пройден
```

---

## Время выполнения

- Шаги 1-4: **3 дня** (Shortcuts infrastructure)
- Шаги 5-6: **2 дня** (Menu bar + Settings)
- Шаги 7-8: **2 дня** (Search + Recent projects)
- Шаг 9: **1 день** (Drag and drop)
- Шаг 10: **2 дня** (Performance)

**Итого: 10 рабочих дней (2 недели)**

---

## Следующая фаза

После завершения Phase 6, переходить к **Phase 7: Mobile Adaptation**.
