import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/request/staff_request_view_models.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../providers/cashier_session_provider.dart';
import 'force_close_sheet.dart';
import 'payment_close_sheet.dart';
import 'session_qr_display.dart';

/// Dense right-rail session detail for cashier master–detail floor.
///
/// Answers: pay now? force close? reissue QR? what is the bill?
class CashierSessionDetailPanel extends ConsumerWidget {
  const CashierSessionDetailPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(cashierSessionControllerProvider);
    final snapshot = session.activeSnapshot;
    final theme = Theme.of(context);

    if (snapshot == null) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app_outlined,
                  size: 36,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Select a table',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Available → open session · Occupied → manage now',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final phase = session.lifecyclePhase;
    final tone = switch (phase) {
      SessionLifecyclePhase.available => StatusTone.success,
      SessionLifecyclePhase.occupied => StatusTone.brand,
      SessionLifecyclePhase.waitingPayment => StatusTone.warning,
      SessionLifecyclePhase.closed => StatusTone.neutral,
    };
    final duration = session.sessionDuration;
    final durationLabel = duration == null
        ? '—'
        : '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    final nextAction = phase == SessionLifecyclePhase.waitingPayment
        ? 'NEXT: Take payment'
        : (session.sessionRequests.any((r) => r.status == RequestStatus.pending)
            ? 'NEXT: Handle request'
            : 'NEXT: Monitor / close when ready');

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: phase == SessionLifecyclePhase.waitingPayment
                ? AppColors.warning.withValues(alpha: 0.12)
                : theme.colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      nextAction,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (session.isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      tooltip: 'Refresh',
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: () async {
                        await session.restore();
                        await session.refreshSessionDetail();
                      },
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RomsTableLabel(
                        label: snapshot.tableLabel,
                        emphasize: true,
                        statusLabel: _phaseLabel(phase, snapshot.session.paymentStatus),
                        tone: tone,
                      ),
                    ),
                    RomsSessionBadge(
                      displayNumber: snapshot.session.displayNumber,
                      tone: tone,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _DenseFacts(
                  rows: [
                    ('Time in', durationLabel),
                    ('Opened', _formatTime(snapshot.session.openedAt)),
                    (
                      'Opened via',
                      snapshot.session.openedVia.name,
                    ),
                    ('Batches', '${snapshot.session.currentBatchNumber}'),
                    ('Status', _phaseLabel(phase, snapshot.session.paymentStatus)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _SectionTitle('Bill'),
                const SizedBox(height: AppSpacing.xs),
                if (session.bill == null)
                  Text('No bill yet', style: theme.textTheme.bodySmall)
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Bill', style: theme.textTheme.bodyMedium),
                          RomsMoneyText(
                            amountMinor: session.bill!.totalMinor,
                            currencyCode: 'VND',
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Paid', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.inkMuted)),
                          RomsMoneyText(
                            amountMinor: session.bill!.paidMinor,
                            currencyCode: 'VND',
                            color: AppColors.inkMuted,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Outstanding', style: theme.textTheme.titleSmall?.copyWith(color: AppColors.warning)),
                          RomsMoneyText(
                            amountMinor: session.bill!.outstandingMinor,
                            currencyCode: 'VND',
                            large: true,
                            color: AppColors.warning,
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: AppSpacing.md),
                _SectionTitle(
                  'Batches (${session.batchSummaries.length})',
                ),
                const SizedBox(height: AppSpacing.xs),
                if (session.batchSummaries.isEmpty)
                  Text('None', style: theme.textTheme.bodySmall)
                else
                  ...session.batchSummaries.map(
                    (b) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '#${b.batchNumber} · ${_formatTime(b.createdAt)}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          StatusChip(
                            label: b.statusLabel,
                            tone: b.completedAt != null
                                ? StatusTone.success
                                : StatusTone.warning,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                _SectionTitle('Join / QR'),
                const SizedBox(height: AppSpacing.xs),
                if (session.sessionToken != null) ...[
                  SelectableText(
                    session.sessionToken!,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: SessionQrDisplay(
                      sessionToken: session.sessionToken!,
                      size: 140,
                    ),
                  ),
                ] else
                  Text(
                    'No code in memory — reissue to show QR.',
                    style: theme.textTheme.bodySmall,
                  ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  label: 'Reissue join code',
                  isExpanded: true,
                  onPressed:
                      session.isLoading ? null : () => session.reissueJoinToken(),
                ),
                const SizedBox(height: AppSpacing.md),
                _SectionTitle(
                  'Requests (${session.sessionRequests.where((r) => r.status == RequestStatus.pending).length} pending)',
                ),
                const SizedBox(height: AppSpacing.xs),
                if (session.sessionRequests.isEmpty)
                  Text('None', style: theme.textTheme.bodySmall)
                else
                  ...session.sessionRequests.take(4).map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${staffRequestTypeLabel(r.requestType)} · ${r.status.name}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ),
                if (session.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    session.errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                SecondaryButton(
                  label: 'Mark waiting payment',
                  isExpanded: true,
                  onPressed: session.isLoading ||
                          phase == SessionLifecyclePhase.waitingPayment
                      ? null
                      : () => session.markWaitingPayment(),
                ),
                const SizedBox(height: AppSpacing.xs),
                PrimaryButton(
                  label: snapshot.session.paymentStatus == SessionPaymentStatus.waitingGateway
                      ? 'Payment Processing...'
                      : (session.bill?.outstandingMinor == 0
                          ? 'Close session'
                          : 'Take payment & close'),
                  icon: Icons.payments_outlined,
                  isExpanded: true,
                  isLoading: session.isLoading,
                  onPressed: session.isLoading || snapshot.session.paymentStatus == SessionPaymentStatus.waitingGateway
                      ? null
                      : () => _closeWithPayment(context, session),
                ),
                const SizedBox(height: AppSpacing.xs),
                DangerButton(
                  label: 'Force close',
                  isExpanded: true,
                  onPressed: session.isLoading
                      ? null
                      : () => _forceClose(context, session),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _closeWithPayment(
    BuildContext context,
    CashierSessionController session,
  ) async {
    final outstanding = session.bill?.outstandingMinor ?? 0;
    
    PaymentMethod? paymentMethod = PaymentMethod.cash;
    if (outstanding > 0) {
      final choice = await showPaymentCloseSheet(context);
      if (choice == null || !context.mounted) return;
      paymentMethod = choice.paymentMethod;
    }

    if (!context.mounted) return;

    final confirmed = await showRomsConfirmDialog(
      context: context,
      title: outstanding > 0 ? 'Close session with payment?' : 'Close session?',
      message: outstanding > 0 
          ? 'Records payment and frees the table. Cannot be undone.'
          : 'Frees the table. Outstanding balance is already fully paid.',
      confirmLabel: outstanding > 0 ? 'Take payment & close' : 'Close session',
      cancelLabel: 'Not yet',
    );
    if (confirmed == true) {
      await session.closeSession(paymentMethod: paymentMethod);
    }
  }

  Future<void> _forceClose(
    BuildContext context,
    CashierSessionController session,
  ) async {
    final choice = await showForceCloseSheet(context);
    if (choice == null || !context.mounted) return;
    final confirmed = await showRomsConfirmDialog(
      context: context,
      title: 'Force close this session?',
      message: 'Frees the table without normal payment.',
      confirmLabel: 'Force close',
      cancelLabel: 'Keep open',
      isDestructive: true,
    );
    if (confirmed == true) {
      await session.closeSession(
        closeType: SessionCloseType.forceClosed,
        forceCloseReason: choice.reason,
        forceCloseNote: choice.note,
        paymentMethod: PaymentMethod.other,
      );
    }
  }

  String _phaseLabel(SessionLifecyclePhase phase, SessionPaymentStatus? paymentStatus) {
    if (paymentStatus == SessionPaymentStatus.waitingGateway) return 'Payment Processing...';
    return switch (phase) {
      SessionLifecyclePhase.available => 'Available',
      SessionLifecyclePhase.occupied => 'Occupied',
      SessionLifecyclePhase.waitingPayment => 'Waiting payment',
      SessionLifecyclePhase.closed => 'Closed',
    };
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class _DenseFacts extends StatelessWidget {
  const _DenseFacts({required this.rows});
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        for (final row in rows)
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.$1,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(row.$2, style: theme.textTheme.titleSmall),
              ],
            ),
          ),
      ],
    );
  }
}
