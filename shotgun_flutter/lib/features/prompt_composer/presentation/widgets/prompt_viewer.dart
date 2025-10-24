import 'package:flutter/material.dart';

/// A widget that displays the final composed prompt.
///
/// This widget shows the prompt in a read-only, scrollable text field
/// with syntax highlighting and selection support.
class PromptViewer extends StatelessWidget {
  /// The prompt text to display
  final String prompt;

  /// Optional title for the viewer
  final String? title;

  /// Whether to show a copy button
  final bool showCopyButton;

  /// Callback when the copy button is pressed
  final VoidCallback? onCopy;

  const PromptViewer({
    super.key,
    required this.prompt,
    this.title,
    this.showCopyButton = false,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (showCopyButton && onCopy != null)
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: onCopy,
                    tooltip: 'Copy to clipboard',
                  ),
              ],
            ),
          ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[50],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                prompt.isEmpty ? 'Your composed prompt will appear here...' : prompt,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  fontFamily: 'monospace',
                  color: prompt.isEmpty ? Colors.grey[400] : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
