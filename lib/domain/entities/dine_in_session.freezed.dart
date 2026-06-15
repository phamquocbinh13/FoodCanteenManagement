// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dine_in_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DineInSession {

 String get id; String get restaurantId; String get tableId; int get sessionNumber; String get displayNumber; SessionStatus get status; SessionOpenedVia get openedVia; String? get openedByUserId; String? get closedByUserId; bool get paymentSoftLock; int get currentBatchNumber; SessionPaymentStatus get paymentStatus; SessionPaymentSummary? get paymentSummary; DateTime get openedAt; DateTime? get closedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of DineInSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DineInSessionCopyWith<DineInSession> get copyWith => _$DineInSessionCopyWithImpl<DineInSession>(this as DineInSession, _$identity);

  /// Serializes this DineInSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DineInSession&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.sessionNumber, sessionNumber) || other.sessionNumber == sessionNumber)&&(identical(other.displayNumber, displayNumber) || other.displayNumber == displayNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.openedVia, openedVia) || other.openedVia == openedVia)&&(identical(other.openedByUserId, openedByUserId) || other.openedByUserId == openedByUserId)&&(identical(other.closedByUserId, closedByUserId) || other.closedByUserId == closedByUserId)&&(identical(other.paymentSoftLock, paymentSoftLock) || other.paymentSoftLock == paymentSoftLock)&&(identical(other.currentBatchNumber, currentBatchNumber) || other.currentBatchNumber == currentBatchNumber)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentSummary, paymentSummary) || other.paymentSummary == paymentSummary)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,tableId,sessionNumber,displayNumber,status,openedVia,openedByUserId,closedByUserId,paymentSoftLock,currentBatchNumber,paymentStatus,paymentSummary,openedAt,closedAt,createdAt,updatedAt);

@override
String toString() {
  return 'DineInSession(id: $id, restaurantId: $restaurantId, tableId: $tableId, sessionNumber: $sessionNumber, displayNumber: $displayNumber, status: $status, openedVia: $openedVia, openedByUserId: $openedByUserId, closedByUserId: $closedByUserId, paymentSoftLock: $paymentSoftLock, currentBatchNumber: $currentBatchNumber, paymentStatus: $paymentStatus, paymentSummary: $paymentSummary, openedAt: $openedAt, closedAt: $closedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DineInSessionCopyWith<$Res>  {
  factory $DineInSessionCopyWith(DineInSession value, $Res Function(DineInSession) _then) = _$DineInSessionCopyWithImpl;
@useResult
$Res call({
 String id, String restaurantId, String tableId, int sessionNumber, String displayNumber, SessionStatus status, SessionOpenedVia openedVia, String? openedByUserId, String? closedByUserId, bool paymentSoftLock, int currentBatchNumber, SessionPaymentStatus paymentStatus, SessionPaymentSummary? paymentSummary, DateTime openedAt, DateTime? closedAt, DateTime createdAt, DateTime updatedAt
});


$SessionPaymentSummaryCopyWith<$Res>? get paymentSummary;

}
/// @nodoc
class _$DineInSessionCopyWithImpl<$Res>
    implements $DineInSessionCopyWith<$Res> {
  _$DineInSessionCopyWithImpl(this._self, this._then);

  final DineInSession _self;
  final $Res Function(DineInSession) _then;

/// Create a copy of DineInSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? restaurantId = null,Object? tableId = null,Object? sessionNumber = null,Object? displayNumber = null,Object? status = null,Object? openedVia = null,Object? openedByUserId = freezed,Object? closedByUserId = freezed,Object? paymentSoftLock = null,Object? currentBatchNumber = null,Object? paymentStatus = null,Object? paymentSummary = freezed,Object? openedAt = null,Object? closedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,sessionNumber: null == sessionNumber ? _self.sessionNumber : sessionNumber // ignore: cast_nullable_to_non_nullable
as int,displayNumber: null == displayNumber ? _self.displayNumber : displayNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,openedVia: null == openedVia ? _self.openedVia : openedVia // ignore: cast_nullable_to_non_nullable
as SessionOpenedVia,openedByUserId: freezed == openedByUserId ? _self.openedByUserId : openedByUserId // ignore: cast_nullable_to_non_nullable
as String?,closedByUserId: freezed == closedByUserId ? _self.closedByUserId : closedByUserId // ignore: cast_nullable_to_non_nullable
as String?,paymentSoftLock: null == paymentSoftLock ? _self.paymentSoftLock : paymentSoftLock // ignore: cast_nullable_to_non_nullable
as bool,currentBatchNumber: null == currentBatchNumber ? _self.currentBatchNumber : currentBatchNumber // ignore: cast_nullable_to_non_nullable
as int,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as SessionPaymentStatus,paymentSummary: freezed == paymentSummary ? _self.paymentSummary : paymentSummary // ignore: cast_nullable_to_non_nullable
as SessionPaymentSummary?,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of DineInSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionPaymentSummaryCopyWith<$Res>? get paymentSummary {
    if (_self.paymentSummary == null) {
    return null;
  }

  return $SessionPaymentSummaryCopyWith<$Res>(_self.paymentSummary!, (value) {
    return _then(_self.copyWith(paymentSummary: value));
  });
}
}


