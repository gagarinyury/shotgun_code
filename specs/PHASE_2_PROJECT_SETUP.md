# Phase 2: Feature - Project Setup (Step 1)

**Duration:** 2 weeks
**Goal:** Реализовать полный Step 1 - выбор проекта, дерево файлов, генерация контекста

---

## ⚠️ ВАЖНО: Валидация каждого шага

**ПОСЛЕ КАЖДОГО ШАГА ОБЯЗАТЕЛЬНО:**

```bash
# 1. Запустить анализ кода
flutter analyze
# Должно быть: 0 issues found

# 2. Генерация кода
flutter pub run build_runner build --delete-conflicting-outputs
# Должно быть: succeeded, no errors

# 3. Запустить тесты
flutter test
# Должно быть: All tests passed!

# 4. Проверить coverage (только для завершенных feature)
flutter test --coverage
lcov --summary coverage/lcov.info
# Должно быть: >85% для данного feature
```

**НЕ ПЕРЕХОДИ К СЛЕДУЮЩЕМУ ШАГУ, ПОКА:**
- ❌ Есть хотя бы одна ошибка в `flutter analyze`
- ❌ Есть failing tests
- ❌ Freezed/JsonSerializable код не сгенерирован
- ❌ Файл создан, но класс не компилируется

---

## Предварительные требования

- ✅ Phase 0 завершена (flutter analyze = 0 issues)
- ✅ Phase 1 завершена (FFI bridge работает)
- ✅ Integration test из Phase 1 проходит

**Проверить перед началом:**
```bash
cd shotgun_flutter

# 1. Проверить что Phase 0 готова
flutter analyze  # 0 issues
flutter test test/core/  # All passed

# 2. Проверить что Phase 1 готова
flutter test test/features/project_setup/data/  # All passed
flutter test integration_test/backend_integration_test.dart  # Passed

# 3. Проверить что FFI работает
dart run test/manual_ffi_test.dart  # Должен вернуть JSON с файлами
```

---

## Шаги выполнения

### 1. Создать Domain Entities (полный набор)

**Создать:** `lib/features/project_setup/domain/entities/shotgun_context.dart`

```dart
import 'package:equatable/equatable.dart';

class ShotgunContext extends Equatable {
  final String projectPath;
  final String context;
  final int sizeBytes;
  final DateTime generatedAt;

  const ShotgunContext({
    required this.projectPath,
    required this.context,
    required this.sizeBytes,
    required this.generatedAt,
  });

  @override
  List<Object?> get props => [projectPath, context, sizeBytes, generatedAt];
}
```

**Создать:** `lib/features/project_setup/domain/entities/generation_progress.dart`

```dart
import 'package:equatable/equatable.dart';

class GenerationProgress extends Equatable {
  final int current;
  final int total;

  const GenerationProgress({
    required this.current,
    required this.total,
  });

  double get percentage => total > 0 ? current / total : 0.0;

  @override
  List<Object?> get props => [current, total];
}
```

**✅ КРИТЕРИИ ПРИЕМКИ ШАГА 1:**

```bash
# 1. Файлы существуют
ls lib/features/project_setup/domain/entities/shotgun_context.dart
ls lib/features/project_setup/domain/entities/generation_progress.dart

# 2. Код компилируется без ошибок
flutter analyze
# Ожидается: 0 issues

# 3. Тесты для entities проходят
flutter test test/features/project_setup/domain/entities/
# Ожидается: All tests passed!
```

**Тест для валидации:**

**Создать:** `test/features/project_setup/domain/entities/shotgun_context_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/project_setup/domain/entities/shotgun_context.dart';

void main() {
  group('ShotgunContext', () {
    final tContext = ShotgunContext(
      projectPath: '/test',
      context: 'test context',
      sizeBytes: 1024,
      generatedAt: DateTime(2024, 1, 1),
    );

    test('should be equal when all fields are the same', () {
      final context2 = ShotgunContext(
        projectPath: '/test',
        context: 'test context',
        sizeBytes: 1024,
        generatedAt: DateTime(2024, 1, 1),
      );

      expect(tContext, equals(context2));
    });

    test('should not be equal when fields differ', () {
      final context2 = ShotgunContext(
        projectPath: '/other',
        context: 'test context',
        sizeBytes: 1024,
        generatedAt: DateTime(2024, 1, 1),
      );

      expect(tContext, isNot(equals(context2)));
    });
  });
}
```

