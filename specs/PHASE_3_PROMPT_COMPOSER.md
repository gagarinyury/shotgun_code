# Phase 3: Feature - Prompt Composer (Step 2)

**Duration:** 2 weeks
**Goal:** Создать UI для композиции промптов с шаблонами и подсчетом токенов

---

## ⚠️ ВАЛИДАЦИЯ ПОСЛЕ КАЖДОГО ШАГА

```bash
flutter analyze            # 0 issues
flutter pub run build_runner build --delete-conflicting-outputs  # succeeded
flutter test              # All passed
flutter test --coverage   # >85% для feature
```

---

## Предварительные требования

```bash
# Phase 2 должна быть завершена
flutter test test/features/project_setup/  # All passed
flutter run  # Project setup screen работает

# Проверить что context генерируется
# Manual: открыть app, выбрать проект, увидеть прогресс
```

---

## Шаги выполнения

### 1. Domain Entities

**Создать:**
- `lib/features/prompt_composer/domain/entities/prompt.dart`
- `lib/features/prompt_composer/domain/entities/prompt_template.dart`
- `lib/features/prompt_composer/domain/entities/custom_rules.dart`

```dart
// prompt.dart
class Prompt extends Equatable {
  final String context;
  final String task;
  final String rules;
  final String finalPrompt;
  final int estimatedTokens;

  const Prompt({...});

  @override
  List<Object?> get props => [...];
}

// prompt_template.dart
class PromptTemplate extends Equatable {
  final String id;
  final String name;
  final String template;  // e.g., "{context}\n\nTASK: {task}\n\nRULES: {rules}"

  const PromptTemplate({...});

  String render({
    required String context,
    required String task,
    required String rules,
  }) {
    return template
        .replaceAll('{context}', context)
        .replaceAll('{task}', task)
        .replaceAll('{rules}', rules);
  }

  @override
  List<Object?> get props => [id, name, template];
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
ls lib/features/prompt_composer/domain/entities/prompt.dart
ls lib/features/prompt_composer/domain/entities/prompt_template.dart
flutter analyze  # 0 issues
flutter test test/features/prompt_composer/domain/entities/  # All passed
```

**Тест:**
```dart
test('PromptTemplate should render correctly', () {
  const template = PromptTemplate(
    id: '1',
    name: 'Basic',
    template: '{context}\nTASK: {task}',
  );

  final result = template.render(
    context: 'ctx',
    task: 'my task',
    rules: '',
  );

  expect(result, 'ctx\nTASK: my task');
});
```

---

### 2. Repository Interface

**Создать:** `lib/features/prompt_composer/domain/repositories/prompt_repository.dart`

```dart
abstract class PromptRepository {
  Future<Either<Failure, String>> composePrompt({
    required String context,
    required String task,
    required String rules,
    required PromptTemplate template,
  });

  Future<Either<Failure, int>> estimateTokens(String text);

  Future<Either<Failure, List<PromptTemplate>>> loadTemplates();
  Future<Either<Failure, void>> saveTemplate(PromptTemplate template);

  Future<Either<Failure, String>> loadCustomRules();
  Future<Either<Failure, void>> saveCustomRules(String rules);
}
```

**✅ КРИТЕРИИ:**
```bash
ls lib/features/prompt_composer/domain/repositories/prompt_repository.dart
flutter analyze  # 0 issues
```

---

### 3. Use Cases

**Создать:**
- `lib/features/prompt_composer/domain/usecases/compose_prompt.dart`
- `lib/features/prompt_composer/domain/usecases/estimate_tokens.dart`

```dart
// compose_prompt.dart
class ComposePrompt {
  final PromptRepository repository;

  ComposePrompt(this.repository);

  Future<Either<Failure, String>> call({
    required String context,
    required String task,
    required String rules,
    required PromptTemplate template,
  }) async {
    return await repository.composePrompt(
      context: context,
      task: task,
      rules: rules,
      template: template,
    );
  }
}

// estimate_tokens.dart
class EstimateTokens {
  final PromptRepository repository;

  EstimateTokens(this.repository);

  Future<Either<Failure, int>> call(String text) async {
    return await repository.estimateTokens(text);
  }
}
```

