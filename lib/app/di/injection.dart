import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import 'modules/admin_module.dart';
import 'modules/auth_module.dart';
import 'modules/ordering_module.dart';
import 'modules/customer_module.dart';
import 'modules/core_module.dart';
import 'modules/delivery_module.dart';
import 'modules/kitchen_module.dart';
import 'modules/menu_module.dart';
import 'modules/payment_module.dart';
import 'modules/request_module.dart';
import 'modules/session_module.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Dependency injection registry composing feature modules.
abstract final class Injection {
  static AppConfig? _config;
  static bool _initialized = false;

  static AppConfig get config => _config!;

  static Future<void> init({AppConfig? config}) async {
    if (_initialized) return;

    _config = config ?? AppConfig.current();

    await CoreModule.register(sl, _config!);
    OrderingModule.register(sl);
    PaymentModule.register(sl);
    AuthModule.register(sl);
    MenuModule.register(sl);
    SessionModule.register(sl);
    CustomerModule.register(sl);
    KitchenModule.register(sl);
    RequestModule.register(sl);
    DeliveryModule.register(sl);
    AdminModule.register(sl);

    _initialized = true;
  }

  static Future<void> reset() async {
    await sl.reset();
    _config = null;
    _initialized = false;
  }
}