**Создать:** `test/features/project_setup/domain/entities/generation_progress_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/project_setup/domain/entities/generation_progress.dart';

void main() {
  group('GenerationProgress', () {
    test('should calculate percentage correctly', () {
      const progress = GenerationProgress(current: 50, total: 100);
      expect(progress.percentage, 0.5);
    });

    test('should handle zero total without error', () {
      const progress = GenerationProgress(current: 0, total: 0);
      expect(progress.percentage, 0.0);
    });
  });
}
```

**Запустить:**
```bash
flutter test test/features/project_setup/domain/entities/
```

**❌ ЕСЛИ НЕ ПРОШЛО:**
- Проверь импорты
- Убедись что Equatable подключена
- Запусти `flutter pub get`

---

### 2. Создать Use Cases

**Создать:** `lib/features/project_setup/domain/usecases/list_files.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/file_node.dart';
import '../repositories/project_repository.dart';

class ListFiles {
  final ProjectRepository repository;

  ListFiles(this.repository);

  Future<Either<Failure, List<FileNode>>> call(String path) async {
    return await repository.listFiles(path);
  }
}
```

**Создать:** `lib/features/project_setup/domain/usecases/generate_context.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/shotgun_context.dart';
import '../repositories/project_repository.dart';

class GenerateContext {
  final ProjectRepository repository;

  GenerateContext(this.repository);

  Stream<Either<Failure, ShotgunContext>> call({
    required String rootDir,
    required List<String> excludedPaths,
  }) {
    return repository.generateContext(
      rootDir: rootDir,
      excludedPaths: excludedPaths,
    );
  }
}
```

**Обновить:** `lib/features/project_setup/domain/repositories/project_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/file_node.dart';
import '../entities/shotgun_context.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<FileNode>>> listFiles(String path);

  Stream<Either<Failure, ShotgunContext>> generateContext({
    required String rootDir,
    required List<String> excludedPaths,
  });

  Future<Either<Failure, void>> setUseGitignore(bool value);
  Future<Either<Failure, void>> setUseCustomIgnore(bool value);
}
```

**✅ КРИТЕРИИ ПРИЕМКИ ШАГА 2:**

```bash
# 1. Файлы созданы
ls lib/features/project_setup/domain/usecases/list_files.dart
ls lib/features/project_setup/domain/usecases/generate_context.dart

# 2. Компиляция без ошибок
flutter analyze
# Ожидается: 0 issues

# 3. Тесты use cases с моками
flutter test test/features/project_setup/domain/usecases/
# Ожидается: All tests passed!
```

**Создать:** `test/features/project_setup/domain/usecases/list_files_test.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/features/project_setup/domain/entities/file_node.dart';
import 'package:shotgun_flutter/features/project_setup/domain/repositories/project_repository.dart';
import 'package:shotgun_flutter/features/project_setup/domain/usecases/list_files.dart';

import 'list_files_test.mocks.dart';

@GenerateMocks([ProjectRepository])
void main() {
  late ListFiles usecase;
  late MockProjectRepository mockRepository;

  setUp(() {
    mockRepository = MockProjectRepository();
    usecase = ListFiles(mockRepository);
  });

  const tPath = '/test';
  final tFileNodes = [
    FileNode(
      name: 'test',
      path: '/test',
      relPath: 'test',
      isDir: true,
      isGitignored: false,
      isCustomIgnored: false,
    ),
  ];

  test('should return list of FileNode from repository', () async {
    when(mockRepository.listFiles(any))
        .thenAnswer((_) async => Right(tFileNodes));

    final result = await usecase(tPath);

    expect(result, Right(tFileNodes));
    verify(mockRepository.listFiles(tPath));
    verifyNoMoreInteractions(mockRepository);
  });
}
```

**Сгенерировать моки:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Запустить тесты:**
```bash
flutter test test/features/project_setup/domain/usecases/
```

---

### 3. Расширить Repository Implementation (Data Layer)

**Обновить:** `lib/features/project_setup/data/datasources/backend_datasource.dart`

Добавить методы:
```dart
abstract class BackendDataSource {
  Future<List<FileNodeModel>> listFiles(String path);

  Stream<Map<String, dynamic>> generateContextStream({
    required String rootDir,
    required List<String> excludedPaths,
  });

  Future<void> setUseGitignore(bool value);
  Future<void> setUseCustomIgnore(bool value);
}
```

