import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/features/project_setup/domain/entities/file_node.dart';
import 'package:shotgun_flutter/features/project_setup/domain/repositories/project_repository.dart';
import 'package:shotgun_flutter/features/project_setup/domain/usecases/list_files.dart';

import 'list_files_test.mocks.dart';

@GenerateMocks([ProjectRepository])
void main() {
  late ListFiles usecase;
  late MockProjectRepository mockRepository;

  setUp(() {
    mockRepository = MockProjectRepository();
    usecase = ListFiles(mockRepository);
  });

  const tPath = '/test/path';
  final tFileNodes = [
    const FileNode(
      name: 'test.txt',
      path: '/test/path/test.txt',
      relPath: 'test.txt',
      isDir: false,
      isGitignored: false,
      isCustomIgnored: false,
    ),
    const FileNode(
      name: 'folder',
      path: '/test/path/folder',
      relPath: 'folder',
      isDir: true,
      isGitignored: false,
      isCustomIgnored: false,
    ),
  ];

  test('should return list of FileNode from repository', () async {
    // arrange
    when(mockRepository.listFiles(any))
        .thenAnswer((_) async => Right(tFileNodes));

    // act
    final result = await usecase(tPath);

    // assert
    expect(result, Right(tFileNodes));
    verify(mockRepository.listFiles(tPath));
    verifyNoMoreInteractions(mockRepository);
  });
}
