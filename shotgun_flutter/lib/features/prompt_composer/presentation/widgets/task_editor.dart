import 'package:flutter/material.dart';

/// A text editor widget for entering the task description.
///
/// This widget provides a multiline text field for users to enter
/// their task description that will be used in the prompt composition.
class TaskEditor extends StatelessWidget {
  /// The initial value for the text field
  final String initialValue;

  /// Callback when the text changes
  final ValueChanged<String> onChanged;

  /// Optional placeholder text
  final String? hintText;

  /// Whether the field is read-only
  final bool readOnly;

  const TaskEditor({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.hintText,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue)
        ..selection = TextSelection.collapsed(offset: initialValue.length),
      onChanged: onChanged,
      maxLines: 10,
      minLines: 5,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: 'Your task for AI',
        hintText: hintText ?? 'Describe what you want the AI to do...',
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      style: const TextStyle(
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}
