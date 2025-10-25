import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/patch.dart';
import '../providers/patch_provider.dart';
import '../../../../shared/services/haptic_service.dart';
import '../../../../shared/services/share_service.dart';

/// Screen for applying patches split from LLM-generated diffs
class PatchApplierScreen extends ConsumerWidget {
  final String diff;

  const PatchApplierScreen({super.key, required this.diff});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patchState = ref.watch(patchNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Patches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Patch',
            onPressed: () => _sharePatch(diff),
          ),
        ],
      ),
      body: patchState.when(
        initial: () => Center(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Wire up dependencies
              // ref.read(patchNotifierProvider.notifier).loadDiff(
              //   diff: diff,
              //   lineLimit: 500,
              //   splitUseCase: splitPatch,
              // );
            },
            child: const Text('Load Patches'),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (patches, isApplying, conflicts) => Column(
          children: [
            if (conflicts.isNotEmpty)
              Container(
                color: Colors.red.shade100,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      '${conflicts.length} conflicts detected',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: patches.length,
                itemBuilder: (context, index) {
                  return _PatchCard(patch: patches[index]);
                },
              ),
            ),
          ],
        ),
        error: (message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error: $message'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sharePatch(String patch) async {
    await HapticService.lightImpact();
    await ShareService.sharePatch(patch);
  }
}

class _PatchCard extends StatelessWidget {
  final Patch patch;

  const _PatchCard({required this.patch});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text('Patch - ${patch.filesChanged} files'),
        subtitle: Text('+${patch.linesAdded} -${patch.linesRemoved} lines'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patch.content,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement apply
                      },
                      child: const Text('Apply'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {
                        // TODO: Show full preview
                      },
                      child: const Text('Preview'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
