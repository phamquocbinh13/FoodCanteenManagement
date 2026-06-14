import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_canteen_management/app/app.dart';
import 'package:food_canteen_management/app/di/injection.dart';
import 'package:food_canteen_management/features/splash/presentation/pages/splash_page.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await Injection.init();
    await tester.pumpWidget(
      const ProviderScope(
        child: FoodCanteenManagementApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SplashPage), findsOneWidget);
  });
}
