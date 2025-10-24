# Flutter UI Roadmap for Shotgun Code

> **Goal:** Create a cross-platform Flutter UI with Clean Architecture, full test coverage, and enhanced automation.

---

## Project Structure (Clean Architecture)

```
shotgun_flutter/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── error/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── network/
│   │   │   └── api_client.dart
│   │   ├── platform/
│   │   │   ├── backend_bridge.dart      # FFI to Go
│   │   │   └── platform_channels.dart
│   │   └── utils/
│   │       ├── logger.dart
│   │       └── validators.dart
│   ├── features/
│   │   ├── project_setup/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── backend_datasource.dart
│   │   │   │   │   └── cache_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   └── file_node_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── project_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── file_node.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── project_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── list_files.dart
│   │   │   │       ├── generate_context.dart
│   │   │   │       └── watch_file_changes.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── project_provider.dart
│   │   │       ├── screens/
│   │   │       │   └── project_setup_screen.dart
│   │   │       └── widgets/
│   │   │           ├── file_tree_widget.dart
│   │   │           └── progress_indicator_widget.dart
│   │   ├── prompt_composer/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── llm_executor/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── patch_applier/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   └── shared/
│       └── widgets/
├── test/
│   ├── core/
│   ├── features/
│   │   ├── project_setup/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── ...
│   └── fixtures/
└── integration_test/
```

---

## 📅 PHASE 0: Project Setup & Foundation

**Duration:** 1 week
**Goal:** Setup Flutter project, establish architecture patterns, and configure tooling.

### 0.1 Project Initialization

- [ ] **0.1.1** Create Flutter project with `flutter create shotgun_flutter`
- [ ] **0.1.2** Setup folder structure (Clean Architecture)
- [ ] **0.1.3** Configure `pubspec.yaml` with core dependencies
  ```yaml
  dependencies:
    flutter_riverpod: ^2.4.0
    freezed_annotation: ^2.4.0
    dartz: ^0.10.1
    equatable: ^2.0.5
    dio: ^5.4.0
    ffi: ^2.1.0

  dev_dependencies:
    flutter_test:
    mockito: ^5.4.0
    build_runner: ^2.4.0
    freezed: ^2.4.0
    riverpod_generator: ^2.3.0
  ```
- [ ] **0.1.4** Setup linting rules (`analysis_options.yaml`)
- [ ] **0.1.5** Configure CI/CD (GitHub Actions)
  - Unit tests
  - Integration tests
  - Code coverage (>80%)

### 0.2 Core Architecture Setup

- [ ] **0.2.1** Create base classes:
  - `core/error/failures.dart` - Base failure classes
  - `core/error/exceptions.dart` - Exception types
  - `core/network/api_client.dart` - HTTP client wrapper
- [ ] **0.2.2** Setup dependency injection container (Riverpod providers)
- [ ] **0.2.3** Create `core/utils/logger.dart` with log levels
- [ ] **0.2.4** Setup environment configuration (dev/prod)

### 0.3 Testing Infrastructure

- [ ] **0.3.1** Create test helpers and mocks base classes
- [ ] **0.3.2** Setup test fixtures directory with sample data
- [ ] **0.3.3** Configure integration test environment
- [ ] **0.3.4** Create mock Go backend for testing (REST API stub)

### 0.4 Documentation

- [ ] **0.4.1** Create `ARCHITECTURE.md` explaining Clean Architecture
- [ ] **0.4.2** Create `CONTRIBUTING.md` with dev guidelines
- [ ] **0.4.3** Setup ADR (Architecture Decision Records) directory
- [ ] **0.4.4** Document testing strategy

**Tests:**
- ✅ All core utilities have unit tests
- ✅ Logger tests
- ✅ Exception/Failure conversion tests
- ✅ CI/CD pipeline runs successfully

---

## 📅 PHASE 1: Go Backend Integration (FFI)

**Duration:** 2 weeks
**Goal:** Establish communication between Flutter and Go backend.

### 1.1 Go Backend API Preparation

- [ ] **1.1.1** Modify Go code to expose C-compatible functions
  ```go
  // backend/bridge.go
  //export ListFilesFFI
  func ListFilesFFI(pathCStr *C.char) *C.char {
      path := C.GoString(pathCStr)
      result := ListFiles(path)
      return C.CString(result)
  }
  ```
