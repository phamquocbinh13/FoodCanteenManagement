// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roms_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RomsOrder {

 String get id; String get restaurantId; int get orderNumber; OrderType get orderType; OrderStatus get status; String? get customerName;@PhoneNumberConverter() PhoneNumber? get customerPhone; String? get notes; String get createdByUserId; DateTime? get submittedAt; DateTime? get completedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of RomsOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RomsOrderCopyWith<RomsOrder> get copyWith => _$RomsOrderCopyWithImpl<RomsOrder>(this as RomsOrder, _$identity);

  /// Serializes this RomsOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RomsOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&(identical(other.status, status) || other.status == status)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,orderNumber,orderType,status,customerName,customerPhone,notes,createdByUserId,submittedAt,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'RomsOrder(id: $id, restaurantId: $restaurantId, orderNumber: $orderNumber, orderType: $orderType, status: $status, customerName: $customerName, customerPhone: $customerPhone, notes: $notes, createdByUserId: $createdByUserId, submittedAt: $submittedAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RomsOrderCopyWith<$Res>  {
  factory $RomsOrderCopyWith(RomsOrder value, $Res Function(RomsOrder) _then) = _$RomsOrderCopyWithImpl;
@useResult
$Res call({
 String id, String restaurantId, int orderNumber, OrderType orderType, OrderStatus status, String? customerName,@PhoneNumberConverter() PhoneNumber? customerPhone, String? notes, String createdByUserId, DateTime? submittedAt, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});


$PhoneNumberCopyWith<$Res>? get customerPhone;

}
/// @nodoc
class _$RomsOrderCopyWithImpl<$Res>
    implements $RomsOrderCopyWith<$Res> {
  _$RomsOrderCopyWithImpl(this._self, this._then);

  final RomsOrder _self;
  final $Res Function(RomsOrder) _then;

/// Create a copy of RomsOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? restaurantId = null,Object? orderNumber = null,Object? orderType = null,Object? status = null,Object? customerName = freezed,Object? customerPhone = freezed,Object? notes = freezed,Object? createdByUserId = null,Object? submittedAt = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as int,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as OrderType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as PhoneNumber?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of RomsOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhoneNumberCopyWith<$Res>? get customerPhone {
    if (_self.customerPhone == null) {
    return null;
  }

  return $PhoneNumberCopyWith<$Res>(_self.customerPhone!, (value) {
    return _then(_self.copyWith(customerPhone: value));
  });
}
}


/// Adds pattern-matching-related methods to [RomsOrder].
extension RomsOrderPatterns on RomsOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RomsOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RomsOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RomsOrder value)  $default,){
final _that = this;
switch (_that) {
case _RomsOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RomsOrder value)?  $default,){
final _that = this;
switch (_that) {
case _RomsOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String restaurantId,  int orderNumber,  OrderType orderType,  OrderStatus status,  String? customerName, @PhoneNumberConverter()  PhoneNumber? customerPhone,  String? notes,  String createdByUserId,  DateTime? submittedAt,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RomsOrder() when $default != null:
return $default(_that.id,_that.restaurantId,_that.orderNumber,_that.orderType,_that.status,_that.customerName,_that.customerPhone,_that.notes,_that.createdByUserId,_that.submittedAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String restaurantId,  int orderNumber,  OrderType orderType,  OrderStatus status,  String? customerName, @PhoneNumberConverter()  PhoneNumber? customerPhone,  String? notes,  String createdByUserId,  DateTime? submittedAt,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RomsOrder():
return $default(_that.id,_that.restaurantId,_that.orderNumber,_that.orderType,_that.status,_that.customerName,_that.customerPhone,_that.notes,_that.createdByUserId,_that.submittedAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String restaurantId,  int orderNumber,  OrderType orderType,  OrderStatus status,  String? customerName, @PhoneNumberConverter()  PhoneNumber? customerPhone,  String? notes,  String createdByUserId,  DateTime? submittedAt,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RomsOrder() when $default != null:
return $default(_that.id,_that.restaurantId,_that.orderNumber,_that.orderType,_that.status,_that.customerName,_that.customerPhone,_that.notes,_that.createdByUserId,_that.submittedAt,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RomsOrder implements RomsOrder {
  const _RomsOrder({required this.id, required this.restaurantId, required this.orderNumber, required this.orderType, this.status = OrderStatus.draft, this.customerName, @PhoneNumberConverter() this.customerPhone, this.notes, required this.createdByUserId, this.submittedAt, this.completedAt, required this.createdAt, required this.updatedAt});
  factory _RomsOrder.fromJson(Map<String, dynamic> json) => _$RomsOrderFromJson(json);

@override final  String id;
@override final  String restaurantId;
@override final  int orderNumber;
@override final  OrderType orderType;
@override@JsonKey() final  OrderStatus status;
@override final  String? customerName;
@override@PhoneNumberConverter() final  PhoneNumber? customerPhone;
@override final  String? notes;
@override final  String createdByUserId;
@override final  DateTime? submittedAt;
@override final  DateTime? completedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of RomsOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RomsOrderCopyWith<_RomsOrder> get copyWith => __$RomsOrderCopyWithImpl<_RomsOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RomsOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RomsOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&(identical(other.status, status) || other.status == status)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,orderNumber,orderType,status,customerName,customerPhone,notes,createdByUserId,submittedAt,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'RomsOrder(id: $id, restaurantId: $restaurantId, orderNumber: $orderNumber, orderType: $orderType, status: $status, customerName: $customerName, customerPhone: $customerPhone, notes: $notes, createdByUserId: $createdByUserId, submittedAt: $submittedAt, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RomsOrderCopyWith<$Res> implements $RomsOrderCopyWith<$Res> {
  factory _$RomsOrderCopyWith(_RomsOrder value, $Res Function(_RomsOrder) _then) = __$RomsOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String restaurantId, int orderNumber, OrderType orderType, OrderStatus status, String? customerName,@PhoneNumberConverter() PhoneNumber? customerPhone, String? notes, String createdByUserId, DateTime? submittedAt, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});


@override $PhoneNumberCopyWith<$Res>? get customerPhone;

}
/// @nodoc
class __$RomsOrderCopyWithImpl<$Res>
    implements _$RomsOrderCopyWith<$Res> {
  __$RomsOrderCopyWithImpl(this._self, this._then);

  final _RomsOrder _self;
  final $Res Function(_RomsOrder) _then;

/// Create a copy of RomsOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantId = null,Object? orderNumber = null,Object? orderType = null,Object? status = null,Object? customerName = freezed,Object? customerPhone = freezed,Object? notes = freezed,Object? createdByUserId = null,Object? submittedAt = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_RomsOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as int,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as OrderType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as PhoneNumber?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of RomsOrder
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhoneNumberCopyWith<$Res>? get customerPhone {
    if (_self.customerPhone == null) {
    return null;
  }

  return $PhoneNumberCopyWith<$Res>(_self.customerPhone!, (value) {
    return _then(_self.copyWith(customerPhone: value));
  });
}
}

// dart format on
