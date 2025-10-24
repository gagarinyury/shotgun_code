// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generateDiffWithLLMHash() =>
    r'3acc2e750bfa7596b3fd777749121cb25f078b66';

/// See also [generateDiffWithLLM].
@ProviderFor(generateDiffWithLLM)
final generateDiffWithLLMProvider =
    AutoDisposeProvider<GenerateDiffWithLLM>.internal(
      generateDiffWithLLM,
      name: r'generateDiffWithLLMProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$generateDiffWithLLMHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GenerateDiffWithLLMRef = AutoDisposeProviderRef<GenerateDiffWithLLM>;
String _$cancelGenerationHash() => r'7c747bda8970e209d11417938a0b40f00d3985d9';

/// See also [cancelGeneration].
@ProviderFor(cancelGeneration)
final cancelGenerationProvider = AutoDisposeProvider<CancelGeneration>.internal(
  cancelGeneration,
  name: r'cancelGenerationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cancelGenerationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CancelGenerationRef = AutoDisposeProviderRef<CancelGeneration>;
String _$lLMNotifierHash() => r'd7bc369abd7d67ed15ab6fa74914fab5b8729501';

/// Provider for LLM generation state management
///
/// Copied from [LLMNotifier].
@ProviderFor(LLMNotifier)
final lLMNotifierProvider =
    AutoDisposeAsyncNotifierProvider<LLMNotifier, LLMState>.internal(
      LLMNotifier.new,
      name: r'lLMNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$lLMNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LLMNotifier = AutoDisposeAsyncNotifier<LLMState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