/// Adds pattern-matching-related methods to [DineInSession].
extension DineInSessionPatterns on DineInSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DineInSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DineInSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DineInSession value)  $default,){
final _that = this;
switch (_that) {
case _DineInSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DineInSession value)?  $default,){
final _that = this;
switch (_that) {
case _DineInSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String tableId,  int sessionNumber,  String displayNumber,  SessionStatus status,  SessionOpenedVia openedVia,  String? openedByUserId,  String? closedByUserId,  bool paymentSoftLock,  int currentBatchNumber,  SessionPaymentStatus paymentStatus,  SessionPaymentSummary? paymentSummary,  DateTime openedAt,  DateTime? closedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DineInSession() when $default != null:
return $default(_that.id,_that.restaurantId,_that.tableId,_that.sessionNumber,_that.displayNumber,_that.status,_that.openedVia,_that.openedByUserId,_that.closedByUserId,_that.paymentSoftLock,_that.currentBatchNumber,_that.paymentStatus,_that.paymentSummary,_that.openedAt,_that.closedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String tableId,  int sessionNumber,  String displayNumber,  SessionStatus status,  SessionOpenedVia openedVia,  String? openedByUserId,  String? closedByUserId,  bool paymentSoftLock,  int currentBatchNumber,  SessionPaymentStatus paymentStatus,  SessionPaymentSummary? paymentSummary,  DateTime openedAt,  DateTime? closedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DineInSession():
return $default(_that.id,_that.restaurantId,_that.tableId,_that.sessionNumber,_that.displayNumber,_that.status,_that.openedVia,_that.openedByUserId,_that.closedByUserId,_that.paymentSoftLock,_that.currentBatchNumber,_that.paymentStatus,_that.paymentSummary,_that.openedAt,_that.closedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String restaurantId,  String tableId,  int sessionNumber,  String displayNumber,  SessionStatus status,  SessionOpenedVia openedVia,  String? openedByUserId,  String? closedByUserId,  bool paymentSoftLock,  int currentBatchNumber,  SessionPaymentStatus paymentStatus,  SessionPaymentSummary? paymentSummary,  DateTime openedAt,  DateTime? closedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DineInSession() when $default != null:
return $default(_that.id,_that.restaurantId,_that.tableId,_that.sessionNumber,_that.displayNumber,_that.status,_that.openedVia,_that.openedByUserId,_that.closedByUserId,_that.paymentSoftLock,_that.currentBatchNumber,_that.paymentStatus,_that.paymentSummary,_that.openedAt,_that.closedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DineInSession implements DineInSession {
  const _DineInSession({required this.id, required this.restaurantId, required this.tableId, required this.sessionNumber, required this.displayNumber, this.status = SessionStatus.open, required this.openedVia, this.openedByUserId, this.closedByUserId, this.paymentSoftLock = false, this.currentBatchNumber = 0, this.paymentStatus = SessionPaymentStatus.unpaid, this.paymentSummary, required this.openedAt, this.closedAt, required this.createdAt, required this.updatedAt});
  factory _DineInSession.fromJson(Map<String, dynamic> json) => _$DineInSessionFromJson(json);

@override final  String id;
@override final  String restaurantId;
@override final  String tableId;
@override final  int sessionNumber;
@override final  String displayNumber;
@override@JsonKey() final  SessionStatus status;
@override final  SessionOpenedVia openedVia;
@override final  String? openedByUserId;
@override final  String? closedByUserId;
@override@JsonKey() final  bool paymentSoftLock;
@override@JsonKey() final  int currentBatchNumber;
@override@JsonKey() final  SessionPaymentStatus paymentStatus;
@override final  SessionPaymentSummary? paymentSummary;
@override final  DateTime openedAt;
@override final  DateTime? closedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of DineInSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DineInSessionCopyWith<_DineInSession> get copyWith => __$DineInSessionCopyWithImpl<_DineInSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DineInSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DineInSession&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.sessionNumber, sessionNumber) || other.sessionNumber == sessionNumber)&&(identical(other.displayNumber, displayNumber) || other.displayNumber == displayNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.openedVia, openedVia) || other.openedVia == openedVia)&&(identical(other.openedByUserId, openedByUserId) || other.openedByUserId == openedByUserId)&&(identical(other.closedByUserId, closedByUserId) || other.closedByUserId == closedByUserId)&&(identical(other.paymentSoftLock, paymentSoftLock) || other.paymentSoftLock == paymentSoftLock)&&(identical(other.currentBatchNumber, currentBatchNumber) || other.currentBatchNumber == currentBatchNumber)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentSummary, paymentSummary) || other.paymentSummary == paymentSummary)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.closedAt, closedAt) || other.closedAt == closedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,tableId,sessionNumber,displayNumber,status,openedVia,openedByUserId,closedByUserId,paymentSoftLock,currentBatchNumber,paymentStatus,paymentSummary,openedAt,closedAt,createdAt,updatedAt);

