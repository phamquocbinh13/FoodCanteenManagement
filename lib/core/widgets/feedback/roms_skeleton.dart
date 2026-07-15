import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

/// Layout-matching placeholder for first paint.
class RomsSkeleton extends StatefulWidget {
  const RomsSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final double? borderRadius;

  @override
  State<RomsSkeleton> createState() => _RomsSkeletonState();
}

class _RomsSkeletonState extends State<RomsSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? AppDarkColors.surfaceRaised : AppColors.surfaceRaised;
    final hi = isDark ? AppDarkColors.border : AppColors.border;

    if (AppMotion.reduceMotion(context)) {
      return _box(base);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return _box(Color.lerp(base, hi, t)!);
      },
    );
  }

  Widget _box(Color color) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? AppRadius.xs,
        ),
      ),
    );
  }
}

/// Common catalog skeleton block.
class RomsSkeletonList extends StatelessWidget {
  const RomsSkeletonList({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, _) => const Row(
        children: [
          RomsSkeleton(width: 56, height: 56, borderRadius: AppRadius.md),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RomsSkeleton(width: double.infinity, height: 14),
                SizedBox(height: AppSpacing.sm),
                RomsSkeleton(width: 120, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
