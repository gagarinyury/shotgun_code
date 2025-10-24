# Phase 8: Cloud Sync & Multi-Device

**Duration:** 2 weeks
**Goal:** Синхронизация contexts, settings, templates между устройствами через cloud

---

## ⚠️ ВАЛИДАЦИЯ ПОСЛЕ КАЖДОГО ШАГА

```bash
# 1. Анализ кода
flutter analyze
# Должно быть: 0 issues found

# 2. Запустить тесты
flutter test
# Должно быть: All tests passed!

# 3. Проверить на нескольких устройствах
flutter run -d ios         # Device 1
flutter run -d android     # Device 2
# Manual: изменить на Device 1 → проверить sync на Device 2

# 4. Проверить backend
# Firebase console / Supabase dashboard
# Должно быть: data syncs correctly

# 5. Проверить coverage
flutter test --coverage
lcov --summary coverage/lcov.info
# Должно быть: >85% для cloud sync features
```

**НЕ ПЕРЕХОДИ К СЛЕДУЮЩЕМУ ШАГУ, ПОКА:**
- ❌ Есть хотя бы одна ошибка в `flutter analyze`
- ❌ Есть failing tests
- ❌ Sync не работает между устройствами
- ❌ Conflicts не разрешаются
- ❌ Offline queue не работает

---

## Предварительные требования

- ✅ Phase 0-7 завершены
- ✅ Mobile version работает
- ✅ Firebase/Supabase project создан
- ✅ Authentication настроен

**Проверить перед началом:**
```bash
cd shotgun_flutter

# 1. Mobile version работает
flutter run -d ios
# Manual: пройти полный workflow

# 2. Firebase/Supabase setup
# Firebase: console.firebase.google.com
# Supabase: app.supabase.com
# Должен быть: project created

# 3. Добавить конфигурацию
ls ios/Runner/GoogleService-Info.plist        # Firebase iOS
ls android/app/google-services.json           # Firebase Android
# или
# Supabase URL и anon key в .env

# 4. Тесты проходят
flutter test test/  # All passed
```

---

## Шаги выполнения

### 1. Authentication - Domain Layer

**Создать:** `lib/features/auth/domain/entities/user.dart`

```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, createdAt];
}

class AuthState extends Equatable {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  const AuthState.initial()
      : user = null,
        isLoading = false,
        error = null;

  const AuthState.loading()
      : user = null,
        isLoading = true,
        error = null;

  AuthState.authenticated(User user)
      : user = user,
        isLoading = false,
        error = null;

  const AuthState.error(String error)
      : user = null,
        isLoading = false,
        error = error;

  @override
  List<Object?> get props => [user, isLoading, error];
}
```

**Создать:** `lib/features/auth/domain/repositories/auth_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle();

  /// Sign in with Apple
  Future<Either<Failure, User>> signInWithApple();

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Get current user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Stream of auth state changes
  Stream<User?> get authStateChanges;
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
ls lib/features/auth/domain/entities/user.dart
ls lib/features/auth/domain/repositories/auth_repository.dart
flutter analyze  # 0 issues
flutter test test/features/auth/domain/  # All passed
```

**Тесты:**
```dart
// test/features/auth/domain/entities/user_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/auth/domain/entities/user.dart';

void main() {
  group('User', () {
    test('should be equal when properties are the same', () {
      final user1 = User(
        id: '1',
        email: 'test@example.com',
        createdAt: DateTime(2024),
      );

      final user2 = User(
        id: '1',
        email: 'test@example.com',
        createdAt: DateTime(2024),
      );

      expect(user1, equals(user2));
    });
  });

  group('AuthState', () {
    test('initial state should have no user', () {
      const state = AuthState.initial();

      expect(state.user, isNull);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('loading state should have isLoading true', () {
      const state = AuthState.loading();

      expect(state.isLoading, true);
    });
  });
}
```

---

### 2. Firebase Authentication Implementation

**Добавить в pubspec.yaml:**
```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0
  google_sign_in: ^6.1.5
  sign_in_with_apple: ^5.0.0
```

**Создать:** `lib/features/auth/data/datasources/firebase_auth_datasource.dart`

