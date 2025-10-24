// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'llm_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LLMState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String response) generating,
    required TResult Function(String diff) completed,
    required TResult Function() cancelled,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String response)? generating,
    TResult? Function(String diff)? completed,
    TResult? Function()? cancelled,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String response)? generating,
    TResult Function(String diff)? completed,
    TResult Function()? cancelled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialState value) initial,
    required TResult Function(_GeneratingState value) generating,
    required TResult Function(_CompletedState value) completed,
    required TResult Function(_CancelledState value) cancelled,
    required TResult Function(_ErrorState value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialState value)? initial,
    TResult? Function(_GeneratingState value)? generating,
    TResult? Function(_CompletedState value)? completed,
    TResult? Function(_CancelledState value)? cancelled,
    TResult? Function(_ErrorState value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialState value)? initial,
    TResult Function(_GeneratingState value)? generating,
    TResult Function(_CompletedState value)? completed,
    TResult Function(_CancelledState value)? cancelled,
    TResult Function(_ErrorState value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LLMStateCopyWith<$Res> {
  factory $LLMStateCopyWith(LLMState value, $Res Function(LLMState) then) =
      _$LLMStateCopyWithImpl<$Res, LLMState>;
}

/// @nodoc
class _$LLMStateCopyWithImpl<$Res, $Val extends LLMState>
    implements $LLMStateCopyWith<$Res> {
  _$LLMStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialStateImplCopyWith<$Res> {
  factory _$$InitialStateImplCopyWith(
    _$InitialStateImpl value,
    $Res Function(_$InitialStateImpl) then,
  ) = __$$InitialStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialStateImplCopyWithImpl<$Res>
    extends _$LLMStateCopyWithImpl<$Res, _$InitialStateImpl>
    implements _$$InitialStateImplCopyWith<$Res> {
  __$$InitialStateImplCopyWithImpl(
    _$InitialStateImpl _value,
    $Res Function(_$InitialStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialStateImpl implements _InitialState {
  const _$InitialStateImpl();

  @override
  String toString() {
    return 'LLMState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String response) generating,
    required TResult Function(String diff) completed,
    required TResult Function() cancelled,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String response)? generating,
    TResult? Function(String diff)? completed,
    TResult? Function()? cancelled,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String response)? generating,
    TResult Function(String diff)? completed,
    TResult Function()? cancelled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialState value) initial,
    required TResult Function(_GeneratingState value) generating,
    required TResult Function(_CompletedState value) completed,
    required TResult Function(_CancelledState value) cancelled,
    required TResult Function(_ErrorState value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialState value)? initial,
    TResult? Function(_GeneratingState value)? generating,
    TResult? Function(_CompletedState value)? completed,
    TResult? Function(_CancelledState value)? cancelled,
    TResult? Function(_ErrorState value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialState value)? initial,
    TResult Function(_GeneratingState value)? generating,
    TResult Function(_CompletedState value)? completed,
    TResult Function(_CancelledState value)? cancelled,
    TResult Function(_ErrorState value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _InitialState implements LLMState {
  const factory _InitialState() = _$InitialStateImpl;
}

/// @nodoc
abstract class _$$GeneratingStateImplCopyWith<$Res> {
  factory _$$GeneratingStateImplCopyWith(
    _$GeneratingStateImpl value,
    $Res Function(_$GeneratingStateImpl) then,
  ) = __$$GeneratingStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String response});
}

/// @nodoc
class __$$GeneratingStateImplCopyWithImpl<$Res>
    extends _$LLMStateCopyWithImpl<$Res, _$GeneratingStateImpl>
    implements _$$GeneratingStateImplCopyWith<$Res> {
  __$$GeneratingStateImplCopyWithImpl(
    _$GeneratingStateImpl _value,
    $Res Function(_$GeneratingStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? response = null}) {
    return _then(
      _$GeneratingStateImpl(
        response: null == response
            ? _value.response
            : response // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GeneratingStateImpl implements _GeneratingState {
  const _$GeneratingStateImpl({required this.response});

  @override
  final String response;

  @override
  String toString() {
    return 'LLMState.generating(response: $response)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeneratingStateImpl &&
            (identical(other.response, response) ||
                other.response == response));
  }

  @override
  int get hashCode => Object.hash(runtimeType, response);

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeneratingStateImplCopyWith<_$GeneratingStateImpl> get copyWith =>
      __$$GeneratingStateImplCopyWithImpl<_$GeneratingStateImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String response) generating,
    required TResult Function(String diff) completed,
    required TResult Function() cancelled,
    required TResult Function(String message) error,
  }) {
    return generating(response);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String response)? generating,
    TResult? Function(String diff)? completed,
    TResult? Function()? cancelled,
    TResult? Function(String message)? error,
  }) {
    return generating?.call(response);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String response)? generating,
    TResult Function(String diff)? completed,
    TResult Function()? cancelled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (generating != null) {
      return generating(response);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialState value) initial,
    required TResult Function(_GeneratingState value) generating,
    required TResult Function(_CompletedState value) completed,
    required TResult Function(_CancelledState value) cancelled,
    required TResult Function(_ErrorState value) error,
  }) {
    return generating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialState value)? initial,
    TResult? Function(_GeneratingState value)? generating,
    TResult? Function(_CompletedState value)? completed,
    TResult? Function(_CancelledState value)? cancelled,
    TResult? Function(_ErrorState value)? error,
  }) {
    return generating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialState value)? initial,
    TResult Function(_GeneratingState value)? generating,
    TResult Function(_CompletedState value)? completed,
    TResult Function(_CancelledState value)? cancelled,
    TResult Function(_ErrorState value)? error,
    required TResult orElse(),
  }) {
    if (generating != null) {
      return generating(this);
    }
    return orElse();
  }
}

