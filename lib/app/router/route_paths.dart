/// Central route path constants.
///
/// Customer deep links and staff surfaces are separated by prefix.
/// See [ARCHITECTURE.md] §9 for navigation strategy.
abstract final class RoutePaths {
  // Bootstrap
  static const splash = '/';

  // Customer
  static const join = '/join/:joinToken';
  static const joinPattern = '/join/:joinToken';
  static const customer = '/customer';
  static const customerScan = '/customer/scan';
  static const session = '/s/:sessionToken';
  static const sessionPattern = '/s/:sessionToken';
  static const sessionMenu = '/s/:sessionToken/menu';
  static const sessionRequest = '/s/:sessionToken/request';

  // Staff auth
  static const login = '/login';

  // Staff surfaces
  static const kitchen = '/kitchen';
  static const cashier = '/cashier';
  static const admin = '/admin';
  static const shipper = '/shipper';

  // Staff order flows
  static const menu = '/menu';
  static const delivery = '/delivery';
  static const takeaway = '/takeaway';
  static const request = '/request';

  /// Named route identifiers for go_router.
  static const splashName = 'splash';
  static const loginName = 'login';
  static const customerName = 'customer';
  static const customerScanName = 'customerScan';
  static const kitchenName = 'kitchen';
  static const cashierName = 'cashier';
  static const adminName = 'admin';
  static const shipperName = 'shipper';
  static const menuName = 'menu';
  static const deliveryName = 'delivery';
  static const takeawayName = 'takeaway';
  static const requestName = 'request';
  static const joinName = 'join';
  static const sessionName = 'session';
  static const sessionMenuName = 'sessionMenu';
  static const sessionRequestName = 'sessionRequest';
}
