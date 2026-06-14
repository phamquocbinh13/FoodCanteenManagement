// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionDevice {

 String get id; String get sessionId; String get deviceFingerprint; DateTime get lastSeenAt; DateTime get createdAt;
/// Create a copy of SessionDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionDeviceCopyWith<SessionDevice> get copyWith => _$SessionDeviceCopyWithImpl<SessionDevice>(this as SessionDevice, _$identity);

  /// Serializes this SessionDevice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.deviceFingerprint, deviceFingerprint) || other.deviceFingerprint == deviceFingerprint)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,deviceFingerprint,lastSeenAt,createdAt);

@override
String toString() {
  return 'SessionDevice(id: $id, sessionId: $sessionId, deviceFingerprint: $deviceFingerprint, lastSeenAt: $lastSeenAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SessionDeviceCopyWith<$Res>  {
  factory $SessionDeviceCopyWith(SessionDevice value, $Res Function(SessionDevice) _then) = _$SessionDeviceCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, String deviceFingerprint, DateTime lastSeenAt, DateTime createdAt
});




}
/// @nodoc
class _$SessionDeviceCopyWithImpl<$Res>
    implements $SessionDeviceCopyWith<$Res> {
  _$SessionDeviceCopyWithImpl(this._self, this._then);

  final SessionDevice _self;
  final $Res Function(SessionDevice) _then;

/// Create a copy of SessionDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? deviceFingerprint = null,Object? lastSeenAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,deviceFingerprint: null == deviceFingerprint ? _self.deviceFingerprint : deviceFingerprint // ignore: cast_nullable_to_non_nullable
as String,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionDevice].
extension SessionDevicePatterns on SessionDevice {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionDevice() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionDevice value)  $default,){
final _that = this;
switch (_that) {
case _SessionDevice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionDevice value)?  $default,){
final _that = this;
switch (_that) {
case _SessionDevice() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  String deviceFingerprint,  DateTime lastSeenAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionDevice() when $default != null:
return $default(_that.id,_that.sessionId,_that.deviceFingerprint,_that.lastSeenAt,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  String deviceFingerprint,  DateTime lastSeenAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SessionDevice():
return $default(_that.id,_that.sessionId,_that.deviceFingerprint,_that.lastSeenAt,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  String deviceFingerprint,  DateTime lastSeenAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionDevice() when $default != null:
return $default(_that.id,_that.sessionId,_that.deviceFingerprint,_that.lastSeenAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionDevice implements SessionDevice {
  const _SessionDevice({required this.id, required this.sessionId, required this.deviceFingerprint, required this.lastSeenAt, required this.createdAt});
  factory _SessionDevice.fromJson(Map<String, dynamic> json) => _$SessionDeviceFromJson(json);

@override final  String id;
@override final  String sessionId;
@override final  String deviceFingerprint;
@override final  DateTime lastSeenAt;
@override final  DateTime createdAt;

/// Create a copy of SessionDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionDeviceCopyWith<_SessionDevice> get copyWith => __$SessionDeviceCopyWithImpl<_SessionDevice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionDeviceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.deviceFingerprint, deviceFingerprint) || other.deviceFingerprint == deviceFingerprint)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,deviceFingerprint,lastSeenAt,createdAt);

@override
String toString() {
  return 'SessionDevice(id: $id, sessionId: $sessionId, deviceFingerprint: $deviceFingerprint, lastSeenAt: $lastSeenAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SessionDeviceCopyWith<$Res> implements $SessionDeviceCopyWith<$Res> {
  factory _$SessionDeviceCopyWith(_SessionDevice value, $Res Function(_SessionDevice) _then) = __$SessionDeviceCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, String deviceFingerprint, DateTime lastSeenAt, DateTime createdAt
});




}
/// @nodoc
class __$SessionDeviceCopyWithImpl<$Res>
    implements _$SessionDeviceCopyWith<$Res> {
  __$SessionDeviceCopyWithImpl(this._self, this._then);

  final _SessionDevice _self;
  final $Res Function(_SessionDevice) _then;

/// Create a copy of SessionDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? deviceFingerprint = null,Object? lastSeenAt = null,Object? createdAt = null,}) {
  return _then(_SessionDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,deviceFingerprint: null == deviceFingerprint ? _self.deviceFingerprint : deviceFingerprint // ignore: cast_nullable_to_non_nullable
as String,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
