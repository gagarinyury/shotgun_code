import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/project_setup/domain/entities/shotgun_context.dart';
import 'package:shotgun_flutter/features/project_setup/domain/repositories/project_repository.dart';
import 'package:shotgun_flutter/features/project_setup/domain/usecases/generate_context.dart';

import 'generate_context_test.mocks.dart';

@GenerateMocks([ProjectRepository])
void main() {
  late GenerateContext usecase;
  late MockProjectRepository mockRepository;

  setUp(() {
    mockRepository = MockProjectRepository();
    usecase = GenerateContext(mockRepository);
  });

  const tRootDir = '/test/project';
  const tExcludedPaths = ['/test/project/node_modules'];
  final tContext = ShotgunContext(
    projectPath: tRootDir,
    context: 'test context content',
    sizeBytes: 1024,
    generatedAt: DateTime(2024, 1, 1),
  );

  test('should return ShotgunContext from repository', () async {
    // arrange
    when(mockRepository.generateContext(
      rootDir: anyNamed('rootDir'),
      excludedPaths: anyNamed('excludedPaths'),
    )).thenAnswer(
      (_) => Stream.value(Right(tContext)),
    );

    // act
    final stream = usecase(
      rootDir: tRootDir,
      excludedPaths: tExcludedPaths,
    );

    // assert
    await expectLater(
      stream,
      emits(Right(tContext)),
    );
    verify(mockRepository.generateContext(
      rootDir: tRootDir,
      excludedPaths: tExcludedPaths,
    ));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when rootDir is empty', () async {
    // act
    final stream = usecase(
      rootDir: '',
      excludedPaths: tExcludedPaths,
    );

    // assert
    await expectLater(
      stream,
      emits(isA<Left<Failure, ShotgunContext>>()),
    );
    verifyNever(mockRepository.generateContext(
      rootDir: anyNamed('rootDir'),
      excludedPaths: anyNamed('excludedPaths'),
    ));
  });
}
