import 'package:flutter/material.dart';
import '../../domain/entities/file_node.dart';

/// Widget for displaying a file tree with checkboxes.
///
/// This widget recursively renders a tree of files and directories,
/// allowing users to select/deselect them for inclusion in context generation.
class FileTreeWidget extends StatelessWidget {
  /// List of root file nodes to display.
  final List<FileNode> nodes;

  /// Callback when a node's inclusion state is toggled.
  final Function(FileNode) onToggle;

  /// Creates a [FileTreeWidget].
  const FileTreeWidget({
    super.key,
    required this.nodes,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return const Center(
        child: Text('No files to display'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        return _FileNodeTile(
          node: nodes[index],
          onToggle: onToggle,
        );
      },
    );
  }
}

/// Internal widget for rendering a single file/directory node.
class _FileNodeTile extends StatefulWidget {
  final FileNode node;
  final Function(FileNode) onToggle;

  const _FileNodeTile({
    required this.node,
    required this.onToggle,
  });

  @override
  State<_FileNodeTile> createState() => _FileNodeTileState();
}

class _FileNodeTileState extends State<_FileNodeTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isExcluded = widget.node.isGitignored || widget.node.isCustomIgnored;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: widget.node.isDir
              ? Icon(
                  _expanded ? Icons.folder_open : Icons.folder,
                  color: isExcluded ? Colors.grey : Colors.blue,
                )
              : Icon(
                  Icons.insert_drive_file,
                  color: isExcluded ? Colors.grey : null,
                ),
          title: Text(
            widget.node.name,
            style: TextStyle(
              color: isExcluded ? Colors.grey : null,
              decoration: isExcluded ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: isExcluded
              ? Text(
                  widget.node.isGitignored
                      ? 'Ignored by .gitignore'
                      : 'Custom ignored',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              : null,
          trailing: Checkbox(
            value: !isExcluded,
            onChanged: (_) => widget.onToggle(widget.node),
          ),
          onTap: widget.node.isDir
              ? () => setState(() => _expanded = !_expanded)
              : null,
        ),
        if (_expanded && widget.node.children != null && widget.node.children!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: FileTreeWidget(
              nodes: widget.node.children!,
              onToggle: widget.onToggle,
            ),
          ),
      ],
    );
  }
}
