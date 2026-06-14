import '../../../../shared/presentation/placeholder_page.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Request Queue',
      subtitle: 'Call-staff requests — Sprint 9',
    );
  }
}

class SessionRequestPage extends StatelessWidget {
  const SessionRequestPage({super.key, required this.sessionToken});

  final String sessionToken;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Call Staff',
      subtitle: 'Session requests — Sprint 9',
    );
  }
}