**Обновить:** `lib/features/project_setup/data/repositories/project_repository_impl.dart`

Реализовать все методы с правильной обработкой ошибок.

**✅ КРИТЕРИИ ПРИЕМКИ ШАГА 3:**

```bash
# 1. Все методы реализованы
grep -n "generateContextStream" lib/features/project_setup/data/datasources/backend_datasource.dart
# Должна быть строка с методом

# 2. Компиляция без ошибок
flutter analyze
# 0 issues

# 3. Тесты для новых методов
flutter test test/features/project_setup/data/repositories/
# All passed

# 4. Coverage >90%
flutter test --coverage test/features/project_setup/data/
lcov --summary coverage/lcov.info | grep "project_setup/data"
# Ожидается: >90%
```

---

### 4. Создать Riverpod Providers

**Создать:** `lib/features/project_setup/presentation/providers/project_provider.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/file_node.dart';
import '../../domain/entities/shotgun_context.dart';
import '../../domain/usecases/list_files.dart';
import '../../domain/usecases/generate_context.dart';

part 'project_provider.g.dart';

@riverpod
class ProjectNotifier extends _$ProjectNotifier {
  @override
  FutureOr<ProjectState> build() {
    return const ProjectState.initial();
  }

  Future<void> loadProject(String path) async {
    state = const AsyncValue.loading();

    final listFilesUseCase = ref.read(listFilesProvider);
    final result = await listFilesUseCase(path);

    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (files) {
        state = AsyncValue.data(ProjectState.loaded(
          projectPath: path,
          fileTree: files,
        ));
        _startContextGeneration(path);
      },
    );
  }

  Future<void> _startContextGeneration(String path) async {
    final generateContextUseCase = ref.read(generateContextProvider);
    final stream = generateContextUseCase(
      rootDir: path,
      excludedPaths: _getExcludedPaths(),
    );

    await for (final result in stream) {
      result.fold(
        (failure) {
          // Handle error
        },
        (context) {
          // Update state with generated context
        },
      );
    }
  }

  List<String> _getExcludedPaths() {
    // Get from current state
    return [];
  }

  Future<void> toggleExclusion(FileNode node) async {
    // Implementation
  }
}

sealed class ProjectState {
  const ProjectState();

  const factory ProjectState.initial() = _InitialState;

  const factory ProjectState.loaded({
    required String projectPath,
    required List<FileNode> fileTree,
    ShotgunContext? context,
  }) = _LoadedState;
}

class _InitialState extends ProjectState {
  const _InitialState();
}

class _LoadedState extends ProjectState {
  final String projectPath;
  final List<FileNode> fileTree;
  final ShotgunContext? context;

  const _LoadedState({
    required this.projectPath,
    required this.fileTree,
    this.context,
  });
}
```

**✅ КРИТЕРИИ ПРИЕМКИ ШАГА 4:**

```bash
# 1. Provider файл создан
ls lib/features/project_setup/presentation/providers/project_provider.dart

# 2. Генерация Riverpod кода
flutter pub run build_runner build --delete-conflicting-outputs
# Должен создаться: project_provider.g.dart

# 3. Проверка генерации
ls lib/features/project_setup/presentation/providers/project_provider.g.dart
# Файл существует

# 4. Компиляция
flutter analyze
# 0 issues

# 5. Тесты для provider
flutter test test/features/project_setup/presentation/providers/
# All passed
```

**Создать тест:** `test/features/project_setup/presentation/providers/project_provider_test.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/project_setup/presentation/providers/project_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('ProjectNotifier', () {
    test('initial state should be ProjectState.initial', () {
      final state = container.read(projectNotifierProvider);

      expect(state, isA<AsyncValue<ProjectState>>());
      state.when(
        data: (data) => expect(data, isA<_InitialState>()),
        loading: () => fail('Should not be loading'),
        error: (_, __) => fail('Should not be error'),
      );
    });
  });
}
```

---

### 5. Создать UI Widgets

**Создать:** `lib/features/project_setup/presentation/widgets/file_tree_widget.dart`

