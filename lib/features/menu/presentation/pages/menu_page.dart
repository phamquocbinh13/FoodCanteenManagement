import '../../../../shared/presentation/placeholder_page.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Menu',
      subtitle: 'Catalog management — Sprint 5',
    );
  }
}

class SessionMenuPage extends StatelessWidget {
  const SessionMenuPage({super.key, required this.sessionToken});

  final String sessionToken;

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(
      title: 'Menu',
      subtitle: 'Session menu — Sprint 5',
    );
  }
}
