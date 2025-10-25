import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/shared/services/cache_service.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CacheService', () {
    late CacheService cacheService;

    setUpAll(() {
      // Mock path_provider plugin
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return '/tmp/test_hive';
          }
          return null;
        },
      );
    });

    setUp(() {
      cacheService = CacheService();
    });

    tearDown(() async {
      // Clear cache after each test to avoid test pollution
      try {
        await cacheService.init();
        await cacheService.clearAllCache();
      } catch (e) {
        // Ignore if not initialized yet
      }
    });

    tearDownAll(() {
      // Clean up mock
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/path_provider'),
        null,
      );
    });

    test('should initialize cache service', () async {
      await cacheService.init();
      // If we get here without exception, test passes
      expect(true, true);
    });

    test('should cache and retrieve context', () async {
      await cacheService.init();

      const projectPath = '/test/project';
      const context = 'test context';

      await cacheService.cacheContext(
        projectPath: projectPath,
        context: context,
      );

      final retrieved = cacheService.getCachedContext(projectPath);
      expect(retrieved, context);
    });

    test('should check if context is cached', () async {
      await cacheService.init();

      const projectPath = '/test/project';
      const context = 'test context';

      await cacheService.cacheContext(
        projectPath: projectPath,
        context: context,
      );

      final isCached = cacheService.isContextCached(projectPath);
      expect(isCached, true);
    });

    test('should clear project cache', () async {
      await cacheService.init();

      const projectPath = '/test/project';
      const context = 'test context';

      await cacheService.cacheContext(
        projectPath: projectPath,
        context: context,
      );

      await cacheService.clearProjectCache(projectPath);

      final isCached = cacheService.isContextCached(projectPath);
      expect(isCached, false);
    });

    test('should clear all cache', () async {
      await cacheService.init();

      const projectPath = '/test/project';
      const context = 'test context';

      await cacheService.cacheContext(
        projectPath: projectPath,
        context: context,
      );

      await cacheService.clearAllCache();

      final isCached = cacheService.isContextCached(projectPath);
      expect(isCached, false);
    });

    test('should calculate cache size', () async {
      await cacheService.init();

      const projectPath1 = '/test/project1';
      const projectPath2 = '/test/project2';
      const context1 = 'test context 1';
      const context2 = 'test context 2';

      await cacheService.cacheContext(
        projectPath: projectPath1,
        context: context1,
      );
      await cacheService.cacheContext(
        projectPath: projectPath2,
        context: context2,
      );

      final size = cacheService.getCacheSize();
      expect(size, context1.length + context2.length);
    });

    test('should check if cache is exceeded', () async {
      await cacheService.init();

      // Add a large context to exceed cache (100MB limit)
      final largeContext = 'x' * (101 * 1024 * 1024); // 101MB
      await cacheService.cacheContext(
        projectPath: '/test/project',
        context: largeContext,
      );

      final isExceeded = cacheService.isCacheExceeded();
      expect(isExceeded, true);
    });

    test('should cache and retrieve settings', () async {
      await cacheService.init();

      const settings = {'theme': 'dark', 'fontSize': 16};

      await cacheService.cacheSettings(settings);

      final retrieved = cacheService.getCachedSettings();
      expect(retrieved, settings);
    });

    test('should export and import cache', () async {
      await cacheService.init();

      const projectPath = '/test/project';
      const context = 'test context';
      const settings = {'theme': 'dark', 'fontSize': 16};

      await cacheService.cacheContext(
        projectPath: projectPath,
        context: context,
      );
      await cacheService.cacheSettings(settings);

      // Export cache
      const exportPath = '/tmp/cache_export.json';
      await cacheService.exportCache(exportPath);

      // Clear cache
      await cacheService.clearAllCache();

      // Import cache
      await cacheService.importCache(exportPath);

      // Verify imported data
      final importedContext = cacheService.getCachedContext(projectPath);
      final importedSettings = cacheService.getCachedSettings();

      expect(importedContext, context);
      expect(importedSettings, settings);
    });

    test('should get cache statistics', () async {
      await cacheService.init();

      const projectPath = '/test/project';
      const context = 'test context';

      await cacheService.cacheContext(
        projectPath: projectPath,
        context: context,
      );

      final stats = cacheService.getCacheStats();

      // Size should be at least the context length
      // (may include metadata from Hive storage)
      expect(stats['totalSize'], greaterThanOrEqualTo(context.length));
      expect(stats['maxSize'], 100 * 1024 * 1024);
      expect(stats['isExceeded'], false);
      expect(stats['contextCount'], 1);
    });
  });
}
