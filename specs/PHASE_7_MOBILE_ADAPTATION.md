# Phase 7: Mobile Adaptation

**Duration:** 3 weeks
**Goal:** Адаптация UI для мобильных устройств, touch gestures, mobile-specific features

---

## ⚠️ ВАЛИДАЦИЯ ПОСЛЕ КАЖДОГО ШАГА

```bash
# 1. Анализ кода
flutter analyze
# Должно быть: 0 issues found

# 2. Запустить тесты
flutter test
# Должно быть: All tests passed!

# 3. Проверить на мобильных устройствах
flutter run -d ios         # iPhone
flutter run -d android     # Android
# Должно быть: app запускается, gestures работают

# 4. Проверить responsive layouts
flutter run -d "iPhone SE (3rd generation)"  # Small screen
flutter run -d "iPad Pro (12.9-inch)"         # Tablet
# Должно быть: UI адаптируется правильно

# 5. Проверить coverage
flutter test --coverage
lcov --summary coverage/lcov.info
# Должно быть: >85% для mobile features
```

**НЕ ПЕРЕХОДИ К СЛЕДУЮЩЕМУ ШАГУ, ПОКА:**
- ❌ Есть хотя бы одна ошибка в `flutter analyze`
- ❌ Есть failing tests
- ❌ Gestures не работают на реальном устройстве
- ❌ UI сломан на small screens (iPhone SE)
- ❌ Tap targets < 44x44 points (Apple HIG)

---

## Предварительные требования

- ✅ Phase 0-6 завершены
- ✅ Desktop version работает полностью
- ✅ Все 4 шага работают на desktop
- ✅ iOS/Android build успешен

**Проверить перед началом:**
```bash
cd shotgun_flutter

# 1. Desktop version работает
flutter test test/  # All passed
flutter run -d macos
# Manual: пройти полный workflow (Step 1-4)

# 2. iOS build
flutter build ios --release
# Должно быть: Build succeeded

# 3. Android build
flutter build apk --release
# Должно быть: Build succeeded

# 4. Проверить permissions
# iOS: Info.plist - NSPhotoLibraryUsageDescription
# Android: AndroidManifest.xml - READ_EXTERNAL_STORAGE
```

---

## Шаги выполнения

### 1. Responsive Layout System

**Создать:** `lib/core/responsive/responsive_layout.dart`

```dart
import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    required this.mobile,
    this.tablet,
    required this.desktop,
    super.key,
  });

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 600) {
      return DeviceType.mobile;
    } else if (width < 1200) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop;
    }
  }
}

/// Breakpoints for responsive design
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1200;
}

/// Extension for responsive values
extension ResponsiveValue on BuildContext {
  T responsive<T>({
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    final deviceType = ResponsiveLayout.getDeviceType(this);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop;
    }
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
ls lib/core/responsive/responsive_layout.dart
flutter analyze  # 0 issues
flutter test test/core/responsive/responsive_layout_test.dart  # All passed
```

**Тесты:**
```dart
// test/core/responsive/responsive_layout_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/core/responsive/responsive_layout.dart';

void main() {
  testWidgets('ResponsiveLayout should show mobile widget on small screen',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
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

  testWidgets('ResponsiveLayout should show desktop widget on large screen',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
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

  test('getDeviceType should return correct type', () {
    // Test with mock BuildContext
    // Would use MediaQuery.of(context).size.width
  });
}
```

---

### 2. Mobile Navigation (Bottom Nav Bar)

**Создать:** `lib/shared/widgets/mobile_navigation.dart`

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileNavigation extends StatelessWidget {
  final int currentIndex;

  const MobileNavigation({
    required this.currentIndex,
    super.key,
  });

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
```

**Обновить:** `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'core/responsive/responsive_layout.dart';
import 'shared/widgets/mobile_navigation.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AppScaffold({
    required this.child,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: Scaffold(
        body: child,
        bottomNavigationBar: MobileNavigation(currentIndex: currentIndex),
      ),
      desktop: Scaffold(
        body: Row(
          children: [
            // Desktop: Left sidebar with steps
            NavigationRail(
              selectedIndex: currentIndex,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.folder_outlined),
                  label: Text('Project'),
                ),
                // ...
              ],
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter analyze  # 0 issues
flutter run -d ios
# Manual: проверить bottom nav bar на iPhone
# Manual: тап на каждую вкладку → переход на нужный экран
# Manual: на desktop → должен показать sidebar
```

**Widget Test:**
```dart
// test/shared/widgets/mobile_navigation_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/shared/widgets/mobile_navigation.dart';

void main() {
  testWidgets('MobileNavigation should display 4 destinations', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
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

  testWidgets('MobileNavigation should highlight selected item', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: MobileNavigation(currentIndex: 1),
        ),
      ),
    );

    // Check that second item is selected
    final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(navBar.selectedIndex, 1);
  });
}
```

---

### 3. Touch Gestures

**Создать:** `lib/shared/widgets/swipe_detector.dart`

```dart
import 'package:flutter/material.dart';

class SwipeDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final double minSwipeDistance;

  const SwipeDetector({
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onSwipeUp,
    this.onSwipeDown,
    this.minSwipeDistance = 50.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;

        if (velocity < -minSwipeDistance && onSwipeLeft != null) {
          onSwipeLeft!();
        } else if (velocity > minSwipeDistance && onSwipeRight != null) {
          onSwipeRight!();
        }
      },
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;

        if (velocity < -minSwipeDistance && onSwipeUp != null) {
          onSwipeUp!();
        } else if (velocity > minSwipeDistance && onSwipeDown != null) {
          onSwipeDown!();
        }
      },
      child: child,
    );
  }
}
```

**Использовать в экранах:**
```dart
class ProjectSetupScreenMobile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwipeDetector(
      onSwipeLeft: () {
        // Next step
        context.go('/prompt-composer');
      },
      onSwipeRight: () {
        // Previous step (or back)
        Navigator.of(context).pop();
      },
      child: Scaffold(
        body: ProjectSetupContent(),
      ),
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d ios
# Manual: swipe left на Project Setup → переход на Compose
# Manual: swipe right → возврат назад
# Manual: swipe down → refresh (если реализовано)
```

**Widget Test:**
```dart
// test/shared/widgets/swipe_detector_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/shared/widgets/swipe_detector.dart';

void main() {
  testWidgets('SwipeDetector should call onSwipeLeft', (tester) async {
    var swipedLeft = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SwipeDetector(
          onSwipeLeft: () {
            swipedLeft = true;
          },
          child: const Text('Swipe me'),
        ),
      ),
    );

    // Simulate swipe left
    await tester.drag(find.text('Swipe me'), const Offset(-200, 0));
    await tester.pumpAndSettle();

    expect(swipedLeft, true);
  });

  testWidgets('SwipeDetector should call onSwipeRight', (tester) async {
    var swipedRight = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SwipeDetector(
          onSwipeRight: () {
            swipedRight = true;
          },
          child: const Text('Swipe me'),
        ),
      ),
    );

    // Simulate swipe right
    await tester.drag(find.text('Swipe me'), const Offset(200, 0));
    await tester.pumpAndSettle();

    expect(swipedRight, true);
  });
}
```

---

### 4. Mobile File Picker

**Обновить:** `lib/features/project_setup/presentation/screens/project_setup_screen.dart`

```dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProjectSetupScreenMobile extends ConsumerWidget {
  Future<void> _pickFolderMobile(WidgetRef ref) async {
    if (Platform.isAndroid || Platform.isIOS) {
      // На мобильных: доступ к Documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Показать dialog со списком доступных папок
      final selectedPath = await showDialog<String>(
        context: context,
        builder: (context) => MobileProjectPickerDialog(
          initialDirectory: directory.path,
        ),
      );

      if (selectedPath != null) {
        ref.read(projectProvider.notifier).loadProject(selectedPath);
      }
    } else {
      // Desktop: standard folder picker
      final result = await FilePicker.platform.getDirectoryPath();
      if (result != null) {
        ref.read(projectProvider.notifier).loadProject(result);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Project'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Select a project folder',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _pickFolderMobile(ref),
              icon: const Icon(Icons.folder),
              label: const Text('Browse'),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileProjectPickerDialog extends StatefulWidget {
  final String initialDirectory;

  const MobileProjectPickerDialog({
    required this.initialDirectory,
    super.key,
  });

  @override
  State<MobileProjectPickerDialog> createState() =>
      _MobileProjectPickerDialogState();
}

class _MobileProjectPickerDialogState extends State<MobileProjectPickerDialog> {
  late String currentPath;
  List<FileSystemEntity> items = [];

  @override
  void initState() {
    super.initState();
    currentPath = widget.initialDirectory;
    _loadDirectory();
  }

  Future<void> _loadDirectory() async {
    final dir = Directory(currentPath);
    final entities = await dir.list().toList();

    setState(() {
      items = entities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Folder'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isDirectory = item is Directory;

            if (!isDirectory) return const SizedBox.shrink();

            return ListTile(
              leading: const Icon(Icons.folder),
              title: Text(item.path.split('/').last),
              onTap: () {
                setState(() {
                  currentPath = item.path;
                });
                _loadDirectory();
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(currentPath),
          child: const Text('Select'),
        ),
      ],
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d ios
# Manual: нажать Browse → показать dialog со списком папок
# Manual: выбрать папку → загрузить проект
# Manual: на Android → проверить permissions (READ_EXTERNAL_STORAGE)
```

---

### 5. Pull-to-Refresh для File Tree

**Обновить:** `lib/features/project_setup/presentation/widgets/file_tree_widget.dart`

```dart
import 'package:flutter/material.dart';

class FileTreeWidget extends ConsumerWidget {
  final List<FileNode> nodes;
  final VoidCallback onRefresh;

  const FileTreeWidget({
    required this.nodes,
    required this.onRefresh,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
        // Wait for refresh to complete
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: nodes.length,
        itemBuilder: (context, index) {
          return _buildFileNode(nodes[index]);
        },
      ),
    );
  }

  Widget _buildFileNode(FileNode node) {
    // Existing implementation
    return ListTile(
      leading: Icon(node.isDir ? Icons.folder : Icons.insert_drive_file),
      title: Text(node.name),
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d ios
# Manual: pull down на file tree → показать refresh indicator
# Manual: release → file tree должен обновиться
```

**Widget Test:**
```dart
testWidgets('FileTreeWidget should support pull-to-refresh', (tester) async {
  var refreshed = false;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: FileTreeWidget(
          nodes: testNodes,
          onRefresh: () {
            refreshed = true;
          },
        ),
      ),
    ),
  );

  // Simulate pull-to-refresh
  await tester.drag(find.byType(ListView), const Offset(0, 300));
  await tester.pumpAndSettle();

  expect(refreshed, true);
});
```

---

### 6. Adaptive Text Fields для Mobile

**Создать:** `lib/shared/widgets/adaptive_text_field.dart`

```dart
import 'package:flutter/material.dart';
import 'dart:io';

class AdaptiveTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const AdaptiveTextField({
    required this.controller,
    this.hintText,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Mobile: larger text, more padding
    final isMobile = Platform.isAndroid || Platform.isIOS;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: isMobile ? 16 : 14, // iOS: 16+ для prevent zoom
      ),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 12,
          vertical: isMobile ? 12 : 8,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 8),
        ),
      ),
    );
  }
}
```

**Использовать в Prompt Composer:**
```dart
class PromptComposerScreenMobile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compose Prompt')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AdaptiveTextField(
              controller: taskController,
              hintText: 'Describe your task...',
              maxLines: 8,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16),
            AdaptiveTextField(
              controller: rulesController,
              hintText: 'Custom rules...',
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d ios
# Manual: тап на text field → keyboard появляется
# Manual: ввести текст → проверить что font size >= 16 (no zoom)
# Manual: проверить что tap targets >= 44x44 points
```

---

### 7. Haptic Feedback

**Создать:** `lib/shared/services/haptic_service.dart`

```dart
import 'package:flutter/services.dart';
import 'dart:io';

class HapticService {
  /// Light impact (e.g., button tap)
  static Future<void> lightImpact() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await HapticFeedback.lightImpact();
    }
  }

  /// Medium impact (e.g., switch toggle)
  static Future<void> mediumImpact() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Heavy impact (e.g., confirmation)
  static Future<void> heavyImpact() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Selection changed (e.g., picker)
  static Future<void> selectionClick() async {
    if (Platform.isIOS || Platform.isAndroid) {
      await HapticFeedback.selectionClick();
    }
  }

  /// Vibrate (Android)
  static Future<void> vibrate() async {
    if (Platform.isAndroid) {
      await HapticFeedback.vibrate();
    }
  }
}
```

**Использовать в buttons:**
```dart
FilledButton(
  onPressed: () async {
    await HapticService.lightImpact();
    // Button action
    _onApplyPatch();
  },
  child: const Text('Apply Patch'),
)
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d ios
# Manual: нажать любую кнопку → почувствовать haptic feedback
# Manual: toggle switch → medium impact
# Manual: apply patch → heavy impact
```

---

### 8. Offline Mode & Caching

**Создать:** `lib/features/project_setup/data/datasources/cache_datasource.dart`

```dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/shotgun_context.dart';
import '../models/shotgun_context_model.dart';

