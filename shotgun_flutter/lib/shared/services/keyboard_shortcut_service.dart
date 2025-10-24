import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/keyboard_shortcut.dart';

final keyboardShortcutServiceProvider = Provider<KeyboardShortcutService>((ref) {
  return KeyboardShortcutService();
});

class KeyboardShortcutService {
  final List<KeyboardShortcut> _shortcuts = DefaultShortcuts.all;
  final Map<ShortcutAction, VoidCallback> _handlers = {};

  /// Register a handler for a specific action
  void registerHandler(ShortcutAction action, VoidCallback handler) {
    _handlers[action] = handler;
  }

  /// Unregister a handler
  void unregisterHandler(ShortcutAction action) {
    _handlers.remove(action);
  }

  /// Handle a key event
  bool handleKeyEvent(KeyEvent event, HardwareKeyboard keyboard) {
    if (event is! KeyDownEvent) return false;

    for (final shortcut in _shortcuts) {
      if (shortcut.matches(event, keyboard)) {
        final handler = _handlers[shortcut.action];
        if (handler != null) {
          handler();
          return true; // Event consumed
        }
      }
    }

    return false; // Event not handled
  }

  /// Get all registered shortcuts
  List<KeyboardShortcut> get shortcuts => List.unmodifiable(_shortcuts);

  /// Get label for action
  String? getLabelForAction(ShortcutAction action) {
    try {
      final shortcut = _shortcuts.firstWhere(
        (s) => s.action == action,
      );
      return shortcut.label;
    } catch (e) {
      return null;
    }
  }
}
