import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/keyboard_shortcut_service.dart';

class GlobalShortcutsWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalShortcutsWrapper({
    required this.child,
    super.key,
  });

  @override
  ConsumerState<GlobalShortcutsWrapper> createState() =>
      _GlobalShortcutsWrapperState();
}

class _GlobalShortcutsWrapperState
    extends ConsumerState<GlobalShortcutsWrapper> {
  @override
  Widget build(BuildContext context) {
    final shortcutService = ref.watch(keyboardShortcutServiceProvider);

    return KeyboardListener(
      focusNode: FocusNode()..requestFocus(),
      autofocus: true,
      onKeyEvent: (event) {
        final keyboard = HardwareKeyboard.instance;
        final handled = shortcutService.handleKeyEvent(event, keyboard);
        if (handled) {
          // Event was handled, prevent default behavior
        }
      },
      child: widget.child,
    );
  }
}
