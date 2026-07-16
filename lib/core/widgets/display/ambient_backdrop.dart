import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Premium ambient blur background component for high-end dining UX.
class AmbientBackdrop extends StatelessWidget {
  const AmbientBackdrop({super.key, required this.imageAsset});

  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── 1. Image Asset at visible ambient opacity ──
          Opacity(
            opacity: 0.30, // Increased to 0.3 per user request
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
            ),
          ),
          // ── 2. Gaussian Blur Filter Overlay ──
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 2.0),
            child: const SizedBox.shrink(),
          ),
          // ── 3. Soft Radial Gradient fading to Canvas at the edges ──
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.4,
                colors: [
                  Colors.transparent,
                  AppColors.canvas.withValues(alpha: 0.8),
                  AppColors.canvas,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