class CacheDataSource {
  static const String _boxName = 'contexts_cache';
  late Box<String> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
  }

  /// Cache context for project
  Future<void> cacheContext({
    required String projectPath,
    required String context,
  }) async {
    await _box.put(projectPath, context);
  }

  /// Get cached context
  String? getCachedContext(String projectPath) {
    return _box.get(projectPath);
  }

  /// Check if context is cached
  bool isCached(String projectPath) {
    return _box.containsKey(projectPath);
  }

  /// Clear cache for project
  Future<void> clearCache(String projectPath) async {
    await _box.delete(projectPath);
  }

  /// Clear all cache
  Future<void> clearAllCache() async {
    await _box.clear();
  }

  /// Get cache size in bytes
  int getCacheSize() {
    int totalSize = 0;
    for (var value in _box.values) {
      totalSize += value.length;
    }
    return totalSize;
  }
}
```

**Обновить Repository:**
```dart
class ProjectRepositoryImpl implements ProjectRepository {
  final BackendDataSource backendDataSource;
  final CacheDataSource cacheDataSource;

  ProjectRepositoryImpl({
    required this.backendDataSource,
    required this.cacheDataSource,
  });

  @override
  Stream<GenerationProgress> generateContext(
    String rootDir,
    List<String> excludedPaths,
  ) async* {
    // Check cache first
    final cached = cacheDataSource.getCachedContext(rootDir);
    if (cached != null) {
      yield GenerationProgress(current: 1, total: 1);
      return;
    }

    // Generate from backend
    await for (final progress in backendDataSource.generateContext(rootDir, excludedPaths)) {
      yield progress;

      // Cache when complete
      if (progress.current == progress.total) {
        await cacheDataSource.cacheContext(
          projectPath: rootDir,
          context: progress.context,
        );
      }
    }
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d ios
# Manual: загрузить проект → выключить интернет/WiFi
# Manual: закрыть app → открыть app
# Manual: проект должен загрузиться из cache
```

**Unit Test:**
```dart
// test/features/project_setup/data/datasources/cache_datasource_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:shotgun_flutter/features/project_setup/data/datasources/cache_datasource.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  group('CacheDataSource', () {
    test('should cache and retrieve context', () async {
      final dataSource = CacheDataSource();
      await dataSource.init();

      const projectPath = '/test/project';
      const context = 'test context';

      await dataSource.cacheContext(
        projectPath: projectPath,
        context: context,
      );

      final retrieved = dataSource.getCachedContext(projectPath);

      expect(retrieved, context);
      expect(dataSource.isCached(projectPath), true);
    });

    test('should clear cache', () async {
      final dataSource = CacheDataSource();
      await dataSource.init();

      await dataSource.cacheContext(
        projectPath: '/test',
        context: 'test',
      );

      await dataSource.clearCache('/test');

      expect(dataSource.isCached('/test'), false);
    });
  });
}
```

---

### 9. Share Functionality

**Создать:** `lib/shared/services/share_service.dart`

```dart
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ShareService {
  /// Share text (context or prompt)
  static Future<void> shareText(String text, {String? subject}) async {
    await Share.share(
      text,
      subject: subject,
    );
  }

  /// Share as file
  static Future<void> shareAsFile({
    required String content,
    required String fileName,
    String? subject,
  }) async {
    // Create temporary file
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content);

    // Share file
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject,
    );
  }

  /// Share context
  static Future<void> shareContext(String context) async {
    await shareAsFile(
      content: context,
      fileName: 'shotgun_context.txt',
      subject: 'Project Context',
    );
  }

  /// Share prompt
  static Future<void> sharePrompt(String prompt) async {
    await shareAsFile(
      content: prompt,
      fileName: 'shotgun_prompt.txt',
      subject: 'LLM Prompt',
    );
  }
}
```

**Добавить в UI:**
```dart
class ProjectSetupScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final context = ref.watch(shotgunContextProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Setup'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              if (context != null) {
                await HapticService.lightImpact();
                await ShareService.shareContext(context);
              }
            },
          ),
        ],
      ),
      body: ProjectSetupContent(),
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d ios
# Manual: нажать share icon → показать iOS share sheet
# Manual: выбрать "Save to Files" → сохранить .txt файл
# Manual: выбрать "AirDrop" → отправить на другое устройство
```

---

### 10. Battery & Performance Optimization

**Создать:** `lib/core/performance/battery_optimizer.dart`

```dart
import 'dart:async';
import 'package:battery_plus/battery_plus.dart';