```dart
import 'package:flutter/material.dart';
import '../../domain/entities/file_node.dart';

class FileTreeWidget extends StatelessWidget {
  final List<FileNode> nodes;
  final Function(FileNode) onToggle;

  const FileTreeWidget({
    Key? key,
    required this.nodes,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        return _FileNodeTile(
          node: nodes[index],
          onToggle: onToggle,
        );
      },
    );
  }
}

class _FileNodeTile extends StatefulWidget {
  final FileNode node;
  final Function(FileNode) onToggle;

  const _FileNodeTile({
    required this.node,
    required this.onToggle,
  });

  @override
  State<_FileNodeTile> createState() => _FileNodeTileState();
}

class _FileNodeTileState extends State<_FileNodeTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: widget.node.isDir
              ? Icon(_expanded ? Icons.folder_open : Icons.folder)
              : const Icon(Icons.insert_drive_file),
          title: Text(widget.node.name),
          trailing: Checkbox(
            value: !widget.node.isGitignored && !widget.node.isCustomIgnored,
            onChanged: (_) => widget.onToggle(widget.node),
          ),
          onTap: widget.node.isDir
              ? () => setState(() => _expanded = !_expanded)
              : null,
        ),
        if (_expanded && widget.node.children != null)
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: FileTreeWidget(
              nodes: widget.node.children!,
              onToggle: widget.onToggle,
            ),
          ),
      ],
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ ШАГА 5:**

```bash
# 1. Widget файл создан
ls lib/features/project_setup/presentation/widgets/file_tree_widget.dart

# 2. Компиляция
flutter analyze
# 0 issues

# 3. Widget тесты
flutter test test/features/project_setup/presentation/widgets/
# All passed
```

**Создать тест:** `test/features/project_setup/presentation/widgets/file_tree_widget_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/project_setup/domain/entities/file_node.dart';
import 'package:shotgun_flutter/features/project_setup/presentation/widgets/file_tree_widget.dart';

