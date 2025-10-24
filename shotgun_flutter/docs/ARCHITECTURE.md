# Architecture

This project follows **Clean Architecture** principles, separating concerns into distinct layers.

## Layers

### 1. Domain Layer (Business Logic)
- **Location:** `lib/features/*/domain/`
- **Purpose:** Contains pure business logic independent of frameworks
- **Components:**
  - **Entities:** Core business objects (e.g., `FileNode`, `Prompt`)
  - **Repositories:** Abstract interfaces defining data operations
  - **Use Cases:** Single-purpose business operations

**Rules:**
- ✅ No dependencies on other layers
- ✅ Pure Dart code (no Flutter imports)
- ✅ Contains business rules and entities

### 2. Data Layer (Data Sources & Implementation)
- **Location:** `lib/features/*/data/`
- **Purpose:** Implements domain interfaces, handles data operations
- **Components:**
  - **Models:** Data transfer objects with JSON serialization (`freezed`)
  - **Data Sources:** External data access (API, FFI, Cache)
  - **Repository Implementations:** Concrete implementations of domain repositories

**Rules:**
- ✅ Depends on Domain layer
- ✅ Converts exceptions to failures
- ✅ Converts models to entities

### 3. Presentation Layer (UI & State)
- **Location:** `lib/features/*/presentation/`
- **Purpose:** UI components and state management
- **Components:**
  - **Providers:** State management with Riverpod
  - **Screens:** Full-page UI components
  - **Widgets:** Reusable UI components

**Rules:**
- ✅ Depends on Domain layer
- ✅ Uses use cases for business logic
- ✅ Manages UI state with Riverpod

## Dependencies Rule

```
Domain ← Data ← Presentation
```

- Domain has **no dependencies**
- Data depends on **Domain only**
- Presentation depends on **Domain** (and indirectly on Data through DI)

## Core Module

**Location:** `lib/core/`

Shared utilities used across all features:
- **error:** Exception and Failure classes
- **network:** HTTP client wrappers
- **platform:** FFI bridges to native code
- **utils:** Logger, validators, helpers

## Data Flow

### Success Flow
```
UI (Widget)
  → Provider
    → Use Case
      → Repository Interface (Domain)
        → Repository Implementation (Data)
          → Data Source
            ← Returns Model
          ← Converts to Entity
        ← Returns Either<Failure, Entity>
      ← Processes result
    ← Updates state
  ← Rebuilds UI
```

### Error Flow
```
Data Source throws Exception
  → Repository catches and converts to Failure
    → Returns Left(Failure)
      → Use Case handles Failure
        → Provider updates error state
          → UI shows error message
```

## Example: Project Setup Feature

```
lib/features/project_setup/
├── domain/
│   ├── entities/
│   │   └── file_node.dart          # Pure business object
│   ├── repositories/
│   │   └── project_repository.dart # Interface
│   └── usecases/
│       └── list_files.dart         # Business operation
├── data/
│   ├── models/
│   │   └── file_node_model.dart    # JSON serializable
│   ├── datasources/
│   │   └── backend_datasource.dart # FFI calls
│   └── repositories/
│       └── project_repository_impl.dart # Implementation
└── presentation/
    ├── providers/
    │   └── project_provider.dart   # Riverpod state
    ├── screens/
    │   └── project_setup_screen.dart
    └── widgets/
        └── file_tree_widget.dart
```

## Testing Strategy

- **Unit Tests:** Each layer tested independently with mocks
- **Widget Tests:** UI components tested in isolation
- **Integration Tests:** Full feature flows tested end-to-end

**Coverage Goals:**
- Domain: **100%**
- Data: **>90%**
- Presentation: **>85%**

## State Management

Using **Riverpod 2.4+** for:
- Dependency injection
- State management
- Reactive updates

## Code Generation

Using **build_runner** for:
- `freezed`: Immutable models with copyWith
- `json_serializable`: JSON serialization
- `riverpod_generator`: Provider generation
- `mockito`: Test mocks

Run: `flutter pub run build_runner build --delete-conflicting-outputs`

## Conventions

- **Naming:**
  - Entities: `FileNode`
  - Models: `FileNodeModel`
  - Repositories: `ProjectRepository` (interface), `ProjectRepositoryImpl` (implementation)
  - Providers: `projectProvider`, `ProjectNotifier`

- **File Organization:**
  - One class per file
  - File name = class name in snake_case
  - Barrel exports in feature folders

- **Error Handling:**
  - Data layer throws `Exception`
  - Repository converts to `Failure`
  - Use `Either<Failure, T>` from `dartz`
