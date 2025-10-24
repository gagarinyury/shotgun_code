# Phase 4: Feature - LLM Executor (Step 3)

**Duration:** 3 weeks
**Goal:** Интеграция LLM APIs, streaming responses, автоматический запрос диффа

---

## ⚠️ ВАЛИДАЦИЯ ПОСЛЕ КАЖДОГО ШАГА

```bash
flutter analyze  # 0 issues
flutter pub run build_runner build  # succeeded
flutter test  # All passed
flutter test --coverage  # >85%
```

---

## Предварительные требования

```bash
# Phase 3 завершена
flutter test test/features/prompt_composer/  # All passed
flutter run  # Prompt composer работает, копирует промпт
```

---

## Шаги выполнения

### 1. Domain Entities

**Создать:**
- `lib/features/llm_executor/domain/entities/llm_config.dart`
- `lib/features/llm_executor/domain/entities/llm_provider_type.dart`
- `lib/features/llm_executor/domain/entities/llm_response.dart`

```dart
// llm_provider_type.dart
enum LLMProviderType {
  gemini,
  openai,
  claude,
}

// llm_config.dart
class LLMConfig extends Equatable {
  final LLMProviderType provider;
  final String apiKey;
  final String model;
  final double temperature;

  const LLMConfig({
    required this.provider,
    required this.apiKey,
    required this.model,
    this.temperature = 0.1,
  });

  @override
  List<Object?> get props => [provider, apiKey, model, temperature];
}

// llm_response.dart
class LLMResponse extends Equatable {
  final String diff;
  final int tokensUsed;
  final DateTime completedAt;

  const LLMResponse({
    required this.diff,
    required this.tokensUsed,
    required this.completedAt,
  });

  @override
  List<Object?> get props => [diff, tokensUsed, completedAt];
}
```

**✅ КРИТЕРИИ:**
```bash
ls lib/features/llm_executor/domain/entities/llm_config.dart
flutter analyze  # 0 issues
flutter test test/features/llm_executor/domain/entities/  # All passed
```

---

### 2. Repository Interface

**Создать:** `lib/features/llm_executor/domain/repositories/llm_repository.dart`

```dart
abstract class LLMRepository {
  Stream<Either<Failure, String>> generateDiff({
    required String prompt,
    required LLMConfig config,
  });

  Future<Either<Failure, void>> cancelGeneration();
}
```

**✅ КРИТЕРИИ:**
```bash
ls lib/features/llm_executor/domain/repositories/llm_repository.dart
flutter analyze  # 0 issues
```

---

### 3. Use Cases

**Создать:**
- `lib/features/llm_executor/domain/usecases/generate_diff_with_llm.dart`
- `lib/features/llm_executor/domain/usecases/cancel_generation.dart`

```dart
// generate_diff_with_llm.dart
class GenerateDiffWithLLM {
  final LLMRepository repository;

  GenerateDiffWithLLM(this.repository);

  Stream<Either<Failure, String>> call({
    required String prompt,
    required LLMConfig config,
  }) {
    return repository.generateDiff(prompt: prompt, config: config);
  }
}
```

**✅ КРИТЕРИИ:**
```bash
flutter pub run build_runner build  # Mocks
flutter test test/features/llm_executor/domain/usecases/  # All passed
```

---

### 4. Data Layer - LLM DataSources

**Создать:**
- `lib/features/llm_executor/data/datasources/gemini_datasource.dart`
- `lib/features/llm_executor/data/datasources/openai_datasource.dart`
- `lib/features/llm_executor/data/datasources/claude_datasource.dart`

```dart
// gemini_datasource.dart
abstract class LLMDataSource {
  Stream<String> generateDiff({
    required String prompt,
    required String apiKey,
    required String model,
    required double temperature,
  });

  void cancel();
}

class GeminiDataSource implements LLMDataSource {
  late GenerativeModel _model;
  StreamSubscription? _subscription;

  @override
  Stream<String> generateDiff({
    required String prompt,
    required String apiKey,
    required String model,
    required double temperature,
  }) async* {
    _model = GenerativeModel(
      model: model,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: temperature,
        maxOutputTokens: 8192,
      ),
    );

    final content = [Content.text(prompt)];
    final responseStream = _model.generateContentStream(content);

    _subscription = responseStream.listen(null);

    await for (final chunk in responseStream) {
      yield chunk.text ?? '';
    }
  }

  @override
  void cancel() {
    _subscription?.cancel();
  }
}
```

**Аналогично для OpenAI и Claude.**

**✅ КРИТЕРИИ:**
```bash
flutter analyze  # 0 issues
flutter test test/features/llm_executor/data/datasources/  # All passed
# Используй mock HTTP responses для тестов
```

---

### 5. Repository Implementation