void main() {
  testWidgets('FileTreeWidget should display nodes', (tester) async {
    final nodes = [
      const FileNode(
        name: 'test.txt',
        path: '/test.txt',
        relPath: 'test.txt',
        isDir: false,
        isGitignored: false,
        isCustomIgnored: false,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FileTreeWidget(
            nodes: nodes,
            onToggle: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('test.txt'), findsOneWidget);
    expect(find.byType(Checkbox), findsOneWidget);
  });
}
```

---

### 6. Создать Screen

**Создать:** `lib/features/project_setup/presentation/screens/project_setup_screen.dart`

```dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/project_provider.dart';
import '../widgets/file_tree_widget.dart';

class ProjectSetupScreen extends ConsumerWidget {
  const ProjectSetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Project'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.folder_open),
              label: const Text('Choose Project'),
              onPressed: () => _pickFolder(ref),
            ),
          ),
          Expanded(
            child: projectState.when(
              data: (state) {
                if (state is _LoadedState) {
                  return FileTreeWidget(
                    nodes: state.fileTree,
                    onToggle: (node) => ref
                        .read(projectNotifierProvider.notifier)
                        .toggleExclusion(node),
                  );
                }
                return const Center(
                  child: Text('Select a project to begin'),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFolder(WidgetRef ref) async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      ref.read(projectNotifierProvider.notifier).loadProject(path);
    }
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ ШАГА 6:**

```bash
# 1. Screen создан
ls lib/features/project_setup/presentation/screens/project_setup_screen.dart

# 2. Компиляция
flutter analyze
# 0 issues

# 3. Widget test для screen
flutter test test/features/project_setup/presentation/screens/
# All passed

# 4. Приложение запускается
flutter run
# Должно запуститься без ошибок
```

---

### 7. Integration Test - Full Flow

**Создать:** `integration_test/project_setup_flow_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shotgun_flutter/features/project_setup/presentation/screens/project_setup_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full project setup flow', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProjectSetupScreen(),
        ),
      ),
    );

    // 1. Screen loads
    expect(find.text('Select Project'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // 2. Can tap folder button (will fail без real folder picker)
    // Manual test required
  });
}
```

**✅ КРИТЕРИИ ПРИЕМКИ ШАГА 7:**

```bash
# 1. Integration test файл создан
ls integration_test/project_setup_flow_test.dart

# 2. Запуск integration test
flutter test integration_test/project_setup_flow_test.dart
# Should pass

# 3. Manual testing
flutter run
# Click "Choose Project", select folder, verify tree appears
```

---

## Финальная валидация Phase 2

### Обязательные проверки

```bash
# 1. Все файлы на месте
ls lib/features/project_setup/domain/entities/shotgun_context.dart
ls lib/features/project_setup/domain/usecases/list_files.dart
ls lib/features/project_setup/presentation/providers/project_provider.dart
ls lib/features/project_setup/presentation/widgets/file_tree_widget.dart
ls lib/features/project_setup/presentation/screens/project_setup_screen.dart

# 2. Весь код компилируется
flutter analyze
# Ожидается: No issues found!

# 3. Все генерации выполнены
ls lib/features/project_setup/presentation/providers/project_provider.g.dart
# Файл существует

# 4. Все тесты проходят
flutter test
# Ожидается: All tests passed!

# 5. Coverage >85%
flutter test --coverage
lcov --summary coverage/lcov.info
# Ожидается: Overall coverage rate: >85%

# 6. Приложение запускается
flutter run
# Должно запуститься без ошибок

# 7. Manual test
# - Открыть приложение
# - Нажать "Choose Project"
# - Выбрать папку
# - Увидеть дерево файлов
# - Поменять checkbox
# - Дерево должно реагировать
```

---

## Критерии приемки Phase 2

### ✅ ОБЯЗАТЕЛЬНЫЕ (все должны быть выполнены)

- [ ] `flutter analyze` = 0 issues
- [ ] `flutter test` = All passed
- [ ] `flutter pub run build_runner build` = succeeded
- [ ] Coverage project_setup/ >85%
- [ ] Приложение запускается без crash
- [ ] File picker открывается
- [ ] Дерево файлов отображается
- [ ] Checkbox'ы работают
- [ ] Integration test проходит

### ⭐ Опциональные

- [ ] Progress bar для context generation
- [ ] Поиск в дереве файлов
- [ ] Сохранение состояния при перезапуске

---

## Checklist (проверять построчно!)

```
[ ] 1.1 Entities созданы
[ ] 1.2 flutter analyze = 0
[ ] 1.3 Entity тесты проходят

[ ] 2.1 Use cases созданы
[ ] 2.2 flutter analyze = 0
[ ] 2.3 Use case тесты с моками проходят
[ ] 2.4 Моки сгенерированы (build_runner)

[ ] 3.1 Repository methods добавлены
[ ] 3.2 flutter analyze = 0
[ ] 3.3 Repository тесты проходят
[ ] 3.4 Coverage data layer >90%

[ ] 4.1 Riverpod provider создан
[ ] 4.2 build_runner сгенерировал .g.dart
[ ] 4.3 flutter analyze = 0
[ ] 4.4 Provider тесты проходят

[ ] 5.1 Widgets созданы
[ ] 5.2 flutter analyze = 0
[ ] 5.3 Widget тесты проходят

[ ] 6.1 Screen создан
[ ] 6.2 flutter analyze = 0
[ ] 6.3 flutter run запускается
[ ] 6.4 Manual test пройден

[ ] 7.1 Integration test написан
[ ] 7.2 Integration test проходит

[ ] ✅ ВСЕ критерии приемки выполнены
```

---

## Время выполнения

- Шаги 1-2: **3 дня** (Domain layer)
- Шаг 3: **2 дня** (Data layer расширение)
- Шаг 4: **2 дня** (Providers)
- Шаги 5-6: **3 дня** (UI)
- Шаг 7: **1 день** (Integration test)
- Финальная валидация: **1 день**

**Итого: 12 рабочих дней (~2.5 недели)**

---

## Потенциальные проблемы и решения

### 1. Riverpod генерация не работает
**Симптом:** `project_provider.g.dart` не создается

**Решение:**
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Widget тесты падают с "MediaQuery not found"
**Решение:** Оборачивай в `MaterialApp`:
```dart
await tester.pumpWidget(
  MaterialApp(home: Scaffold(body: YourWidget()))
);
```

### 3. File picker не работает в тестах
**Решение:** Используй моки:
```dart
class MockFilePicker extends Mock implements FilePicker {}
```

### 4. Stream генерации контекста не останавливается
**Решение:** Добавь cancellation token в use case

---

## 📝 Напоминание после завершения

**ПЕРЕД ТЕМ КАК СКАЗАТЬ "PHASE 2 ГОТОВА":**

1. ✅ Открой `specs/PHASE_2_PROJECT_SETUP.md`
2. ✅ Пройди ВЕСЬ checklist построчно
3. ✅ Запусти ВСЕ команды валидации
4. ✅ Сделай manual test
5. ✅ Только тогда отметь как завершенную