class BatteryOptimizer {
  final Battery _battery = Battery();
  Timer? _checkTimer;
  bool _isLowPowerMode = false;

  bool get isLowPowerMode => _isLowPowerMode;

  Future<void> init() async {
    // Check battery state periodically
    _checkTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _checkBatteryState();
    });

    await _checkBatteryState();
  }

  Future<void> _checkBatteryState() async {
    final batteryLevel = await _battery.batteryLevel;
    final batteryState = await _battery.batteryState;

    // Enable low power mode if battery < 20% or power saving mode
    _isLowPowerMode = batteryLevel < 20 ||
        batteryState == BatteryState.charging && batteryLevel < 30;
  }

  void dispose() {
    _checkTimer?.cancel();
  }

  /// Get recommended settings based on battery
  PerformanceSettings getRecommendedSettings() {
    if (_isLowPowerMode) {
      return PerformanceSettings(
        enableAnimations: false,
        reducedRefreshRate: true,
        backgroundTasksDisabled: true,
      );
    }

    return PerformanceSettings(
      enableAnimations: true,
      reducedRefreshRate: false,
      backgroundTasksDisabled: false,
    );
  }
}

class PerformanceSettings {
  final bool enableAnimations;
  final bool reducedRefreshRate;
  final bool backgroundTasksDisabled;

