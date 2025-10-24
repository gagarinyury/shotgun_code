import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/prompt_provider.dart';
import '../widgets/prompt_viewer.dart';
import '../widgets/task_editor.dart';
import '../widgets/token_counter.dart';

/// Screen for composing prompts with templates and token counting.
///
/// This screen provides a split view where users can:
/// - Enter their task description (left side)
/// - See the composed prompt and token count (right side)
/// - Select from available templates
/// - Edit custom rules
/// - Copy the final prompt to clipboard
class PromptComposerScreen extends ConsumerWidget {
  const PromptComposerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promptState = ref.watch(promptNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose Prompt'),
        elevation: 2,
      ),
      body: promptState.when(
        data: (state) => _buildContent(context, ref, state),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, PromptState state) {
    return Row(
      children: [
        // Left side: Task editor and settings
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TaskEditor(
                  initialValue: state.task,
                  onChanged: (task) {
                    ref.read(promptNotifierProvider.notifier).updateTask(task);
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Custom Rules',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: state.customRules)
                      ..selection = TextSelection.collapsed(
                        offset: state.customRules.length,
                      ),
                    onChanged: (rules) {
                      ref
                          .read(promptNotifierProvider.notifier)
                          .updateCustomRules(rules);
                    },
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter custom rules for the AI...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Divider
        Container(
          width: 1,
          color: Colors.grey[300],
        ),
        // Right side: Prompt viewer
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Final Prompt',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TokenCounter(tokens: state.estimatedTokens),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Template: '),
                    const SizedBox(width: 8),
                    if (state.templates.isNotEmpty)
                      DropdownButton(
                        value: state.selectedTemplate,
                        items: state.templates.map((template) {
                          return DropdownMenuItem(
                            value: template,
                            child: Text(template.name),
                          );
                        }).toList(),
                        onChanged: (template) {
                          if (template != null) {
                            ref
                                .read(promptNotifierProvider.notifier)
                                .selectTemplate(template);
                          }
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: PromptViewer(
                    prompt: state.finalPrompt,
                    showCopyButton: true,
                    onCopy: () => _copyToClipboard(context, state.finalPrompt),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: state.finalPrompt.isNotEmpty
                        ? () => _copyToClipboard(context, state.finalPrompt)
                        : null,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Prompt to Clipboard'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                if (state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    if (text.isEmpty) return;

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prompt copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
