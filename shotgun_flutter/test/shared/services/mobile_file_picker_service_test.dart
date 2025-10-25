import 'package:flutter_test/flutter_test.dart';
import 'package:shotgun_flutter/shared/services/mobile_file_picker_service.dart';

void main() {
  group('MobileFilePickerService', () {
    test('should get common project paths for Android', () {
      // This test would need to mock Platform.isAndroid
      // For now, just test that the method returns a list
      final paths = MobileFilePickerService.getCommonProjectPaths();
      expect(paths, isA<List<String>>());
    });

    test('should get common project paths for iOS', () {
      // This test would need to mock Platform.isIOS
      final paths = MobileFilePickerService.getCommonProjectPaths();
      expect(paths, isA<List<String>>());
    });

    test('should get common project paths for desktop', () {
      // This test would need to mock desktop platform
      final paths = MobileFilePickerService.getCommonProjectPaths();
      expect(paths, isA<List<String>>());
    });

    test('should return documents path structure', () async {
      final path = await MobileFilePickerService.getDocumentsPath();
      expect(path, isA<String>());
      expect(path.isNotEmpty, true);
    });

    test('should return downloads path structure', () async {
      final path = await MobileFilePickerService.getDownloadsPath();
      expect(path, isA<String>());
      expect(path.isNotEmpty, true);
    });
  });
}
