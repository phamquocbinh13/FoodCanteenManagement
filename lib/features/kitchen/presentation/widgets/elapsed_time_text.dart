import 'dart:async';

import 'package:flutter/material.dart';

/// Live elapsed-time label for kitchen batch cards (createdAt → now).
class ElapsedTimeText extends StatefulWidget {
  const ElapsedTimeText({
    super.key,
    required this.createdAt,
    this.style,
  });

  final DateTime createdAt;
  final TextStyle? style;

  @override
  State<ElapsedTimeText> createState() => _ElapsedTimeTextState();
}

class _ElapsedTimeTextState extends State<ElapsedTimeText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static String formatElapsed(Duration elapsed) {
    final minutes = elapsed.inMinutes;
    if (minutes < 1) return 'Vừa mới';
    if (minutes < 60) return 'Chờ $minutes phút';
    final hours = elapsed.inHours;
    final remainder = minutes % 60;
    if (remainder == 0) return 'Chờ $hours giờ';
    return 'Chờ $hours giờ $remainder phút';
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = DateTime.now().difference(widget.createdAt.toLocal());
    return Text(
      formatElapsed(elapsed),
      style: widget.style,
    );
  }
}

String formatKitchenClockTime(DateTime dt) {
  final local = dt.toLocal();
  final h = local.hour.toString().padLeft(2, '0');
  final m = local.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
