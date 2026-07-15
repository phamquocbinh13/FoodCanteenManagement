import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/enums/domain_enums.dart';

/// Result of the take-payment sheet.
final class PaymentCloseChoice {
  const PaymentCloseChoice({required this.paymentMethod});

  final PaymentMethod paymentMethod;
}

Future<PaymentCloseChoice?> showPaymentCloseSheet(BuildContext context) {
  return showRomsBottomSheet<PaymentCloseChoice>(
    context: context,
    builder: (context) => const _PaymentCloseSheet(),
  );
}

class _PaymentCloseSheet extends StatefulWidget {
  const _PaymentCloseSheet();

  @override
  State<_PaymentCloseSheet> createState() => _PaymentCloseSheetState();
}

class _PaymentCloseSheetState extends State<_PaymentCloseSheet> {
  PaymentMethod _method = PaymentMethod.cash;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RomsBottomSheetScaffold(
      title: 'Take payment',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select how the guest paid, then close the session.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          RadioGroup<PaymentMethod>(
            groupValue: _method,
            onChanged: (value) {
              if (value != null) setState(() => _method = value);
            },
            child: Column(
              children: [
                for (final method in PaymentMethod.values)
                  RadioListTile<PaymentMethod>(
                    contentPadding: EdgeInsets.zero,
                    value: method,
                    title: Text(_methodLabel(method)),
                    subtitle: Text(_methodHint(method)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: 'Confirm payment & close',
            icon: Icons.payments_outlined,
            isExpanded: true,
            onPressed: () => Navigator.of(context).pop(
              PaymentCloseChoice(paymentMethod: _method),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: 'Cancel',
            isExpanded: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  String _methodLabel(PaymentMethod method) => switch (method) {
        PaymentMethod.cash => 'Cash',
        PaymentMethod.card => 'Card',
        PaymentMethod.bankTransfer => 'Bank transfer',
        PaymentMethod.other => 'Other',
      };

  String _methodHint(PaymentMethod method) => switch (method) {
        PaymentMethod.cash => 'Counted at the register',
        PaymentMethod.card => 'Card terminal / tap',
        PaymentMethod.bankTransfer => 'QR / bank transfer',
        PaymentMethod.other => 'Voucher, comps, or mixed',
      };
}
