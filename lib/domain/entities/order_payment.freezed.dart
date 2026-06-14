// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderPayment {

 String get id; String get orderId; PaymentMethod get paymentMethod;@MoneyConverter() Money get subtotal;@MoneyConverter() Money get taxAmount;@MoneyConverter() Money get serviceChargeAmount;@MoneyConverter() Money get totalAmount; DateTime get paidAt; String get recordedByUserId; DateTime get createdAt;
/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderPaymentCopyWith<OrderPayment> get copyWith => _$OrderPaymentCopyWithImpl<OrderPayment>(this as OrderPayment, _$identity);

  /// Serializes this OrderPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.serviceChargeAmount, serviceChargeAmount) || other.serviceChargeAmount == serviceChargeAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.recordedByUserId, recordedByUserId) || other.recordedByUserId == recordedByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,paymentMethod,subtotal,taxAmount,serviceChargeAmount,totalAmount,paidAt,recordedByUserId,createdAt);

@override
String toString() {
  return 'OrderPayment(id: $id, orderId: $orderId, paymentMethod: $paymentMethod, subtotal: $subtotal, taxAmount: $taxAmount, serviceChargeAmount: $serviceChargeAmount, totalAmount: $totalAmount, paidAt: $paidAt, recordedByUserId: $recordedByUserId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $OrderPaymentCopyWith<$Res>  {
  factory $OrderPaymentCopyWith(OrderPayment value, $Res Function(OrderPayment) _then) = _$OrderPaymentCopyWithImpl;
@useResult
$Res call({
 String id, String orderId, PaymentMethod paymentMethod,@MoneyConverter() Money subtotal,@MoneyConverter() Money taxAmount,@MoneyConverter() Money serviceChargeAmount,@MoneyConverter() Money totalAmount, DateTime paidAt, String recordedByUserId, DateTime createdAt
});


$MoneyCopyWith<$Res> get subtotal;$MoneyCopyWith<$Res> get taxAmount;$MoneyCopyWith<$Res> get serviceChargeAmount;$MoneyCopyWith<$Res> get totalAmount;

}
/// @nodoc
class _$OrderPaymentCopyWithImpl<$Res>
    implements $OrderPaymentCopyWith<$Res> {
  _$OrderPaymentCopyWithImpl(this._self, this._then);

  final OrderPayment _self;
  final $Res Function(OrderPayment) _then;

/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? paymentMethod = null,Object? subtotal = null,Object? taxAmount = null,Object? serviceChargeAmount = null,Object? totalAmount = null,Object? paidAt = null,Object? recordedByUserId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as Money,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as Money,serviceChargeAmount: null == serviceChargeAmount ? _self.serviceChargeAmount : serviceChargeAmount // ignore: cast_nullable_to_non_nullable
as Money,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Money,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,recordedByUserId: null == recordedByUserId ? _self.recordedByUserId : recordedByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get subtotal {
  
  return $MoneyCopyWith<$Res>(_self.subtotal, (value) {
    return _then(_self.copyWith(subtotal: value));
  });
}/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get taxAmount {
  
  return $MoneyCopyWith<$Res>(_self.taxAmount, (value) {
    return _then(_self.copyWith(taxAmount: value));
  });
}/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get serviceChargeAmount {
  
  return $MoneyCopyWith<$Res>(_self.serviceChargeAmount, (value) {
    return _then(_self.copyWith(serviceChargeAmount: value));
  });
}/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get totalAmount {
  
  return $MoneyCopyWith<$Res>(_self.totalAmount, (value) {
    return _then(_self.copyWith(totalAmount: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderPayment].
extension OrderPaymentPatterns on OrderPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderPayment value)  $default,){
final _that = this;
switch (_that) {
case _OrderPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderPayment value)?  $default,){
final _that = this;
switch (_that) {
case _OrderPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderId,  PaymentMethod paymentMethod, @MoneyConverter()  Money subtotal, @MoneyConverter()  Money taxAmount, @MoneyConverter()  Money serviceChargeAmount, @MoneyConverter()  Money totalAmount,  DateTime paidAt,  String recordedByUserId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderPayment() when $default != null:
return $default(_that.id,_that.orderId,_that.paymentMethod,_that.subtotal,_that.taxAmount,_that.serviceChargeAmount,_that.totalAmount,_that.paidAt,_that.recordedByUserId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderId,  PaymentMethod paymentMethod, @MoneyConverter()  Money subtotal, @MoneyConverter()  Money taxAmount, @MoneyConverter()  Money serviceChargeAmount, @MoneyConverter()  Money totalAmount,  DateTime paidAt,  String recordedByUserId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _OrderPayment():
return $default(_that.id,_that.orderId,_that.paymentMethod,_that.subtotal,_that.taxAmount,_that.serviceChargeAmount,_that.totalAmount,_that.paidAt,_that.recordedByUserId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderId,  PaymentMethod paymentMethod, @MoneyConverter()  Money subtotal, @MoneyConverter()  Money taxAmount, @MoneyConverter()  Money serviceChargeAmount, @MoneyConverter()  Money totalAmount,  DateTime paidAt,  String recordedByUserId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderPayment() when $default != null:
return $default(_that.id,_that.orderId,_that.paymentMethod,_that.subtotal,_that.taxAmount,_that.serviceChargeAmount,_that.totalAmount,_that.paidAt,_that.recordedByUserId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderPayment implements OrderPayment {
  const _OrderPayment({required this.id, required this.orderId, required this.paymentMethod, @MoneyConverter() required this.subtotal, @MoneyConverter() this.taxAmount = const Money(amountMinor: 0, currencyCode: 'USD'), @MoneyConverter() this.serviceChargeAmount = const Money(amountMinor: 0, currencyCode: 'USD'), @MoneyConverter() required this.totalAmount, required this.paidAt, required this.recordedByUserId, required this.createdAt});
  factory _OrderPayment.fromJson(Map<String, dynamic> json) => _$OrderPaymentFromJson(json);

@override final  String id;
@override final  String orderId;
@override final  PaymentMethod paymentMethod;
@override@MoneyConverter() final  Money subtotal;
@override@JsonKey()@MoneyConverter() final  Money taxAmount;
@override@JsonKey()@MoneyConverter() final  Money serviceChargeAmount;
@override@MoneyConverter() final  Money totalAmount;
@override final  DateTime paidAt;
@override final  String recordedByUserId;
@override final  DateTime createdAt;

/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderPaymentCopyWith<_OrderPayment> get copyWith => __$OrderPaymentCopyWithImpl<_OrderPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.serviceChargeAmount, serviceChargeAmount) || other.serviceChargeAmount == serviceChargeAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.recordedByUserId, recordedByUserId) || other.recordedByUserId == recordedByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,paymentMethod,subtotal,taxAmount,serviceChargeAmount,totalAmount,paidAt,recordedByUserId,createdAt);

@override
String toString() {
  return 'OrderPayment(id: $id, orderId: $orderId, paymentMethod: $paymentMethod, subtotal: $subtotal, taxAmount: $taxAmount, serviceChargeAmount: $serviceChargeAmount, totalAmount: $totalAmount, paidAt: $paidAt, recordedByUserId: $recordedByUserId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$OrderPaymentCopyWith<$Res> implements $OrderPaymentCopyWith<$Res> {
  factory _$OrderPaymentCopyWith(_OrderPayment value, $Res Function(_OrderPayment) _then) = __$OrderPaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderId, PaymentMethod paymentMethod,@MoneyConverter() Money subtotal,@MoneyConverter() Money taxAmount,@MoneyConverter() Money serviceChargeAmount,@MoneyConverter() Money totalAmount, DateTime paidAt, String recordedByUserId, DateTime createdAt
});


@override $MoneyCopyWith<$Res> get subtotal;@override $MoneyCopyWith<$Res> get taxAmount;@override $MoneyCopyWith<$Res> get serviceChargeAmount;@override $MoneyCopyWith<$Res> get totalAmount;

}
/// @nodoc
class __$OrderPaymentCopyWithImpl<$Res>
    implements _$OrderPaymentCopyWith<$Res> {
  __$OrderPaymentCopyWithImpl(this._self, this._then);

  final _OrderPayment _self;
  final $Res Function(_OrderPayment) _then;

/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? paymentMethod = null,Object? subtotal = null,Object? taxAmount = null,Object? serviceChargeAmount = null,Object? totalAmount = null,Object? paidAt = null,Object? recordedByUserId = null,Object? createdAt = null,}) {
  return _then(_OrderPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as Money,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as Money,serviceChargeAmount: null == serviceChargeAmount ? _self.serviceChargeAmount : serviceChargeAmount // ignore: cast_nullable_to_non_nullable
as Money,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Money,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,recordedByUserId: null == recordedByUserId ? _self.recordedByUserId : recordedByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get subtotal {
  
  return $MoneyCopyWith<$Res>(_self.subtotal, (value) {
    return _then(_self.copyWith(subtotal: value));
  });
}/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get taxAmount {
  
  return $MoneyCopyWith<$Res>(_self.taxAmount, (value) {
    return _then(_self.copyWith(taxAmount: value));
  });
}/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get serviceChargeAmount {
  
  return $MoneyCopyWith<$Res>(_self.serviceChargeAmount, (value) {
    return _then(_self.copyWith(serviceChargeAmount: value));
  });
}/// Create a copy of OrderPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get totalAmount {
  
  return $MoneyCopyWith<$Res>(_self.totalAmount, (value) {
    return _then(_self.copyWith(totalAmount: value));
  });
}
}

// dart format on
