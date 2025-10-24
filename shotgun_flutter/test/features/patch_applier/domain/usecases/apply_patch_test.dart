import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/entities/apply_result.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/entities/patch.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/repositories/patch_repository.dart';
import 'package:shotgun_flutter/features/patch_applier/domain/usecases/apply_patch.dart';

@GenerateMocks([PatchRepository])
import 'apply_patch_test.mocks.dart';

void main() {
  late ApplyPatch useCase;
  late MockPatchRepository mockRepository;

  setUp(() {
    mockRepository = MockPatchRepository();
    useCase = ApplyPatch(mockRepository);
  });

  group('ApplyPatch', () {
    const testPatch = Patch(
      content: 'diff content',
      projectPath: '/path',
      filesChanged: 1,
      linesAdded: 10,
      linesRemoved: 5,
    );

    test('should forward call to repository', () async {
      // Arrange
      final expectedResult = ApplyResult.success();
      when(mockRepository.applyPatch(any, dryRun: anyNamed('dryRun')))
          .thenAnswer((_) async => Right(expectedResult));

      // Act
      final result = await useCase(testPatch);

      // Assert
      expect(result, Right(expectedResult));
      verify(mockRepository.applyPatch(testPatch, dryRun: false));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass dryRun parameter', () async {
      // Arrange
      final expectedResult = ApplyResult.success();
      when(mockRepository.applyPatch(any, dryRun: anyNamed('dryRun')))
          .thenAnswer((_) async => Right(expectedResult));

      // Act
      await useCase(testPatch, dryRun: true);

      // Assert
      verify(mockRepository.applyPatch(testPatch, dryRun: true));
    });
  });
}