```dart
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

class FirebaseAuthDataSource {
  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthDataSource({
    fb.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Sign in with email/password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw ServerException('User is null after sign in');
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseError(e.code));
    }
  }

  /// Sign up with email/password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw ServerException('User is null after sign up');
      }

      return UserModel.fromFirebaseUser(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw ServerException(_mapFirebaseError(e.code));
    }
  }

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw ServerException('Google sign in cancelled');
      }

      final googleAuth = await googleUser.authentication;

      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw ServerException('User is null after Google sign in');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw ServerException('Google sign in failed: $e');
    }
  }

  /// Sign in with Apple
  Future<UserModel> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = fb.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(oauthCredential);

      if (userCredential.user == null) {
        throw ServerException('User is null after Apple sign in');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw ServerException('Apple sign in failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Get current user
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  /// Stream of auth state changes
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(
          (user) => user != null ? UserModel.fromFirebaseUser(user) : null,
        );
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Authentication error: $code';
    }
  }
}
```

**Создать:** `lib/features/auth/data/models/user_model.dart`

```dart
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    required super.createdAt,
  });

  factory UserModel.fromFirebaseUser(fb.User user) {
    return UserModel(
      id: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  User toEntity() => this;
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter pub get
flutter analyze  # 0 issues
flutter run -d ios
# Manual: нажать "Sign in with Google" → OAuth flow
# Manual: успешная авторизация → вернуться в app
```

---

### 3. Cloud Sync - Firestore

**Создать:** `lib/features/sync/domain/entities/sync_item.dart`

```dart
import 'package:equatable/equatable.dart';

enum SyncItemType {
  context,
  template,
  settings,
}

class SyncItem extends Equatable {
  final String id;
  final SyncItemType type;
  final String userId;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  const SyncItem({
    required this.id,
    required this.type,
    required this.userId,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
  });

  @override
  List<Object?> get props => [id, type, userId, data, createdAt, updatedAt, synced];
}
```

**Создать:** `lib/features/sync/data/datasources/firestore_sync_datasource.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/sync_item_model.dart';
import '../../domain/entities/sync_item.dart';

class FirestoreSyncDataSource {
  final FirebaseFirestore _firestore;

  FirestoreSyncDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Upload context
  Future<void> uploadContext({
    required String userId,
    required String projectPath,
    required String context,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('contexts')
          .doc(_sanitizeProjectPath(projectPath));

      await docRef.set({
        'projectPath': projectPath,
        'context': context,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw ServerException('Failed to upload context: $e');
    }
  }

  /// Download context
  Future<String?> downloadContext({
    required String userId,
    required String projectPath,
  }) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('contexts')
          .doc(_sanitizeProjectPath(projectPath));

      final snapshot = await docRef.get();

      if (!snapshot.exists) return null;

      final data = snapshot.data();
      return data?['context'] as String?;
    } catch (e) {
      throw ServerException('Failed to download context: $e');
    }
  }

  /// Stream of contexts
  Stream<List<SyncItemModel>> watchContexts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('contexts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SyncItemModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Delete context
  Future<void> deleteContext({
    required String userId,
    required String projectPath,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('contexts')
          .doc(_sanitizeProjectPath(projectPath))
          .delete();
    } catch (e) {
      throw ServerException('Failed to delete context: $e');
    }
  }

  /// Sync settings
  Future<void> uploadSettings({
    required String userId,
    required Map<String, dynamic> settings,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'settings': settings,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw ServerException('Failed to upload settings: $e');
    }
  }

  /// Download settings
  Future<Map<String, dynamic>?> downloadSettings(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) return null;

      final data = doc.data();
      return data?['settings'] as Map<String, dynamic>?;
    } catch (e) {
      throw ServerException('Failed to download settings: $e');
    }
  }

  String _sanitizeProjectPath(String path) {
    // Firestore doc IDs cannot contain /
    return path.replaceAll('/', '_');
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter analyze  # 0 issues
flutter test test/features/sync/data/datasources/  # All passed
# Manual: Firebase console → check data is written
```

---

### 4. Conflict Resolution

**Создать:** `lib/features/sync/domain/services/conflict_resolver.dart`

