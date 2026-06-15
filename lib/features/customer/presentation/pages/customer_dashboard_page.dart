import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../application/session/customer_session_messages.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../providers/customer_ordering_provider.dart';
import '../providers/customer_session_provider.dart';
import '../widgets/customer_demo_exit_button.dart';

/// Customer dashboard after a successful join.
class SessionPage extends ConsumerStatefulWidget {
  const SessionPage({super.key, required this.sessionToken});

  final String sessionToken;

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureSession());
  }

  Future<void> _ensureSession() async {
    final controller = ref.read(customerSessionControllerProvider);
    if (controller.isJoined &&
        controller.sessionToken == widget.sessionToken) {
      return;
    }

    final ok = await controller.join(widget.sessionToken);
    if (!mounted) return;
    if (!ok) {
      context.go('/customer');
      return;
    }
    await ref.read(customerOrderingControllerProvider).refreshSessionOrdering(
          ref.read(customerSessionControllerProvider).snapshot!.session.id,
        );
  }

  Future<void> _requestPayment() async {
    final controller = ref.read(customerSessionControllerProvider);
    await controller.requestPayment();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(CustomerSessionMessages.paymentRequested)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(customerSessionControllerProvider);
    final ordering = ref.watch(customerOrderingControllerProvider);
    final theme = Theme.of(context);
    final snapshot = controller.snapshot;

    if (controller.isLoading && snapshot == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (snapshot == null) {
      return Scaffold(
        body: Center(
          child: Text(
            controller.errorMessage ?? CustomerSessionMessages.sessionNotFound,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Session'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: controller.isLoading
                ? null
                : () async {
                    await controller.refreshCurrentSession();
                    if (!context.mounted) return;
                    await ordering.refreshSessionOrdering(
                      snapshot.session.id,
                    );
                  },
            icon: const Icon(Icons.refresh),
          ),
          const CustomerDemoExitButton(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Restaurant', style: theme.textTheme.labelLarge),
                      Text(
                        'Demo Restaurant',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('Table', style: theme.textTheme.labelLarge),
                      Text(
                        snapshot.tableLabel,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('Status', style: theme.textTheme.labelLarge),
                      Text(
                        controller.statusLabel,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text('Session', style: theme.textTheme.labelLarge),
                      Text(snapshot.session.displayNumber),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Your Batches', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              if (ordering.batchProgress.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Text(
                      'Chưa có batch nào được gửi bếp.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                ...ordering.batchProgress.map(
                  (batch) => Card(
                    child: ListTile(
                      title: Text('Batch #${batch.batchNumber}'),
                      trailing: Text(
                        batch.statusLabel,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: batch.isCompleted
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              Text('Order Summary', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    ordering.bill != null && ordering.bill!.totalMinor > 0
                        ? 'Total: \$${(ordering.bill!.totalMinor / 100).toStringAsFixed(2)}'
                        : 'No items ordered yet.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton(
                onPressed: () async {
                  await context.push('/s/${widget.sessionToken}/menu');
                  if (!context.mounted) return;
                  await ordering.refreshSessionOrdering(snapshot.session.id);
                },
                child: const Text('Add More'),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () => context.push(
                  '/s/${widget.sessionToken}/request',
                ),
                child: const Text('Call Staff'),
              ),
              const SizedBox(height: AppSpacing.sm),
              FilledButton(
                onPressed: controller.lifecyclePhase ==
                            SessionLifecyclePhase.closed ||
                        controller.paymentRequested
                    ? null
                    : _requestPayment,
                child: Text(
                  controller.paymentRequested
                      ? 'Payment Requested'
                      : 'Request Payment',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
