import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:shotgun_flutter/core/platform/backend_bridge.dart';
import 'package:shotgun_flutter/features/project_setup/data/datasources/backend_datasource.dart';
import 'package:shotgun_flutter/features/prompt_composer/domain/repositories/prompt_repository.dart';

@GenerateMocks([
  Dio,
  BackendBridge,
  BackendDataSource,
  PromptRepository,
])
void main() {}