**Создать:** `lib/features/llm_executor/data/repositories/llm_repository_impl.dart`

```dart
class LLMRepositoryImpl implements LLMRepository {
  final Map<LLMProviderType, LLMDataSource> dataSources;

  LLMRepositoryImpl({required this.dataSources});

  @override
  Stream<Either<Failure, String>> generateDiff({
    required String prompt,
    required LLMConfig config,
  }) async* {
    try {
      final dataSource = dataSources[config.provider];
      if (dataSource == null) {
        yield Left(ServerFailure('Provider ${config.provider} not supported'));
        return;
      }

      final stream = dataSource.generateDiff(
        prompt: prompt,
        apiKey: config.apiKey,
        model: config.model,
        temperature: config.temperature,
      );

      await for (final chunk in stream) {
        yield Right(chunk);
      }
    } catch (e) {
      yield Left(ServerFailure('LLM generation failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelGeneration() async {
    try {
      for (final source in dataSources.values) {
        source.cancel();
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Cancel failed: $e'));
    }
  }
}
```

**✅ КРИТЕРИИ:**
```bash
flutter analyze  # 0 issues
flutter test test/features/llm_executor/data/repositories/  # All passed
```

---

### 6. Secure Storage для API Keys

**Создать:** `lib/features/llm_executor/data/datasources/secure_storage_datasource.dart`

```dart
class SecureStorageDataSource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveApiKey(LLMProviderType provider, String apiKey) async {
    await _storage.write(key: '${provider.name}_api_key', value: apiKey);
  }

  Future<String?> getApiKey(LLMProviderType provider) async {
    return await _storage.read(key: '${provider.name}_api_key');
  }

  Future<void> deleteApiKey(LLMProviderType provider) async {
    await _storage.delete(key: '${provider.name}_api_key');
  }
}
```

**✅ КРИТЕРИИ:**
```bash
flutter analyze  # 0 issues
flutter test test/features/llm_executor/data/datasources/  # Mock secure storage
```

---

### 7. Presentation - Provider

**Создать:** `lib/features/llm_executor/presentation/providers/llm_provider.dart`

```dart
@riverpod
class LLMNotifier extends _$LLMNotifier {
  StreamSubscription<Either<Failure, String>>? _subscription;
  final StringBuffer _accumulatedResponse = StringBuffer();

  @override
  FutureOr<LLMState> build() {
    return const LLMState.initial();
  }

  Future<void> startGeneration({
    required String prompt,
    required LLMConfig config,
  }) async {
    state = const AsyncValue.data(LLMState.generating(response: ''));
    _accumulatedResponse.clear();

    final useCase = ref.read(generateDiffWithLLMProvider);
    final stream = useCase(prompt: prompt, config: config);

    _subscription = stream.listen(
      (result) {
        result.fold(
          (failure) {
            state = AsyncValue.error(failure, StackTrace.current);
            _subscription?.cancel();
          },
          (chunk) {
            _accumulatedResponse.write(chunk);
            state = AsyncValue.data(
              LLMState.generating(response: _accumulatedResponse.toString()),
            );
          },
        );
      },
      onDone: () {
        state = AsyncValue.data(
          LLMState.completed(diff: _accumulatedResponse.toString()),
        );
      },
    );
  }

  Future<void> cancel() async {
    await _subscription?.cancel();
    final cancelUseCase = ref.read(cancelGenerationProvider);
    await cancelUseCase();
    state = const AsyncValue.data(LLMState.cancelled());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

@freezed
class LLMState with _$LLMState {
  const factory LLMState.initial() = _InitialState;
  const factory LLMState.generating({required String response}) = _GeneratingState;
  const factory LLMState.completed({required String diff}) = _CompletedState;
  const factory LLMState.cancelled() = _CancelledState;
}
```

**✅ КРИТЕРИИ:**
```bash
flutter pub run build_runner build  # .g.dart/.freezed.dart
flutter analyze  # 0 issues
flutter test test/features/llm_executor/presentation/providers/  # All passed
```

---

### 8. UI - Screen

**Создать:** `lib/features/llm_executor/presentation/screens/llm_executor_screen.dart`

