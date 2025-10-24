import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class AppMenuBar extends StatelessWidget {
  final VoidCallback onOpenProject;
  final VoidCallback onSettings;
  final VoidCallback onAbout;

  const AppMenuBar({
    required this.onOpenProject,
    required this.onSettings,
    required this.onAbout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Only show menu bar on desktop platforms
    if (!Platform.isMacOS && !Platform.isWindows && !Platform.isLinux) {
      return const SizedBox.shrink();
    }

    return PlatformMenuBar(
      menus: [
        PlatformMenu(
          label: 'File',
          menus: [
            PlatformMenuItem(
              label: 'Open Project...',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyO,
                meta: true,
              ),
              onSelected: onOpenProject,
            ),
            const PlatformMenuItemGroup(
              members: [
                PlatformMenuItem(
                  label: 'Settings',
                  shortcut: SingleActivator(
                    LogicalKeyboardKey.comma,
                    meta: true,
                  ),
                ),
              ],
            ),
            if (Platform.isMacOS)
              const PlatformMenuItem(
                label: 'Quit',
                shortcut: SingleActivator(
                  LogicalKeyboardKey.keyQ,
                  meta: true,
                ),
              ),
          ],
        ),
        PlatformMenu(
          label: 'Edit',
          menus: [
            PlatformMenuItem(
              label: 'Undo',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyZ,
                meta: true,
              ),
              onSelected: () {
                // Undo logic will be implemented in Step 6
              },
            ),
            PlatformMenuItem(
              label: 'Redo',
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyZ,
                meta: true,
                shift: true,
              ),
              onSelected: () {
                // Redo logic will be implemented in Step 6
              },
            ),
          ],
        ),
        PlatformMenu(
          label: 'Help',
          menus: [
            PlatformMenuItem(
              label: 'About Shotgun Code',
              onSelected: onAbout,
            ),
          ],
        ),
      ],
    );
  }
}