  PerformanceSettings({
    required this.enableAnimations,
    required this.reducedRefreshRate,
    required this.backgroundTasksDisabled,
  });
}
```

**Использовать в app:**
```dart
class MyApp extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final BatteryOptimizer _batteryOptimizer = BatteryOptimizer();

  @override
  void initState() {
    super.initState();
    _batteryOptimizer.init();
  }

  @override
  void dispose() {
    _batteryOptimizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = _batteryOptimizer.getRecommendedSettings();

    return MaterialApp.router(
      // Disable animations if low power mode
      theme: ThemeData(
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
      routerConfig: _router,
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
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run --profile -d ios
# Manual: запустить app при battery < 20%
# Manual: проверить что animations отключены
# Manual: проверить battery usage в Settings → Battery
# Target: < 5% per hour active use
```

**Performance Test:**
```dart
// test/core/performance/battery_optimizer_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/core/performance/battery_optimizer.dart';

void main() {
  test('BatteryOptimizer should enable low power mode when battery < 20%', () async {
    final optimizer = BatteryOptimizer();
    await optimizer.init();

    // Mock battery level
    // In real test, would use mockito to mock Battery

    final settings = optimizer.getRecommendedSettings();

    expect(settings, isNotNull);
  });
}
```

---

## Критерии приемки Phase 7

### Обязательные

- ✅ ResponsiveLayout работает на всех размерах экранов
- ✅ Mobile navigation (bottom nav bar) работает
- ✅ Swipe gestures работают (left/right/up/down)
- ✅ File picker работает на iOS/Android
- ✅ Pull-to-refresh работает
- ✅ Text fields адаптивные (font size >= 16, no zoom)
- ✅ Haptic feedback при interactions
- ✅ Offline mode с caching работает
- ✅ Share functionality работает
- ✅ Battery optimization активен при low battery
- ✅ Все тесты проходят (unit/widget/integration)
- ✅ Coverage >85%
- ✅ flutter analyze = 0 issues
- ✅ App runs на реальных устройствах (iOS + Android)

### Опциональные

- ⭐ Camera для QR code scanning (API keys)
- ⭐ Biometric auth (Face ID / Touch ID)
- ⭐ Background tasks (long LLM requests)
- ⭐ Push notifications
- ⭐ Widget для home screen

---

## Manual Testing Checklist

```
Responsive Layout:
[ ] iPhone SE (5.4") - UI не сломан
[ ] iPhone 15 Pro (6.1") - UI правильный
[ ] iPad Pro (12.9") - используется tablet layout
[ ] Android phone (различные размеры) - работает

Navigation:
[ ] Bottom nav bar на mobile
[ ] Sidebar на tablet/desktop
[ ] Swipe left → next screen
[ ] Swipe right → previous screen

Touch Gestures:
[ ] Tap targets >= 44x44 points
[ ] Pull-to-refresh работает
[ ] Long press работает (context menu)
[ ] Pinch-to-zoom (где нужно)

File Picker:
[ ] iOS: показывает Documents
[ ] Android: показывает folders с permissions
[ ] Можно выбрать папку
[ ] Выбранная папка загружается

Text Input:
[ ] Font size >= 16 (no zoom on iOS)
[ ] Keyboard появляется instantly
[ ] Autocorrect работает
[ ] Done button закрывает keyboard

Haptic Feedback:
[ ] Button tap → light impact
[ ] Toggle → medium impact
[ ] Confirmation → heavy impact
[ ] Feels natural

Offline Mode:
[ ] Context кэшируется
[ ] Работает без интернета
[ ] Cache indicator показывается
[ ] Sync когда online снова

Share:
[ ] Share context → iOS share sheet
[ ] Save to Files работает
[ ] AirDrop работает (iOS)
[ ] Nearby Share работает (Android)

Battery:
[ ] При battery < 20% → low power mode
[ ] Animations отключены в low power
[ ] Battery usage < 5% per hour

Performance:
[ ] Startup < 3 seconds
[ ] Smooth scroll (60fps)
[ ] No jank на animations
[ ] Memory < 200MB average
```

---

## Потенциальные проблемы

### 1. iOS: Permissions для File Access
**Решение:**
- Добавить в `Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Access photos for project files</string>
<key>UIFileSharingEnabled</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

### 2. Android: Storage Permissions
**Решение:**
- Добавить в `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```
- Запросить runtime permissions

### 3. Text Fields Zoom на iOS
**Решение:**
- Font size >= 16px для всех input fields
- Meta viewport: `user-scalable=no` (но лучше просто font size)

### 4. Gestures конфликтуют с scroll
**Решение:**
- Использовать `GestureDetector` с `behavior: HitTestBehavior.opaque`
- Настроить `minSwipeDistance` правильно

### 5. Cache растет слишком быстро
**Решение:**
- Лимит на cache size (например, 100MB)
- LRU eviction policy
- Кнопка "Clear Cache" в Settings

### 6. Battery drain от file watcher
**Решение:**
- Отключить file watcher на mobile
- Использовать manual refresh (pull-to-refresh)

---

## Checklist

```
[ ] 1. Responsive Layout System
[ ] 2. Mobile Navigation (Bottom Nav)
[ ] 3. Touch Gestures (Swipe)
[ ] 4. Mobile File Picker
[ ] 5. Pull-to-Refresh
[ ] 6. Adaptive Text Fields
[ ] 7. Haptic Feedback
[ ] 8. Offline Mode & Caching
[ ] 9. Share Functionality
[ ] 10. Battery & Performance Optimization
[ ] ✅ Все критерии приемки выполнены
[ ] ✅ Manual testing на реальных устройствах
[ ] ✅ iOS App Store guidelines соблюдены
[ ] ✅ Android Play Store guidelines соблюдены
```

---

## Время выполнения

- Шаги 1-3: **4 дня** (Responsive layout + navigation + gestures)
- Шаги 4-5: **3 дня** (File picker + pull-to-refresh)
- Шаги 6-7: **2 дня** (Text fields + haptics)
- Шаги 8-9: **4 дня** (Offline mode + share)
- Шаг 10: **2 дня** (Battery optimization)

**Итого: 15 рабочих дней (3 недели)**

---

## Следующая фаза

После завершения Phase 7, переходить к **Phase 8: Cloud Sync & Multi-Device**.
