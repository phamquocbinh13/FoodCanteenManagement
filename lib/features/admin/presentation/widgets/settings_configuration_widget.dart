import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/admin_dashboard_provider.dart';

class SettingsConfigurationWidget extends ConsumerWidget {
  const SettingsConfigurationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(adminSettingsProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('System Settings & Configuration', style: Theme.of(context).textTheme.headlineMedium),
              ElevatedButton.icon(
                onPressed: () {
                  // TBD: Save Settings
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          settingsAsync.when(
            data: (settings) {
              if (settings == null) {
                return const Center(child: Text('Settings not found', style: TextStyle(color: AppColors.inkMuted)));
              }
              return Column(
                children: [
                  ListTile(
                    title: const Text('Default Currency'),
                    subtitle: const Text('The currency used for all transactions and reports.'),
                    trailing: SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: settings.defaultCurrency,
                        decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Tax Rate (BPS)'),
                    subtitle: const Text('Base points for tax calculations (e.g., 800 = 8.00%).'),
                    trailing: SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: settings.taxRateBps.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Service Charge (BPS)'),
                    subtitle: const Text('Base points for auto-gratuity/service charges (e.g., 500 = 5.00%).'),
                    trailing: SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: settings.serviceChargeBps.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                      ),
                    ),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Allow QR on Reserved Tables'),
                    subtitle: const Text('If enabled, customers can scan QR codes to join reserved tables.'),
                    value: settings.allowQrOnReservedTable,
                    onChanged: (val) {
                      // TBD: Toggle local state before save
                    },
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Payment Soft Lock'),
                    subtitle: const Text('If enabled, ordering is disabled when a payment is pending.'),
                    value: settings.paymentSoftLockEnabled,
                    onChanged: (val) {
                      // TBD: Toggle local state before save
                    },
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Failed to load settings: $err')),
          ),
        ],
      ),
    );
  }
}
