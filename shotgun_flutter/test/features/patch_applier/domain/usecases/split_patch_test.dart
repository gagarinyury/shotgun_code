import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/entities/patch.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/repositories/patch_repository.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/usecases/split_patch.dart';

@GenerateMocks([PatchRepository])
import 'split_patch_test.mocks.dart';

void main() {
  late SplitPatch useCase;
  late MockPatchRepository mockRepository;

  setUp(() {
    mockRepository = MockPatchRepository();
    useCase = SplitPatch(mockRepository);
  });

  group('SplitPatch', () {
    const testDiff = 'diff --git a/file.dart b/file.dart';
    const lineLimit = 500;

    test('should forward call to repository', () async {
      // Arrange
      const expectedPatches = [
        Patch(
          content: 'patch1',
          projectPath: '',
          filesChanged: 1,
          linesAdded: 5,
          linesRemoved: 2,
        ),
      ];
      when(mockRepository.splitPatch(any, any))
          .thenAnswer((_) async => const Right(expectedPatches));

      // Act
      final result = await useCase(testDiff, lineLimit);

      // Assert
      expect(result, const Right(expectedPatches));
      verify(mockRepository.splitPatch(testDiff, lineLimit));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass correct parameters', () async {
      // Arrange
      const customLineLimit = 1000;
      when(mockRepository.splitPatch(any, any))
          .thenAnswer((_) async => const Right([]));

      // Act
      await useCase(testDiff, customLineLimit);

      // Assert
      verify(mockRepository.splitPatch(testDiff, customLineLimit));
    });
  });
}
