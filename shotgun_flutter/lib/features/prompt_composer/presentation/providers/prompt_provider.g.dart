// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$promptLocalDataSourceHash() =>
    r'64068ad330096365e75f342a756f34d662d56b06';

/// Provides the PromptLocalDataSource singleton instance.
///
/// Copied from [promptLocalDataSource].
@ProviderFor(promptLocalDataSource)
final promptLocalDataSourceProvider =
    AutoDisposeProvider<PromptLocalDataSource>.internal(
      promptLocalDataSource,
      name: r'promptLocalDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$promptLocalDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PromptLocalDataSourceRef =
    AutoDisposeProviderRef<PromptLocalDataSource>;
String _$promptRepositoryHash() => r'0a65eceb4fdcc34850eaba84bc50503d716fc52e';

/// Provides the PromptRepository implementation.
///
/// Copied from [promptRepository].
@ProviderFor(promptRepository)
final promptRepositoryProvider = AutoDisposeProvider<PromptRepository>.internal(
  promptRepository,
  name: r'promptRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$promptRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PromptRepositoryRef = AutoDisposeProviderRef<PromptRepository>;
String _$composePromptHash() => r'ad389b3a1d64e310bd4e1223617a16c237d00028';

/// Provides the ComposePrompt use case.
///
/// Copied from [composePrompt].
@ProviderFor(composePrompt)
final composePromptProvider = AutoDisposeProvider<ComposePrompt>.internal(
  composePrompt,
  name: r'composePromptProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$composePromptHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ComposePromptRef = AutoDisposeProviderRef<ComposePrompt>;
String _$estimateTokensHash() => r'5a979732f1771f4567cc9222bbaae36d58cd20ee';

/// Provides the EstimateTokens use case.
///
/// Copied from [estimateTokens].
@ProviderFor(estimateTokens)
final estimateTokensProvider = AutoDisposeProvider<EstimateTokens>.internal(
  estimateTokens,
  name: r'estimateTokensProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$estimateTokensHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EstimateTokensRef = AutoDisposeProviderRef<EstimateTokens>;
String _$loadTemplatesHash() => r'df38e0d40d0d69a4de130db72cb344079c4df80a';

/// Provides the LoadTemplates use case.
///
/// Copied from [loadTemplates].
@ProviderFor(loadTemplates)
final loadTemplatesProvider = AutoDisposeProvider<LoadTemplates>.internal(
  loadTemplates,
  name: r'loadTemplatesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loadTemplatesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoadTemplatesRef = AutoDisposeProviderRef<LoadTemplates>;
String _$loadCustomRulesHash() => r'4c43dd978389eb23786c30ae603e74637c67d90a';

/// Provides the LoadCustomRules use case.
///
/// Copied from [loadCustomRules].
@ProviderFor(loadCustomRules)
final loadCustomRulesProvider = AutoDisposeProvider<LoadCustomRules>.internal(
  loadCustomRules,
  name: r'loadCustomRulesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loadCustomRulesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoadCustomRulesRef = AutoDisposeProviderRef<LoadCustomRules>;
String _$saveCustomRulesHash() => r'f8b65f55632ad216a1856b693a777ae9f7d3d78f';

/// Provides the SaveCustomRules use case.
///
/// Copied from [saveCustomRules].
@ProviderFor(saveCustomRules)
final saveCustomRulesProvider = AutoDisposeProvider<SaveCustomRules>.internal(
  saveCustomRules,
  name: r'saveCustomRulesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$saveCustomRulesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SaveCustomRulesRef = AutoDisposeProviderRef<SaveCustomRules>;
String _$promptNotifierHash() => r'7e4d68666a0f8d2e40a4bcdda24488925171b46b';

/// Notifier for managing prompt composition state.
///
/// Copied from [PromptNotifier].
@ProviderFor(PromptNotifier)
final promptNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PromptNotifier, PromptState>.internal(
      PromptNotifier.new,
      name: r'promptNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$promptNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PromptNotifier = AutoDisposeAsyncNotifier<PromptState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