- [ ] **1.1.2** Create Go shared library build script
  ```bash
  # build_lib.sh
  go build -buildmode=c-shared -o libshotgun.so
  ```
- [ ] **1.1.3** Generate platform-specific binaries:
  - `libshotgun.so` (Linux)
  - `libshotgun.dylib` (macOS)
  - `shotgun.dll` (Windows)
- [ ] **1.1.4** Create header file (`shotgun.h`) for FFI bindings

### 1.2 Flutter FFI Bridge

- [ ] **1.2.1** Create `core/platform/backend_bridge.dart`
  ```dart
  class BackendBridge {
    late DynamicLibrary _lib;

    BackendBridge() {
      _lib = _loadLibrary();
    }

    DynamicLibrary _loadLibrary() {
      if (Platform.isAndroid || Platform.isLinux) {
        return DynamicLibrary.open('libshotgun.so');
      } else if (Platform.isIOS || Platform.isMacOS) {
        return DynamicLibrary.process();
      } else if (Platform.isWindows) {
        return DynamicLibrary.open('shotgun.dll');
      }
      throw UnsupportedError('Platform not supported');
    }
  }
  ```
- [ ] **1.2.2** Create FFI bindings for all Go functions:
  - `listFiles(String path)`
  - `generateContext(String rootDir, List<String> excluded)`
  - `splitDiff(String diff, int lineLimit)`
- [ ] **1.2.3** Implement memory management (free C strings)
- [ ] **1.2.4** Create error handling for FFI calls

### 1.3 Data Layer Implementation

- [ ] **1.3.1** Create `backend_datasource.dart` using FFI bridge
- [ ] **1.3.2** Implement data models with `freezed`:
  ```dart
  @freezed
  class FileNodeModel with _$FileNodeModel {
    factory FileNodeModel({
      required String name,
      required String path,
      required bool isDir,
      required bool isGitignored,
      List<FileNodeModel>? children,
    }) = _FileNodeModel;

    factory FileNodeModel.fromJson(Map<String, dynamic> json) =>
        _$FileNodeModelFromJson(json);
  }
  ```
- [ ] **1.3.3** Create JSON serialization/deserialization
- [ ] **1.3.4** Implement cache datasource with `hive`

### 1.4 Testing

- [ ] **1.4.1** Unit tests for FFI bridge
- [ ] **1.4.2** Unit tests for data models
- [ ] **1.4.3** Unit tests for datasources
- [ ] **1.4.4** Integration tests for Go ↔ Flutter communication
- [ ] **1.4.5** Memory leak tests (Valgrind/Instruments)

**Tests:**
- ✅ FFI bridge unit tests (>90% coverage)
- ✅ Data model serialization tests
- ✅ Integration tests with real Go backend
- ✅ No memory leaks detected

---

## 📅 PHASE 2: Feature - Project Setup (Step 1)

**Duration:** 2 weeks
**Goal:** Implement project selection, file tree display, and context generation.

### 2.1 Domain Layer

- [ ] **2.1.1** Create entities:
  - `domain/entities/file_node.dart`
  - `domain/entities/shotgun_context.dart`
  - `domain/entities/generation_progress.dart`
- [ ] **2.1.2** Create repository interface:
  ```dart
  abstract class ProjectRepository {
    Future<Either<Failure, List<FileNode>>> listFiles(String path);
    Stream<GenerationProgress> generateContext(String rootDir, List<String> excluded);
    Future<Either<Failure, void>> setUseGitignore(bool value);
  }
  ```
- [ ] **2.1.3** Create use cases:
  - `ListFiles` use case
  - `GenerateContext` use case
  - `WatchFileChanges` use case
  - `ToggleExclusion` use case

### 2.2 Data Layer

- [ ] **2.2.1** Implement `ProjectRepositoryImpl`
- [ ] **2.2.2** Create cache layer for file trees
- [ ] **2.2.3** Implement error mapping (Exception → Failure)
- [ ] **2.2.4** Add retry logic for failed operations

### 2.3 Presentation Layer

- [ ] **2.3.1** Create Riverpod providers:
  ```dart
  @riverpod
  class ProjectNotifier extends _$ProjectNotifier {
    @override
    Future<ProjectState> build() async {
      return ProjectState.initial();
    }

    Future<void> loadProject(String path) async { ... }
    Future<void> toggleExclusion(FileNode node) async { ... }
  }
  ```
