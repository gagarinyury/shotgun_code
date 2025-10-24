// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_node_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileNodeModelImpl _$$FileNodeModelImplFromJson(Map<String, dynamic> json) =>
    _$FileNodeModelImpl(
      name: json['name'] as String,
      path: json['path'] as String,
      relPath: json['relPath'] as String,
      isDir: json['isDir'] as bool,
      isGitignored: json['isGitignored'] as bool,
      isCustomIgnored: json['isCustomIgnored'] as bool,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => FileNodeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$FileNodeModelImplToJson(_$FileNodeModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'path': instance.path,
      'relPath': instance.relPath,
      'isDir': instance.isDir,
      'isGitignored': instance.isGitignored,
      'isCustomIgnored': instance.isCustomIgnored,
      'children': instance.children,
    };
