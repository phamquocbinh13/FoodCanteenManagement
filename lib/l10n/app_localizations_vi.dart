// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Quản Lý Canteen';

  @override
  String get splashTitle => 'Quản Lý Canteen';

  @override
  String get loginTitle => 'Đăng Nhập Nhân Viên';

  @override
  String get retry => 'Thử lại';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get loading => 'Đang tải…';

  @override
  String get errorGeneric => 'Đã xảy ra lỗi';

  @override
  String get emptyStateTitle => 'Chưa có dữ liệu';

  @override
  String get searchHint => 'Tìm kiếm…';
}
