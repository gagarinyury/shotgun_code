import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/repositories/git_repository.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/usecases/create_commit.dart';

@GenerateMocks([GitRepository])
import 'create_commit_test.mocks.dart';

void main() {
  late CreateCommit useCase;
  late MockGitRepository mockRepository;

  setUp(() {
    mockRepository = MockGitRepository();
    useCase = CreateCommit(mockRepository);
  });

  group('CreateCommit', () {
    const testMessage = 'feat: add new feature';

    test('should forward call to repository', () async {
      // Arrange
      when(mockRepository.createCommit(any))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(testMessage);

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.createCommit(testMessage));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass correct message', () async {
      // Arrange
      const customMessage = 'fix: bug fix';
      when(mockRepository.createCommit(any))
          .thenAnswer((_) async => const Right(null));

      // Act
      await useCase(customMessage);

      // Assert
      verify(mockRepository.createCommit(customMessage));
    });
  });
}
