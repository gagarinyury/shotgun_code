# Phase 9: Advanced Features & Optimization

**Duration:** 2 weeks
**Goal:** Power-user features, performance optimization, monitoring

---

## ⚠️ ВАЛИДАЦИЯ ПОСЛЕ КАЖДОГО ШАГА

```bash
# 1. Анализ кода
flutter analyze
# Должно быть: 0 issues found

# 2. Запустить тесты
flutter test
# Должно быть: All tests passed!

# 3. Performance profiling
flutter run --profile -d macos
# DevTools → Performance → проверить 60fps

# 4. Memory profiling
flutter run --profile -d macos
# DevTools → Memory → проверить < 300MB

# 5. Проверить coverage
flutter test --coverage
lcov --summary coverage/lcov.info
# Должно быть: >85%
```

**НЕ ПЕРЕХОДИ К СЛЕДУЮЩЕМУ ШАГУ, ПОКА:**
- ❌ Есть хотя бы одна ошибка в `flutter analyze`
- ❌ Есть failing tests
- ❌ Performance < 60fps
- ❌ Memory leaks обнаружены
- ❌ Startup time > 3 seconds

---

## Предварительные требования

- ✅ Phase 0-8 завершены
- ✅ App работает на всех платформах
- ✅ All features функциональны

**Проверить перед началом:**
```bash
cd shotgun_flutter

# 1. Все фичи работают
flutter run -d macos
# Manual: пройти полный workflow

# 2. Performance baseline
flutter run --profile -d macos
# Record: startup time, fps, memory usage

# 3. Тесты проходят
flutter test test/  # All passed
flutter test --coverage
# Coverage >= 85%
```

---

## Шаги выполнения

### 1. Custom LLM Endpoints

**Создать:** `lib/features/llm_executor/domain/entities/custom_llm_endpoint.dart`

```dart
import 'package:equatable/equatable.dart';

class CustomLLMEndpoint extends Equatable {
  final String id;
  final String name;
  final String baseUrl;
  final String? apiKey;
  final Map<String, String>? headers;
  final String modelName;

  const CustomLLMEndpoint({
    required this.id,
    required this.name,
    required this.baseUrl,
    this.apiKey,
    this.headers,
    required this.modelName,
  });

  @override
  List<Object?> get props => [id, name, baseUrl, apiKey, headers, modelName];
}
```

**Создать:** `lib/features/llm_executor/data/datasources/custom_llm_datasource.dart`

```dart
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/custom_llm_endpoint.dart';

class CustomLLMDataSource {
  final Dio _dio;

  CustomLLMDataSource({Dio? dio}) : _dio = dio ?? Dio();

  Stream<String> generateDiff({
    required String prompt,
    required CustomLLMEndpoint endpoint,
  }) async* {
    try {
      final response = await _dio.post(
        '${endpoint.baseUrl}/v1/chat/completions',
        data: {
          'model': endpoint.modelName,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'stream': true,
          'temperature': 0.1,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${endpoint.apiKey}',
            'Content-Type': 'application/json',
            ...?endpoint.headers,
          },
          responseType: ResponseType.stream,
        ),
      );

      // Parse SSE stream
      await for (final chunk in response.data.stream) {
        final String line = String.fromCharCodes(chunk);

        if (line.startsWith('data: ')) {
          final jsonStr = line.substring(6).trim();

          if (jsonStr == '[DONE]') break;

          final json = jsonDecode(jsonStr);
          final content = json['choices']?[0]?['delta']?['content'];

          if (content != null) {
            yield content;
          }
        }
      }
    } catch (e) {
      throw ServerException('Custom LLM request failed: $e');
    }
  }
}
```

**UI для добавления endpoint:**
```dart
class AddCustomEndpointDialog extends StatefulWidget {
  @override
  State<AddCustomEndpointDialog> createState() =>
      _AddCustomEndpointDialogState();
}

class _AddCustomEndpointDialogState extends State<AddCustomEndpointDialog> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _modelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Custom LLM Endpoint'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'My Local LLM',
              ),
            ),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Base URL',
                hintText: 'http://localhost:8000',
              ),
            ),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API Key (optional)',
              ),
              obscureText: true,
            ),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model Name',
                hintText: 'llama-3-70b',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final endpoint = CustomLLMEndpoint(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: _nameController.text,
              baseUrl: _urlController.text,
              apiKey: _apiKeyController.text.isEmpty
                  ? null
                  : _apiKeyController.text,
              modelName: _modelController.text,
            );

            Navigator.of(context).pop(endpoint);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d macos
# Manual: Settings → Add Custom Endpoint
# Manual: ввести localhost:8000 → сохранить
# Manual: LLM Executor → выбрать custom endpoint → работает
```

---

### 2. Batch Processing

**Создать:** `lib/features/batch_processing/domain/entities/batch_job.dart`

