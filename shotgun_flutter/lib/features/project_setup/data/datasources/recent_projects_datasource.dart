import 'package:shared_preferences/shared_preferences.dart';

class RecentProjectsDataSource {
  static const String _key = 'recent_projects';
  static const int _maxRecent = 10;

  final SharedPreferences prefs;

  RecentProjectsDataSource({required this.prefs});

  /// Get list of recent project paths
  List<String> getRecentProjects() {
    return prefs.getStringList(_key) ?? [];
  }

  /// Add a project to recent list
  Future<void> addRecentProject(String path) async {
    final recent = getRecentProjects();

    // Remove if already exists
    recent.remove(path);

    // Add to beginning
    recent.insert(0, path);

    // Keep only last N projects
    if (recent.length > _maxRecent) {
      recent.removeRange(_maxRecent, recent.length);
    }

    await prefs.setStringList(_key, recent);
  }

  /// Clear all recent projects
  Future<void> clearRecentProjects() async {
    await prefs.remove(_key);
  }
}
