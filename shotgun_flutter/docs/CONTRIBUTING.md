# Contributing Guide

Thank you for contributing to Shotgun Flutter! This guide will help you get started.

## Development Workflow

### 1. Setup
```bash
cd shotgun_flutter
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Create Feature Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation updates
- `test/` - Test improvements

### 3. Make Changes

Follow the architecture:
- **Domain first:** Define entities, repositories, use cases
- **Data second:** Implement repositories, data sources, models
- **Presentation last:** Create UI, providers, widgets

### 4. Run Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/error/failures_test.dart

# Run with coverage
flutter test --coverage
```

### 5. Check Code Quality
```bash
# Analyze code
flutter analyze

# Format code
flutter format .

# Run code generation
flutter pub run build_runner build --delete-conflicting-outputs
```

### 6. Commit Changes

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Feature
git commit -m "feat: add file tree selection"

# Fix
git commit -m "fix: resolve memory leak in FFI bridge"

# Refactor
git commit -m "refactor: simplify repository error handling"

# Test
git commit -m "test: add tests for Logger utility"

# Docs
git commit -m "docs: update architecture guide"
```

### 7. Push and Create PR
```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

## Code Style

### Dart/Flutter Guidelines
- Follow `analysis_options.yaml` rules
- Use `const` constructors where possible
- Add trailing commas for better formatting
- Declare return types explicitly
- Avoid `print()` - use `Logger` instead

### Example
```dart
// ✅ Good
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 100,
      height: 100,
      child: Text('Hello'),
    );
  }
}

// ❌ Bad
class MyWidget extends StatelessWidget {
  MyWidget();

  @override
  build(context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Text('Hello')
    );
  }
}
```

## Testing Requirements

### Coverage Goals
- **Domain layer:** 100% coverage
- **Data layer:** >90% coverage
- **Presentation layer:** >85% coverage
- **Overall:** >85% coverage

### Test Types

#### 1. Unit Tests
Test individual classes/functions in isolation.

```dart
test('should return list of entities when datasource call is successful', () async {
  // Arrange
  when(mockDataSource.listFiles(any)).thenAnswer((_) async => tModels);

  // Act
  final result = await repository.listFiles(tPath);

  // Assert
  expect(result, isA<Right>());
  verify(mockDataSource.listFiles(tPath));
});
```

#### 2. Widget Tests
Test UI components.

```dart
testWidgets('should display file tree', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: FileTreeWidget(nodes: testNodes),
    ),
  );

  expect(find.text('test.dart'), findsOneWidget);
});
```

#### 3. Integration Tests
Test complete flows (in `integration_test/`).

```dart
testWidgets('full project setup flow', (tester) async {
  // Test entire user journey
});
```

## Common Tasks

### Adding a New Feature

1. Create folder structure:
```bash
mkdir -p lib/features/my_feature/{domain/{entities,repositories,usecases},data/{models,datasources,repositories},presentation/{providers,screens,widgets}}
```

2. Define domain layer (entities, repository interface, use cases)
3. Implement data layer (models, data sources, repository)
4. Create presentation layer (providers, screens, widgets)
5. Write tests for each layer

### Adding a New Dependency

```bash
flutter pub add package_name
```

Update `pubspec.yaml` with appropriate category comment.

### Generating Code

After adding `@freezed`, `@riverpod`, or JSON serialization:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running on Device

```bash
# List devices
flutter devices

# Run on specific device
flutter run -d device_id

# Run with hot reload
flutter run
# Press 'r' for hot reload
# Press 'R' for hot restart
```

## Pull Request Checklist

Before submitting a PR, ensure:

- [ ] Code follows style guide
- [ ] All tests pass (`flutter test`)
- [ ] No analyzer warnings (`flutter analyze`)
- [ ] Code is formatted (`flutter format .`)
- [ ] Coverage meets requirements (>85%)
- [ ] Documentation is updated
- [ ] Commit messages follow Conventional Commits
- [ ] PR description explains changes
- [ ] Related issues are linked

## Code Review Process

1. **Automated checks:** CI must pass
2. **Review:** At least one approval required
3. **Testing:** Reviewer tests changes locally
4. **Merge:** Squash and merge to maintain clean history

## Getting Help

- **Documentation:** Check `docs/` folder
- **Issues:** Search existing issues on GitHub
- **Questions:** Create a discussion on GitHub

## Architecture References

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Best Practices](https://docs.flutter.dev/testing/best-practices)
- [Riverpod Documentation](https://riverpod.dev/)

## License

By contributing, you agree that your contributions will be licensed under the project's license.