```dart
import '../entities/sync_item.dart';

enum ConflictResolutionStrategy {
  useLocal,
  useRemote,
  useNewest,
  mergeData,
}

class ConflictResolver {
  /// Resolve conflict between local and remote items
  SyncItem resolveConflict({
    required SyncItem local,
    required SyncItem remote,
    ConflictResolutionStrategy strategy = ConflictResolutionStrategy.useNewest,
  }) {
    switch (strategy) {
      case ConflictResolutionStrategy.useLocal:
        return local;

      case ConflictResolutionStrategy.useRemote:
        return remote;

      case ConflictResolutionStrategy.useNewest:
        return local.updatedAt.isAfter(remote.updatedAt) ? local : remote;

      case ConflictResolutionStrategy.mergeData:
        return _mergeData(local, remote);
    }
  }

  SyncItem _mergeData(SyncItem local, SyncItem remote) {
    // Simple merge: take newest for each field
    final mergedData = <String, dynamic>{};

    // Merge data fields
    local.data.forEach((key, value) {
      mergedData[key] = value;
    });

    remote.data.forEach((key, value) {
      // If remote is newer, use remote value
      if (remote.updatedAt.isAfter(local.updatedAt)) {
        mergedData[key] = value;
      }
    });

    return SyncItem(
      id: local.id,
      type: local.type,
      userId: local.userId,
      data: mergedData,
      createdAt: local.createdAt,
      updatedAt: remote.updatedAt.isAfter(local.updatedAt)
          ? remote.updatedAt
          : local.updatedAt,
      synced: true,
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter test test/features/sync/domain/services/conflict_resolver_test.dart  # All passed
```

**Тесты:**
```dart
// test/features/sync/domain/services/conflict_resolver_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/sync/domain/services/conflict_resolver.dart';
import 'package:shotgun_flutter/features/sync/domain/entities/sync_item.dart';

void main() {
  late ConflictResolver resolver;

  setUp(() {
    resolver = ConflictResolver();
  });

  group('ConflictResolver', () {
    test('should use local when strategy is useLocal', () {
      final local = SyncItem(
        id: '1',
        type: SyncItemType.context,
        userId: 'user1',
        data: {'value': 'local'},
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      final remote = SyncItem(
        id: '1',
        type: SyncItemType.context,
        userId: 'user1',
        data: {'value': 'remote'},
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 3),
      );

      final result = resolver.resolveConflict(
        local: local,
        remote: remote,
        strategy: ConflictResolutionStrategy.useLocal,
      );

      expect(result, equals(local));
    });

    test('should use newest when strategy is useNewest', () {
      final local = SyncItem(
        id: '1',
        type: SyncItemType.context,
        userId: 'user1',
        data: {'value': 'local'},
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      final remote = SyncItem(
        id: '1',
        type: SyncItemType.context,
        userId: 'user1',
        data: {'value': 'remote'},
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 3),
      );

      final result = resolver.resolveConflict(
        local: local,
        remote: remote,
        strategy: ConflictResolutionStrategy.useNewest,
      );

      expect(result, equals(remote)); // Remote is newer
    });
  });
}
```

---

### 5. Sync Provider (Riverpod)

**Создать:** `lib/features/sync/presentation/providers/sync_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/sync_item.dart';
import '../../domain/repositories/sync_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  throw UnimplementedError('Provide implementation');
});

final syncStatusProvider = StateProvider<SyncStatus>((ref) {
  return SyncStatus.idle;
});

enum SyncStatus {
  idle,
  syncing,
  synced,
  error,
}

final syncProvider = StreamProvider<List<SyncItem>>((ref) {
  final user = ref.watch(authStateProvider).value;
  final repository = ref.watch(syncRepositoryProvider);

  if (user == null) {
    return Stream.value([]);
  }

  return repository.watchContexts(user.id);
});

class SyncNotifier extends StateNotifier<AsyncValue<void>> {
  final SyncRepository _repository;
  final String userId;

  SyncNotifier({
    required SyncRepository repository,
    required this.userId,
  })  : _repository = repository,
        super(const AsyncValue.data(null));

  Future<void> uploadContext({
    required String projectPath,
    required String context,
  }) async {
    state = const AsyncValue.loading();

    final result = await _repository.uploadContext(
      userId: userId,
      projectPath: projectPath,
      context: context,
    );

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }

  Future<String?> downloadContext(String projectPath) async {
    final result = await _repository.downloadContext(
      userId: userId,
      projectPath: projectPath,
    );

    return result.fold(
      (failure) => null,
      (context) => context,
    );
  }
}

final syncNotifierProvider =
    StateNotifierProvider.family<SyncNotifier, AsyncValue<void>, String>(
  (ref, userId) {
    final repository = ref.watch(syncRepositoryProvider);
    return SyncNotifier(repository: repository, userId: userId);
  },
);
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter analyze  # 0 issues
flutter run -d ios
# Manual: изменить context → проверить sync indicator
# Manual: открыть на другом устройстве → context синхронизирован
```

