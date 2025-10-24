import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prompt_template.dart';

/// Domain repository interface for prompt composition operations.
///
/// This abstract class defines the contract for prompt-related operations
/// without any implementation details. It uses `Either<Failure, Success>` pattern
/// for error handling, following Clean Architecture principles.
///
/// All methods return Either to explicitly handle both success and failure cases:
/// - `Left(Failure)`: An error occurred
/// - `Right(Success)`: Operation completed successfully
abstract class PromptRepository {
  /// Composes a final prompt from context, task, rules, and template.
  ///
  /// Takes the raw components and a template, then renders the final prompt
  /// by replacing placeholders in the template.
  ///
  /// Parameters:
  /// - [context]: The project context (file contents)
  /// - [task]: The user's task description
  /// - [rules]: Custom rules to apply
  /// - [template]: The template to use for composition
  ///
  /// Returns:
  /// - `Right(String)`: The composed final prompt
  /// - `Left(Failure)`: If composition fails
  Future<Either<Failure, String>> composePrompt({
    required String context,
    required String task,
    required String rules,
    required PromptTemplate template,
  });

  /// Estimates the number of tokens in the given text.
  ///
  /// Uses approximation (~4 characters = 1 token) to estimate token count.
  /// This helps users stay within LLM context limits.
  ///
  /// Parameters:
  /// - [text]: The text to estimate tokens for
  ///
  /// Returns:
  /// - `Right(int)`: Estimated token count
  /// - `Left(Failure)`: If estimation fails
  Future<Either<Failure, int>> estimateTokens(String text);

  /// Loads all available prompt templates.
  ///
  /// Returns both built-in templates and user-created custom templates.
  ///
  /// Returns:
  /// - `Right(List<PromptTemplate>)`: List of available templates
  /// - `Left(Failure)`: If loading fails
  Future<Either<Failure, List<PromptTemplate>>> loadTemplates();

  /// Saves a new or updated prompt template.
  ///
  /// Templates are persisted locally and will be available in future sessions.
  ///
  /// Parameters:
  /// - [template]: The template to save
  ///
  /// Returns:
  /// - `Right(void)`: Template saved successfully
  /// - `Left(Failure)`: If save fails
  Future<Either<Failure, void>> saveTemplate(PromptTemplate template);

  /// Loads the user's custom rules.
  ///
  /// Custom rules are additional instructions that should be included
  /// in prompts to guide LLM behavior.
  ///
  /// Returns:
  /// - `Right(String)`: The custom rules text (empty string if none)
  /// - `Left(Failure)`: If loading fails
  Future<Either<Failure, String>> loadCustomRules();

  /// Saves the user's custom rules.
  ///
  /// Custom rules are persisted locally and will be loaded in future sessions.
  ///
  /// Parameters:
  /// - [rules]: The custom rules text to save
  ///
  /// Returns:
  /// - `Right(void)`: Rules saved successfully
  /// - `Left(Failure)`: If save fails
  Future<Either<Failure, void>> saveCustomRules(String rules);
}
