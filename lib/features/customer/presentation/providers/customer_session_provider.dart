import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/injection.dart';
import '../controllers/customer_session_controller.dart';

export '../controllers/customer_session_controller.dart';

final customerSessionControllerProvider =
    ChangeNotifierProvider<CustomerSessionController>((ref) {
  return sl<CustomerSessionController>();
});
