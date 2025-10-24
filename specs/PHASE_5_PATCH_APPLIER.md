# Phase 5: Feature - Patch Applier (Step 4)

**Duration:** 3 weeks
**Goal:** Автоматическое применение патчей с conflict resolution и Git integration

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
# Phase 4 завершена
flutter test test/features/llm_executor/  # All passed
flutter run  # LLM executor работает, генерирует diff
```

---

## Шаги выполнения

### 1. Domain Entities

**Создать:**
- `lib/features/patch_applier/domain/entities/patch.dart`
- `lib/features/patch_applier/domain/entities/apply_result.dart`
- `lib/features/patch_applier/domain/entities/conflict.dart`

```dart
// patch.dart
class Patch extends Equatable {
  final String content;
  final String projectPath;
  final int filesChanged;
  final int linesAdded;
  final int linesRemoved;

  const Patch({
    required this.content,
    required this.projectPath,
    required this.filesChanged,
    required this.linesAdded,
    required this.linesRemoved,
  });

  @override
  List<Object?> get props => [content, projectPath, filesChanged, linesAdded, linesRemoved];
}

// apply_result.dart
class ApplyResult extends Equatable {
  final bool success;
  final List<Conflict> conflicts;
  final String message;

  const ApplyResult({
    required this.success,
    this.conflicts = const [],
    required this.message,
  });

  factory ApplyResult.success() {
    return const ApplyResult(success: true, message: 'Patch applied successfully');
  }

  factory ApplyResult.failure({required List<Conflict> conflicts}) {
    return ApplyResult(
      success: false,
      conflicts: conflicts,
      message: 'Patch has conflicts',
    );
  }

  @override
  List<Object?> get props => [success, conflicts, message];
}

// conflict.dart
class Conflict extends Equatable {
  final String filePath;
  final int lineNumber;
  final String theirVersion;
  final String ourVersion;

  const Conflict({
    required this.filePath,
    required this.lineNumber,
    required this.theirVersion,
    required this.ourVersion,
  });

  @override
  List<Object?> get props => [filePath, lineNumber, theirVersion, ourVersion];
}
```

**✅ КРИТЕРИИ:**
```bash
ls lib/features/patch_applier/domain/entities/patch.dart
ls lib/features/patch_applier/domain/entities/apply_result.dart
ls lib/features/patch_applier/domain/entities/conflict.dart
flutter analyze  # 0 issues
flutter test test/features/patch_applier/domain/entities/  # All passed
```

---

### 2. Repository Interfaces

**Создать:**
- `lib/features/patch_applier/domain/repositories/patch_repository.dart`
- `lib/features/patch_applier/domain/repositories/git_repository.dart`

```dart
// patch_repository.dart
abstract class PatchRepository {
  Future<Either<Failure, ApplyResult>> applyPatch(
    Patch patch,
    {bool dryRun = false},
  );

  Future<Either<Failure, List<Conflict>>> detectConflicts(Patch patch);

  Future<Either<Failure, List<Patch>>> splitPatch(
    String diff,
    int lineLimit,
  );
}

// git_repository.dart
abstract class GitRepository {
  Future<Either<Failure, void>> createCommit(String message);
  Future<Either<Failure, void>> createBranch(String name);
  Future<Either<Failure, void>> rollback();
  Future<Either<Failure, bool>> hasUncommittedChanges();
}
```

**✅ КРИТЕРИИ:**
```bash
flutter analyze  # 0 issues
```

---

### 3. Use Cases

**Создать:**
- `lib/features/patch_applier/domain/usecases/apply_patch.dart`
- `lib/features/patch_applier/domain/usecases/split_patch.dart`
- `lib/features/patch_applier/domain/usecases/create_commit.dart`
- `lib/features/patch_applier/domain/usecases/rollback_changes.dart`

```dart
// apply_patch.dart
class ApplyPatch {
  final PatchRepository repository;

  ApplyPatch(this.repository);

  Future<Either<Failure, ApplyResult>> call(
    Patch patch, {
    bool dryRun = false,
  }) async {
    return await repository.applyPatch(patch, dryRun: dryRun);
  }
}

// split_patch.dart
class SplitPatch {
  final PatchRepository repository;

  SplitPatch(this.repository);