**✅ КРИТЕРИИ:**
```bash
ls lib/features/prompt_composer/domain/usecases/compose_prompt.dart
ls lib/features/prompt_composer/domain/usecases/estimate_tokens.dart
flutter analyze  # 0 issues
flutter pub run build_runner build  # Generate mocks
flutter test test/features/prompt_composer/domain/usecases/  # All passed
```

---

### 4. Data Layer

**Создать:**
- `lib/features/prompt_composer/data/datasources/prompt_local_datasource.dart` (Hive)
- `lib/features/prompt_composer/data/repositories/prompt_repository_impl.dart`

```dart
// Token estimation (простой подсчет)
class TokenEstimator {
  static int estimate(String text) {
    // ~4 chars = 1 token (approximation)
    return (text.length / 4).ceil();
  }
}

// Hive datasource для templates и rules
class PromptLocalDataSource {
  late Box<String> _rulesBox;
  late Box<Map> _templatesBox;

  Future<void> init() async {
    _rulesBox = await Hive.openBox('custom_rules');
    _templatesBox = await Hive.openBox('templates');
  }

  Future<void> saveCustomRules(String rules) async {
    await _rulesBox.put('default', rules);
  }

  Future<String> loadCustomRules() async {
    return _rulesBox.get('default', defaultValue: '');
  }

  // ... templates methods
}
```

**✅ КРИТЕРИИ:**
```bash
flutter analyze  # 0 issues
flutter test test/features/prompt_composer/data/  # All passed
# Coverage >85%
flutter test --coverage test/features/prompt_composer/data/
```

---

### 5. Presentation - Provider

**Создать:** `lib/features/prompt_composer/presentation/providers/prompt_provider.dart`

```dart
@riverpod
class PromptNotifier extends _$PromptNotifier {
  @override
  FutureOr<PromptState> build() async {
    final templates = await ref.read(loadTemplatesUseCaseProvider)();
    final rules = await ref.read(loadCustomRulesUseCaseProvider)();

    return PromptState.initial(
      templates: templates.getOrElse(() => []),
      customRules: rules.getOrElse(() => ''),
    );
  }

  Future<void> updateTask(String task) async {
    state.whenData((data) async {
      final newState = data.copyWith(task: task);
      state = AsyncValue.data(newState);
      await _recomposePrompt();
    });
  }

  Future<void> selectTemplate(PromptTemplate template) async {
    state.whenData((data) async {
      final newState = data.copyWith(selectedTemplate: template);
      state = AsyncValue.data(newState);
      await _recomposePrompt();
    });
  }

  Future<void> _recomposePrompt() async {
    state.whenData((data) async {
      final composeUseCase = ref.read(composePromptUseCaseProvider);
      final result = await composeUseCase(
        context: data.context,
        task: data.task,
        rules: data.customRules,
        template: data.selectedTemplate,
      );

      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (composedPrompt) {
          final estimateUseCase = ref.read(estimateTokensUseCaseProvider);
          estimateUseCase(composedPrompt).then((tokensResult) {
            tokensResult.fold(
              (_) {},
              (tokens) {
                final newState = data.copyWith(
                  finalPrompt: composedPrompt,
                  estimatedTokens: tokens,
                );
                state = AsyncValue.data(newState);
              },
            );
          });
        },
      );
    });
  }
}

@freezed
class PromptState with _$PromptState {
  const factory PromptState({
    required String context,
    required String task,
    required String customRules,
    required List<PromptTemplate> templates,
    required PromptTemplate selectedTemplate,
    required String finalPrompt,
    required int estimatedTokens,
  }) = _PromptState;

  factory PromptState.initial({
    required List<PromptTemplate> templates,
    required String customRules,
  }) {
    return PromptState(
      context: '',
      task: '',
      customRules: customRules,
      templates: templates,
      selectedTemplate: templates.first,
      finalPrompt: '',
      estimatedTokens: 0,
    );
  }
}
```

**✅ КРИТЕРИИ:**
```bash
flutter pub run build_runner build  # Generate .freezed and .g files
ls lib/features/prompt_composer/presentation/providers/prompt_provider.g.dart
ls lib/features/prompt_composer/presentation/providers/prompt_provider.freezed.dart
flutter analyze  # 0 issues
flutter test test/features/prompt_composer/presentation/providers/  # All passed
```

---

### 6. UI Widgets

**Создать:**
- `lib/features/prompt_composer/presentation/widgets/task_editor.dart`
- `lib/features/prompt_composer/presentation/widgets/token_counter.dart`
- `lib/features/prompt_composer/presentation/widgets/prompt_viewer.dart`

