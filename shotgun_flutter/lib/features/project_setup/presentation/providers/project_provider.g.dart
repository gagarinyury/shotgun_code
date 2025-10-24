// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$backendBridgeHash() => r'1f7830696da56c28c24bc8ecad332a60aabbee41';

/// Provides the BackendBridge singleton instance.
///
/// Copied from [backendBridge].
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
String _$backendDataSourceHash() => r'4fb8d4f83850c3726f27f2f29f1a8898e4f40384';

/// Provides the BackendDataSource implementation.
///
/// Copied from [backendDataSource].
@ProviderFor(backendDataSource)
final backendDataSourceProvider =
    AutoDisposeProvider<BackendDataSource>.internal(
      backendDataSource,
      name: r'backendDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$backendDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BackendDataSourceRef = AutoDisposeProviderRef<BackendDataSource>;
String _$projectRepositoryHash() => r'14356d19bc95139520e29946d010cca7029b02d3';

/// Provides the ProjectRepository implementation.
///
/// Copied from [projectRepository].
@ProviderFor(projectRepository)
final projectRepositoryProvider =
    AutoDisposeProvider<ProjectRepository>.internal(
      projectRepository,
      name: r'projectRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$projectRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProjectRepositoryRef = AutoDisposeProviderRef<ProjectRepository>;
String _$listFilesHash() => r'91fbaf9c2801df2e959b15d98928673cba3016ac';

/// Provides the ListFiles use case.
///
/// Copied from [listFiles].
@ProviderFor(listFiles)
final listFilesProvider = AutoDisposeProvider<ListFiles>.internal(
  listFiles,
  name: r'listFilesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$listFilesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ListFilesRef = AutoDisposeProviderRef<ListFiles>;
String _$generateContextHash() => r'6a1eedb3818b92b27af7e04e96c661bc72935f61';

/// Provides the GenerateContext use case.
///
/// Copied from [generateContext].
@ProviderFor(generateContext)
final generateContextProvider = AutoDisposeProvider<GenerateContext>.internal(
  generateContext,
  name: r'generateContextProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generateContextHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GenerateContextRef = AutoDisposeProviderRef<GenerateContext>;
String _$projectNotifierHash() => r'6f65202b20b17cf460cf42a700d00785d208d533';

/// Notifier for managing project state.
///
/// Copied from [ProjectNotifier].
@ProviderFor(ProjectNotifier)
final projectNotifierProvider =
    AutoDisposeNotifierProvider<ProjectNotifier, ProjectState>.internal(
      ProjectNotifier.new,
      name: r'projectNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$projectNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProjectNotifier = AutoDisposeNotifier<ProjectState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
