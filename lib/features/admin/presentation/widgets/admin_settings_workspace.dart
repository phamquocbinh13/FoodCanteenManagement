import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import 'settings_configuration_widget.dart';

class AdminSettingsWorkspace extends StatelessWidget {
  const AdminSettingsWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          SettingsConfigurationWidget(),
        ],
      ),
    );
  }
}
