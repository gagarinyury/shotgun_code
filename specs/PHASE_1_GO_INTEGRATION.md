# Phase 1: Go Backend Integration (FFI)

**Duration:** 2 weeks
**Goal:** Установить связь Flutter ↔ Go через FFI для вызова функций backend

---

## Задача

Создать FFI bridge между Flutter и существующим Go backend. Dart должен вызывать Go функции (`ListFiles`, `GenerateContext`, `SplitDiff`) через shared library.

---

## Предварительные требования

- ✅ Phase 0 завершена
- ✅ Go установлен (1.21+)
- ✅ CGo доступен (`go env CGO_ENABLED` = 1)

---

## Шаги выполнения

### 1. Подготовить Go код для FFI

**Создать:** `backend/bridge.go`

```go
package main

import "C"
import (
	"encoding/json"
	"unsafe"
)

//export ListFilesFFI
func ListFilesFFI(pathCStr *C.char) *C.char {
	path := C.GoString(pathCStr)

	// Вызов существующей функции
	app := NewApp()
	files, err := app.ListFiles(path)
	if err != nil {
		return C.CString(marshalError(err))
	}

	result, _ := json.Marshal(files)
	return C.CString(string(result))
}

//export FreeString
func FreeString(str *C.char) {
	C.free(unsafe.Pointer(str))
}

func marshalError(err error) string {
	errObj := map[string]string{"error": err.Error()}
	bytes, _ := json.Marshal(errObj)
	return string(bytes)
}

func main() {}
```

**Критерии приемки:**
- ✅ Файл `backend/bridge.go` создан
- ✅ Функции помечены `//export`
- ✅ Функция `FreeString` для освобождения памяти
- ✅ Ошибки возвращаются как JSON с полем "error"

---

### 2. Создать build script для библиотек

**Создать:** `backend/build_lib.sh`

```bash
#!/bin/bash

# macOS (Intel)
GOOS=darwin GOARCH=amd64 CGO_ENABLED=1 \
  go build -buildmode=c-shared \
  -o ../shotgun_flutter/macos/libshotgun_amd64.dylib \
  bridge.go app.go split_diff.go

# macOS (Apple Silicon)
GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 \
  go build -buildmode=c-shared \
  -o ../shotgun_flutter/macos/libshotgun_arm64.dylib \
  bridge.go app.go split_diff.go

# Linux
GOOS=linux GOARCH=amd64 CGO_ENABLED=1 \
  go build -buildmode=c-shared \
  -o ../shotgun_flutter/linux/libshotgun.so \
  bridge.go app.go split_diff.go

# Windows
GOOS=windows GOARCH=amd64 CGO_ENABLED=1 CC=x86_64-w64-mingw32-gcc \
  go build -buildmode=c-shared \
  -o ../shotgun_flutter/windows/shotgun.dll \
  bridge.go app.go split_diff.go

echo "✅ Libraries built successfully"
```

**Запустить:**
```bash
cd backend
chmod +x build_lib.sh
./build_lib.sh
```

**Критерии приемки:**
- ✅ Скрипт выполняется без ошибок
- ✅ `.dylib` создан для macOS
- ✅ `.so` создан для Linux
- ✅ `.dll` создан для Windows
- ✅ Файлы копируются в правильные папки Flutter

---

### 3. Создать FFI bindings в Flutter

**Создать:** `lib/core/platform/backend_bridge.dart`

```dart
import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef ListFilesFFIC = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>);
typedef ListFilesFFIDart = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>);

typedef FreeStringC = ffi.Void Function(ffi.Pointer<Utf8>);
typedef FreeStringDart = void Function(ffi.Pointer<Utf8>);

class BackendBridge {
  late ffi.DynamicLibrary _lib;
  late ListFilesFFIDart _listFiles;
  late FreeStringDart _freeString;

  BackendBridge() {
    _lib = _loadLibrary();
    _listFiles = _lib.lookupFunction<ListFilesFFIC, ListFilesFFIDart>('ListFilesFFI');
    _freeString = _lib.lookupFunction<FreeStringC, FreeStringDart>('FreeString');
  }

  ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid || Platform.isLinux) {
      return ffi.DynamicLibrary.open('libshotgun.so');
    } else if (Platform.isMacOS) {
      // Detect architecture
      final arch = Abi.current().toString();
      if (arch.contains('arm64')) {
        return ffi.DynamicLibrary.open('libshotgun_arm64.dylib');
      } else {
        return ffi.DynamicLibrary.open('libshotgun_amd64.dylib');
      }
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('shotgun.dll');
    }
    throw UnsupportedError('Platform ${Platform.operatingSystem} not supported');
  }

  String listFiles(String path) {
    final pathPtr = path.toNativeUtf8();
    final resultPtr = _listFiles(pathPtr);

    final result = resultPtr.toDartString();

    // Free memory
    malloc.free(pathPtr);
    _freeString(resultPtr);

    return result;
  }

  void dispose() {
    // Cleanup if needed
  }
}
```

