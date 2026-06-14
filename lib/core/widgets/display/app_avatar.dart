import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Circular avatar with optional image and fallback initials.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 40,
    this.backgroundColor,
  });

  final String? imageUrl;
  final String? initials;
  final double size;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor ?? AppColors.primaryLight,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null && initials != null
          ? Text(
              initials!,
              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: size * 0.35,
                fontWeight: FontWeight.w600,
              ),
            )
          : imageUrl == null
              ? Icon(Icons.person, size: size * 0.5, color: AppColors.textOnPrimary)
              : null,
    );
  }
}
