import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/enums/domain_enums.dart';

/// Result of the force-close sheet.
final class ForceCloseChoice {
  const ForceCloseChoice({
    required this.reason,
    this.note,
  });

  final ForceCloseReason reason;
  final String? note;
}

Future<ForceCloseChoice?> showForceCloseSheet(BuildContext context) {
  return showRomsBottomSheet<ForceCloseChoice>(
    context: context,
    builder: (context) => const _ForceCloseSheet(),
  );
}

class _ForceCloseSheet extends StatefulWidget {
  const _ForceCloseSheet();

  @override
  State<_ForceCloseSheet> createState() => _ForceCloseSheetState();
}

class _ForceCloseSheetState extends State<_ForceCloseSheet> {
  ForceCloseReason _reason = ForceCloseReason.customerLeft;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RomsBottomSheetScaffold(
      title: 'Force close session',
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Use only when payment cannot be completed normally. '
              'This frees the table and revokes guest access.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            RadioGroup<ForceCloseReason>(
              groupValue: _reason,
              onChanged: (value) {
                if (value != null) setState(() => _reason = value);
              },
              child: Column(
                children: [
                  for (final reason in ForceCloseReason.values)
                    RadioListTile<ForceCloseReason>(
                      contentPadding: EdgeInsets.zero,
                      value: reason,
                      title: Text(_reasonLabel(reason)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            RomsTextField(
              controller: _noteController,
              label: 'Note (optional)',
              hint: 'Short context for the shift log',
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            DangerButton(
              label: 'Force close',
              icon: Icons.lock_reset_outlined,
              isExpanded: true,
              onPressed: () {
                final note = _noteController.text.trim();
                Navigator.of(context).pop(
                  ForceCloseChoice(
                    reason: _reason,
                    note: note.isEmpty ? null : note,
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            SecondaryButton(
              label: 'Cancel',
              isExpanded: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  String _reasonLabel(ForceCloseReason reason) => switch (reason) {
        ForceCloseReason.customerLeft => 'Customer left',
        ForceCloseReason.dispute => 'Dispute',
        ForceCloseReason.systemError => 'System error',
        ForceCloseReason.other => 'Other',
      };
}
