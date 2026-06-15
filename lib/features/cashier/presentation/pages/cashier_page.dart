import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../../../../shared/presentation/staff_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/cashier_session_provider.dart';
import '../widgets/session_qr_display.dart';

class CashierPage extends ConsumerWidget {
  const CashierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);
    final session = ref.watch(cashierSessionControllerProvider);
    final theme = Theme.of(context);

    return StaffScaffold(
      title: 'Cashier',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (role != null) Center(child: StaffRoleBadge(role: role)),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Session Engine Demo',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                _StatusCard(session: session),
                if (session.hasActiveSession && session.batchSummaries.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text('Kitchen Batches (read-only)', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  ...session.batchSummaries.map(
                    (batch) => Card(
                      child: ListTile(
                        title: Text('Batch #${batch.batchNumber}'),
                        subtitle: Text(
                          'Created ${_formatTime(batch.createdAt)}'
                          '${batch.completedAt != null ? ' • Done ${_formatTime(batch.completedAt!)}' : ''}',
                        ),
                        trailing: Text(batch.statusLabel),
                      ),
                    ),
                  ),
                ],
                if (session.hasActiveSession &&
                    session.sessionToken != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  _CustomerShareCard(
                    tableLabel: session.activeSnapshot?.tableLabel ?? 'Table',
                    displayNumber:
                        session.activeSnapshot?.session.displayNumber ?? '',
                    sessionToken: session.sessionToken!,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                if (session.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Text(
                      session.errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                if (!session.hasActiveSession)
                  FilledButton(
                    onPressed: session.isLoading
                        ? null
                        : () => session.createOnTable1(),
                    child: const Text('Create Session — Table 1'),
                  ),
                if (session.hasActiveSession) ...[
                  OutlinedButton(
                    onPressed: session.isLoading ||
                            session.lifecyclePhase ==
                                SessionLifecyclePhase.waitingPayment
                        ? null
                        : () => session.markWaitingPayment(),
                    child: const Text('Mark Waiting Payment'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FilledButton.tonal(
                    onPressed: session.isLoading
                        ? null
                        : () => session.closeSession(),
                    child: const Text('Close Session'),
                  ),
                ],
                if (session.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.lg),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatTime(DateTime dt) {
  final local = dt.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.session});

  final CashierSessionController session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final snapshot = session.activeSnapshot;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phase', style: theme.textTheme.labelLarge),
            Text(
              _phaseLabel(session.lifecyclePhase),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            if (snapshot != null) ...[
              Text('Display #', style: theme.textTheme.labelLarge),
              Text(
                snapshot.session.displayNumber,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Table', style: theme.textTheme.labelLarge),
              Text(snapshot.tableLabel, style: theme.textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.sm),
              Text('Session status', style: theme.textTheme.labelLarge),
              Text(
                snapshot.session.status.name,
                style: theme.textTheme.bodyLarge,
              ),
            ] else
              Text(
                'No active session. Table 1 is available.',
                style: theme.textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }

  String _phaseLabel(SessionLifecyclePhase phase) {
    return switch (phase) {
      SessionLifecyclePhase.available => 'Available',
      SessionLifecyclePhase.occupied => 'Occupied',
      SessionLifecyclePhase.waitingPayment => 'Waiting Payment',
      SessionLifecyclePhase.closed => 'Closed',
    };
  }
}

class _CustomerShareCard extends StatelessWidget {
  const _CustomerShareCard({
    required this.tableLabel,
    required this.displayNumber,
    required this.sessionToken,
  });

  final String tableLabel;
  final String displayNumber;
  final String sessionToken;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Customer Join',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(tableLabel, style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text('Session', style: theme.textTheme.labelLarge),
            Text(displayNumber, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text('Session Code', style: theme.textTheme.labelLarge),
            SelectableText(
              sessionToken,
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(child: SessionQrDisplay(sessionToken: sessionToken)),
          ],
        ),
      ),
    );
  }
}
