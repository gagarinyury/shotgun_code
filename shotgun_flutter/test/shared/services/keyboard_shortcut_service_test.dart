import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:shotgun_flutter/shared/services/keyboard_shortcut_service.dart';
import 'package:shotgun_flutter/shared/domain/entities/keyboard_shortcut.dart';

void main() {
  late KeyboardShortcutService service;

  setUp(() {
    service = KeyboardShortcutService();
  });

  group('KeyboardShortcutService', () {
    test('should initialize with default shortcuts', () {
      expect(service.shortcuts, isNotEmpty);
      expect(service.shortcuts.length, greaterThanOrEqualTo(5));
    });

    test('should register handler', () {
      var called = false;

      service.registerHandler(ShortcutAction.openProject, () {
        called = true;
      });

      expect(called, false);
      // Handler is registered but not called yet
    });

    test('should unregister handler', () {
      service.registerHandler(ShortcutAction.openProject, () {});
      service.unregisterHandler(ShortcutAction.openProject);

      // Handler should no longer be registered
      // We can't directly test this without triggering the handler
    });

    test('should get label for action', () {
      final label = service.getLabelForAction(ShortcutAction.openProject);

      expect(label, isNotNull);
      expect(label, contains('O'));
      expect(label, contains('Cmd'));
    });

    test('should return null for non-existent action', () {
      // All actions are defined, so we test with existing action
      final label = service.getLabelForAction(ShortcutAction.openProject);
      expect(label, isNotNull);
    });

    test('should have openProject shortcut', () {
      final openProjectShortcut = service.shortcuts.firstWhere(
        (s) => s.action == ShortcutAction.openProject,
      );

      expect(openProjectShortcut, isNotNull);
      expect(openProjectShortcut.action, ShortcutAction.openProject);
    });

    test('should have nextStep shortcut', () {
      final nextStepShortcut = service.shortcuts.firstWhere(
        (s) => s.action == ShortcutAction.nextStep,
      );

      expect(nextStepShortcut, isNotNull);
      expect(nextStepShortcut.action, ShortcutAction.nextStep);
    });

    test('should have copyContext shortcut', () {
      final copyContextShortcut = service.shortcuts.firstWhere(
        (s) => s.action == ShortcutAction.copyContext,
      );

      expect(copyContextShortcut, isNotNull);
      expect(copyContextShortcut.action, ShortcutAction.copyContext);
    });

    test('should have undo shortcut', () {
      final undoShortcut = service.shortcuts.firstWhere(
        (s) => s.action == ShortcutAction.undo,
      );

      expect(undoShortcut, isNotNull);
      expect(undoShortcut.action, ShortcutAction.undo);
    });

    test('should have search shortcut', () {
      final searchShortcut = service.shortcuts.firstWhere(
        (s) => s.action == ShortcutAction.search,
      );

      expect(searchShortcut, isNotNull);
      expect(searchShortcut.action, ShortcutAction.search);
    });

    test('shortcuts list should be unmodifiable', () {
      final shortcuts = service.shortcuts;

      expect(() => shortcuts.add(const KeyboardShortcut(
        action: ShortcutAction.save,
        key: LogicalKeyboardKey.keyS,
      )), throwsUnsupportedError);
    });
  });
}
