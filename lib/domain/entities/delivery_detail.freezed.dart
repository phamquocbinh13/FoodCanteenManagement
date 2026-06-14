// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryDetail {

 String get id; String get orderId; DeliveryStatus get deliveryStatus; String get deliveryAddress; String? get deliveryNotes; String? get shipperUserId; DateTime? get readyAt; DateTime? get claimedAt; DateTime? get deliveringAt; DateTime? get completedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of DeliveryDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeliveryDetailCopyWith<DeliveryDetail> get copyWith => _$DeliveryDetailCopyWithImpl<DeliveryDetail>(this as DeliveryDetail, _$identity);

  /// Serializes this DeliveryDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeliveryDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.deliveryStatus, deliveryStatus) || other.deliveryStatus == deliveryStatus)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.deliveryNotes, deliveryNotes) || other.deliveryNotes == deliveryNotes)&&(identical(other.shipperUserId, shipperUserId) || other.shipperUserId == shipperUserId)&&(identical(other.readyAt, readyAt) || other.readyAt == readyAt)&&(identical(other.claimedAt, claimedAt) || other.claimedAt == claimedAt)&&(identical(other.deliveringAt, deliveringAt) || other.deliveringAt == deliveringAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,deliveryStatus,deliveryAddress,deliveryNotes,shipperUserId,readyAt,claimedAt,deliveringAt,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'DeliveryDetail(id: $id, orderId: $orderId, deliveryStatus: $deliveryStatus, deliveryAddress: $deliveryAddress, deliveryNotes: $deliveryNotes, shipperUserId: $shipperUserId, readyAt: $readyAt, claimedAt: $claimedAt, deliveringAt: $deliveringAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DeliveryDetailCopyWith<$Res>  {
  factory $DeliveryDetailCopyWith(DeliveryDetail value, $Res Function(DeliveryDetail) _then) = _$DeliveryDetailCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, DeliveryStatus deliveryStatus, String deliveryAddress, String? deliveryNotes, String? shipperUserId, DateTime? readyAt, DateTime? claimedAt, DateTime? deliveringAt, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$DeliveryDetailCopyWithImpl<$Res>
    implements $DeliveryDetailCopyWith<$Res> {
  _$DeliveryDetailCopyWithImpl(this._self, this._then);

  final DeliveryDetail _self;
  final $Res Function(DeliveryDetail) _then;

/// Create a copy of DeliveryDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? deliveryStatus = null,Object? deliveryAddress = null,Object? deliveryNotes = freezed,Object? shipperUserId = freezed,Object? readyAt = freezed,Object? claimedAt = freezed,Object? deliveringAt = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,deliveryStatus: null == deliveryStatus ? _self.deliveryStatus : deliveryStatus // ignore: cast_nullable_to_non_nullable
as DeliveryStatus,deliveryAddress: null == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as String,deliveryNotes: freezed == deliveryNotes ? _self.deliveryNotes : deliveryNotes // ignore: cast_nullable_to_non_nullable
as String?,shipperUserId: freezed == shipperUserId ? _self.shipperUserId : shipperUserId // ignore: cast_nullable_to_non_nullable
as String?,readyAt: freezed == readyAt ? _self.readyAt : readyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,claimedAt: freezed == claimedAt ? _self.claimedAt : claimedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveringAt: freezed == deliveringAt ? _self.deliveringAt : deliveringAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DeliveryDetail].
extension DeliveryDetailPatterns on DeliveryDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeliveryDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeliveryDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeliveryDetail value)  $default,){
final _that = this;
switch (_that) {
case _DeliveryDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeliveryDetail value)?  $default,){
final _that = this;
switch (_that) {
case _DeliveryDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  DeliveryStatus deliveryStatus,  String deliveryAddress,  String? deliveryNotes,  String? shipperUserId,  DateTime? readyAt,  DateTime? claimedAt,  DateTime? deliveringAt,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeliveryDetail() when $default != null:
return $default(_that.id,_that.orderId,_that.deliveryStatus,_that.deliveryAddress,_that.deliveryNotes,_that.shipperUserId,_that.readyAt,_that.claimedAt,_that.deliveringAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  DeliveryStatus deliveryStatus,  String deliveryAddress,  String? deliveryNotes,  String? shipperUserId,  DateTime? readyAt,  DateTime? claimedAt,  DateTime? deliveringAt,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DeliveryDetail():
return $default(_that.id,_that.orderId,_that.deliveryStatus,_that.deliveryAddress,_that.deliveryNotes,_that.shipperUserId,_that.readyAt,_that.claimedAt,_that.deliveringAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  DeliveryStatus deliveryStatus,  String deliveryAddress,  String? deliveryNotes,  String? shipperUserId,  DateTime? readyAt,  DateTime? claimedAt,  DateTime? deliveringAt,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DeliveryDetail() when $default != null:
return $default(_that.id,_that.orderId,_that.deliveryStatus,_that.deliveryAddress,_that.deliveryNotes,_that.shipperUserId,_that.readyAt,_that.claimedAt,_that.deliveringAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeliveryDetail implements DeliveryDetail {
  const _DeliveryDetail({required this.id, required this.orderId, this.deliveryStatus = DeliveryStatus.pending, required this.deliveryAddress, this.deliveryNotes, this.shipperUserId, this.readyAt, this.claimedAt, this.deliveringAt, this.completedAt, required this.createdAt, required this.updatedAt});
  factory _DeliveryDetail.fromJson(Map<String, dynamic> json) => _$DeliveryDetailFromJson(json);

@override final  String id;
@override final  String orderId;
@override@JsonKey() final  DeliveryStatus deliveryStatus;
@override final  String deliveryAddress;
@override final  String? deliveryNotes;
@override final  String? shipperUserId;
@override final  DateTime? readyAt;
@override final  DateTime? claimedAt;
@override final  DateTime? deliveringAt;
@override final  DateTime? completedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of DeliveryDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeliveryDetailCopyWith<_DeliveryDetail> get copyWith => __$DeliveryDetailCopyWithImpl<_DeliveryDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeliveryDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeliveryDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.deliveryStatus, deliveryStatus) || other.deliveryStatus == deliveryStatus)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.deliveryNotes, deliveryNotes) || other.deliveryNotes == deliveryNotes)&&(identical(other.shipperUserId, shipperUserId) || other.shipperUserId == shipperUserId)&&(identical(other.readyAt, readyAt) || other.readyAt == readyAt)&&(identical(other.claimedAt, claimedAt) || other.claimedAt == claimedAt)&&(identical(other.deliveringAt, deliveringAt) || other.deliveringAt == deliveringAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,deliveryStatus,deliveryAddress,deliveryNotes,shipperUserId,readyAt,claimedAt,deliveringAt,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'DeliveryDetail(id: $id, orderId: $orderId, deliveryStatus: $deliveryStatus, deliveryAddress: $deliveryAddress, deliveryNotes: $deliveryNotes, shipperUserId: $shipperUserId, readyAt: $readyAt, claimedAt: $claimedAt, deliveringAt: $deliveringAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DeliveryDetailCopyWith<$Res> implements $DeliveryDetailCopyWith<$Res> {
  factory _$DeliveryDetailCopyWith(_DeliveryDetail value, $Res Function(_DeliveryDetail) _then) = __$DeliveryDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, DeliveryStatus deliveryStatus, String deliveryAddress, String? deliveryNotes, String? shipperUserId, DateTime? readyAt, DateTime? claimedAt, DateTime? deliveringAt, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$DeliveryDetailCopyWithImpl<$Res>
    implements _$DeliveryDetailCopyWith<$Res> {
  __$DeliveryDetailCopyWithImpl(this._self, this._then);

  final _DeliveryDetail _self;
  final $Res Function(_DeliveryDetail) _then;

/// Create a copy of DeliveryDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? deliveryStatus = null,Object? deliveryAddress = null,Object? deliveryNotes = freezed,Object? shipperUserId = freezed,Object? readyAt = freezed,Object? claimedAt = freezed,Object? deliveringAt = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DeliveryDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,deliveryStatus: null == deliveryStatus ? _self.deliveryStatus : deliveryStatus // ignore: cast_nullable_to_non_nullable
as DeliveryStatus,deliveryAddress: null == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as String,deliveryNotes: freezed == deliveryNotes ? _self.deliveryNotes : deliveryNotes // ignore: cast_nullable_to_non_nullable
as String?,shipperUserId: freezed == shipperUserId ? _self.shipperUserId : shipperUserId // ignore: cast_nullable_to_non_nullable
as String?,readyAt: freezed == readyAt ? _self.readyAt : readyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,claimedAt: freezed == claimedAt ? _self.claimedAt : claimedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveringAt: freezed == deliveringAt ? _self.deliveringAt : deliveringAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