- [ ] **2.3.2** Create `ProjectSetupScreen` with:
  - Folder picker button
  - File tree view
  - Exclusion controls (gitignore toggle, custom rules)
  - Progress indicator
- [ ] **2.3.3** Create widgets:
  - `FileTreeWidget` (recursive tree view with checkboxes)
  - `ExclusionPanel` (settings for exclusion rules)
  - `ProgressIndicatorWidget` (linear progress with stats)
- [ ] **2.3.4** Implement navigation to next step

### 2.4 Testing

- [ ] **2.4.1** Unit tests for entities
- [ ] **2.4.2** Unit tests for use cases (with mocked repository)
- [ ] **2.4.3** Unit tests for repository implementation
- [ ] **2.4.4** Unit tests for providers (with mocked use cases)
- [ ] **2.4.5** Widget tests for all widgets
- [ ] **2.4.6** Integration tests for full project setup flow

**Tests:**
- ✅ Domain layer: 100% coverage
- ✅ Data layer: >90% coverage
- ✅ Presentation: >85% coverage
- ✅ Integration test: Full Step 1 workflow

---

## 📅 PHASE 3: Feature - Prompt Composer (Step 2)

**Duration:** 2 weeks
**Goal:** Build UI for composing prompts with templates and token counting.

### 3.1 Domain Layer

- [ ] **3.1.1** Create entities:
  - `domain/entities/prompt.dart`
  - `domain/entities/prompt_template.dart`
  - `domain/entities/custom_rules.dart`
- [ ] **3.1.2** Create repository interface:
  ```dart
  abstract class PromptRepository {
    Future<Either<Failure, String>> composePrompt({
      required String context,
      required String task,
      required String rules,
      required PromptTemplate template,
    });
    Future<Either<Failure, int>> estimateTokens(String text);
  }
  ```
- [ ] **3.1.3** Create use cases:
  - `ComposePrompt` use case
  - `EstimateTokens` use case
  - `LoadTemplates` use case
  - `SaveCustomRules` use case

### 3.2 Data Layer

- [ ] **3.2.1** Implement `PromptRepositoryImpl`
- [ ] **3.2.2** Create local storage for templates and rules (Hive)
- [ ] **3.2.3** Implement token counter (tiktoken-dart or approximation)
- [ ] **3.2.4** Create prompt template parser

### 3.3 Presentation Layer

- [ ] **3.3.1** Create providers for prompt state
- [ ] **3.3.2** Create `PromptComposerScreen` with:
  - Task editor (multiline text field)
  - Rules editor (with modal for custom rules)
  - Template selector (dropdown)
  - Final prompt viewer (read-only, with token count)
  - Copy button
- [ ] **3.3.3** Create widgets:
  - `TaskEditor` (with syntax highlighting)
  - `RulesEditor` (with save/load)
  - `TokenCounter` (color-coded by limit)
  - `PromptViewer` (scrollable, selectable)
- [ ] **3.3.4** Implement navigation to Step 3

### 3.4 Testing

- [ ] **3.4.1** Unit tests for entities
- [ ] **3.4.2** Unit tests for use cases
- [ ] **3.4.3** Unit tests for repository
- [ ] **3.4.4** Unit tests for providers
- [ ] **3.4.5** Widget tests for all components
- [ ] **3.4.6** Integration tests for prompt composition flow
- [ ] **3.4.7** Token counter accuracy tests

**Tests:**
- ✅ Domain layer: 100% coverage
- ✅ Token estimation: ±5% accuracy
- ✅ Presentation: >85% coverage
- ✅ Integration test: Full Step 2 workflow

---

## 📅 PHASE 4: Feature - LLM Executor (Step 3)

**Duration:** 3 weeks
**Goal:** Integrate LLM APIs with streaming support and automatic diff splitting.

### 4.1 Domain Layer

- [ ] **4.1.1** Create entities:
  - `domain/entities/llm_config.dart` (API key, model, temperature)
  - `domain/entities/llm_response.dart`
  - `domain/entities/diff_split.dart`
- [ ] **4.1.2** Create repository interfaces:
  ```dart
  abstract class LLMRepository {
    Stream<String> generateDiff({
      required String prompt,
      required LLMConfig config,
    });
    Future<Either<Failure, void>> cancelGeneration();
  }

  abstract class DiffRepository {
    Future<Either<Failure, List<String>>> splitDiff(
      String diff,
      int lineLimit,
    );
  }
  ```
