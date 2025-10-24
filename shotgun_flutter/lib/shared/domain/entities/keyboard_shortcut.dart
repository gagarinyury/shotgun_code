import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

enum ShortcutAction {
  openProject,
  nextStep,
  copyContext,
  copyPrompt,
  undo,
  redo,
  save,
  search,
}

class KeyboardShortcut extends Equatable {
  final ShortcutAction action;
  final LogicalKeyboardKey key;
  final bool control;
  final bool shift;
  final bool alt;
  final bool meta;

  const KeyboardShortcut({
    required this.action,
    required this.key,
    this.control = false,
    this.shift = false,
    this.alt = false,
    this.meta = false,
  });

  /// Check if this shortcut matches the current key event
  bool matches(KeyEvent event, HardwareKeyboard keyboard) {
    return event.logicalKey == key &&
        keyboard.isControlPressed == control &&
        keyboard.isShiftPressed == shift &&
        keyboard.isAltPressed == alt &&
        keyboard.isMetaPressed == meta;
  }

  /// Get platform-specific label (Cmd on macOS, Ctrl on others)
  String get label {
    final modifiers = <String>[];
    // Order: Ctrl -> Alt -> Shift -> Meta (Cmd)
    if (control) modifiers.add('Ctrl');
    if (alt) modifiers.add('Alt');
    if (shift) modifiers.add('Shift');
    if (meta) modifiers.add('Cmd');

    modifiers.add(key.keyLabel);
    return modifiers.join('+');
  }

  @override
  List<Object?> get props => [action, key, control, shift, alt, meta];
}

/// Default shortcuts for the app
class DefaultShortcuts {
  static List<KeyboardShortcut> get all {
    return [
      const KeyboardShortcut(
        action: ShortcutAction.openProject,
        key: LogicalKeyboardKey.keyO,
        meta: true, // Cmd on macOS
      ),
      const KeyboardShortcut(
        action: ShortcutAction.nextStep,
        key: LogicalKeyboardKey.enter,
        meta: true,
      ),
      const KeyboardShortcut(
        action: ShortcutAction.copyContext,
        key: LogicalKeyboardKey.keyC,
        meta: true,
        shift: true,
      ),
      const KeyboardShortcut(
        action: ShortcutAction.undo,
        key: LogicalKeyboardKey.keyZ,
        meta: true,
      ),
      const KeyboardShortcut(
        action: ShortcutAction.search,
        key: LogicalKeyboardKey.keyF,
        meta: true,
      ),
    ];
  }
}
