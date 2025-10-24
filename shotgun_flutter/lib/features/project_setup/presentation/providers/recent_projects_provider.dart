import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/recent_projects_datasource.dart';

// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main()');
});

// Provider for RecentProjectsDataSource
final recentProjectsDataSourceProvider = Provider<RecentProjectsDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return RecentProjectsDataSource(prefs: prefs);
});

// Provider for recent projects list
final recentProjectsProvider = Provider<List<String>>((ref) {
  final dataSource = ref.watch(recentProjectsDataSourceProvider);
  return dataSource.getRecentProjects();
});
