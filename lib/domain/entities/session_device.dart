import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_device.freezed.dart';
part 'session_device.g.dart';

/// Customer device joined to a [DineInSession] (multi-phone dine-in).
///
/// DATA_MODEL §3.7 — tracks fingerprint for audit and rate limiting.
@freezed
abstract class SessionDevice with _$SessionDevice {
  const factory SessionDevice({
    required String id,
    required String sessionId,
    required String deviceFingerprint,
    required DateTime lastSeenAt,
    required DateTime createdAt,
  }) = _SessionDevice;

  factory SessionDevice.fromJson(Map<String, dynamic> json) =>
      _$SessionDeviceFromJson(json);
}
