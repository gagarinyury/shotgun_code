import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/file_node.dart';

/// Widget for displaying a file tree with checkboxes and search.
///
/// This widget recursively renders a tree of files and directories,
/// allowing users to select/deselect them for inclusion in context generation.
class FileTreeWidget extends StatefulWidget {
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
  State<FileTreeWidget> createState() => _FileTreeWidgetState();
}

class _FileTreeWidgetState extends State<FileTreeWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  /// Filter nodes based on search query
  List<FileNode> _filterNodes(List<FileNode> nodes, String query) {
    if (query.isEmpty) return nodes;

    return nodes.where((node) {
      final matchesName = node.name.toLowerCase().contains(query.toLowerCase());
      final hasMatchingChildren =
          node.children != null &&
          _filterNodes(node.children!, query).isNotEmpty;

      return matchesName || hasMatchingChildren;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredNodes = _filterNodes(widget.nodes, _searchQuery);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search files... (Cmd+F)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              _debounceTimer?.cancel();
              _debounceTimer = Timer(const Duration(milliseconds: 300), () {
                if (mounted) {
                  setState(() {
                    _searchQuery = value;
                  });
                }
              });
            },
          ),
        ),

        // File tree
        Expanded(
          child: filteredNodes.isEmpty
              ? const Center(child: Text('No files to display'))
              : ListView.builder(
                  itemCount: filteredNodes.length,
                  itemBuilder: (context, index) {
                    return _FileNodeTile(
                      node: filteredNodes[index],
                      onToggle: widget.onToggle,
                      searchQuery: _searchQuery,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Internal widget for rendering a single file/directory node.
class _FileNodeTile extends StatefulWidget {
  final FileNode node;
  final Function(FileNode) onToggle;
  final String searchQuery;

  const _FileNodeTile({
    required this.node,
    required this.onToggle,
    this.searchQuery = '',
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
        if (_expanded &&
            widget.node.children != null &&
            widget.node.children!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: _FileTreeList(
              nodes: widget.node.children!,
              onToggle: widget.onToggle,
              searchQuery: widget.searchQuery,
            ),
          ),
      ],
    );
  }
}

/// Helper widget for rendering a list of file nodes without search bar
class _FileTreeList extends StatelessWidget {
  final List<FileNode> nodes;
  final Function(FileNode) onToggle;
  final String searchQuery;

  const _FileTreeList({
    required this.nodes,
    required this.onToggle,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        return _FileNodeTile(
          node: nodes[index],
          onToggle: onToggle,
          searchQuery: searchQuery,
        );
      },
    );
  }
}
