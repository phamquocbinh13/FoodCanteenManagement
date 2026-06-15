import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_canteen_management/app/app.dart';
import 'package:food_canteen_management/app/di/injection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App smoke test shows splash then login', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await Injection.reset();
    await Injection.init();

    await tester.pumpWidget(
      const ProviderScope(
        child: FoodCanteenManagementApp(),
      ),
    );
    await tester.pump();
    expect(find.text('Starting…'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Staff Login'), findsOneWidget);
  });
}