- [ ] **4.1.3** Create use cases:
  - `GenerateDiffWithLLM` use case
  - `CancelGeneration` use case
  - `SplitDiff` use case

### 4.2 Data Layer

- [ ] **4.2.1** Implement LLM datasources:
  - `GeminiDataSource` (Google AI)
  - `OpenAIDataSource` (GPT-4)
  - `ClaudeDataSource` (Anthropic)
- [ ] **4.2.2** Implement `LLMRepositoryImpl` with provider selection
- [ ] **4.2.3** Implement `DiffRepositoryImpl` (calls Go via FFI)
- [ ] **4.2.4** Add streaming support with proper error handling
- [ ] **4.2.5** Implement API key secure storage (flutter_secure_storage)

### 4.3 Presentation Layer

- [ ] **4.3.1** Create providers for LLM state
- [ ] **4.3.2** Create `LLMExecutorScreen` with:
  - LLM provider selector (Gemini, OpenAI, Claude)
  - API key input (with visibility toggle)
  - Model/temperature settings
  - Streaming response display (animated)
  - Cancel button
  - Status indicators (generating, complete, error)
- [ ] **4.3.3** Create widgets:
  - `StreamingResponseWidget` (auto-scroll, syntax highlighting)
  - `LLMConfigPanel` (settings drawer)
  - `GenerationStatusWidget` (progress + ETA)
- [ ] **4.3.4** Implement automatic diff splitting after generation
- [ ] **4.3.5** Add navigation to Step 4

### 4.4 Testing

- [ ] **4.4.1** Unit tests for entities
- [ ] **4.4.2** Unit tests for use cases (with mocked LLM responses)
- [ ] **4.4.3** Unit tests for each LLM datasource
- [ ] **4.4.4** Unit tests for repository implementations
- [ ] **4.4.5** Unit tests for providers
- [ ] **4.4.6** Widget tests for all components
- [ ] **4.4.7** Integration tests with mock LLM server
- [ ] **4.4.8** Error handling tests (network failures, timeout, invalid response)
- [ ] **4.4.9** Streaming tests (chunked responses)

**Tests:**
- ✅ Domain layer: 100% coverage
- ✅ Data layer: >90% coverage
- ✅ LLM integration tests with mock servers
- ✅ Streaming response tests
- ✅ Error handling tests
- ✅ Presentation: >85% coverage

---

## 📅 PHASE 5: Feature - Patch Applier (Step 4)

**Duration:** 3 weeks
**Goal:** Implement automatic patch application with conflict resolution and Git integration.

### 5.1 Domain Layer

- [ ] **5.1.1** Create entities:
  - `domain/entities/patch.dart`
  - `domain/entities/apply_result.dart`
  - `domain/entities/conflict.dart`
  - `domain/entities/git_commit.dart`
- [ ] **5.1.2** Create repository interfaces:
  ```dart
  abstract class PatchRepository {
    Future<Either<Failure, ApplyResult>> applyPatch(
      Patch patch,
      {bool dryRun = false}
    );
    Future<Either<Failure, List<Conflict>>> detectConflicts(Patch patch);
    Future<Either<Failure, Patch>> resolveConflict(
      Conflict conflict,
      String resolution,
    );
  }

  abstract class GitRepository {
    Future<Either<Failure, void>> createCommit(String message);
    Future<Either<Failure, void>> createBranch(String name);
    Future<Either<Failure, void>> rollback();
  }
  ```
- [ ] **5.1.3** Create use cases:
  - `ApplyPatch` use case
  - `ApplyAllPatches` use case
  - `DetectConflicts` use case
  - `ResolveConflict` use case
  - `CreateCommit` use case
  - `RollbackChanges` use case

### 5.2 Data Layer

- [ ] **5.2.1** Implement `PatchRepositoryImpl` (calls Go via FFI)
- [ ] **5.2.2** Implement `GitRepositoryImpl` using `libgit2dart`
- [ ] **5.2.3** Create conflict detection algorithm
- [ ] **5.2.4** Implement patch preview (dry-run mode)
- [ ] **5.2.5** Add file backup before applying patches

### 5.3 Presentation Layer