```dart
import 'package:equatable/equatable.dart';

enum BatchJobStatus {
  pending,
  processing,
  completed,
  failed,
}

class BatchJob extends Equatable {
  final String id;
  final List<String> projectPaths;
  final String task;
  final BatchJobStatus status;
  final int processed;
  final int total;
  final DateTime createdAt;
  final DateTime? completedAt;

  const BatchJob({
    required this.id,
    required this.projectPaths,
    required this.task,
    required this.status,
    this.processed = 0,
    required this.total,
    required this.createdAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        projectPaths,
        task,
        status,
        processed,
        total,
        createdAt,
        completedAt,
      ];
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
# Manual: создать batch job для 5 проектов
# Manual: проверить progress (1/5, 2/5, etc)
# Manual: все 5 проектов обработаны
```

---

### 3. Plugin System

**Создать:** `lib/core/plugins/plugin_interface.dart`

```dart
abstract class ShotgunPlugin {
  String get name;
  String get version;
  String get description;

  /// Process context before LLM call
  Future<String> preprocessContext(String context);

  /// Process diff after LLM response
  Future<String> postprocessDiff(String diff);

  /// Custom UI widget (optional)
  Widget? getConfigWidget();
}
```

**Example plugin:**
```dart
class CodeFormatterPlugin implements ShotgunPlugin {
  @override
  String get name => 'Code Formatter';

  @override
  String get version => '1.0.0';

  @override
  String get description => 'Format code before sending to LLM';

  @override
  Future<String> preprocessContext(String context) async {
    // Format code
    return context; // formatted
  }

  @override
  Future<String> postprocessDiff(String diff) async {
    return diff; // formatted
  }

  @override
  Widget? getConfigWidget() {
    return CheckboxListTile(
      title: const Text('Format code'),
      value: true,
      onChanged: (value) {},
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
# Manual: загрузить plugin
# Manual: plugin обрабатывает context
# Manual: config UI показывается
```

---

### 4. Performance Optimization - Virtual Scrolling

**Обновить:** `lib/features/project_setup/presentation/widgets/file_tree_widget.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileTreeWidget extends ConsumerWidget {
  final List<FileNode> nodes;

  const FileTreeWidget({required this.nodes, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use ListView.builder for virtual scrolling
    return ListView.builder(
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        return _buildNode(nodes[index]);
      },
      // Add caching
      addAutomaticKeepAlives: true,
      cacheExtent: 1000, // Cache 1000px ahead
    );
  }

  Widget _buildNode(FileNode node) {
    return ExpansionTile(
      key: ValueKey(node.path),
      title: Text(node.name),
      children: node.children?.map(_buildNode).toList() ?? [],
    );
  }
}
```

**Performance test:**
```dart
// test/performance/file_tree_performance_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FileTree should render 10000 nodes without jank', (tester) async {
    final nodes = List.generate(10000, (i) => FileNode(...));

    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FileTreeWidget(nodes: nodes),
        ),
      ),
    );

    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds, lessThan(1000));
  });
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run --profile -d macos
# Manual: загрузить проект с 10k+ файлами
# DevTools → Performance → проверить 60fps при scroll
# Memory < 300MB
```

---

### 5. Startup Time Optimization

**Создать:** `lib/core/initialization/app_initializer.dart`

```dart
import 'package:flutter/foundation.dart';

class AppInitializer {
  static Future<void> initialize() async {
    // Parallel initialization
    await Future.wait([
      _initHive(),
      _initFirebase(),
      _initPreferences(),
    ]);
  }

  static Future<void> _initHive() async {
    if (kDebugMode) print('[Init] Hive starting...');
    await Hive.initFlutter();
    if (kDebugMode) print('[Init] Hive done');
  }

  static Future<void> _initFirebase() async {
    if (kDebugMode) print('[Init] Firebase starting...');
    await Firebase.initializeApp();
    if (kDebugMode) print('[Init] Firebase done');
  }

  static Future<void> _initPreferences() async {
    if (kDebugMode) print('[Init] SharedPreferences starting...');
    await SharedPreferences.getInstance();
    if (kDebugMode) print('[Init] SharedPreferences done');
  }
}
```

**Benchmark:**
```dart
// test/performance/startup_benchmark_test.dart
void main() {
  test('App should initialize in < 2 seconds', () async {
    final stopwatch = Stopwatch()..start();

    await AppInitializer.initialize();

    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds, lessThan(2000));
  });
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run --profile -d macos
# Засечь время от запуска до UI
# Target: < 2 seconds
```

---

### 6. Crash Reporting (Sentry)

**Добавить в pubspec.yaml:**
```yaml
dependencies:
  sentry_flutter: ^7.14.0
```

**Настроить:**
```dart
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://your-dsn@sentry.io/project-id';
      options.tracesSampleRate = 1.0;
      options.environment = kDebugMode ? 'development' : 'production';
    },
    appRunner: () => runApp(const MyApp()),
  );
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
# 1. Trigger crash
throw Exception('Test crash');

# 2. Check Sentry dashboard
# Sentry.io → Issues → должен быть crash report
```

---

### 7. Analytics (Firebase Analytics)

