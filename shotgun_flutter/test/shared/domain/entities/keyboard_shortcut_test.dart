import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:shotgun_flutter/shared/domain/entities/keyboard_shortcut.dart';

void main() {
  group('KeyboardShortcut', () {
    test('should create shortcut with correct properties', () {
      const shortcut = KeyboardShortcut(
        action: ShortcutAction.openProject,
        key: LogicalKeyboardKey.keyO,
        meta: true,
      );

      expect(shortcut.action, ShortcutAction.openProject);
      expect(shortcut.key, LogicalKeyboardKey.keyO);
      expect(shortcut.meta, true);
      expect(shortcut.control, false);
      expect(shortcut.shift, false);
      expect(shortcut.alt, false);
    });

    test('should have correct key for matching', () {
      const shortcut = KeyboardShortcut(
        action: ShortcutAction.openProject,
        key: LogicalKeyboardKey.keyO,
        meta: true,
      );

      // Verify the shortcut properties are set correctly for matching
      expect(shortcut.key, LogicalKeyboardKey.keyO);
      expect(shortcut.meta, true);
      expect(shortcut.control, false);
      expect(shortcut.shift, false);
      expect(shortcut.alt, false);
    });

    test('should generate correct label with single modifier', () {
      const shortcut = KeyboardShortcut(
        action: ShortcutAction.openProject,
        key: LogicalKeyboardKey.keyO,
        meta: true,
      );

      expect(shortcut.label, 'Cmd+O');
    });

    test('should generate correct label with multiple modifiers', () {
      const shortcut = KeyboardShortcut(
        action: ShortcutAction.copyContext,
        key: LogicalKeyboardKey.keyC,
        meta: true,
        shift: true,
      );

      expect(shortcut.label, 'Shift+Cmd+C');
    });

    test('should generate correct label with ctrl modifier', () {
      const shortcut = KeyboardShortcut(
        action: ShortcutAction.save,
        key: LogicalKeyboardKey.keyS,
        control: true,
      );

      expect(shortcut.label, 'Ctrl+S');
    });

    test('should support equality comparison', () {
      const shortcut1 = KeyboardShortcut(
        action: ShortcutAction.openProject,
        key: LogicalKeyboardKey.keyO,
        meta: true,
      );

      const shortcut2 = KeyboardShortcut(
        action: ShortcutAction.openProject,
        key: LogicalKeyboardKey.keyO,
        meta: true,
      );

      const shortcut3 = KeyboardShortcut(
        action: ShortcutAction.nextStep,
        key: LogicalKeyboardKey.enter,
        meta: true,
      );

      expect(shortcut1, equals(shortcut2));
      expect(shortcut1, isNot(equals(shortcut3)));
    });
  });

  group('DefaultShortcuts', () {
    test('should contain all defined shortcuts', () {
      final shortcuts = DefaultShortcuts.all;

      expect(shortcuts, isNotEmpty);
      expect(shortcuts.length, greaterThanOrEqualTo(5));
    });

    test('should contain openProject shortcut', () {
      final shortcuts = DefaultShortcuts.all;

      final openProject = shortcuts.firstWhere(
        (s) => s.action == ShortcutAction.openProject,
      );

      expect(openProject.key, LogicalKeyboardKey.keyO);
      expect(openProject.meta, true);
    });

    test('should contain nextStep shortcut', () {
      final shortcuts = DefaultShortcuts.all;

      final nextStep = shortcuts.firstWhere(
        (s) => s.action == ShortcutAction.nextStep,
      );

      expect(nextStep.key, LogicalKeyboardKey.enter);
      expect(nextStep.meta, true);
    });

    test('should contain copyContext shortcut', () {
      final shortcuts = DefaultShortcuts.all;

      final copyContext = shortcuts.firstWhere(
        (s) => s.action == ShortcutAction.copyContext,
      );

      expect(copyContext.key, LogicalKeyboardKey.keyC);
      expect(copyContext.meta, true);
      expect(copyContext.shift, true);
    });

    test('should contain undo shortcut', () {
      final shortcuts = DefaultShortcuts.all;

      final undo = shortcuts.firstWhere(
        (s) => s.action == ShortcutAction.undo,
      );

      expect(undo.key, LogicalKeyboardKey.keyZ);
      expect(undo.meta, true);
    });

    test('should contain search shortcut', () {
      final shortcuts = DefaultShortcuts.all;

      final search = shortcuts.firstWhere(
        (s) => s.action == ShortcutAction.search,
      );

      expect(search.key, LogicalKeyboardKey.keyF);
      expect(search.meta, true);
    });

    test('should have unique actions', () {
      final shortcuts = DefaultShortcuts.all;
      final actions = shortcuts.map((s) => s.action).toList();
      final uniqueActions = actions.toSet();

      expect(actions.length, equals(uniqueActions.length));
    });
  });
}