---

### 6. Sync UI Indicators

**Создать:** `lib/features/sync/presentation/widgets/sync_indicator.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sync_provider.dart';

class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(syncStatusProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _buildIndicator(syncStatus),
    );
  }

  Widget _buildIndicator(SyncStatus status) {
    switch (status) {
      case SyncStatus.idle:
        return const SizedBox.shrink();

      case SyncStatus.syncing:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Syncing...', style: TextStyle(fontSize: 12)),
          ],
        );

      case SyncStatus.synced:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_done, size: 16, color: Colors.green),
            SizedBox(width: 4),
            Text('Synced', style: TextStyle(fontSize: 12, color: Colors.green)),
          ],
        );

      case SyncStatus.error:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 16, color: Colors.red),
            SizedBox(width: 4),
            Text('Sync failed', style: TextStyle(fontSize: 12, color: Colors.red)),
          ],
        );
    }
  }
}
```

**Добавить в AppBar:**
```dart
AppBar(
  title: const Text('Project Setup'),
  actions: [
    const SyncIndicator(),
    const SizedBox(width: 16),
    // Other actions...
  ],
)
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d ios
# Manual: изменить данные → показать "Syncing..."
# Manual: после sync → показать "Synced" с зеленой галочкой
# Manual: offline → показать "Sync failed" с красным иконом
```

---

### 7. Manual Sync Button

**Обновить:** `lib/features/settings/presentation/screens/settings_screen.dart`

```dart
class SettingsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ... existing settings

          const Divider(),

          // Cloud Sync section
          ListTile(
            title: const Text('Cloud Sync'),
            subtitle: user != null
                ? Text('Signed in as ${user.email}')
                : const Text('Not signed in'),
          ),

          if (user != null) ...[
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Manual Sync'),
              subtitle: const Text('Sync contexts and settings now'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final notifier = ref.read(syncNotifierProvider(user.id).notifier);

                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                // Trigger sync
                await notifier.uploadContext(
                  projectPath: 'current_project',
                  context: 'current_context',
                );

                Navigator.of(context).pop();

                // Show success
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sync complete!')),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.cloud_off),
              title: const Text('Sign Out'),
              onTap: () async {
                await ref.read(authRepositoryProvider).signOut();
              },
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Sign In'),
              subtitle: const Text('Enable cloud sync'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to sign in screen
                context.go('/sign-in');
              },
            ),
          ],
        ],
      ),
    );
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d ios
# Manual: Settings → Manual Sync → нажать
# Manual: проверить loading indicator
# Manual: проверить success snackbar
# Manual: проверить Firebase console → data synced
```

---

### 8. Offline Queue

**Создать:** `lib/features/sync/data/datasources/offline_queue_datasource.dart`

```dart
import 'package:hive_flutter/hive_flutter.dart';

class OfflineQueueItem {
  final String id;
  final String type; // 'upload_context', 'delete_context', etc
  final Map<String, dynamic> data;
  final DateTime createdAt;

  OfflineQueueItem({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OfflineQueueItem.fromJson(Map<String, dynamic> json) {
    return OfflineQueueItem(
      id: json['id'],
      type: json['type'],
      data: Map<String, dynamic>.from(json['data']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class OfflineQueueDataSource {
  static const String _boxName = 'offline_queue';
  late Box<String> _box;

  Future<void> init() async {
    _box = await Hive.openBox<String>(_boxName);
  }

  /// Add item to queue
  Future<void> enqueue(OfflineQueueItem item) async {
    final json = item.toJson();
    await _box.put(item.id, jsonEncode(json));
  }

  /// Get all items in queue
  List<OfflineQueueItem> getAll() {
    return _box.values
        .map((jsonString) => OfflineQueueItem.fromJson(
              jsonDecode(jsonString),
            ))
        .toList();
  }

  /// Remove item from queue
  Future<void> dequeue(String id) async {
    await _box.delete(id);
  }

  /// Clear queue
  Future<void> clearQueue() async {
    await _box.clear();
  }

  /// Get queue size
  int get size => _box.length;
}
```

