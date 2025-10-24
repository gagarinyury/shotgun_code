// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_node_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FileNodeModel _$FileNodeModelFromJson(Map<String, dynamic> json) {
  return _FileNodeModel.fromJson(json);
}

/// @nodoc
mixin _$FileNodeModel {
  String get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  String get relPath => throw _privateConstructorUsedError;
  bool get isDir => throw _privateConstructorUsedError;
  bool get isGitignored => throw _privateConstructorUsedError;
  bool get isCustomIgnored => throw _privateConstructorUsedError;
  List<FileNodeModel>? get children => throw _privateConstructorUsedError;

  /// Serializes this FileNodeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileNodeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileNodeModelCopyWith<FileNodeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileNodeModelCopyWith<$Res> {
  factory $FileNodeModelCopyWith(
    FileNodeModel value,
    $Res Function(FileNodeModel) then,
  ) = _$FileNodeModelCopyWithImpl<$Res, FileNodeModel>;
  @useResult
  $Res call({
    String name,
    String path,
    String relPath,
    bool isDir,
    bool isGitignored,
    bool isCustomIgnored,
    List<FileNodeModel>? children,
  });
}

/// @nodoc
class _$FileNodeModelCopyWithImpl<$Res, $Val extends FileNodeModel>
    implements $FileNodeModelCopyWith<$Res> {
  _$FileNodeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileNodeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? relPath = null,
    Object? isDir = null,
    Object? isGitignored = null,
    Object? isCustomIgnored = null,
    Object? children = freezed,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            path: null == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as String,
            relPath: null == relPath
                ? _value.relPath
                : relPath // ignore: cast_nullable_to_non_nullable
                      as String,
            isDir: null == isDir
                ? _value.isDir
                : isDir // ignore: cast_nullable_to_non_nullable
                      as bool,
            isGitignored: null == isGitignored
                ? _value.isGitignored
                : isGitignored // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCustomIgnored: null == isCustomIgnored
                ? _value.isCustomIgnored
                : isCustomIgnored // ignore: cast_nullable_to_non_nullable
                      as bool,
            children: freezed == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as List<FileNodeModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FileNodeModelImplCopyWith<$Res>
    implements $FileNodeModelCopyWith<$Res> {
  factory _$$FileNodeModelImplCopyWith(
    _$FileNodeModelImpl value,
    $Res Function(_$FileNodeModelImpl) then,
  ) = __$$FileNodeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String path,
    String relPath,
    bool isDir,
    bool isGitignored,
    bool isCustomIgnored,
    List<FileNodeModel>? children,
  });
}

/// @nodoc
class __$$FileNodeModelImplCopyWithImpl<$Res>
    extends _$FileNodeModelCopyWithImpl<$Res, _$FileNodeModelImpl>
    implements _$$FileNodeModelImplCopyWith<$Res> {
  __$$FileNodeModelImplCopyWithImpl(
    _$FileNodeModelImpl _value,
    $Res Function(_$FileNodeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileNodeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = null,
    Object? relPath = null,
    Object? isDir = null,
    Object? isGitignored = null,
    Object? isCustomIgnored = null,
    Object? children = freezed,
  }) {
    return _then(
      _$FileNodeModelImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        path: null == path
            ? _value.path
            : path // ignore: cast_nullable_to_non_nullable
                  as String,
        relPath: null == relPath
            ? _value.relPath
            : relPath // ignore: cast_nullable_to_non_nullable
                  as String,
        isDir: null == isDir
            ? _value.isDir
            : isDir // ignore: cast_nullable_to_non_nullable
                  as bool,
        isGitignored: null == isGitignored
            ? _value.isGitignored
            : isGitignored // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCustomIgnored: null == isCustomIgnored
            ? _value.isCustomIgnored
            : isCustomIgnored // ignore: cast_nullable_to_non_nullable
                  as bool,
        children: freezed == children
            ? _value._children
            : children // ignore: cast_nullable_to_non_nullable
                  as List<FileNodeModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FileNodeModelImpl extends _FileNodeModel {
  const _$FileNodeModelImpl({
    required this.name,
    required this.path,
    required this.relPath,
    required this.isDir,
    required this.isGitignored,
    required this.isCustomIgnored,
    final List<FileNodeModel>? children,
  }) : _children = children,
       super._();

  factory _$FileNodeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileNodeModelImplFromJson(json);

  @override
  final String name;
  @override
  final String path;
  @override
  final String relPath;
  @override
  final bool isDir;
  @override
  final bool isGitignored;
  @override
  final bool isCustomIgnored;
  final List<FileNodeModel>? _children;
  @override
  List<FileNodeModel>? get children {
    final value = _children;
    if (value == null) return null;
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FileNodeModel(name: $name, path: $path, relPath: $relPath, isDir: $isDir, isGitignored: $isGitignored, isCustomIgnored: $isCustomIgnored, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileNodeModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.relPath, relPath) || other.relPath == relPath) &&
            (identical(other.isDir, isDir) || other.isDir == isDir) &&
            (identical(other.isGitignored, isGitignored) ||
                other.isGitignored == isGitignored) &&
            (identical(other.isCustomIgnored, isCustomIgnored) ||
                other.isCustomIgnored == isCustomIgnored) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    path,
    relPath,
    isDir,
    isGitignored,
    isCustomIgnored,
    const DeepCollectionEquality().hash(_children),
  );

  /// Create a copy of FileNodeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileNodeModelImplCopyWith<_$FileNodeModelImpl> get copyWith =>
      __$$FileNodeModelImplCopyWithImpl<_$FileNodeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileNodeModelImplToJson(this);
  }
}

abstract class _FileNodeModel extends FileNodeModel {
  const factory _FileNodeModel({
    required final String name,
    required final String path,
    required final String relPath,
    required final bool isDir,
    required final bool isGitignored,
    required final bool isCustomIgnored,
    final List<FileNodeModel>? children,
  }) = _$FileNodeModelImpl;
  const _FileNodeModel._() : super._();

  factory _FileNodeModel.fromJson(Map<String, dynamic> json) =
      _$FileNodeModelImpl.fromJson;

  @override
  String get name;
  @override
  String get path;
  @override
  String get relPath;
  @override
  bool get isDir;
  @override
  bool get isGitignored;
  @override
  bool get isCustomIgnored;
  @override
  List<FileNodeModel>? get children;

  /// Create a copy of FileNodeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileNodeModelImplCopyWith<_$FileNodeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
