import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/features/project_setup/domain/entities/file_node.dart';
import 'package:shotgun_flutter/features/project_setup/presentation/widgets/file_tree_widget.dart';

void main() {
  group('FileTreeWidget', () {
    testWidgets('should display empty message when nodes is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FileTreeWidget(
              nodes: const [],
              onToggle: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('No files to display'), findsOneWidget);
    });

    testWidgets('should display file nodes', (tester) async {
      const nodes = [
        FileNode(
          name: 'test.txt',
          path: '/test.txt',
          relPath: 'test.txt',
          isDir: false,
          isGitignored: false,
          isCustomIgnored: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FileTreeWidget(
              nodes: nodes,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('test.txt'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byIcon(Icons.insert_drive_file), findsOneWidget);
    });

    testWidgets('should display folder icon for directories', (tester) async {
      const nodes = [
        FileNode(
          name: 'folder',
          path: '/folder',
          relPath: 'folder',
          isDir: true,
          isGitignored: false,
          isCustomIgnored: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FileTreeWidget(
              nodes: nodes,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('folder'), findsOneWidget);
      expect(find.byIcon(Icons.folder), findsOneWidget);
    });

    testWidgets('should show gitignored items as crossed out', (tester) async {
      const nodes = [
        FileNode(
          name: 'ignored.txt',
          path: '/ignored.txt',
          relPath: 'ignored.txt',
          isDir: false,
          isGitignored: true,
          isCustomIgnored: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FileTreeWidget(
              nodes: nodes,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('ignored.txt'), findsOneWidget);
      expect(find.text('Ignored by .gitignore'), findsOneWidget);
    });

    testWidgets('should call onToggle when checkbox is tapped', (tester) async {
      const testNode = FileNode(
        name: 'test.txt',
        path: '/test.txt',
        relPath: 'test.txt',
        isDir: false,
        isGitignored: false,
        isCustomIgnored: false,
      );

      FileNode? toggledNode;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FileTreeWidget(
              nodes: const [testNode],
              onToggle: (node) => toggledNode = node,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(toggledNode, equals(testNode));
    });

    testWidgets('should expand folder when tapped', (tester) async {
      const nodes = [
        FileNode(
          name: 'folder',
          path: '/folder',
          relPath: 'folder',
          isDir: true,
          isGitignored: false,
          isCustomIgnored: false,
          children: [
            FileNode(
              name: 'child.txt',
              path: '/folder/child.txt',
              relPath: 'folder/child.txt',
              isDir: false,
              isGitignored: false,
              isCustomIgnored: false,
            ),
          ],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FileTreeWidget(
              nodes: nodes,
              onToggle: (_) {},
            ),
          ),
        ),
      );

      // Initially, child should not be visible
      expect(find.text('child.txt'), findsNothing);

      // Tap folder to expand
      await tester.tap(find.text('folder'));
      await tester.pumpAndSettle();

      // Child should now be visible
      expect(find.text('child.txt'), findsOneWidget);
      expect(find.byIcon(Icons.folder_open), findsOneWidget);
    });
  });
}