**Создать:** `lib/features/sync/domain/services/offline_sync_service.dart`

```dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/datasources/offline_queue_datasource.dart';
import '../../data/datasources/firestore_sync_datasource.dart';

class OfflineSyncService {
  final OfflineQueueDataSource _queueDataSource;
  final FirestoreSyncDataSource _firestoreDataSource;
  final Connectivity _connectivity;

  StreamSubscription? _connectivitySubscription;

  OfflineSyncService({
    required OfflineQueueDataSource queueDataSource,
    required FirestoreSyncDataSource firestoreDataSource,
    Connectivity? connectivity,
  })  : _queueDataSource = queueDataSource,
        _firestoreDataSource = firestoreDataSource,
        _connectivity = connectivity ?? Connectivity();

  /// Start watching connectivity and process queue when online
  void startWatching() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        if (result != ConnectivityResult.none) {
          _processQueue();
        }
      },
    );
  }

  /// Stop watching
  void stopWatching() {
    _connectivitySubscription?.cancel();
  }

  /// Process offline queue
  Future<void> _processQueue() async {
    final items = _queueDataSource.getAll();

    for (final item in items) {
      try {
        await _processQueueItem(item);
        await _queueDataSource.dequeue(item.id);
      } catch (e) {
        // Keep in queue, will retry later
        print('Failed to process queue item: $e');
      }
    }
  }

  Future<void> _processQueueItem(OfflineQueueItem item) async {
    switch (item.type) {
      case 'upload_context':
        await _firestoreDataSource.uploadContext(
          userId: item.data['userId'],
          projectPath: item.data['projectPath'],
          context: item.data['context'],
        );
        break;

      case 'delete_context':
        await _firestoreDataSource.deleteContext(
          userId: item.data['userId'],
          projectPath: item.data['projectPath'],
        );
        break;

      // Add other types as needed
    }
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
flutter run -d ios
# Manual: выключить WiFi/cellular
# Manual: изменить context → добавлено в offline queue
# Manual: включить WiFi → queue обработан, data synced
```

---

### 9. Multi-Device Testing

**Создать test script:**
```bash
#!/bin/bash
# test_multi_device.sh

echo "Testing multi-device sync..."

# Device 1: iOS
flutter run -d ios &
PID1=$!

# Wait for device 1 to start
sleep 10

# Device 2: Android
flutter run -d android &
PID2=$!

echo "Both devices running"
echo "iOS PID: $PID1"
echo "Android PID: $PID2"

echo "Manual testing steps:"
echo "1. Sign in on both devices with same account"
echo "2. On Device 1: create a context"
echo "3. On Device 2: check that context appears"
echo "4. On Device 2: modify context"
echo "5. On Device 1: check that changes sync"

read -p "Press enter to stop devices..."

kill $PID1
kill $PID2
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
# Manual multi-device testing
# 1. Sign in on iPhone
# 2. Sign in on Android (same account)
# 3. Create context on iPhone → appears on Android
# 4. Modify on Android → syncs to iPhone
# 5. Offline on iPhone → changes queued
# 6. Online on iPhone → changes synced
```

---

### 10. Security & Privacy

**Создать:** `lib/features/sync/domain/services/encryption_service.dart`

```dart
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  late encrypt.Key _key;
  late encrypt.IV _iv;
  late encrypt.Encrypter _encrypter;

  EncryptionService({String? customKey}) {
    if (customKey != null) {
      _key = encrypt.Key.fromUtf8(customKey.padRight(32, '0').substring(0, 32));
    } else {
      _key = encrypt.Key.fromSecureRandom(32);
    }

    _iv = encrypt.IV.fromLength(16);
    _encrypter = encrypt.Encrypter(encrypt.AES(_key));
  }

  /// Encrypt data before upload
  String encryptData(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypt data after download
  String decryptData(String encryptedText) {
    final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  /// Get encryption key (for storage)
  String getKeyString() {
    return base64.encode(_key.bytes);
  }
}
```

