import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../application/session/customer_session_messages.dart';
import '../providers/customer_ordering_provider.dart';
import '../providers/customer_session_provider.dart';

/// Clears customer session scope and returns to staff login for role switching.
Future<void> confirmAndExitCustomerDemo({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(CustomerSessionMessages.demoExitTitle),
      content: const Text(CustomerSessionMessages.demoExitPrompt),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(CustomerSessionMessages.demoExitCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(CustomerSessionMessages.demoExitConfirm),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;

  await exitCustomerDemo(ref);
  if (context.mounted) {
    context.go(RoutePaths.login);
  }
}

/// Tears down persisted token, cart scope, and in-memory customer providers.
Future<void> exitCustomerDemo(WidgetRef ref) async {
  final session = ref.read(customerSessionControllerProvider);
  final ordering = ref.read(customerOrderingControllerProvider);
  final sessionId = session.snapshot?.session.id;

  try {
    if (sessionId != null) {
      await ordering.clearCart(sessionId);
    }
  } catch (_) {
    // Leaving must succeed even if cart clear fails remotely.
  } finally {
    await session.leaveSession();
    ordering.resetSessionState();
    ref.invalidate(customerOrderingControllerProvider);
  }
}
