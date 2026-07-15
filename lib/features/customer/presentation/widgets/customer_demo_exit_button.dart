import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../actions/customer_demo_exit.dart';

/// AppBar action for leaving the anonymous customer session during demo testing.
class CustomerDemoExitButton extends ConsumerWidget {
  const CustomerDemoExitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: 'Leave session',
      icon: const Icon(Icons.logout),
      onPressed: () => confirmAndExitCustomerDemo(context: context, ref: ref),
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
