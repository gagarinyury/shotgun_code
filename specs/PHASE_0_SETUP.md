# Phase 0: Project Setup & Foundation

**Duration:** 1 week
**Goal:** Настроить Flutter проект с Clean Architecture, тестами и CI/CD

---

## Задача

Создать базовую структуру Flutter проекта с чистой архитектурой, настроить инфраструктуру для тестирования и автоматизации.

---

## Шаги выполнения

### 1. Создать Flutter проект

```bash
flutter create shotgun_flutter --org com.shotgun
cd shotgun_flutter
```

**Критерии приемки:**
- ✅ Проект создан
- ✅ `flutter run` запускается без ошибок
- ✅ Стандартный counter app работает

---

### 2. Создать структуру папок Clean Architecture

```
lib/
├── core/
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── platform/
│   └── utils/
├── features/
│   ├── project_setup/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   ├── prompt_composer/
│   ├── llm_executor/
│   └── patch_applier/
└── shared/
    └── widgets/
test/
├── core/
├── features/
└── fixtures/
```

**Критерии приемки:**
- ✅ Все папки созданы
- ✅ В каждой папке есть `.gitkeep` или dummy файл
- ✅ Структура соответствует Clean Architecture

---

### 3. Настроить pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

  # Functional Programming
  dartz: ^0.10.1

  # Value Equality
  equatable: ^2.0.5

  # Immutable Models
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0

  # Networking
  dio: ^5.4.0

  # Platform
  ffi: ^2.1.0

  # Utils
  path_provider: ^2.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Testing
  mockito: ^5.4.0

  # Code Generation
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  riverpod_generator: ^2.3.0

  # Linting
  flutter_lints: ^3.0.0
```

**Критерии приемки:**
- ✅ `flutter pub get` выполняется без ошибок
- ✅ Все зависимости установлены
- ✅ Версии пакетов актуальные

---

### 4. Настроить analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

  errors:
    invalid_annotation_target: ignore

  language:
    strict-casts: true
    strict-raw-types: true

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - always_declare_return_types
    - require_trailing_commas
    - avoid_print
    - avoid_unnecessary_containers
    - sized_box_for_whitespace
```

**Критерии приемки:**
- ✅ `flutter analyze` проходит без warnings
- ✅ Линтер находит проблемы в тестовом коде

---

### 5. Создать базовые классы core/error

**Файл:** `lib/core/error/failures.dart`

```dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class BackendFailure extends Failure {
  const BackendFailure(super.message);
}
```

**Файл:** `lib/core/error/exceptions.dart`

```dart
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}

class BackendException implements Exception {
  final String message;
  const BackendException(this.message);
}
```

**Критерии приемки:**
- ✅ Файлы созданы
- ✅ Классы компилируются без ошибок
- ✅ Equatable работает для Failure

---

### 6. Создать Logger

**Файл:** `lib/core/utils/logger.dart`

```dart
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  static void log(String message, {LogLevel level = LogLevel.info}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final prefix = _getPrefix(level);
      debugPrint('[$timestamp] $prefix $message');
    }
  }

  static String _getPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍 DEBUG:';
      case LogLevel.info:
        return 'ℹ️ INFO:';
      case LogLevel.warning:
        return '⚠️ WARNING:';
      case LogLevel.error:
        return '❌ ERROR:';
    }
  }

  static void debug(String message) => log(message, level: LogLevel.debug);
  static void info(String message) => log(message, level: LogLevel.info);
  static void warning(String message) => log(message, level: LogLevel.warning);
  static void error(String message) => log(message, level: LogLevel.error);
}
```

**Критерии приемки:**
- ✅ Logger работает в debug mode
- ✅ Логи не печатаются в release mode
- ✅ Все уровни логирования работают

---

### 7. Настроить тестовую инфраструктуру

**Файл:** `test/helpers/test_helper.dart`

```dart
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';

@GenerateMocks([
  Dio,
])
void main() {}
```

**Запустить:**
```bash
flutter pub run build_runner build
```

