import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/exceptions.dart';
import 'package:shotgun_flutter/features/project_setup/data/datasources/backend_datasource.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late BackendDataSourceImpl dataSource;
  late MockBackendBridge mockBridge;

  setUp(() {
    mockBridge = MockBackendBridge();
    dataSource = BackendDataSourceImpl(bridge: mockBridge);
  });

  group('listFiles', () {
    const tPath = '/test/path';
    const tJsonResponse = '''
    [
      {
        "name": "test",
        "path": "/test",
        "relPath": "test",
        "isDir": true,
        "isGitignored": false,
        "isCustomIgnored": false,
        "children": []
      }
    ]
    ''';

    test('should return list of FileNodeModel when call is successful', () async {
      // Arrange
      when(mockBridge.listFiles(any)).thenReturn(tJsonResponse);

      // Act
      final result = await dataSource.listFiles(tPath);

      // Assert
      expect(result, isA<List<dynamic>>());
      expect(result.length, 1);
      expect(result[0].name, 'test');
      expect(result[0].path, '/test');
      expect(result[0].isDir, true);
      verify(mockBridge.listFiles(tPath));
    });

    test('should throw BackendException when response contains error', () async {
      // Arrange
      const errorResponse = '{"error": "Something went wrong"}';
      when(mockBridge.listFiles(any)).thenReturn(errorResponse);

      // Act & Assert
      expect(
        () async => await dataSource.listFiles(tPath),
        throwsA(isA<BackendException>()),
      );
      verify(mockBridge.listFiles(tPath));
    });

    test('should throw BackendException when JSON is invalid', () async {
      // Arrange
      const invalidJson = 'not valid json';
      when(mockBridge.listFiles(any)).thenReturn(invalidJson);

      // Act & Assert
      expect(
        () async => await dataSource.listFiles(tPath),
        throwsA(isA<BackendException>()),
      );
    });

    test('should throw BackendException when response format is unexpected', () async {
      // Arrange
      const unexpectedFormat = '{"someKey": "someValue"}';
      when(mockBridge.listFiles(any)).thenReturn(unexpectedFormat);

      // Act & Assert
      expect(
        () async => await dataSource.listFiles(tPath),
        throwsA(isA<BackendException>()),
      );
    });
  });
}