```dart
class LLMExecutorScreen extends ConsumerStatefulWidget {
  final String prompt;

  const LLMExecutorScreen({Key? key, required this.prompt}) : super(key: key);

  @override
  ConsumerState<LLMExecutorScreen> createState() => _LLMExecutorScreenState();
}

class _LLMExecutorScreenState extends ConsumerState<LLMExecutorScreen> {
  late LLMConfig _config;

  @override
  void initState() {
    super.initState();
    _config = const LLMConfig(
      provider: LLMProviderType.gemini,
      apiKey: '', // Load from secure storage
      model: 'gemini-2.0-flash-exp',
    );
    _loadApiKeys();
  }

  Future<void> _loadApiKeys() async {
    // Load from secure storage
  }

  @override
  Widget build(BuildContext context) {
    final llmState = ref.watch(llmNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Processing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showConfigDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Provider selector
          _buildProviderSelector(),

          // Streaming response
          Expanded(
            child: llmState.when(
              data: (state) {
                return state.when(
                  initial: () => const Center(
                    child: Text('Ready to generate'),
                  ),
                  generating: (response) => _buildStreamingView(response),
                  completed: (diff) => _buildCompletedView(diff),
                  cancelled: () => const Center(
                    child: Text('Generation cancelled'),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),

          // Actions
          _buildActions(llmState),
        ],
      ),
    );
  }

  Widget _buildStreamingView(String response) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(
          response,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildActions(AsyncValue<LLMState> llmState) {
    return llmState.maybeWhen(
      data: (state) => state.maybeWhen(
        initial: () => ElevatedButton(
          onPressed: () => ref
              .read(llmNotifierProvider.notifier)
              .startGeneration(prompt: widget.prompt, config: _config),
          child: const Text('Generate Diff'),
        ),
        generating: (_) => ElevatedButton(
          onPressed: () => ref.read(llmNotifierProvider.notifier).cancel(),
          child: const Text('Cancel'),
        ),
        completed: (diff) => ElevatedButton(
          onPressed: () => _proceedToApplyPatch(diff),
          child: const Text('Apply Changes'),
        ),
        orElse: () => const SizedBox(),
      ),
      orElse: () => const SizedBox(),
    );
  }

  void _proceedToApplyPatch(String diff) {
    // Navigate to Phase 5 (Patch Applier)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatchApplierScreen(diff: diff),
      ),
    );
  }

  void _showConfigDialog() {
    // Show dialog for API key, model, temperature
  }

  Widget _buildProviderSelector() {
    return DropdownButton<LLMProviderType>(
      value: _config.provider,
      items: LLMProviderType.values.map((type) {
        return DropdownMenuItem(value: type, child: Text(type.name));
      }).toList(),
      onChanged: (provider) {
        if (provider != null) {
          setState(() {
            _config = _config.copyWith(provider: provider);
          });
        }
      },
    );
  }
}
```

**✅ КРИТЕРИИ:**
```bash
flutter analyze  # 0 issues
flutter run  # App starts
# Manual test:
# - Enter API key
# - Start generation
# - See streaming response
# - Cancel works
# - Completed shows diff
```

---

## Финальная валидация Phase 4

```bash
# 1. Файлы созданы
ls lib/features/llm_executor/domain/
ls lib/features/llm_executor/data/datasources/gemini_datasource.dart
ls lib/features/llm_executor/presentation/screens/

# 2. Генерация
flutter pub run build_runner build

# 3. Компиляция
flutter analyze  # 0 issues

# 4. Тесты
flutter test  # All passed

# 5. Coverage
flutter test --coverage  # >85%

# 6. Integration test с mock LLM
flutter test integration_test/llm_executor_test.dart

# 7. Manual test с реальным API
flutter run
# - Ввести API key (Gemini)
# - Сгенерировать diff
# - Увидеть streaming
# - Cancel работает
# - Diff сохраняется
```

---

## Критерии приемки Phase 4

### ✅ ОБЯЗАТЕЛЬНЫЕ

- [ ] `flutter analyze` = 0 issues
- [ ] `flutter test` = All passed
- [ ] Coverage >85%
- [ ] Streaming работает (чанки появляются)
- [ ] Cancel останавливает генерацию
- [ ] API keys хранятся в FlutterSecureStorage
- [ ] Поддерживаются минимум 2 LLM providers (Gemini + OpenAI)
- [ ] Diff передается в Phase 5

### ⭐ Опциональные
- [ ] Claude поддержка
- [ ] Retry при ошибках сети
- [ ] ETA для генерации

---

## Checklist

```
[ ] 1. Domain entities + тесты
[ ] 2. Repository interface
[ ] 3. Use cases + mock тесты
[ ] 4. LLM datasources (Gemini, OpenAI, Claude)
[ ] 5. Repository impl + тесты
[ ] 6. Secure storage для API keys
[ ] 7. Provider + .g/.freezed
[ ] 8. Screen + streaming UI
[ ] 9. Integration test
[ ] 10. Manual test с реальным API
[ ] ✅ Все критерии приемки
```

---

## Время: 15 дней (3 недели)

---

## Потенциальные проблемы

### 1. Streaming не работает
**Решение:** Проверь что `async*` используется, не `async`.

### 2. API key не сохраняется
**Решение:** Проверь iOS/Android permissions для FlutterSecureStorage.

### 3. Memory leak от stream
**Решение:** Всегда cancel subscription в dispose().
