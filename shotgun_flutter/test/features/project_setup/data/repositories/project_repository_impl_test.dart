import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/exceptions.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/project_setup/data/models/file_node_model.dart';
import 'package:shotgun_flutter/features/project_setup/data/repositories/project_repository_impl.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late ProjectRepositoryImpl repository;
  late MockBackendDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockBackendDataSource();
    repository = ProjectRepositoryImpl(backendDataSource: mockDataSource);
  });

  group('listFiles', () {
    const tPath = '/test';
    const tModels = [
      FileNodeModel(
        name: 'test',
        path: '/test',
        relPath: 'test',
        isDir: true,
        isGitignored: false,
        isCustomIgnored: false,
      ),
    ];

    test('should return entities when datasource call is successful', () async {
      // Arrange
      when(mockDataSource.listFiles(any)).thenAnswer((_) async => tModels);

      // Act
      final result = await repository.listFiles(tPath);

      // Assert
      expect(result, isA<Right<Failure, dynamic>>());
      result.fold(
        (failure) => fail('Should not return failure'),
        (entities) {
          expect(entities.length, 1);
          expect(entities[0].name, 'test');
          expect(entities[0].path, '/test');
          expect(entities[0].isDir, true);
        },
      );
      verify(mockDataSource.listFiles(tPath));
    });

    test('should return BackendFailure when datasource throws BackendException', () async {
      // Arrange
      when(mockDataSource.listFiles(any))
          .thenThrow(const BackendException('error'));

      // Act
      final result = await repository.listFiles(tPath);

      // Assert
      expect(result, isA<Left<Failure, dynamic>>());
      result.fold(
        (failure) {
          expect(failure, isA<BackendFailure>());
          expect(failure.message, 'error');
        },
        (_) => fail('Should not return success'),
      );
    });

    test('should return BackendFailure with generic message on unexpected error', () async {
      // Arrange
      when(mockDataSource.listFiles(any)).thenThrow(Exception('unexpected'));

      // Act
      final result = await repository.listFiles(tPath);

      // Assert
      expect(result, isA<Left<Failure, dynamic>>());
      result.fold(
        (failure) {
          expect(failure, isA<BackendFailure>());
          expect(failure.message, contains('Unexpected error'));
        },
        (_) => fail('Should not return success'),
      );
    });
  });
}
