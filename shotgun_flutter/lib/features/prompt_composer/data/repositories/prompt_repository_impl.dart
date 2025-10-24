import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/prompt_template.dart';
import '../../domain/repositories/prompt_repository.dart';
import '../datasources/prompt_local_datasource.dart';
import '../utils/token_estimator.dart';

/// Implementation of [PromptRepository].
///
/// Handles prompt composition, token estimation, and template/rules persistence.
/// Uses [PromptLocalDataSource] for local storage and [TokenEstimator] for
/// token counting.
///
/// All exceptions are caught and converted to [Failure] objects following
/// the Either pattern for error handling.
class PromptRepositoryImpl implements PromptRepository {
  final PromptLocalDataSource localDataSource;

  /// Built-in default templates that are always available.
  static final List<PromptTemplate> _defaultTemplates = [
    const PromptTemplate(
      id: 'basic',
      name: 'Basic',
      template: '{context}\n\nTASK: {task}',
    ),
    const PromptTemplate(
      id: 'detailed',
      name: 'Detailed',
      template: '{context}\n\nTASK: {task}\n\nRULES: {rules}',
    ),
    const PromptTemplate(
      id: 'structured',
      name: 'Structured',
      template: '# Context\n{context}\n\n# Task\n{task}\n\n# Rules\n{rules}',
    ),
  ];

  PromptRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, String>> composePrompt({
    required String context,
    required String task,
    required String rules,
    required PromptTemplate template,
  }) async {
    try {
      final composedPrompt = template.render(
        context: context,
        task: task,
        rules: rules,
      );
      return Right(composedPrompt);
    } catch (e) {
      return Left(CacheFailure('Failed to compose prompt: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> estimateTokens(String text) async {
    try {
      final tokens = TokenEstimator.estimate(text);
      return Right(tokens);
    } catch (e) {
      return Left(CacheFailure('Failed to estimate tokens: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<PromptTemplate>>> loadTemplates() async {
    try {
      // Start with default templates
      final templates = List<PromptTemplate>.from(_defaultTemplates);

      // Load custom templates from storage
      final customTemplatesData = await localDataSource.loadAllTemplates();

      // Convert maps to PromptTemplate entities
      for (final templateData in customTemplatesData) {
        try {
          final template = PromptTemplate(
            id: templateData['id'] as String,
            name: templateData['name'] as String,
            template: templateData['template'] as String,
          );
          templates.add(template);
        } catch (e) {
          // Skip invalid templates
          continue;
        }
      }

      return Right(templates);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to load templates: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveTemplate(PromptTemplate template) async {
    try {
      // Don't allow overwriting built-in templates
      if (_defaultTemplates.any((t) => t.id == template.id)) {
        return const Left(
          CacheFailure('Cannot overwrite built-in templates'),
        );
      }

      final templateData = {
        'id': template.id,
        'name': template.name,
        'template': template.template,
      };

      await localDataSource.saveTemplate(template.id, templateData);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to save template: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> loadCustomRules() async {
    try {
      final rules = await localDataSource.loadCustomRules();
      return Right(rules);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to load custom rules: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveCustomRules(String rules) async {
    try {
      await localDataSource.saveCustomRules(rules);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to save custom rules: ${e.toString()}'));
    }
  }
}