**Критерии приемки:**
- ✅ Моки генерируются без ошибок
- ✅ Файл `test/helpers/test_helper.mocks.dart` создан
- ✅ `flutter test` проходит

---

### 8. Создать тесты для core/error

**Файл:** `test/core/error/failures_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/core/error/failures.dart';

void main() {
  group('Failures', () {
    test('ServerFailure should be equal when messages are the same', () {
      const failure1 = ServerFailure('error');
      const failure2 = ServerFailure('error');

      expect(failure1, equals(failure2));
    });

    test('ServerFailure should not be equal when messages differ', () {
      const failure1 = ServerFailure('error1');
      const failure2 = ServerFailure('error2');

      expect(failure1, isNot(equals(failure2)));
    });
  });
}
```

**Файл:** `test/core/utils/logger_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/core/utils/logger.dart';

void main() {
  group('Logger', () {
    test('should log without throwing exceptions', () {
      expect(() => Logger.debug('test'), returnsNormally);
      expect(() => Logger.info('test'), returnsNormally);
      expect(() => Logger.warning('test'), returnsNormally);
      expect(() => Logger.error('test'), returnsNormally);
    });
  });
}
```

**Критерии приемки:**
- ✅ Все тесты проходят
- ✅ Coverage для core/error и core/utils = 100%
- ✅ `flutter test` успешен

---

### 9. Настроить CI/CD (GitHub Actions)

**Файл:** `.github/workflows/flutter_ci.yml`

```yaml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Run code generation
        run: flutter pub run build_runner build --delete-conflicting-outputs

      - name: Analyze code
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
```

**Критерии приемки:**
- ✅ Workflow файл создан
- ✅ CI запускается на push
- ✅ Все шаги проходят успешно
- ✅ Coverage загружается (если Codecov настроен)

---

### 10. Создать документацию

**Файл:** `docs/ARCHITECTURE.md`

```markdown
# Architecture

This project follows Clean Architecture principles.

## Layers

1. **Domain Layer** - Business logic, entities, use cases
2. **Data Layer** - Data sources, repositories, models
3. **Presentation Layer** - UI, state management, widgets

## Dependencies Rule

Domain ← Data ← Presentation
```

**Файл:** `docs/CONTRIBUTING.md`

```markdown
# Contributing

## Development Workflow

1. Create feature branch from `develop`
2. Make changes
3. Run tests: `flutter test`
4. Run analyzer: `flutter analyze`
5. Create Pull Request

## Code Style

- Follow `analysis_options.yaml`
- Add tests for all new features
- Keep coverage > 80%
```

**Критерии приемки:**
- ✅ Файлы созданы
- ✅ Документация понятна
- ✅ Содержит примеры кода

---

## Критерии приемки Phase 0

### Обязательные

- ✅ Проект запускается без ошибок
- ✅ Структура папок соответствует Clean Architecture
- ✅ Все зависимости установлены
- ✅ `flutter analyze` проходит без warnings
- ✅ `flutter test` проходит успешно
- ✅ CI/CD настроен и работает
- ✅ Coverage core/ = 100%
- ✅ Документация создана

### Опциональные

- ⭐ Coverage отображается в README
- ⭐ Badges в README (build status, coverage)
- ⭐ Pre-commit hooks настроены

---

## Checklist

```
[ ] 1. Flutter проект создан
[ ] 2. Структура папок Clean Architecture
[ ] 3. pubspec.yaml настроен
[ ] 4. analysis_options.yaml настроен
[ ] 5. core/error классы созданы
[ ] 6. Logger создан
[ ] 7. Тестовая инфраструктура настроена
[ ] 8. Тесты для core/ написаны
[ ] 9. CI/CD настроен
[ ] 10. Документация создана
[ ] ✅ Все критерии приемки выполнены
```

---

## Время выполнения

- Шаги 1-4: **1 день**
- Шаги 5-6: **1 день**
- Шаги 7-8: **2 дня**
- Шаги 9-10: **1 день**

**Итого: 5 рабочих дней**
