import 'dart:io';
import 'package:flutter/material.dart';

class MobileProjectPickerDialog extends StatefulWidget {
  final String initialDirectory;

  const MobileProjectPickerDialog({required this.initialDirectory, super.key});

  @override
  State<MobileProjectPickerDialog> createState() =>
      _MobileProjectPickerDialogState();
}

class _MobileProjectPickerDialogState extends State<MobileProjectPickerDialog> {
  late String currentPath;
  List<FileSystemEntity> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentPath = widget.initialDirectory;
    _loadDirectory();
  }

  Future<void> _loadDirectory() async {
    setState(() {
      isLoading = true;
    });

    try {
      final dir = Directory(currentPath);
      final entities = await dir.list().toList();

      setState(() {
        items = entities;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading directory: $e')));
      }
    }
  }

  void _navigateToDirectory(String path) {
    setState(() {
      currentPath = path;
    });
    _loadDirectory();
  }

  void _navigateToParent() {
    final parentPath = Directory(currentPath).parent.path;
    if (parentPath != currentPath) {
      _navigateToDirectory(parentPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text('Select Folder'),
          const Spacer(),
          if (Directory(currentPath).parent.path != currentPath)
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: _navigateToParent,
              tooltip: 'Parent Directory',
            ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isDirectory = item is Directory;
                  final itemName = item.path.split('/').last;

                  if (!isDirectory) return const SizedBox.shrink();

                  return ListTile(
                    leading: Icon(
                      Icons.folder,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(itemName),
                    subtitle: Text(item.path),
                    onTap: () {
                      _navigateToDirectory(item.path);
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        Navigator.of(context).pop(item.path);
                      },
                      tooltip: 'Select this folder',
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(currentPath),
          child: const Text('Select Current'),
        ),
      ],
    );
  }
}
