import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:shotgun_flutter/core/platform/backend_bridge.dart';
import 'package:shotgun_flutter/features/project_setup/data/datasources/backend_datasource.dart';

@GenerateMocks([
  Dio,
  BackendBridge,
  BackendDataSource,
])
void main() {}
