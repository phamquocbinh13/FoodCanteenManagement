import 'package:flutter/material.dart';

import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../buttons/danger_button.dart';

/// Themed confirm dialog — max one primary + one dismissive action.
Future<bool?> showRomsConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDestructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          SecondaryButton(
            label: cancelLabel,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          if (isDestructive)
            DangerButton(
              label: confirmLabel,
              onPressed: () => Navigator.of(ctx).pop(true),
            )
          else
            PrimaryButton(
              label: confirmLabel,
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
        ],
      );
    },
  );
}