- [ ] **5.3.1** Create providers for patch application state
- [ ] **5.3.2** Create `PatchApplierScreen` with:
  - List of split diffs (expandable cards)
  - Patch preview (side-by-side diff viewer)
  - Apply button per patch
  - Apply all button
  - Conflict resolver UI (when conflicts detected)
  - Git commit UI
  - Rollback button
- [ ] **5.3.3** Create widgets:
  - `DiffPreviewWidget` (syntax-highlighted, side-by-side)
  - `ConflictResolverWidget` (interactive merge UI)
  - `ApplyProgressWidget` (multi-patch progress)
  - `GitCommitDialog` (commit message editor)
- [ ] **5.3.4** Implement success/error notifications
- [ ] **5.3.5** Add "Start Over" button to return to Step 1

### 5.4 Testing

- [ ] **5.4.1** Unit tests for entities
- [ ] **5.4.2** Unit tests for use cases
- [ ] **5.4.3** Unit tests for repository implementations
- [ ] **5.4.4** Unit tests for providers
- [ ] **5.4.5** Widget tests for all components
- [ ] **5.4.6** Integration tests for patch application
- [ ] **5.4.7** Conflict detection tests (various scenarios)
- [ ] **5.4.8** Rollback tests
- [ ] **5.4.9** Git integration tests

**Tests:**
- ✅ Domain layer: 100% coverage
- ✅ Data layer: >90% coverage
- ✅ Conflict detection: 100% accuracy on test cases
- ✅ Rollback functionality verified
- ✅ Presentation: >85% coverage
- ✅ Integration test: Full Step 4 workflow

---

## 📅 PHASE 6: Cross-Platform Polish & Desktop Features

**Duration:** 2 weeks
**Goal:** Optimize for desktop platforms, add keyboard shortcuts, and improve UX.

### 6.1 Desktop Optimization

- [ ] **6.1.1** Implement keyboard shortcuts:
  - `Cmd/Ctrl + O` - Open project
  - `Cmd/Ctrl + Enter` - Proceed to next step
  - `Cmd/Ctrl + C` - Copy context/prompt
  - `Cmd/Ctrl + Z` - Undo/rollback
- [ ] **6.1.2** Add menu bar (macOS/Windows)
- [ ] **6.1.3** Implement drag-and-drop for folder selection
- [ ] **6.1.4** Add right-click context menus in file tree
- [ ] **6.1.5** Optimize layout for large screens (>=1920x1080)

### 6.2 Advanced Features

- [ ] **6.2.1** Add search in file tree
- [ ] **6.2.2** Implement recent projects list
- [ ] **6.2.3** Add favorites/bookmarks for common rules
- [ ] **6.2.4** Create diff viewer with syntax highlighting
- [ ] **6.2.5** Add export context as file (.txt, .md)

### 6.3 Settings & Preferences

- [ ] **6.3.1** Create settings screen:
  - Default LLM provider
  - Default model/temperature
  - Theme (light/dark/system)
  - Font size
  - Auto-save preferences
- [ ] **6.3.2** Implement settings persistence (shared_preferences)
- [ ] **6.3.3** Add settings validation

### 6.4 Testing

- [ ] **6.4.1** Keyboard shortcut tests
- [ ] **6.4.2** Settings persistence tests
- [ ] **6.4.3** UI tests on different screen sizes
- [ ] **6.4.4** Accessibility tests (screen readers, high contrast)

**Tests:**
- ✅ All shortcuts work correctly
- ✅ Settings persist across app restarts
- ✅ UI responsive on all desktop resolutions
- ✅ WCAG 2.1 AA compliance

---

## 📅 PHASE 7: Mobile Adaptation

**Duration:** 3 weeks
**Goal:** Adapt UI for mobile devices, add touch gestures, and mobile-specific features.

### 7.1 UI Adaptation

- [ ] **7.1.1** Redesign navigation for mobile (bottom nav bar)
- [ ] **7.1.2** Optimize file tree for touch (larger tap targets)
- [ ] **7.1.3** Implement swipe gestures:
  - Swipe right - Go back
  - Swipe left - Go forward
  - Pull to refresh - Reload file tree
- [ ] **7.1.4** Adapt text editors for mobile keyboards
- [ ] **7.1.5** Responsive layouts (phone/tablet)

### 7.2 Mobile-Specific Features

