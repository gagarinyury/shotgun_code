import 'package:equatable/equatable.dart';

/// Domain entity representing custom rules for prompt composition.
///
/// Custom rules are user-defined instructions that should be included
/// in the prompt to guide the LLM's behavior.
class CustomRules extends Equatable {
  /// Unique identifier for this set of rules
  final String id;

  /// Name/title for this set of rules
  final String name;

  /// The actual rules text
  final String content;

  /// When these rules were created
  final DateTime createdAt;

  /// When these rules were last modified
  final DateTime updatedAt;

  const CustomRules({
    required this.id,
    required this.name,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, content, createdAt, updatedAt];

  /// Creates a copy of this CustomRules with updated fields
  CustomRules copyWith({
    String? id,
    String? name,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomRules(
      id: id ?? this.id,
      name: name ?? this.name,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CustomRules(id: $id, name: $name, length: ${content.length})';
  }
}
