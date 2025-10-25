import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MobileFilePickerService {
  static Future<String?> pickDirectory() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // Request storage permissions for Android
      if (Platform.isAndroid) {
        final storagePermission = await Permission.storage.request();
        if (storagePermission != PermissionStatus.granted) {
          return null;
        }
      }

      // Get documents directory as default
      final directory = await getApplicationDocumentsDirectory();

      // Show custom directory picker dialog
      return await _showDirectoryPicker(directory.path);
    } else {
      // Desktop: use standard file picker
      return await FilePicker.platform.getDirectoryPath();
    }
  }

  static Future<String?> _showDirectoryPicker(String initialPath) async {
    // This would need to be implemented with a custom dialog
    // For now, return the initial path
    return initialPath;
  }

  static Future<bool> requestStoragePermissions() async {
    if (Platform.isAndroid) {
      final storagePermission = await Permission.storage.request();
      final manageStoragePermission = await Permission.manageExternalStorage
          .request();

      return storagePermission == PermissionStatus.granted ||
          manageStoragePermission == PermissionStatus.granted;
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit storage permissions for app documents
      return true;
    }

    return true; // Desktop platforms
  }

  static Future<String> getDocumentsPath() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else {
      // Desktop: use user's home directory
      return Platform.environment['HOME'] ?? '.';
    }
  }

  static Future<String> getDownloadsPath() async {
    if (Platform.isAndroid) {
      final directory = await getDownloadsDirectory();
      return directory?.path ?? '/storage/emulated/0/Download';
    } else if (Platform.isIOS) {
      // iOS doesn't have a separate downloads directory
      final documentsDir = await getApplicationDocumentsDirectory();
      return '${documentsDir.path}/Downloads';
    } else {
      // Desktop: use standard downloads directory
      return Platform.environment['HOME'] != null
          ? '${Platform.environment['HOME']}/Downloads'
          : './Downloads';
    }
  }

  static List<String> getCommonProjectPaths() {
    if (Platform.isAndroid) {
      return [
        '/storage/emulated/0/Download',
        '/storage/emulated/0/Documents',
        '/sdcard/Download',
        '/sdcard/Documents',
      ];
    } else if (Platform.isIOS) {
      return ['/var/mobile/Containers/Data/Application'];
    } else {
      // Desktop
      return [
        '${Platform.environment['HOME'] ?? '.'}/Documents',
        '${Platform.environment['HOME'] ?? '.'}/Projects',
        '${Platform.environment['HOME'] ?? '.'}/workspace',
      ];
    }
  }
}
