import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_spacing.dart';

/// Renders a QR code encoding the raw session bearer token.
class SessionQrDisplay extends StatelessWidget {
  const SessionQrDisplay({
    super.key,
    required this.sessionToken,
    this.size = 180,
  });

  final String sessionToken;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: QrImageView(
            data: sessionToken,
            version: QrVersions.auto,
            size: size,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Scan to join session',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
