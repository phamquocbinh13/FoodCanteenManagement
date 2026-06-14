import '../../../../shared/presentation/placeholder_page.dart';
import 'package:flutter/material.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Customer',
      subtitle: 'Customer surface — Sprint 7',
    );
  }
}

class SessionPage extends StatelessWidget {
  const SessionPage({super.key, required this.sessionToken});

  final String sessionToken;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Session',
      subtitle: 'Token: $sessionToken — Sprint 3',
    );
  }
}

class JoinPage extends StatelessWidget {
  const JoinPage({super.key, required this.joinToken});

  final String joinToken;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'QR Join',
      subtitle: 'Join token: $joinToken — Sprint 4',
    );
  }
}