  Future<Either<Failure, List<Patch>>> call(
    String diff,
    int lineLimit,
  ) async {
    return await repository.splitPatch(diff, lineLimit);
  }
}
```

**✅ КРИТЕРИИ:**
```bash
flutter pub run build_runner build  # Mocks
flutter test test/features/patch_applier/domain/usecases/  # All passed
```

---

### 4. Data Layer - Backend Integration (FFI)

**Обновить Go backend:** `backend/bridge.go`

```go
//export SplitDiffFFI
func SplitDiffFFI(diffCStr *C.char, lineLimitC C.int) *C.char {
	diff := C.GoString(diffCStr)
	lineLimit := int(lineLimitC)

	app := NewApp()
	splits, err := app.SplitShotgunDiff(diff, lineLimit)
	if err != nil {
		return C.CString(marshalError(err))
	}

	result, _ := json.Marshal(splits)
	return C.CString(string(result))
}

//export ApplyPatchFFI
func ApplyPatchFFI(projectPathCStr *C.char, patchContentCStr *C.char, dryRunC C.int) *C.char {
	projectPath := C.GoString(projectPathCStr)
	patchContent := C.GoString(patchContentCStr)
	dryRun := int(dryRunC) == 1

	// Apply patch using git apply or custom logic
	result := applyPatch(projectPath, patchContent, dryRun)

	jsonResult, _ := json.Marshal(result)
	return C.CString(string(jsonResult))
}
```

**Пересобрать библиотеки:**
```bash
cd backend
./build_lib.sh
```

**Создать:** `lib/core/platform/backend_bridge.dart` (расширить)

```dart
// Добавить новые FFI bindings
typedef SplitDiffFFIC = ffi.Pointer<Utf8> Function(
  ffi.Pointer<Utf8>,
  ffi.Int,
);
typedef SplitDiffFFIDart = ffi.Pointer<Utf8> Function(
  ffi.Pointer<Utf8>,
  int,
);

class BackendBridge {
  // ... existing code

  late SplitDiffFFIDart _splitDiff;

  BackendBridge() {
    _lib = _loadLibrary();
    _listFiles = _lib.lookupFunction<...>('ListFilesFFI');
    _splitDiff = _lib.lookupFunction<SplitDiffFFIC, SplitDiffFFIDart>('SplitDiffFFI');
    _freeString = _lib.lookupFunction<...>('FreeString');
  }

  String splitDiff(String diff, int lineLimit) {
    final diffPtr = diff.toNativeUtf8();
    final resultPtr = _splitDiff(diffPtr, lineLimit);

    final result = resultPtr.toDartString();

    malloc.free(diffPtr);
    _freeString(resultPtr);

    return result;
  }
}
```

**✅ КРИТЕРИИ:**
```bash
# 1. Go код компилируется
cd backend && go build bridge.go
# No errors

# 2. Библиотеки пересобраны
./build_lib.sh
ls ../shotgun_flutter/macos/libshotgun_arm64.dylib

# 3. FFI работает
flutter test test/core/platform/backend_bridge_test.dart
# splitDiff вызывается и возвращает JSON
```

---

### 5. Data Layer - Repositories

**Создать:** `lib/features/patch_applier/data/repositories/patch_repository_impl.dart`

```dart
class PatchRepositoryImpl implements PatchRepository {
  final BackendBridge bridge;

  PatchRepositoryImpl({required this.bridge});

  @override
  Future<Either<Failure, List<Patch>>> splitPatch(
    String diff,
    int lineLimit,
  ) async {
    try {
      final jsonString = bridge.splitDiff(diff, lineLimit);
      final decoded = jsonDecode(jsonString);

      if (decoded is Map && decoded.containsKey('error')) {
        throw BackendException(decoded['error']);
      }

      if (decoded is List) {
        final patches = decoded.map((item) {
          return Patch(
            content: item,
            projectPath: '',
            filesChanged: _countFiles(item),
            linesAdded: _countAdditions(item),
            linesRemoved: _countDeletions(item),
          );
        }).toList();

        return Right(patches);
      }

      throw BackendException('Unexpected response format');
    } catch (e) {
      return Left(BackendFailure('Failed to split patch: $e'));
    }
  }

  int _countFiles(String diff) {
    return 'diff --git'.allMatches(diff).length;
  }

  int _countAdditions(String diff) {
    return '\n+'.allMatches(diff).length;
  }

  int _countDeletions(String diff) {
    return '\n-'.allMatches(diff).length;
  }

  @override
  Future<Either<Failure, ApplyResult>> applyPatch(
    Patch patch,
    {bool dryRun = false},
  ) async {
    // Call Go FFI to apply patch
    // Return ApplyResult with conflicts if any
  }

