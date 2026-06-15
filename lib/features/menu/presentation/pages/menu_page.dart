import '../../../../shared/presentation/placeholder_page.dart';
import 'package:flutter/material.dart';

export '../../../customer/presentation/pages/session_menu_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Catalog management',
      subtitle: 'Manager menu editor — future sprint',
    );
  }
}
