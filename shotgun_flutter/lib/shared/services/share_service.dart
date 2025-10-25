import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ShareService {
  /// Share text (context or prompt)
  static Future<void> shareText(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }

  /// Share as file
  static Future<void> shareAsFile({
    required String content,
    required String fileName,
    String? subject,
  }) async {
    // Create temporary file
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content);

    // Share file
    await Share.shareXFiles([XFile(file.path)], subject: subject);
  }

  /// Share context
  static Future<void> shareContext(String context) async {
    await shareAsFile(
      content: context,
      fileName: 'shotgun_context.txt',
      subject: 'Project Context',
    );
  }

  /// Share prompt
  static Future<void> sharePrompt(String prompt) async {
    await shareAsFile(
      content: prompt,
      fileName: 'shotgun_prompt.txt',
      subject: 'LLM Prompt',
    );
  }

  /// Share patch
  static Future<void> sharePatch(String patch) async {
    await shareAsFile(
      content: patch,
      fileName: 'shotgun_patch.diff',
      subject: 'Git Patch',
    );
  }
}