  @override
  Future<Either<Failure, List<Conflict>>> detectConflicts(Patch patch) async {
    // Call dry run and parse conflicts
  }
}
```

**Создать:** `lib/features/patch_applier/data/repositories/git_repository_impl.dart`

```dart
import 'package:libgit2dart/libgit2dart.dart';

class GitRepositoryImpl implements GitRepository {
  final String projectPath;

  GitRepositoryImpl({required this.projectPath});

  @override
  Future<Either<Failure, void>> createCommit(String message) async {
    try {
      final repo = Repository.open(projectPath);

      // Stage all changes
      final index = repo.index;
      index.addAll();
      index.write();

      // Create commit
      final sig = Signature.create(
        name: 'Shotgun Flutter',
        email: 'shotgun@flutter.dev',
        time: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );

      repo.createCommit(
        updateRef: 'HEAD',
        author: sig,
        committer: sig,
        message: message,
        tree: repo.index.writeTree(),
        parents: [repo.head.target],
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to create commit: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> rollback() async {
    try {
      final repo = Repository.open(projectPath);
      repo.resetHard(repo.head.target);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to rollback: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasUncommittedChanges() async {
    try {
      final repo = Repository.open(projectPath);
      final statusList = repo.status();
      return Right(statusList.isNotEmpty);
    } catch (e) {
      return Left(ServerFailure('Failed to check status: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> createBranch(String name) async {
    try {
      final repo = Repository.open(projectPath);
      repo.createBranch(name, repo.head.target);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to create branch: $e'));
    }
  }
}
```

**✅ КРИТЕРИИ:**
```bash
flutter analyze  # 0 issues
flutter test test/features/patch_applier/data/repositories/  # All passed
```

---

### 6. Presentation - Provider

**Создать:** `lib/features/patch_applier/presentation/providers/patch_provider.dart`

```dart
@riverpod
class PatchNotifier extends _$PatchNotifier {
  @override
  FutureOr<PatchState> build(String rawDiff) async {
    final splitUseCase = ref.read(splitPatchProvider);
    final result = await splitUseCase(rawDiff, 500);

    return result.fold(
      (failure) => PatchState.error(failure.message),
      (patches) => PatchState.loaded(patches: patches),
    );
  }

  Future<void> applyPatch(Patch patch, {bool dryRun = false}) async {
    state.whenData((data) async {
      if (data is _LoadedState) {
        state = AsyncValue.data(data.copyWith(isApplying: true));

        final applyUseCase = ref.read(applyPatchUseCaseProvider);
        final result = await applyUseCase(patch, dryRun: dryRun);

        result.fold(
          (failure) {
            state = AsyncValue.error(failure, StackTrace.current);
          },
          (applyResult) {
            if (applyResult.success) {
              // Mark patch as applied
              final newPatches = data.patches.map((p) {
                return p == patch ? p.copyWith(applied: true) : p;
              }).toList();

              state = AsyncValue.data(
                data.copyWith(patches: newPatches, isApplying: false),
              );
            } else {
              // Show conflicts
              state = AsyncValue.data(
                data.copyWith(
                  conflicts: applyResult.conflicts,
                  isApplying: false,
                ),
              );
            }
          },
        );
      }
    });
  }

  Future<void> applyAll() async {
    state.whenData((data) async {
      if (data is _LoadedState) {
        for (final patch in data.patches) {
          await applyPatch(patch);
        }
      }
    });
  }

  Future<void> createCommit(String message) async {
    final gitUseCase = ref.read(createCommitUseCaseProvider);
    final result = await gitUseCase(message);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        // Success notification
      },
    );
  }
}

@freezed
class PatchState with _$PatchState {
  const factory PatchState.loaded({
    required List<Patch> patches,
    @Default(false) bool isApplying,
    @Default([]) List<Conflict> conflicts,
  }) = _LoadedState;

  const factory PatchState.error(String message) = _ErrorState;
}
```

**✅ КРИТЕРИИ:**
```bash
flutter pub run build_runner build
flutter analyze  # 0 issues
flutter test test/features/patch_applier/presentation/providers/  # All passed
```

---

### 7. UI - Screen

**Создать:** `lib/features/patch_applier/presentation/screens/patch_applier_screen.dart`

```dart
class PatchApplierScreen extends ConsumerWidget {
  final String diff;

  const PatchApplierScreen({Key? key, required this.diff}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patchState = ref.watch(patchNotifierProvider(diff));

    return Scaffold(
      appBar: AppBar(title: const Text('Apply Patch')),
      body: patchState.when(
        data: (state) {
          return state.when(
            loaded: (patches, isApplying, conflicts) {
              return Column(
                children: [
                  if (conflicts.isNotEmpty) _buildConflictsWarning(conflicts),

                  Expanded(
                    child: ListView.builder(
                      itemCount: patches.length,
                      itemBuilder: (context, index) {
                        return _PatchCard(
                          patch: patches[index],
                          onApply: (patch) => ref
                              .read(patchNotifierProvider(diff).notifier)
                              .applyPatch(patch),
                          onPreview: (patch) => _showPatchPreview(context, patch),
                        );
                      },
                    ),
                  ),

                  // Bottom actions
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: isApplying
                              ? null
                              : () => ref
                                  .read(patchNotifierProvider(diff).notifier)
                                  .applyAll(),
                          child: const Text('Apply All'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => _showCommitDialog(context, ref),
                          child: const Text('Commit Changes'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (message) => Center(child: Text('Error: $message')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildConflictsWarning(List<Conflict> conflicts) {
    return Card(
      color: Colors.red[100],
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.red),
        title: Text('${conflicts.length} conflicts detected'),
        subtitle: const Text('Resolve conflicts before applying'),
      ),
    );
  }

  void _showPatchPreview(BuildContext context, Patch patch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Patch Preview'),
        content: SingleChildScrollView(
          child: Text(
            patch.content,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCommitDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Commit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Commit message',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(patchNotifierProvider(diff).notifier)
                  .createCommit(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Commit'),
          ),
        ],
      ),
    );
  }
}

class _PatchCard extends StatelessWidget {
  final Patch patch;
  final Function(Patch) onApply;
  final Function(Patch) onPreview;

  const _PatchCard({
    required this.patch,
    required this.onApply,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text('Patch - ${patch.filesChanged} files'),
        subtitle: Text('+${patch.linesAdded} -${patch.linesRemoved} lines'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => onPreview(patch),
                  child: const Text('Preview'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => onApply(patch),
                  child: const Text('Apply'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**✅ КРИТЕРИИ:**
```bash
flutter analyze  # 0 issues
flutter run  # App starts
# Manual test:
# - Open patch applier with diff
# - See list of split patches
# - Preview patch
# - Apply patch
# - Create commit
```

---

## Финальная валидация Phase 5

```bash
# 1. Go backend обновлен
cd backend && go build bridge.go  # No errors
./build_lib.sh  # Libraries built

# 2. FFI bindings работают
flutter test test/core/platform/  # splitDiff works

# 3. Компиляция
flutter analyze  # 0 issues

# 4. Тесты
flutter test  # All passed

# 5. Coverage
flutter test --coverage  # >85%

# 6. Integration test
flutter test integration_test/patch_applier_test.dart

# 7. Manual test
flutter run
# - Complete Phase 1-4 flow
# - Generate diff from LLM
# - Split patches
# - Apply patches
# - Create Git commit
# - Verify files changed
```

---

## Критерии приемки Phase 5

### ✅ ОБЯЗАТЕЛЬНЫЕ

- [ ] `flutter analyze` = 0 issues
- [ ] `flutter test` = All passed
- [ ] Coverage >85%
- [ ] Diff splitting работает
- [ ] Patches применяются к файлам
- [ ] Conflicts детектируются
- [ ] Git commit создается
- [ ] Rollback работает
- [ ] Full workflow (Phase 1-5) работает end-to-end

### ⭐ Опциональные
- [ ] Interactive conflict resolver
- [ ] Branch creation
- [ ] Patch preview с syntax highlighting

---

## Checklist

```
[ ] 1. Domain entities + тесты
[ ] 2. Repository interfaces
[ ] 3. Use cases + mock тесты
[ ] 4. Go backend обновлен (SplitDiff, ApplyPatch FFI)
[ ] 5. FFI bindings расширены
[ ] 6. Repository implementations + тесты
[ ] 7. Git repository (libgit2dart)
[ ] 8. Provider + .g/.freezed
[ ] 9. Screen + UI
[ ] 10. Integration test end-to-end
[ ] 11. Manual test full workflow
[ ] ✅ Все критерии приемки
```

---

## Время: 15 дней (3 недели)

---

## Потенциальные проблемы

### 1. libgit2dart compilation errors
**Решение:** Проверь что Git установлен, libgit2 dependencies доступны.

### 2. Patch apply fails на Windows
**Решение:** Используй `\r\n` line endings detection.

### 3. Conflicts не детектируются
**Решение:** Используй `git apply --check` через FFI для проверки.
