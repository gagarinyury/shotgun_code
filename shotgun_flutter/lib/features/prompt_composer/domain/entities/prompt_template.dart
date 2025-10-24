import 'package:equatable/equatable.dart';

/// Domain entity representing a prompt template.
///
/// A template contains placeholders like {context}, {task}, {rules}
/// that can be replaced with actual values to generate the final prompt.
class PromptTemplate extends Equatable {
  /// Unique identifier for this template
  final String id;

  /// Human-readable name of the template
  final String name;

  /// Template string with placeholders: {context}, {task}, {rules}
  /// Example: "{context}\n\nTASK: {task}\n\nRULES: {rules}"
  final String template;

  const PromptTemplate({
    required this.id,
    required this.name,
    required this.template,
  });

  /// Renders the template by replacing placeholders with actual values
  String render({
    required String context,
    required String task,
    required String rules,
  }) {
    return template
        .replaceAll('{context}', context)
        .replaceAll('{task}', task)
        .replaceAll('{rules}', rules);
  }

  @override
  List<Object?> get props => [id, name, template];

  /// Creates a copy of this PromptTemplate with updated fields
  PromptTemplate copyWith({
    String? id,
    String? name,
    String? template,
  }) {
    return PromptTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      template: template ?? this.template,
    );
  }

  @override
  String toString() {
    return 'PromptTemplate(id: $id, name: $name)';
  }
}
