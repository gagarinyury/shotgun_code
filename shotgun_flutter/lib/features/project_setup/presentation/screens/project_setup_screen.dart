import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/shotgun_context.dart';
import '../providers/project_provider.dart';
import '../widgets/file_tree_widget.dart';
import '../../../../shared/services/haptic_service.dart';
import '../../../../shared/services/share_service.dart';

/// Screen for project setup (Step 1 of the workflow).
///
/// This screen allows users to:
/// - Select a project directory
/// - View the file tree
/// - Toggle file/directory inclusion for context generation
/// - See the generated context (when ready)
class ProjectSetupScreen extends ConsumerWidget {
  const ProjectSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shotgun Code - Project Setup'),
        actions: [
          if (projectState is ProjectStateLoaded &&
              projectState.context != null) ...[
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share Context',
              onPressed: () => _shareContext(projectState.context!),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Context Info',
              onPressed: () => _showContextInfo(context, projectState.context!),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Header with folder picker button
          _buildHeader(context, ref, projectState),

          // File tree or status message
          Expanded(child: _buildBody(context, ref, projectState)),

          // Footer with context stats
          if (projectState is ProjectStateLoaded &&
              projectState.context != null)
            _buildFooter(projectState.context!),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, ProjectState state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.folder_open),
            label: const Text('Choose Project Folder'),
            onPressed: () => _pickFolder(ref),
          ),
          const SizedBox(width: 16),
          if (state is ProjectStateLoaded)
            Expanded(
              child: Text(
                'Project: ${state.projectPath}',
                style: const TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ProjectState state) {
    return switch (state) {
      ProjectStateInitial() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Select a project folder to begin',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      ProjectStateLoaded(:final fileTree, :final excludedPaths) => Column(
        children: [
          if (excludedPaths.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.orange.withValues(alpha: 0.1),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${excludedPaths.length} paths excluded',
                    style: const TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: FileTreeWidget(
                nodes: fileTree,
                onToggle: (node) {
                  ref
                      .read(projectNotifierProvider.notifier)
                      .toggleExclusion(node);
                },
              ),
            ),
          ),
        ],
      ),
      ProjectStateGenerating(:final fileTree, :final excludedPaths) => Column(
        children: [
          const LinearProgressIndicator(),
          const SizedBox(height: 16),
          const Text('Generating context...', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          if (excludedPaths.isNotEmpty)
            Text(
              '${excludedPaths.length} paths excluded',
              style: const TextStyle(color: Colors.grey),
            ),
          Expanded(
            child: SingleChildScrollView(
              child: FileTreeWidget(
                nodes: fileTree,
                onToggle: (node) {
                  ref
                      .read(projectNotifierProvider.notifier)
                      .toggleExclusion(node);
                },
              ),
            ),
          ),
        ],
      ),
      ProjectStateError(:final message) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error: $message',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _pickFolder(ref),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    };
  }

  Widget _buildFooter(ShotgunContext context) {
    final sizeKB = (context.sizeBytes / 1024).toStringAsFixed(1);
    final generatedTime = _formatTime(context.generatedAt);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        border: const Border(top: BorderSide(color: Colors.green)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            'Context generated: $sizeKB KB',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            'at $generatedTime',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFolder(WidgetRef ref) async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path != null) {
      ref.read(projectNotifierProvider.notifier).loadProject(path);
    }
  }

  void _showContextInfo(BuildContext context, ShotgunContext shotgunContext) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Context Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Project: ${shotgunContext.projectPath}'),
            const SizedBox(height: 8),
            Text(
              'Size: ${(shotgunContext.sizeBytes / 1024).toStringAsFixed(1)} KB',
            ),
            const SizedBox(height: 8),
            Text('Generated: ${_formatTime(shotgunContext.generatedAt)}'),
            const SizedBox(height: 16),
            const Text(
              'The context has been generated and is ready to use.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _shareContext(shotgunContext);
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  Future<void> _shareContext(ShotgunContext shotgunContext) async {
    await HapticService.lightImpact();
    await ShareService.shareContext(shotgunContext.context);
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }
}
