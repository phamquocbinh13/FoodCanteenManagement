import 'package:flutter/material.dart';

/// Global application shell providing snackbar, overlay, and dialog support.
///
/// Wrap feature pages via go_router [ShellRoute] so every route shares
/// a single [ScaffoldMessengerState].
class AppShell extends StatelessWidget {
  AppShell({
    super.key,
    required this.child,
    GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
  }) : scaffoldMessengerKey =
            scaffoldMessengerKey ?? _defaultScaffoldMessengerKey;

  final Widget child;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  static final GlobalKey<ScaffoldMessengerState> _defaultScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get messengerKey =>
      _defaultScaffoldMessengerKey;

  /// Shows a floating snackbar through the global shell messenger.
  static void showSnackBar(
    BuildContext context, {
    required String message,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    _defaultScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), action: action, duration: duration),
    );
  }

  /// Shows a dialog using the nearest navigator (go_router compatible).
  static Future<T?> showAppDialog<T>({
    required BuildContext context,
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: SafeArea(child: child),
    );
  }
}