@override
String toString() {
  return 'DineInSession(id: $id, restaurantId: $restaurantId, tableId: $tableId, sessionNumber: $sessionNumber, displayNumber: $displayNumber, status: $status, openedVia: $openedVia, openedByUserId: $openedByUserId, closedByUserId: $closedByUserId, paymentSoftLock: $paymentSoftLock, currentBatchNumber: $currentBatchNumber, paymentStatus: $paymentStatus, paymentSummary: $paymentSummary, openedAt: $openedAt, closedAt: $closedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DineInSessionCopyWith<$Res> implements $DineInSessionCopyWith<$Res> {
  factory _$DineInSessionCopyWith(_DineInSession value, $Res Function(_DineInSession) _then) = __$DineInSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String restaurantId, String tableId, int sessionNumber, String displayNumber, SessionStatus status, SessionOpenedVia openedVia, String? openedByUserId, String? closedByUserId, bool paymentSoftLock, int currentBatchNumber, SessionPaymentStatus paymentStatus, SessionPaymentSummary? paymentSummary, DateTime openedAt, DateTime? closedAt, DateTime createdAt, DateTime updatedAt
});


@override $SessionPaymentSummaryCopyWith<$Res>? get paymentSummary;

}
/// @nodoc
class __$DineInSessionCopyWithImpl<$Res>
    implements _$DineInSessionCopyWith<$Res> {
  __$DineInSessionCopyWithImpl(this._self, this._then);

  final _DineInSession _self;
  final $Res Function(_DineInSession) _then;

/// Create a copy of DineInSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantId = null,Object? tableId = null,Object? sessionNumber = null,Object? displayNumber = null,Object? status = null,Object? openedVia = null,Object? openedByUserId = freezed,Object? closedByUserId = freezed,Object? paymentSoftLock = null,Object? currentBatchNumber = null,Object? paymentStatus = null,Object? paymentSummary = freezed,Object? openedAt = null,Object? closedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DineInSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,sessionNumber: null == sessionNumber ? _self.sessionNumber : sessionNumber // ignore: cast_nullable_to_non_nullable
as int,displayNumber: null == displayNumber ? _self.displayNumber : displayNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,openedVia: null == openedVia ? _self.openedVia : openedVia // ignore: cast_nullable_to_non_nullable
as SessionOpenedVia,openedByUserId: freezed == openedByUserId ? _self.openedByUserId : openedByUserId // ignore: cast_nullable_to_non_nullable
as String?,closedByUserId: freezed == closedByUserId ? _self.closedByUserId : closedByUserId // ignore: cast_nullable_to_non_nullable
as String?,paymentSoftLock: null == paymentSoftLock ? _self.paymentSoftLock : paymentSoftLock // ignore: cast_nullable_to_non_nullable
as bool,currentBatchNumber: null == currentBatchNumber ? _self.currentBatchNumber : currentBatchNumber // ignore: cast_nullable_to_non_nullable
as int,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as SessionPaymentStatus,paymentSummary: freezed == paymentSummary ? _self.paymentSummary : paymentSummary // ignore: cast_nullable_to_non_nullable
as SessionPaymentSummary?,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,closedAt: freezed == closedAt ? _self.closedAt : closedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of DineInSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionPaymentSummaryCopyWith<$Res>? get paymentSummary {
    if (_self.paymentSummary == null) {
    return null;
  }

  return $SessionPaymentSummaryCopyWith<$Res>(_self.paymentSummary!, (value) {
    return _then(_self.copyWith(paymentSummary: value));
  });
}
}

// dart format on
