// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'llm_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$generateDiffWithLLMHash() =>
    r'1d6aecd86ecad244f9e46b0d7ca061b2d57a38f7';

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
String _$cancelGenerationHash() => r'746393396b179fc6d0e3c44a7dfb49399f81fe0d';

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
String _$lLMNotifierHash() => r'5b9ddfdb067b75c53f80c6b8c87df4f35426beab';

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