**Критерии приемки:**
- ✅ Класс `BackendBridge` создан
- ✅ Библиотека загружается для всех платформ
- ✅ Функция `listFiles` работает
- ✅ Память освобождается после вызовов
- ✅ Нет memory leaks

---

### 4. Создать Data Models

**Создать:** `lib/features/project_setup/data/models/file_node_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/file_node.dart';

part 'file_node_model.freezed.dart';
part 'file_node_model.g.dart';

@freezed
class FileNodeModel with _$FileNodeModel {
  const FileNodeModel._();

  const factory FileNodeModel({
    required String name,
    required String path,
    required String relPath,
    required bool isDir,
    required bool isGitignored,
    required bool isCustomIgnored,
    List<FileNodeModel>? children,
  }) = _FileNodeModel;

  factory FileNodeModel.fromJson(Map<String, dynamic> json) =>
      _$FileNodeModelFromJson(json);

  FileNode toEntity() {
    return FileNode(
      name: name,
      path: path,
      relPath: relPath,
      isDir: isDir,
      isGitignored: isGitignored,
      isCustomIgnored: isCustomIgnored,
      children: children?.map((c) => c.toEntity()).toList(),
    );
  }
}
```

**Запустить:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Критерии приемки:**
- ✅ Model создан с `@freezed`
- ✅ JSON serialization работает
- ✅ Метод `toEntity()` конвертирует в domain entity
- ✅ `.freezed.dart` и `.g.dart` файлы сгенерированы

---

### 5. Создать Domain Entities

**Создать:** `lib/features/project_setup/domain/entities/file_node.dart`

```dart
import 'package:equatable/equatable.dart';

class FileNode extends Equatable {
  final String name;
  final String path;
  final String relPath;
  final bool isDir;
  final bool isGitignored;
  final bool isCustomIgnored;
  final List<FileNode>? children;

  const FileNode({
    required this.name,
    required this.path,
    required this.relPath,
    required this.isDir,
    required this.isGitignored,
    required this.isCustomIgnored,
    this.children,
  });

  @override
  List<Object?> get props => [
        name,
        path,
        relPath,
        isDir,
        isGitignored,
        isCustomIgnored,
        children,
      ];
}
```

**Критерии приемки:**
- ✅ Entity создана
- ✅ Extends `Equatable`
- ✅ Все поля immutable (final)
- ✅ `props` включает все поля

---

### 6. Создать Backend DataSource

**Создать:** `lib/features/project_setup/data/datasources/backend_datasource.dart`

```dart
import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../core/platform/backend_bridge.dart';
import '../models/file_node_model.dart';

abstract class BackendDataSource {
  Future<List<FileNodeModel>> listFiles(String path);
}

class BackendDataSourceImpl implements BackendDataSource {
  final BackendBridge bridge;

  BackendDataSourceImpl({required this.bridge});

  @override
  Future<List<FileNodeModel>> listFiles(String path) async {
    try {
      final jsonString = bridge.listFiles(path);
      final decoded = jsonDecode(jsonString);

      // Check for error
      if (decoded is Map && decoded.containsKey('error')) {
        throw BackendException(decoded['error']);
      }

      // Parse array of FileNodes
      if (decoded is List) {
        return decoded
            .map((item) => FileNodeModel.fromJson(item))
            .toList();
      }

      throw BackendException('Unexpected response format');
    } catch (e) {
      if (e is BackendException) rethrow;
      throw BackendException('Failed to list files: $e');
    }
  }
}
```

