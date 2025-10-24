import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/repositories/git_repository.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/usecases/rollback_changes.dart';

@GenerateMocks([GitRepository])
import 'rollback_changes_test.mocks.dart';

void main() {
  late RollbackChanges useCase;
  late MockGitRepository mockRepository;

  setUp(() {
    mockRepository = MockGitRepository();
    useCase = RollbackChanges(mockRepository);
  });

  group('RollbackChanges', () {
    test('should forward call to repository', () async {
      // Arrange
      when(mockRepository.rollback())
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.rollback());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
