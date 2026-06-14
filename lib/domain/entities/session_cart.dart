import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_cart.freezed.dart';
part 'session_cart.g.dart';

/// Pre-confirm mutable cart for a [DineInSession]. DATA_MODEL §3.8.
///
/// One cart per open session. [version] supports optimistic concurrency for
/// multi-device dine-in. Cleared after batch confirmation.
@freezed
abstract class SessionCart with _$SessionCart {
  const factory SessionCart({
    required String id,
    required String sessionId,
    @Default(1) int version,
    required DateTime updatedAt,
    required DateTime createdAt,
  }) = _SessionCart;

  factory SessionCart.fromJson(Map<String, dynamic> json) =>
      _$SessionCartFromJson(json);
}
