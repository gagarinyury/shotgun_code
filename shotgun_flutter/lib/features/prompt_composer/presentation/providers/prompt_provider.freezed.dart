// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prompt_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PromptState {
  /// The project context (generated from files)
  String get context => throw _privateConstructorUsedError;

  /// The user's task description
  String get task => throw _privateConstructorUsedError;

  /// Custom rules to apply
  String get customRules => throw _privateConstructorUsedError;

  /// Available templates
  List<PromptTemplate> get templates => throw _privateConstructorUsedError;

  /// Currently selected template
  PromptTemplate? get selectedTemplate => throw _privateConstructorUsedError;

  /// The final composed prompt
  String get finalPrompt => throw _privateConstructorUsedError;

  /// Estimated token count
  int get estimatedTokens => throw _privateConstructorUsedError;

  /// Error message if any
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of PromptState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PromptStateCopyWith<PromptState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromptStateCopyWith<$Res> {
  factory $PromptStateCopyWith(
    PromptState value,
    $Res Function(PromptState) then,
  ) = _$PromptStateCopyWithImpl<$Res, PromptState>;
  @useResult
  $Res call({
    String context,
    String task,
    String customRules,
    List<PromptTemplate> templates,
    PromptTemplate? selectedTemplate,
    String finalPrompt,
    int estimatedTokens,
    String? errorMessage,
  });
}

/// @nodoc
class _$PromptStateCopyWithImpl<$Res, $Val extends PromptState>
    implements $PromptStateCopyWith<$Res> {
  _$PromptStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PromptState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
    Object? task = null,
    Object? customRules = null,
    Object? templates = null,
    Object? selectedTemplate = freezed,
    Object? finalPrompt = null,
    Object? estimatedTokens = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            context: null == context
                ? _value.context
                : context // ignore: cast_nullable_to_non_nullable
                      as String,
            task: null == task
                ? _value.task
                : task // ignore: cast_nullable_to_non_nullable
                      as String,
            customRules: null == customRules
                ? _value.customRules
                : customRules // ignore: cast_nullable_to_non_nullable
                      as String,
            templates: null == templates
                ? _value.templates
                : templates // ignore: cast_nullable_to_non_nullable
                      as List<PromptTemplate>,
            selectedTemplate: freezed == selectedTemplate
                ? _value.selectedTemplate
                : selectedTemplate // ignore: cast_nullable_to_non_nullable
                      as PromptTemplate?,
            finalPrompt: null == finalPrompt
                ? _value.finalPrompt
                : finalPrompt // ignore: cast_nullable_to_non_nullable
                      as String,
            estimatedTokens: null == estimatedTokens
                ? _value.estimatedTokens
                : estimatedTokens // ignore: cast_nullable_to_non_nullable
                      as int,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PromptStateImplCopyWith<$Res>
    implements $PromptStateCopyWith<$Res> {
  factory _$$PromptStateImplCopyWith(
    _$PromptStateImpl value,
    $Res Function(_$PromptStateImpl) then,
  ) = __$$PromptStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String context,
    String task,
    String customRules,
    List<PromptTemplate> templates,
    PromptTemplate? selectedTemplate,
    String finalPrompt,
    int estimatedTokens,
    String? errorMessage,
  });
}