**Критерии приемки:**
- ✅ DataSource создан
- ✅ Использует `BackendBridge`
- ✅ Парсит JSON ответ
- ✅ Обрабатывает ошибки (проверяет поле "error")
- ✅ Бросает `BackendException` при ошибках

---

### 7. Создать Repository Implementation

**Создать:** `lib/features/project_setup/data/repositories/project_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/file_node.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/backend_datasource.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final BackendDataSource backendDataSource;

  ProjectRepositoryImpl({required this.backendDataSource});

  @override
  Future<Either<Failure, List<FileNode>>> listFiles(String path) async {
    try {
      final models = await backendDataSource.listFiles(path);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on BackendException catch (e) {
      return Left(BackendFailure(e.message));
    } catch (e) {
      return Left(BackendFailure('Unexpected error: $e'));
    }
  }
}
```

**Критерии приемки:**
- ✅ Repository реализует интерфейс
- ✅ Использует `Either<Failure, Success>`
- ✅ Конвертирует exceptions в failures
- ✅ Конвертирует models в entities

---

### 8. Создать Repository Interface (Domain)

**Создать:** `lib/features/project_setup/domain/repositories/project_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/file_node.dart';

abstract class ProjectRepository {
  Future<Either<Failure, List<FileNode>>> listFiles(String path);
}
```

**Критерии приемки:**
- ✅ Интерфейс создан
- ✅ Возвращает `Either<Failure, T>`
- ✅ Не зависит от implementation details

---

### 9. Написать тесты

**Создать:** `test/core/platform/backend_bridge_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/core/platform/backend_bridge.dart';

void main() {
  late BackendBridge bridge;

  setUp(() {
    bridge = BackendBridge();
  });

  group('BackendBridge', () {
    test('should load library without throwing', () {
      expect(() => BackendBridge(), returnsNormally);
    });

    test('should call listFiles and return JSON', () {
      final result = bridge.listFiles('/tmp');
      expect(result, isA<String>());
      expect(result, isNotEmpty);
    });
  });
}
```

**Создать:** `test/features/project_setup/data/datasources/backend_datasource_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/exceptions.dart';
import 'package:shotgun_flutter/core/platform/backend_bridge.dart';
import 'package:shotgun_flutter/features/project_setup/data/datasources/backend_datasource.dart';

class MockBackendBridge extends Mock implements BackendBridge {}

void main() {
  late BackendDataSourceImpl dataSource;
  late MockBackendBridge mockBridge;

  setUp(() {
    mockBridge = MockBackendBridge();
    dataSource = BackendDataSourceImpl(bridge: mockBridge);
  });

  group('listFiles', () {
    const tPath = '/test/path';
    const tJsonResponse = '[{"name":"test","path":"/test","relPath":"test","isDir":true,"isGitignored":false,"isCustomIgnored":false}]';

    test('should return list of FileNodeModel when call is successful', () async {
      when(mockBridge.listFiles(any)).thenReturn(tJsonResponse);

      final result = await dataSource.listFiles(tPath);

      expect(result, isA<List>());
      expect(result.length, 1);
      expect(result[0].name, 'test');
    });

    test('should throw BackendException when response contains error', () async {
      when(mockBridge.listFiles(any)).thenReturn('{"error":"Something went wrong"}');

      expect(
        () async => await dataSource.listFiles(tPath),
        throwsA(isA<BackendException>()),
      );
    });
  });
}
```

**Создать:** `test/features/project_setup/data/repositories/project_repository_impl_test.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/exceptions.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/project_setup/data/datasources/backend_datasource.dart';
import 'package:shotgun_flutter/features/project_setup/data/models/file_node_model.dart';
import 'package:shotgun_flutter/features/project_setup/data/repositories/project_repository_impl.dart';

class MockBackendDataSource extends Mock implements BackendDataSource {}

void main() {
  late ProjectRepositoryImpl repository;
  late MockBackendDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockBackendDataSource();
    repository = ProjectRepositoryImpl(backendDataSource: mockDataSource);
  });

  group('listFiles', () {
    const tPath = '/test';
    final tModels = [
      FileNodeModel(
        name: 'test',
        path: '/test',
        relPath: 'test',
        isDir: true,
        isGitignored: false,
        isCustomIgnored: false,
      ),
    ];

    test('should return entities when datasource call is successful', () async {
      when(mockDataSource.listFiles(any)).thenAnswer((_) async => tModels);

      final result = await repository.listFiles(tPath);

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (entities) {
          expect(entities.length, 1);
          expect(entities[0].name, 'test');
        },
      );
    });

    test('should return BackendFailure when datasource throws BackendException', () async {
      when(mockDataSource.listFiles(any)).thenThrow(BackendException('error'));

      final result = await repository.listFiles(tPath);

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<BackendFailure>()),
        (_) => fail('Should not return success'),
      );
    });
  });
}
```

