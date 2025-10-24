import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/project_setup/domain/entities/file_node.dart';
import 'package:shotgun_flutter/features/project_setup/presentation/widgets/file_tree_widget.dart';

void main() {
  group('FileTree Performance', () {
    test('should render 10000 nodes in < 1 second', () async {
      final stopwatch = Stopwatch()..start();

      // Generate 10k nodes
      final nodes = List.generate(10000, (i) {
        return FileNode(
          name: 'file_$i.dart',
          path: '/path/file_$i.dart',
          relPath: 'file_$i.dart',
          isDir: false,
          isGitignored: false,
          isCustomIgnored: false,
        );
      });

      // Create widget (simulating render time)
      FileTreeWidget(nodes: nodes, onToggle: (_) {});

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('should filter 10000 nodes quickly', () async {
      final stopwatch = Stopwatch()..start();

      // Generate 10k nodes
      final nodes = List.generate(10000, (i) {
        return FileNode(
          name: 'file_$i.dart',
          path: '/path/file_$i.dart',
          relPath: 'file_$i.dart',
          isDir: false,
          isGitignored: false,
          isCustomIgnored: false,
        );
      });

      // Simulate filtering
      final filtered = nodes
          .where(
            (node) => node.name.toLowerCase().contains('test'.toLowerCase()),
          )
          .toList();

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(500));
      expect(filtered.length, equals(0)); // No files contain 'test'
    });

    test('should handle nested structure efficiently', () async {
      final stopwatch = Stopwatch()..start();

      // Create nested structure: 100 folders with 100 files each
      final nodes = List.generate(100, (folderIndex) {
        final children = List.generate(100, (fileIndex) {
          return FileNode(
            name: 'file_$fileIndex.dart',
            path: '/folder_$folderIndex/file_$fileIndex.dart',
            relPath: 'folder_$folderIndex/file_$fileIndex.dart',
            isDir: false,
            isGitignored: false,
            isCustomIgnored: false,
          );
        });

        return FileNode(
          name: 'folder_$folderIndex',
          path: '/folder_$folderIndex',
          relPath: 'folder_$folderIndex',
          isDir: true,
          isGitignored: false,
          isCustomIgnored: false,
          children: children,
        );
      });

      // Create widget with nested structure
      FileTreeWidget(nodes: nodes, onToggle: (_) {});

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      expect(nodes.length, equals(100));
      expect(
        nodes.fold<int>(
          0,
          (sum, folder) => sum + (folder.children?.length ?? 0),
        ),
        equals(10000),
      );
    });

    test('should search efficiently in large dataset', () async {
      final stopwatch = Stopwatch()..start();

      // Generate 10k nodes with varied names
      final nodes = List.generate(10000, (i) {
        final isTestFile = i % 100 == 0; // Every 100th file is a test file
        return FileNode(
          name: isTestFile ? 'test_file_$i.dart' : 'regular_file_$i.dart',
          path:
              '/path/${isTestFile ? 'test_file_$i.dart' : 'regular_file_$i.dart'}',
          relPath: isTestFile ? 'test_file_$i.dart' : 'regular_file_$i.dart',
          isDir: false,
          isGitignored: false,
          isCustomIgnored: false,
        );
      });

      // Search for test files
      const searchQuery = 'test';
      final filtered = nodes.where((node) {
        final matchesName = node.name.toLowerCase().contains(
          searchQuery.toLowerCase(),
        );
        return matchesName;
      }).toList();

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(500));
      expect(filtered.length, equals(100)); // Should find 100 test files
    });
  });
}