/// @nodoc
class __$$PromptStateImplCopyWithImpl<$Res>
    extends _$PromptStateCopyWithImpl<$Res, _$PromptStateImpl>
    implements _$$PromptStateImplCopyWith<$Res> {
  __$$PromptStateImplCopyWithImpl(
    _$PromptStateImpl _value,
    $Res Function(_$PromptStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PromptState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? context = null,
    Object? task = null,
    Object? customRules = null,
    Object? templates = null,
    Object? selectedTemplate = freezed,
    Object? finalPrompt = null,
    Object? estimatedTokens = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$PromptStateImpl(
        context: null == context
            ? _value.context
            : context // ignore: cast_nullable_to_non_nullable
                  as String,
        task: null == task
            ? _value.task
            : task // ignore: cast_nullable_to_non_nullable
                  as String,
        customRules: null == customRules
            ? _value.customRules
            : customRules // ignore: cast_nullable_to_non_nullable
                  as String,
        templates: null == templates
            ? _value._templates
            : templates // ignore: cast_nullable_to_non_nullable
                  as List<PromptTemplate>,
        selectedTemplate: freezed == selectedTemplate
            ? _value.selectedTemplate
            : selectedTemplate // ignore: cast_nullable_to_non_nullable
                  as PromptTemplate?,
        finalPrompt: null == finalPrompt
            ? _value.finalPrompt
            : finalPrompt // ignore: cast_nullable_to_non_nullable
                  as String,
        estimatedTokens: null == estimatedTokens
            ? _value.estimatedTokens
            : estimatedTokens // ignore: cast_nullable_to_non_nullable
                  as int,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PromptStateImpl implements _PromptState {
  const _$PromptStateImpl({
    this.context = '',
    this.task = '',
    this.customRules = '',
    final List<PromptTemplate> templates = const [],
    this.selectedTemplate,
    this.finalPrompt = '',
    this.estimatedTokens = 0,
    this.errorMessage,
  }) : _templates = templates;

  /// The project context (generated from files)
  @override
  @JsonKey()
  final String context;

  /// The user's task description
  @override
  @JsonKey()
  final String task;

  /// Custom rules to apply
  @override
  @JsonKey()
  final String customRules;

  /// Available templates
  final List<PromptTemplate> _templates;

  /// Available templates
  @override
  @JsonKey()
  List<PromptTemplate> get templates {
    if (_templates is EqualUnmodifiableListView) return _templates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_templates);
  }

  /// Currently selected template
  @override
  final PromptTemplate? selectedTemplate;

  /// The final composed prompt
  @override
  @JsonKey()
  final String finalPrompt;

  /// Estimated token count
  @override
  @JsonKey()
  final int estimatedTokens;

  /// Error message if any
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'PromptState(context: $context, task: $task, customRules: $customRules, templates: $templates, selectedTemplate: $selectedTemplate, finalPrompt: $finalPrompt, estimatedTokens: $estimatedTokens, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromptStateImpl &&
            (identical(other.context, context) || other.context == context) &&
            (identical(other.task, task) || other.task == task) &&
            (identical(other.customRules, customRules) ||
                other.customRules == customRules) &&
            const DeepCollectionEquality().equals(
              other._templates,
              _templates,
            ) &&
            (identical(other.selectedTemplate, selectedTemplate) ||
                other.selectedTemplate == selectedTemplate) &&
            (identical(other.finalPrompt, finalPrompt) ||
                other.finalPrompt == finalPrompt) &&
            (identical(other.estimatedTokens, estimatedTokens) ||
                other.estimatedTokens == estimatedTokens) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    context,
    task,
    customRules,
    const DeepCollectionEquality().hash(_templates),
    selectedTemplate,
    finalPrompt,
    estimatedTokens,
    errorMessage,
  );

  /// Create a copy of PromptState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PromptStateImplCopyWith<_$PromptStateImpl> get copyWith =>
      __$$PromptStateImplCopyWithImpl<_$PromptStateImpl>(this, _$identity);
}

abstract class _PromptState implements PromptState {
  const factory _PromptState({
    final String context,
    final String task,
    final String customRules,
    final List<PromptTemplate> templates,
    final PromptTemplate? selectedTemplate,
    final String finalPrompt,
    final int estimatedTokens,
    final String? errorMessage,
  }) = _$PromptStateImpl;

  /// The project context (generated from files)
  @override
  String get context;

  /// The user's task description
  @override
  String get task;

  /// Custom rules to apply
  @override
  String get customRules;

  /// Available templates
  @override
  List<PromptTemplate> get templates;

  /// Currently selected template
  @override
  PromptTemplate? get selectedTemplate;

  /// The final composed prompt
  @override
  String get finalPrompt;

  /// Estimated token count
  @override
  int get estimatedTokens;

  /// Error message if any
  @override
  String? get errorMessage;

  /// Create a copy of PromptState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PromptStateImplCopyWith<_$PromptStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