**Запустить:**
```bash
flutter test
```

**Критерии приемки:**
- ✅ Все тесты проходят
- ✅ Coverage для FFI bridge >80%
- ✅ Coverage для datasource >90%
- ✅ Coverage для repository >90%
- ✅ Моки используются правильно

---

### 10. Интеграционный тест (Flutter + Go)

**Создать:** `integration_test/backend_integration_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shotgun_flutter/core/platform/backend_bridge.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Backend Integration', () {
    late BackendBridge bridge;

    setUpAll(() {
      bridge = BackendBridge();
    });

    test('should list files from real filesystem', () {
      final result = bridge.listFiles('.');

      expect(result, isNotEmpty);
      expect(result, contains('name'));
      expect(result, contains('path'));
    });

    tearDownAll(() {
      bridge.dispose();
    });
  });
}
```

**Запустить:**
```bash
flutter test integration_test/backend_integration_test.dart
```

**Критерии приемки:**
- ✅ Интеграционный тест проходит
- ✅ Реальный вызов Go функции работает
- ✅ Нет memory leaks (проверить через Instruments/Valgrind)

---

## Критерии приемки Phase 1

### Обязательные

- ✅ Go библиотеки собираются для всех платформ
- ✅ FFI bridge загружает библиотеку
- ✅ `listFiles` вызывается и возвращает данные
- ✅ JSON парсинг работает корректно
- ✅ Ошибки обрабатываются правильно
- ✅ Memory management (нет утечек)
- ✅ Все unit тесты проходят (coverage >85%)
- ✅ Интеграционный тест проходит
- ✅ Clean Architecture соблюдена:
  - Domain не зависит от Data
  - Data реализует Domain интерфейсы
  - Models конвертируются в Entities

### Опциональные

- ⭐ Async/await для FFI вызовов (через Isolate)
- ⭐ Retry logic для failed calls
- ⭐ Caching для listFiles результатов

---

## Checklist

```
[ ] 1. Go bridge.go создан
[ ] 2. Build script работает, библиотеки собраны
[ ] 3. BackendBridge класс создан
[ ] 4. Data models с Freezed
[ ] 5. Domain entities созданы
[ ] 6. Backend datasource реализован
[ ] 7. Repository implementation создан
[ ] 8. Repository interface (domain) создан
[ ] 9. Unit тесты написаны и проходят
[ ] 10. Интеграционный тест проходит
[ ] ✅ Все критерии приемки выполнены
```

---

## Время выполнения

- Шаги 1-2: **2 дня** (Go подготовка и build)
- Шаги 3-5: **3 дня** (FFI bridge, models, entities)
- Шаги 6-8: **3 дня** (Datasource, repository)
- Шаги 9-10: **2 дня** (Тесты)

**Итого: 10 рабочих дней (2 недели)**

---

## Потенциальные проблемы

### 1. CGo недоступен
**Решение:** Установить GCC/Clang для платформы

### 2. Memory leaks
**Решение:**
- Всегда вызывать `FreeString` после получения результата
- Использовать `malloc.free()` для Dart pointers
- Проверять через Instruments (macOS) или Valgrind (Linux)

### 3. Platform-specific build issues
**Решение:**
- macOS: Universal binary или отдельные для Intel/ARM
- Windows: MinGW-w64 для кросс-компиляции
- Linux: стандартный GCC

### 4. JSON parsing errors
**Решение:**
- Строгая валидация JSON на Go стороне
- Try-catch в Dart при парсинге
- Unit тесты для всех edge cases
