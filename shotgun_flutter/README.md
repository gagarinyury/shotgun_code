# Shotgun Flutter

Cross-platform Flutter UI for Shotgun Code - automated code generation with LLMs.

## 🎯 Project Status

**Phase 0: Complete** ✅
- Project setup
- Clean Architecture structure
- Core utilities (Logger, Error handling)
- Testing infrastructure
- CI/CD pipeline

**Next:** Phase 1 - Go Backend Integration (FFI)

## 📁 Project Structure

```
lib/
├── core/               # Shared utilities
│   ├── error/         # Failures and exceptions
│   ├── network/       # HTTP client
│   ├── platform/      # FFI bridges
│   └── utils/         # Logger, validators
├── features/          # Feature modules (Clean Architecture)
│   ├── project_setup/
│   ├── prompt_composer/
│   ├── llm_executor/
│   └── patch_applier/
└── shared/            # Shared widgets
```

## 🚀 Getting Started

### Prerequisites

- Flutter 3.16+ ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Dart 3.2+
- Go 1.21+ (for backend)

### Installation

```bash
cd shotgun_flutter
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Run Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Run Application

```bash
flutter run
```

## 🏗️ Architecture

This project follows **Clean Architecture** with three layers:

- **Domain:** Business logic, entities, use cases
- **Data:** Data sources, repositories, models
- **Presentation:** UI, state management, widgets

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for details.

## 🧪 Testing

Coverage goals:
- **Domain layer:** 100%
- **Data layer:** >90%
- **Presentation:** >85%
- **Overall:** >85%

Current coverage:
- **Core/Error:** 100%
- **Core/Utils:** 100%

## 📚 Documentation

- [Architecture Guide](docs/ARCHITECTURE.md)
- [Contributing Guide](docs/CONTRIBUTING.md)
- [Phase 0 Spec](../specs/PHASE_0_SETUP.md)
- [Phase 1 Spec](../specs/PHASE_1_GO_INTEGRATION.md)

## 🛠️ Tech Stack

- **Framework:** Flutter 3.16+
- **State Management:** Riverpod 2.4+
- **Functional Programming:** Dartz
- **Immutable Models:** Freezed
- **Networking:** Dio
- **FFI:** dart:ffi
- **Testing:** flutter_test, Mockito

## 🤝 Contributing

See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for development guidelines.

## 📋 Development Roadmap

- [x] **Phase 0:** Project Setup (1 week)
- [ ] **Phase 1:** Go Backend Integration - FFI (2 weeks)
- [ ] **Phase 2:** Project Setup Feature (2 weeks)
- [ ] **Phase 3:** Prompt Composer (2 weeks)
- [ ] **Phase 4:** LLM Executor (3 weeks)
- [ ] **Phase 5:** Patch Applier (3 weeks)
- [ ] **Phase 6:** Desktop Polish (2 weeks)
- [ ] **Phase 7:** Mobile Adaptation (3 weeks)
- [ ] **Phase 8:** Cloud Sync (2 weeks)
- [ ] **Phase 9:** Advanced Features (2 weeks)
- [ ] **Phase 10:** Release (1 week)

See [../FLUTTER_ROADMAP.md](../FLUTTER_ROADMAP.md) for full roadmap.

## 📄 License

[Add license information]