- [ ] **7.2.1** Implement local storage access (Android/iOS)
- [ ] **7.2.2** Add share functionality (share context as text)
- [ ] **7.2.3** Implement camera integration (scan QR for API keys)
- [ ] **7.2.4** Add biometric authentication for API key access
- [ ] **7.2.5** Implement background task handling (long-running LLM calls)

### 7.3 Offline Mode

- [ ] **7.3.1** Cache generated contexts locally
- [ ] **7.3.2** Implement queue for LLM requests (when offline)
- [ ] **7.3.3** Add offline indicator in UI
- [ ] **7.3.4** Sync queued requests when back online

### 7.4 Testing

- [ ] **7.4.1** Widget tests for mobile layouts
- [ ] **7.4.2** Gesture recognition tests
- [ ] **7.4.3** Tests on real devices (Android + iOS)
- [ ] **7.4.4** Battery usage tests
- [ ] **7.4.5** Offline mode tests

**Tests:**
- ✅ UI works on phones (5.5"+ screens)
- ✅ UI works on tablets
- ✅ All gestures recognized correctly
- ✅ Offline mode functional
- ✅ Battery usage acceptable (<5% per hour active use)

---

## 📅 PHASE 8: Cloud Sync & Multi-Device

**Duration:** 2 weeks
**Goal:** Add cloud sync for contexts, settings, and templates across devices.

### 8.1 Backend Setup

- [ ] **8.1.1** Choose backend (Firebase, Supabase, or custom)
- [ ] **8.1.2** Setup authentication (email/Google/Apple)
- [ ] **8.1.3** Create database schema:
  - Users
  - Projects (contexts, settings)
  - Templates (shared/private)
- [ ] **8.1.4** Implement API endpoints

### 8.2 Flutter Integration

- [ ] **8.2.1** Create authentication flow (login/signup/logout)
- [ ] **8.2.2** Implement sync repository:
  ```dart
  abstract class SyncRepository {
    Future<Either<Failure, void>> uploadContext(ShotgunContext context);
    Stream<ShotgunContext> watchContexts();
    Future<Either<Failure, void>> syncSettings();
  }
  ```
- [ ] **8.2.3** Add sync indicators in UI
- [ ] **8.2.4** Implement conflict resolution (local vs cloud)
- [ ] **8.2.5** Add manual sync button

### 8.3 Testing

- [ ] **8.3.1** Unit tests for sync repository
- [ ] **8.3.2** Integration tests with mock backend
- [ ] **8.3.3** Multi-device sync tests
- [ ] **8.3.4** Conflict resolution tests
- [ ] **8.3.5** Network failure recovery tests

**Tests:**
- ✅ Sync repository: >90% coverage
- ✅ Data syncs correctly across devices
- ✅ Conflicts resolved properly
- ✅ Works with poor network conditions

---

## 📅 PHASE 9: Advanced Features & Optimization

**Duration:** 2 weeks
**Goal:** Add power-user features and optimize performance.

### 9.1 Advanced Features

- [ ] **9.1.1** Add batch processing (multiple projects)
- [ ] **9.1.2** Implement custom LLM endpoints (self-hosted models)
- [ ] **9.1.3** Add webhooks for notifications
- [ ] **9.1.4** Create CLI mode (for CI/CD pipelines)
- [ ] **9.1.5** Add plugin system for custom processors

### 9.2 Performance Optimization

- [ ] **9.2.1** Profile app performance (Flutter DevTools)
- [ ] **9.2.2** Optimize file tree rendering (virtual scrolling)
- [ ] **9.2.3** Reduce app bundle size (code splitting)
- [ ] **9.2.4** Optimize memory usage (image caching, lazy loading)
- [ ] **9.2.5** Reduce startup time (<2 seconds)

### 9.3 Monitoring & Analytics

- [ ] **9.3.1** Add crash reporting (Sentry/Firebase Crashlytics)
- [ ] **9.3.2** Implement anonymous usage analytics
- [ ] **9.3.3** Add performance monitoring
- [ ] **9.3.4** Create admin dashboard for metrics

### 9.4 Testing

- [ ] **9.4.1** Performance benchmarks
- [ ] **9.4.2** Load tests (large projects >10k files)
- [ ] **9.4.3** Memory leak detection
- [ ] **9.4.4** Battery usage tests

**Tests:**
- ✅ App starts in <2 seconds
- ✅ Handles 10k+ files without lag
- ✅ Memory usage <200MB average
- ✅ No memory leaks detected

---

## 📅 PHASE 10: Documentation & Release

**Duration:** 1 week
**Goal:** Finalize documentation, create release builds, and publish.

### 10.1 Documentation

- [ ] **10.1.1** Update `README.md` with:
  - Installation instructions
  - Quick start guide
  - Screenshots/GIFs
- [ ] **10.1.2** Create user documentation:
  - Step-by-step tutorials
  - FAQ
  - Troubleshooting guide
- [ ] **10.1.3** Create developer documentation:
  - Architecture overview
  - Contributing guide
  - API documentation (Dart docs)
- [ ] **10.1.4** Create video tutorials

### 10.2 Release Preparation

- [ ] **10.2.1** Code review (full codebase audit)
- [ ] **10.2.2** Security audit (dependencies, API keys)
- [ ] **10.2.3** Create release builds:
  - macOS (Intel + Apple Silicon)
  - Windows (x64)
  - Linux (AppImage, deb, rpm)
  - Android APK/AAB
  - iOS IPA
- [ ] **10.2.4** Setup app signing (all platforms)
- [ ] **10.2.5** Create installers (DMG, MSI, etc.)

### 10.3 Distribution

- [ ] **10.3.1** Publish to:
  - GitHub Releases
  - Mac App Store
  - Microsoft Store
  - Google Play Store
  - Apple App Store
- [ ] **10.3.2** Create landing page (website)
- [ ] **10.3.3** Write launch blog post
- [ ] **10.3.4** Setup support channels (Discord, GitHub Discussions)

### 10.4 Testing

- [ ] **10.4.1** Beta testing with users (20+ testers)
- [ ] **10.4.2** Final QA pass on all platforms
- [ ] **10.4.3** Accessibility testing
- [ ] **10.4.4** Performance testing on low-end devices

**Tests:**
- ✅ All platforms tested by real users
- ✅ No critical bugs reported
- ✅ Documentation is clear and complete
- ✅ App approved by all app stores

---

## 📊 Test Coverage Goals

| Layer | Coverage Goal | Current |
|-------|--------------|---------|
| **Domain (Entities)** | 100% | - |
| **Domain (Use Cases)** | 100% | - |
| **Data (Repositories)** | >90% | - |
| **Data (Data Sources)** | >85% | - |
| **Presentation (Providers)** | >85% | - |
| **Presentation (Widgets)** | >80% | - |
| **Integration Tests** | All critical flows | - |

---

## 🎯 Success Metrics

### Technical Metrics
- ✅ Code coverage: >85% overall
- ✅ Zero critical bugs
- ✅ App startup: <2 seconds
- ✅ Memory usage: <200MB average
- ✅ Crash-free rate: >99.9%

### User Metrics
- ✅ User onboarding: <5 minutes to first successful workflow
- ✅ Average workflow completion: <10 minutes
- ✅ User satisfaction: >4.5/5 stars
- ✅ Daily active users: 100+ (month 1)

---

## 🛠️ Tech Stack Summary

### Core
- **Flutter**: 3.16+
- **Dart**: 3.2+
- **Go**: 1.21+ (backend)

### State Management
- **Riverpod**: 2.4+
- **Freezed**: 2.4+ (immutable models)

### Networking
- **Dio**: 5.4+ (HTTP client)
- **FFI**: 2.1+ (Go bridge)

### Storage
- **Hive**: 2.2+ (local cache)
- **SharedPreferences**: 2.2+ (settings)
- **FlutterSecureStorage**: 9.0+ (API keys)

### LLM
- **GoogleGenerativeAI**: 0.2+ (Gemini)
- **OpenAIDart**: 1.0+ (GPT)

### Git
- **Libgit2dart**: 1.0+

### Testing
- **Mockito**: 5.4+
- **FlutterTest**: (built-in)
- **IntegrationTest**: (built-in)

---

## 📝 Notes

- Each phase builds on previous phases - do not skip
- All tests must pass before moving to next phase
- Code reviews required for each feature
- Update documentation as features are added
- Follow [Conventional Commits](https://www.conventionalcommits.org/) for all commits

---

**Estimated Total Duration: 20-24 weeks (5-6 months)**

**Team Size Recommendation:**
- 2-3 Flutter developers
- 1 Go developer (backend)
- 1 QA engineer
- 1 Designer (part-time)