**Firestore Rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Contexts
      match /contexts/{contextId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

**✅ КРИТЕРИИ ПРИЕМКИ:**
```bash
# 1. Firestore Rules тестирование
# Firebase Console → Firestore → Rules → Test
# User A не может читать data User B

# 2. Encryption тестирование
flutter test test/features/sync/domain/services/encryption_service_test.dart
# Encrypted data не должен быть readable
```

---

## Критерии приемки Phase 8

### Обязательные

- ✅ Authentication работает (Email, Google, Apple)
- ✅ Cloud sync contexts работает (Firestore)
- ✅ Conflict resolution работает
- ✅ Sync indicators в UI
- ✅ Manual sync button работает
- ✅ Offline queue работает
- ✅ Multi-device sync проверен
- ✅ Security rules настроены
- ✅ Encryption работает (опционально)
- ✅ Все тесты проходят
- ✅ Coverage >85%
- ✅ flutter analyze = 0 issues

### Опциональные

- ⭐ End-to-end encryption
- ⭐ Selective sync (choose what to sync)
- ⭐ Sync history/versioning
- ⭐ Collaboration features

---

## Manual Testing Checklist

```
Authentication:
[ ] Sign up с email → успешно
[ ] Sign in с email → успешно
[ ] Sign in с Google → OAuth flow работает
[ ] Sign in с Apple → OAuth flow работает (iOS only)
[ ] Sign out → успешно

Cloud Sync:
[ ] Create context → synced to cloud
[ ] Modify context → synced to cloud
[ ] Delete context → synced to cloud
[ ] Open on Device 2 → context appears

Conflict Resolution:
[ ] Modify on Device 1 offline
[ ] Modify same on Device 2 online
[ ] Device 1 online → conflict resolved correctly

UI Indicators:
[ ] Syncing indicator появляется
[ ] Synced indicator с зеленой галочкой
[ ] Error indicator при failure

Offline Mode:
[ ] Offline → changes queued
[ ] Online → queue processed
[ ] Queue size indicator (опционально)

Security:
[ ] User A не видит data User B
[ ] Firestore rules работают
[ ] Encrypted data нечитаем (если encryption)
```

---

## Потенциальные проблемы

### 1. Firebase Setup сложен
**Решение:**
- Следовать официальной документации FlutterFire
- iOS: GoogleService-Info.plist в правильном месте
- Android: google-services.json в app/

### 2. OAuth flow не работает на iOS
**Решение:**
- Info.plist: добавить URL schemes
- Xcode: настроить Associated Domains (Apple Sign In)

### 3. Conflicts не разрешаются правильно
**Решение:**
- Использовать timestamps для "last write wins"
- Опционально: показывать user UI для выбора версии

### 4. Offline queue растет слишком быстро
**Решение:**
- Лимит на queue size (например, 100 items)
- Expire old items (>7 days)

### 5. Firestore costs высокие
**Решение:**
- Cache locally (Hive)
- Sync только при изменениях
- Batch operations

---

## Checklist

```
[ ] 1. Authentication - Domain Layer
[ ] 2. Firebase Authentication Implementation
[ ] 3. Cloud Sync - Firestore
[ ] 4. Conflict Resolution
[ ] 5. Sync Provider (Riverpod)
[ ] 6. Sync UI Indicators
[ ] 7. Manual Sync Button
[ ] 8. Offline Queue
[ ] 9. Multi-Device Testing
[ ] 10. Security & Privacy
[ ] ✅ Все критерии приемки выполнены
[ ] ✅ Multi-device testing пройден
```

---

## Время выполнения

- Шаги 1-2: **3 дня** (Authentication setup)
- Шаги 3-4: **3 дня** (Firestore + conflicts)
- Шаги 5-7: **2 дня** (UI integration)
- Шаги 8-10: **2 дня** (Offline + security)

**Итого: 10 рабочих дней (2 недели)**

---

## Следующая фаза

После завершения Phase 8, переходить к **Phase 9: Advanced Features & Optimization**.
