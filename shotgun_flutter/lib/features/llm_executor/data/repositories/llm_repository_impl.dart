import 'package:dartz/dartz.dart';
import 'package:shotgun_flutter/core/error/exceptions.dart';
import 'package:shotgun_flutter/core/error/failures.dart';
import 'package:shotgun_flutter/features/llm_executor/data/datasources/llm_datasource.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_config.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_provider_type.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/repositories/llm_repository.dart';

/// Implementation of LLM repository
class LLMRepositoryImpl implements LLMRepository {
  final Map<LLMProviderType, LLMDataSource> dataSources;

  LLMRepositoryImpl({required this.dataSources});

  @override
  Stream<Either<Failure, String>> generateDiff({
    required String prompt,
    required LLMConfig config,
  }) async* {
    try {
      // Get data source for the specified provider
      final dataSource = dataSources[config.provider];

      if (dataSource == null) {
        yield Left(
          ServerFailure('Provider ${config.provider.name} not supported'),
        );
        return;
      }

      // Generate diff with streaming
      final stream = dataSource.generateDiff(
        prompt: prompt,
        apiKey: config.apiKey,
        model: config.model,
        temperature: config.temperature,
      );

      // Yield each chunk wrapped in Right
      await for (final chunk in stream) {
        yield Right(chunk);
      }
    } on ServerException catch (e) {
      yield Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      yield Left(CacheFailure(e.message));
    } catch (e) {
      yield Left(ServerFailure('LLM generation failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelGeneration() async {
    try {
      // Cancel generation for all data sources
      for (final dataSource in dataSources.values) {
        dataSource.cancel();
      }
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Cancel failed: $e'));
    }
  }
}
