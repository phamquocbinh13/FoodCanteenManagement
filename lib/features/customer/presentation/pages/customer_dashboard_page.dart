import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../application/session/customer_session_messages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/restaurant_brand.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/enums/domain_enums.dart';
import '../providers/customer_ordering_provider.dart';
import '../providers/customer_session_provider.dart';
import '../widgets/customer_demo_exit_button.dart';

/// Customer session hub after a successful join with luxurious borderless layout.
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
    final brand = RestaurantBrand.current;

    if (controller.isLoading && snapshot == null) {
      return const Scaffold(
        body: Center(child: LoadingIndicator()),
      );
    }

    if (snapshot == null) {
      return Scaffold(
        body: ErrorState(
          title: 'Session unavailable',
          message:
              controller.errorMessage ?? CustomerSessionMessages.sessionNotFound,
          onRetry: () => context.go('/customer'),
          retryLabel: 'Back to join',
        ),
      );
    }

    final phase = controller.lifecyclePhase;
    final bill = ordering.bill;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        title: Text(brand.displayName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          RomsIconButton(
            icon: Icons.refresh_rounded,
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
          ),
          const CustomerDemoExitButton(),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const AmbientBackdrop(
              imageAsset: 'assets/images/backgrounds/bg_customer_sensory.png',
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              // ── Header Section (Table Label & Status in clean typographic style) ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.tableLabel,
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: AppColors.ink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text(
                        'ID: ${snapshot.session.displayNumber}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '•',
                        style: TextStyle(color: AppColors.inkMuted),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        controller.statusLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.brand,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // ── Order Progress Section ─────────────────────────────────────
              Text(
                'ORDER PROGRESS',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.inkMuted,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              if (ordering.batchProgress.isEmpty)
                Text(
                  'No orders sent to the kitchen yet. Browse the menu to begin.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.inkMuted,
                  ),
                )
              else
                ...ordering.batchProgress.map(
                  (batch) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Batch #${batch.batchNumber}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              batch.statusLabel,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.brand,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        if (batch.items.isNotEmpty)
                          ...batch.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${item.quantityLabel} x ${item.name}',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: AppColors.ink,
                                          ),
                                        ),
                                      ),
                                      RomsMoneyText(
                                        amountMinor: item.lineTotalMinor,
                                        currencyCode: 'VND',
                                        color: AppColors.ink,
                                      ),
                                    ],
                                  ),
                                  if (item.kitchenNotes.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12.0, top: 2.0),
                                      child: Text(
                                        item.kitchenNotes,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: AppColors.inkMuted,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24.0),

              // ── Bill Ledger Section ────────────────────────────────────────
              Text(
                'BILL LEDGER',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.inkMuted,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              if (bill != null && bill.totalMinor > 0)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Bill',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.ink,
                          ),
                        ),
                        RomsMoneyText(
                          amountMinor: bill.totalMinor,
                          currencyCode: 'VND',
                          large: true,
                          color: AppColors.ink,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Paid',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.inkMuted,
                          ),
                        ),
                        RomsMoneyText(
                          amountMinor: bill.paidMinor,
                          currencyCode: 'VND',
                          color: AppColors.inkMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Outstanding',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: bill.outstandingMinor == 0 ? AppColors.success : AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        RomsMoneyText(
                          amountMinor: bill.outstandingMinor,
                          currencyCode: 'VND',
                          color: bill.outstandingMinor == 0 ? AppColors.success : AppColors.accent,
                          large: true,
                        ),
                      ],
                    ),
                  ],
                )
              else
                Text(
                  'No items ordered yet.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
              const SizedBox(height: 32.0),

              // ── Concierge Dock (Browse Menu & Call Staff Horizontal Row) ──
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand,
                        foregroundColor: AppColors.onBrand,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      onPressed: () async {
                        await context.push('/s/${widget.sessionToken}/menu');
                        if (!context.mounted) return;
                        await ordering.refreshSessionOrdering(snapshot.session.id);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.menu_book_outlined, size: 18.0, color: AppColors.onBrand),
                          const SizedBox(width: 8.0),
                          const Text('Browse Menu'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.inkMuted,
                        side: BorderSide(color: AppColors.borderStrong),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      onPressed: () => context.push(
                        '/s/${widget.sessionToken}/request',
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.support_agent_outlined, size: 18.0, color: AppColors.inkMuted),
                          const SizedBox(width: 8.0),
                          const Text('Call Staff'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // ── Payment Action Triggers (Minimal flat text triggers at bottom) ──
              if (phase != SessionLifecyclePhase.closed && bill != null && bill.outstandingMinor > 0) ...[
                const Divider(color: AppColors.border, height: 1.0),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: controller.paymentRequested ? null : _requestPayment,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.brand,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: Text(
                    controller.paymentRequested
                        ? 'PAYMENT REQUESTED'
                        : 'REQUEST PAYMENT (CASH)',
                    style: const TextStyle(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () async {
                    final url = await ordering.createVnpayIntent();
                    if (url != null && context.mounted) {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      
                      // Poll status every 2 seconds for up to 5 minutes (150 iterations) to allow payment processing
                      for (int i = 0; i < 150; i++) {
                        await Future.delayed(const Duration(seconds: 2));
                        if (!context.mounted) return;
                        final status = await ordering.checkPaymentStatus();
                        if (status == 'paid') {
                          await closeInAppWebView();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Payment Successful!')),
                          );
                          await controller.refreshCurrentSession();
                          if (!context.mounted) return;
                          await ordering.refreshSessionOrdering(snapshot.session.id);
                          return;
                        } else if (status == 'failed') {
                          await closeInAppWebView();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Payment Failed or Canceled')),
                          );
                          await controller.refreshCurrentSession();
                          if (!context.mounted) return;
                          await ordering.refreshSessionOrdering(snapshot.session.id);
                          return;
                        }
                      }
                      
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment status checking. Refresh dashboard to update.')),
                      );
                    } else if (ordering.errorMessage != null && context.mounted) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(ordering.errorMessage!)),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: const Text(
                    'PAY WITH VNPAY',
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  ),
);
  }
}
