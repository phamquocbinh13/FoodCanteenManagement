import '../../domain/entities/staff_request.dart';
import '../../domain/enums/domain_enums.dart';

/// Cashier / customer display labels for [RequestType].
String staffRequestTypeLabel(RequestType type) => switch (type) {
      RequestType.payment => 'Request Payment',
      RequestType.staffAssistance => 'Staff Assistance',
      RequestType.extraWater => 'Extra Water',
      RequestType.extraBowl => 'Extra Bowl',
      RequestType.extraSpoon => 'Extra Spoon',
    };

/// Queue row for cashier request board.
final class StaffRequestQueueItemView {
  const StaffRequestQueueItemView({
    required this.request,
    required this.tableLabel,
    required this.sessionDisplayNumber,
  });

  final StaffRequest request;
  final String tableLabel;
  final String sessionDisplayNumber;

  String get typeLabel => staffRequestTypeLabel(request.requestType);
  bool get isPayment => request.requestType == RequestType.payment;
}
