// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_applier_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$backendBridgeHash() => r'1f7830696da56c28c24bc8ecad332a60aabbee41';

/// See also [backendBridge].
@ProviderFor(backendBridge)
final backendBridgeProvider = AutoDisposeProvider<BackendBridge>.internal(
  backendBridge,
  name: r'backendBridgeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backendBridgeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BackendBridgeRef = AutoDisposeProviderRef<BackendBridge>;
String _$patchRepositoryHash() => r'ccad818f17b8119f4f983b1f0e305ea72339924d';

/// See also [patchRepository].
@ProviderFor(patchRepository)
final patchRepositoryProvider = AutoDisposeProvider<PatchRepository>.internal(
  patchRepository,
  name: r'patchRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$patchRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PatchRepositoryRef = AutoDisposeProviderRef<PatchRepository>;
String _$gitRepositoryHash() => r'862613aaafd86e1a03cbe47186564cfbbcbe51f7';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [gitRepository].
@ProviderFor(gitRepository)
const gitRepositoryProvider = GitRepositoryFamily();

/// See also [gitRepository].
class GitRepositoryFamily extends Family<GitRepository> {
  /// See also [gitRepository].
  const GitRepositoryFamily();

  /// See also [gitRepository].
  GitRepositoryProvider call(String projectPath) {
    return GitRepositoryProvider(projectPath);
  }

  @override
  GitRepositoryProvider getProviderOverride(
    covariant GitRepositoryProvider provider,
  ) {
    return call(provider.projectPath);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'gitRepositoryProvider';
}

/// See also [gitRepository].
class GitRepositoryProvider extends AutoDisposeProvider<GitRepository> {
  /// See also [gitRepository].
  GitRepositoryProvider(String projectPath)
    : this._internal(
        (ref) => gitRepository(ref as GitRepositoryRef, projectPath),
        from: gitRepositoryProvider,
        name: r'gitRepositoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$gitRepositoryHash,
        dependencies: GitRepositoryFamily._dependencies,
        allTransitiveDependencies:
            GitRepositoryFamily._allTransitiveDependencies,
        projectPath: projectPath,
      );

  GitRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectPath,
  }) : super.internal();

  final String projectPath;

  @override
  Override overrideWith(
    GitRepository Function(GitRepositoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GitRepositoryProvider._internal(
        (ref) => create(ref as GitRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectPath: projectPath,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<GitRepository> createElement() {
    return _GitRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GitRepositoryProvider && other.projectPath == projectPath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectPath.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GitRepositoryRef on AutoDisposeProviderRef<GitRepository> {
  /// The parameter `projectPath` of this provider.
  String get projectPath;
}

class _GitRepositoryProviderElement
    extends AutoDisposeProviderElement<GitRepository>
    with GitRepositoryRef {
  _GitRepositoryProviderElement(super.provider);

  @override
  String get projectPath => (origin as GitRepositoryProvider).projectPath;
}

String _$applyPatchUseCaseHash() => r'ef0b6d54700c33d6aeeaa366e4f8e011e8e92d72';

/// See also [applyPatchUseCase].
@ProviderFor(applyPatchUseCase)
final applyPatchUseCaseProvider = AutoDisposeProvider<ApplyPatch>.internal(
  applyPatchUseCase,
  name: r'applyPatchUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$applyPatchUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApplyPatchUseCaseRef = AutoDisposeProviderRef<ApplyPatch>;
String _$splitPatchUseCaseHash() => r'bfa64890bf315f9592d189456548c8ee91a8ca14';

/// See also [splitPatchUseCase].
@ProviderFor(splitPatchUseCase)
final splitPatchUseCaseProvider = AutoDisposeProvider<SplitPatch>.internal(
  splitPatchUseCase,
  name: r'splitPatchUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$splitPatchUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SplitPatchUseCaseRef = AutoDisposeProviderRef<SplitPatch>;
String _$createCommitUseCaseHash() =>
    r'81fef688a5e153c42b30b93aca5e194d6e70a4cd';

/// See also [createCommitUseCase].
@ProviderFor(createCommitUseCase)
const createCommitUseCaseProvider = CreateCommitUseCaseFamily();

/// See also [createCommitUseCase].
class CreateCommitUseCaseFamily extends Family<CreateCommit> {
  /// See also [createCommitUseCase].
  const CreateCommitUseCaseFamily();

  /// See also [createCommitUseCase].
  CreateCommitUseCaseProvider call(String projectPath) {
    return CreateCommitUseCaseProvider(projectPath);
  }

  @override
  CreateCommitUseCaseProvider getProviderOverride(
    covariant CreateCommitUseCaseProvider provider,
  ) {
    return call(provider.projectPath);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createCommitUseCaseProvider';
}

/// See also [createCommitUseCase].
class CreateCommitUseCaseProvider extends AutoDisposeProvider<CreateCommit> {
  /// See also [createCommitUseCase].
  CreateCommitUseCaseProvider(String projectPath)
    : this._internal(
        (ref) =>
            createCommitUseCase(ref as CreateCommitUseCaseRef, projectPath),
        from: createCommitUseCaseProvider,
        name: r'createCommitUseCaseProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$createCommitUseCaseHash,
        dependencies: CreateCommitUseCaseFamily._dependencies,
        allTransitiveDependencies:
            CreateCommitUseCaseFamily._allTransitiveDependencies,
        projectPath: projectPath,
      );

  CreateCommitUseCaseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectPath,
  }) : super.internal();

  final String projectPath;

  @override
  Override overrideWith(
    CreateCommit Function(CreateCommitUseCaseRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateCommitUseCaseProvider._internal(
        (ref) => create(ref as CreateCommitUseCaseRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectPath: projectPath,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<CreateCommit> createElement() {
    return _CreateCommitUseCaseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateCommitUseCaseProvider &&
        other.projectPath == projectPath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectPath.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CreateCommitUseCaseRef on AutoDisposeProviderRef<CreateCommit> {
  /// The parameter `projectPath` of this provider.
  String get projectPath;
}

class _CreateCommitUseCaseProviderElement
    extends AutoDisposeProviderElement<CreateCommit>
    with CreateCommitUseCaseRef {
  _CreateCommitUseCaseProviderElement(super.provider);

  @override
  String get projectPath => (origin as CreateCommitUseCaseProvider).projectPath;
}

String _$rollbackChangesUseCaseHash() =>
    r'25a99e29dca34b10351c8489109ac012688f47ec';

/// See also [rollbackChangesUseCase].
@ProviderFor(rollbackChangesUseCase)
const rollbackChangesUseCaseProvider = RollbackChangesUseCaseFamily();

/// See also [rollbackChangesUseCase].
class RollbackChangesUseCaseFamily extends Family<RollbackChanges> {
  /// See also [rollbackChangesUseCase].
  const RollbackChangesUseCaseFamily();

  /// See also [rollbackChangesUseCase].
  RollbackChangesUseCaseProvider call(String projectPath) {
    return RollbackChangesUseCaseProvider(projectPath);
  }

  @override
  RollbackChangesUseCaseProvider getProviderOverride(
    covariant RollbackChangesUseCaseProvider provider,
  ) {
    return call(provider.projectPath);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rollbackChangesUseCaseProvider';
}

/// See also [rollbackChangesUseCase].
class RollbackChangesUseCaseProvider
    extends AutoDisposeProvider<RollbackChanges> {
  /// See also [rollbackChangesUseCase].
  RollbackChangesUseCaseProvider(String projectPath)
    : this._internal(
        (ref) => rollbackChangesUseCase(
          ref as RollbackChangesUseCaseRef,
          projectPath,
        ),
        from: rollbackChangesUseCaseProvider,
        name: r'rollbackChangesUseCaseProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$rollbackChangesUseCaseHash,
        dependencies: RollbackChangesUseCaseFamily._dependencies,
        allTransitiveDependencies:
            RollbackChangesUseCaseFamily._allTransitiveDependencies,
        projectPath: projectPath,
      );

  RollbackChangesUseCaseProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectPath,
  }) : super.internal();

  final String projectPath;

  @override
  Override overrideWith(
    RollbackChanges Function(RollbackChangesUseCaseRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RollbackChangesUseCaseProvider._internal(
        (ref) => create(ref as RollbackChangesUseCaseRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectPath: projectPath,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<RollbackChanges> createElement() {
    return _RollbackChangesUseCaseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RollbackChangesUseCaseProvider &&
        other.projectPath == projectPath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectPath.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RollbackChangesUseCaseRef on AutoDisposeProviderRef<RollbackChanges> {
  /// The parameter `projectPath` of this provider.
  String get projectPath;
}

class _RollbackChangesUseCaseProviderElement
    extends AutoDisposeProviderElement<RollbackChanges>
    with RollbackChangesUseCaseRef {
  _RollbackChangesUseCaseProviderElement(super.provider);

  @override
  String get projectPath =>
      (origin as RollbackChangesUseCaseProvider).projectPath;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