abstract class _GeneratingState implements LLMState {
  const factory _GeneratingState({required final String response}) =
      _$GeneratingStateImpl;

  String get response;

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeneratingStateImplCopyWith<_$GeneratingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CompletedStateImplCopyWith<$Res> {
  factory _$$CompletedStateImplCopyWith(
    _$CompletedStateImpl value,
    $Res Function(_$CompletedStateImpl) then,
  ) = __$$CompletedStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String diff});
}

/// @nodoc
class __$$CompletedStateImplCopyWithImpl<$Res>
    extends _$LLMStateCopyWithImpl<$Res, _$CompletedStateImpl>
    implements _$$CompletedStateImplCopyWith<$Res> {
  __$$CompletedStateImplCopyWithImpl(
    _$CompletedStateImpl _value,
    $Res Function(_$CompletedStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? diff = null}) {
    return _then(
      _$CompletedStateImpl(
        diff: null == diff
            ? _value.diff
            : diff // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CompletedStateImpl implements _CompletedState {
  const _$CompletedStateImpl({required this.diff});

  @override
  final String diff;

  @override
  String toString() {
    return 'LLMState.completed(diff: $diff)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletedStateImpl &&
            (identical(other.diff, diff) || other.diff == diff));
  }

  @override
  int get hashCode => Object.hash(runtimeType, diff);

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletedStateImplCopyWith<_$CompletedStateImpl> get copyWith =>
      __$$CompletedStateImplCopyWithImpl<_$CompletedStateImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String response) generating,
    required TResult Function(String diff) completed,
    required TResult Function() cancelled,
    required TResult Function(String message) error,
  }) {
    return completed(diff);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String response)? generating,
    TResult? Function(String diff)? completed,
    TResult? Function()? cancelled,
    TResult? Function(String message)? error,
  }) {
    return completed?.call(diff);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String response)? generating,
    TResult Function(String diff)? completed,
    TResult Function()? cancelled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(diff);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialState value) initial,
    required TResult Function(_GeneratingState value) generating,
    required TResult Function(_CompletedState value) completed,
    required TResult Function(_CancelledState value) cancelled,
    required TResult Function(_ErrorState value) error,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialState value)? initial,
    TResult? Function(_GeneratingState value)? generating,
    TResult? Function(_CompletedState value)? completed,
    TResult? Function(_CancelledState value)? cancelled,
    TResult? Function(_ErrorState value)? error,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialState value)? initial,
    TResult Function(_GeneratingState value)? generating,
    TResult Function(_CompletedState value)? completed,
    TResult Function(_CancelledState value)? cancelled,
    TResult Function(_ErrorState value)? error,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class _CompletedState implements LLMState {
  const factory _CompletedState({required final String diff}) =
      _$CompletedStateImpl;

  String get diff;

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompletedStateImplCopyWith<_$CompletedStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CancelledStateImplCopyWith<$Res> {
  factory _$$CancelledStateImplCopyWith(
    _$CancelledStateImpl value,
    $Res Function(_$CancelledStateImpl) then,
  ) = __$$CancelledStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CancelledStateImplCopyWithImpl<$Res>
    extends _$LLMStateCopyWithImpl<$Res, _$CancelledStateImpl>
    implements _$$CancelledStateImplCopyWith<$Res> {
  __$$CancelledStateImplCopyWithImpl(
    _$CancelledStateImpl _value,
    $Res Function(_$CancelledStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CancelledStateImpl implements _CancelledState {
  const _$CancelledStateImpl();

  @override
  String toString() {
    return 'LLMState.cancelled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CancelledStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String response) generating,
    required TResult Function(String diff) completed,
    required TResult Function() cancelled,
    required TResult Function(String message) error,
  }) {
    return cancelled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String response)? generating,
    TResult? Function(String diff)? completed,
    TResult? Function()? cancelled,
    TResult? Function(String message)? error,
  }) {
    return cancelled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String response)? generating,
    TResult Function(String diff)? completed,
    TResult Function()? cancelled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialState value) initial,
    required TResult Function(_GeneratingState value) generating,
    required TResult Function(_CompletedState value) completed,
    required TResult Function(_CancelledState value) cancelled,
    required TResult Function(_ErrorState value) error,
  }) {
    return cancelled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialState value)? initial,
    TResult? Function(_GeneratingState value)? generating,
    TResult? Function(_CompletedState value)? completed,
    TResult? Function(_CancelledState value)? cancelled,
    TResult? Function(_ErrorState value)? error,
  }) {
    return cancelled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialState value)? initial,
    TResult Function(_GeneratingState value)? generating,
    TResult Function(_CompletedState value)? completed,
    TResult Function(_CancelledState value)? cancelled,
    TResult Function(_ErrorState value)? error,
    required TResult orElse(),
  }) {
    if (cancelled != null) {
      return cancelled(this);
    }
    return orElse();
  }
}

