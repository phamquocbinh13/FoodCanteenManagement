import 'package:flutter/material.dart';

/// Icon toolbar action — [tooltip] required for accessibility.
class RomsIconButton extends StatelessWidget {
  const RomsIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, color: color),
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }
}