**Настроить:**
```dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, Map<String, dynamic>? parameters) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // Custom events
  Future<void> logProjectLoaded(String projectPath) async {
    await logEvent('project_loaded', {'path': projectPath});
  }

  Future<void> logLLMRequest(String provider, int tokens) async {
    await logEvent('llm_request', {
      'provider': provider,
      'tokens': tokens,
    });
  }

  Future<void> logPatchApplied(int filesChanged) async {
    await logEvent('patch_applied', {
      'files_changed': filesChanged,
    });
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
# Firebase Console → Analytics → Events
# Должны быть: project_loaded, llm_request, patch_applied
```

---

### 8. Admin Dashboard (Web)

**Создать:** `lib/features/admin/presentation/screens/admin_dashboard_screen.dart`

```dart
class AdminDashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildMetricCard(
            title: 'Total Users',
            value: '1,234',
            icon: Icons.people,
          ),
          _buildMetricCard(
            title: 'Projects',
            value: '5,678',
            icon: Icons.folder,
          ),
          _buildMetricCard(
            title: 'LLM Requests',
            value: '12,345',
            icon: Icons.auto_awesome,
          ),
          _buildMetricCard(
            title: 'Patches Applied',
            value: '9,876',
            icon: Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text(title),
          ],
        ),
      ),
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d chrome
# Navigate to /admin
# Проверить metrics отображаются
```

---

### 9. Memory Leak Detection

**Создать:** `test/memory_leak_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:leak_tracker/leak_tracker.dart';

void main() {
  testWidgets('No memory leaks in FileTreeWidget', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FileTreeWidget(nodes: testNodes),
        ),
      ),
    );

    // Navigate away
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Text('Empty')),
      ),
    );

    // Check for leaks
    await tester.pumpAndSettle();

    // Would use LeakTracker to detect leaks
  });
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run --profile -d macos
# DevTools → Memory → Take snapshot
# Navigate through all screens
# Take snapshot again
# No leaked widgets/controllers
```

---

### 10. Bundle Size Optimization

**Analyze bundle:**
```bash
# Build release
flutter build apk --release --analyze-size

# Output:
# app-release.apk (total size): 15.2 MB
```

**Оптимизации:**
```yaml
# android/app/build.gradle
android {
  buildTypes {
    release {
      minifyEnabled true
      shrinkResources true
    }
  }
}
```

**Tree shaking:**
```bash
flutter build web --release --tree-shake-icons
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
# APK size < 20 MB
# iOS IPA size < 30 MB
# Web bundle < 5 MB (gzipped)
```

---

## Критерии приемки Phase 9

### Обязательные

- ✅ Custom LLM endpoints работают
- ✅ Batch processing работает
- ✅ Plugin system базовый функционал
- ✅ Virtual scrolling оптимизация
- ✅ Startup time < 2 seconds
- ✅ Crash reporting настроен (Sentry)
- ✅ Analytics настроены (Firebase)
- ✅ Admin dashboard (базовый)
- ✅ No memory leaks
- ✅ Bundle size оптимизирован
- ✅ Все тесты проходят
- ✅ Coverage >85%
- ✅ flutter analyze = 0 issues

### Опциональные

- ⭐ CLI mode
- ⭐ Webhooks
- ⭐ Advanced plugins
- ⭐ Real-time collaboration

---

## Manual Testing Checklist

```
Custom LLM:
[ ] Add localhost endpoint → успешно
[ ] Select custom endpoint → LLM request works
[ ] Remove endpoint → успешно

Batch Processing:
[ ] Create batch job (5 projects) → успешно
[ ] Progress updates correctly
[ ] All projects processed

Performance:
[ ] App starts in < 2 seconds
[ ] 10k file tree scrolls at 60fps
[ ] Memory usage < 300MB

Monitoring:
[ ] Crash → Sentry report
[ ] Event → Firebase Analytics
[ ] Admin dashboard → metrics visible
```

---

## Потенциальные проблемы

### 1. Custom LLM не совместим с API
**Решение:**
- Использовать OpenAI-compatible API format
- Fallback на simple HTTP POST

### 2. Performance regression
**Решение:**
- Golden tests для performance
- CI/CD performance benchmarks

### 3. Bundle size слишком большой
**Решение:**
- Deferred loading для features
- Split bundles (web)
- Minify/tree-shake

---

## Checklist

```
[ ] 1. Custom LLM Endpoints
[ ] 2. Batch Processing
[ ] 3. Plugin System
[ ] 4. Virtual Scrolling Optimization
[ ] 5. Startup Time Optimization
[ ] 6. Crash Reporting (Sentry)
[ ] 7. Analytics (Firebase)
[ ] 8. Admin Dashboard
[ ] 9. Memory Leak Detection
[ ] 10. Bundle Size Optimization
[ ] ✅ Все критерии приемки выполнены
```

---

## Время выполнения

- Шаги 1-3: **4 дня** (Advanced features)
- Шаги 4-5: **2 дня** (Performance)
- Шаги 6-8: **3 дня** (Monitoring)
- Шаги 9-10: **1 день** (Optimization)

**Итого: 10 рабочих дней (2 недели)**

---

## Следующая фаза

После завершения Phase 9, переходить к **Phase 10: Documentation & Release**.