abstract class _CancelledState implements LLMState {
  const factory _CancelledState() = _$CancelledStateImpl;
}

/// @nodoc
abstract class _$$ErrorStateImplCopyWith<$Res> {
  factory _$$ErrorStateImplCopyWith(
    _$ErrorStateImpl value,
    $Res Function(_$ErrorStateImpl) then,
  ) = __$$ErrorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorStateImplCopyWithImpl<$Res>
    extends _$LLMStateCopyWithImpl<$Res, _$ErrorStateImpl>
    implements _$$ErrorStateImplCopyWith<$Res> {
  __$$ErrorStateImplCopyWithImpl(
    _$ErrorStateImpl _value,
    $Res Function(_$ErrorStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorStateImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorStateImpl implements _ErrorState {
  const _$ErrorStateImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'LLMState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorStateImplCopyWith<_$ErrorStateImpl> get copyWith =>
      __$$ErrorStateImplCopyWithImpl<_$ErrorStateImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String response) generating,
    required TResult Function(String diff) completed,
    required TResult Function() cancelled,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String response)? generating,
    TResult? Function(String diff)? completed,
    TResult? Function()? cancelled,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String response)? generating,
    TResult Function(String diff)? completed,
    TResult Function()? cancelled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_InitialState value) initial,
    required TResult Function(_GeneratingState value) generating,
    required TResult Function(_CompletedState value) completed,
    required TResult Function(_CancelledState value) cancelled,
    required TResult Function(_ErrorState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_InitialState value)? initial,
    TResult? Function(_GeneratingState value)? generating,
    TResult? Function(_CompletedState value)? completed,
    TResult? Function(_CancelledState value)? cancelled,
    TResult? Function(_ErrorState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_InitialState value)? initial,
    TResult Function(_GeneratingState value)? generating,
    TResult Function(_CompletedState value)? completed,
    TResult Function(_CancelledState value)? cancelled,
    TResult Function(_ErrorState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _ErrorState implements LLMState {
  const factory _ErrorState({required final String message}) = _$ErrorStateImpl;

  String get message;

  /// Create a copy of LLMState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorStateImplCopyWith<_$ErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