```dart
// task_editor.dart
class TaskEditor extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const TaskEditor({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      onChanged: onChanged,
      maxLines: 10,
      decoration: const InputDecoration(
        labelText: 'Your task for AI',
        border: OutlineInputBorder(),
      ),
    );
  }
}

// token_counter.dart
class TokenCounter extends StatelessWidget {
  final int tokens;

  const TokenCounter({Key? key, required this.tokens}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getColorForTokens(tokens);

    return Chip(
      label: Text('~$tokens tokens'),
      backgroundColor: color,
    );
  }

  Color _getColorForTokens(int tokens) {
    if (tokens < 50000) return Colors.green[100]!;
    if (tokens < 100000) return Colors.orange[100]!;
    return Colors.red[100]!;
  }
}
```

**✅ КРИТЕРИИ:**
```bash
flutter analyze  # 0 issues
flutter test test/features/prompt_composer/presentation/widgets/  # All passed
```

---

### 7. Screen

**Создать:** `lib/features/prompt_composer/presentation/screens/prompt_composer_screen.dart`

```dart
class PromptComposerScreen extends ConsumerWidget {
  const PromptComposerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promptState = ref.watch(promptNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Compose Prompt')),
      body: promptState.when(
        data: (state) => Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  TaskEditor(
                    initialValue: state.task,
                    onChanged: (task) =>
                        ref.read(promptNotifierProvider.notifier).updateTask(task),
                  ),
                  // Rules editor
                  // Context display
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Template:'),
                      DropdownButton<PromptTemplate>(
                        value: state.selectedTemplate,
                        items: state.templates.map((t) {
                          return DropdownMenuItem(
                            value: t,
                            child: Text(t.name),
                          );
                        }).toList(),
                        onChanged: (template) {
                          if (template != null) {
                            ref
                                .read(promptNotifierProvider.notifier)
                                .selectTemplate(template);
                          }
                        },
                      ),
                      TokenCounter(tokens: state.estimatedTokens),
                    ],
                  ),
                  Expanded(
                    child: PromptViewer(prompt: state.finalPrompt),
                  ),
                  ElevatedButton(
                    onPressed: () => _copyPrompt(state.finalPrompt),
                    child: const Text('Copy Prompt'),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _copyPrompt(String prompt) {
    Clipboard.setData(ClipboardData(text: prompt));
  }
}
```

**✅ КРИТЕРИИ:**
```bash
flutter analyze  # 0 issues
flutter run  # App starts
# Manual: navigate to prompt composer, type task, see prompt update
```

---

## Финальная валидация Phase 3

```bash
# 1. Все файлы созданы
ls lib/features/prompt_composer/domain/entities/
ls lib/features/prompt_composer/domain/usecases/
ls lib/features/prompt_composer/presentation/screens/

# 2. Генерация кода
flutter pub run build_runner build
ls lib/features/prompt_composer/presentation/providers/prompt_provider.g.dart

# 3. Компиляция
flutter analyze
# 0 issues

# 4. Тесты
flutter test
# All passed

# 5. Coverage
flutter test --coverage
lcov --summary coverage/lcov.info | grep "prompt_composer"
# >85%

# 6. Manual test
flutter run
# - Open prompt composer
# - Type task
# - See final prompt update
# - See token count
# - Change template
# - Copy prompt to clipboard
```

---

## Критерии приемки Phase 3

### ✅ ОБЯЗАТЕЛЬНЫЕ

- [ ] `flutter analyze` = 0 issues
- [ ] `flutter test` = All passed
- [ ] Coverage >85%
- [ ] Token counter работает (±10% точность)
- [ ] Prompt updates в реальном времени
- [ ] Templates можно выбирать
- [ ] Copy to clipboard работает
- [ ] Custom rules сохраняются (Hive)

---

## Checklist

```
[ ] 1. Domain entities + тесты
[ ] 2. Repository interface
[ ] 3. Use cases + mock тесты
[ ] 4. Data layer + Hive + тесты
[ ] 5. Provider + .g.dart/.freezed.dart
[ ] 6. Widgets + тесты
[ ] 7. Screen + manual test
[ ] ✅ Все критерии приемки
```

---

## Время: 10 дней (2 недели)
