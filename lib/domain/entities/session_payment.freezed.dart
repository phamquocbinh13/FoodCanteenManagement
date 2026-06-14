// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionPayment {

 String get id; String get sessionId; PaymentMethod get paymentMethod; SessionCloseType get closeType; ForceCloseReason? get forceCloseReason; String? get forceCloseNote;@MoneyConverter() Money get subtotal;@MoneyConverter() Money get taxAmount;@MoneyConverter() Money get serviceChargeAmount;@MoneyConverter() Money get totalAmount; String get closedByUserId; DateTime get paidAt; DateTime get createdAt;
/// Create a copy of SessionPayment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionPaymentCopyWith<SessionPayment> get copyWith => _$SessionPaymentCopyWithImpl<SessionPayment>(this as SessionPayment, _$identity);

  /// Serializes this SessionPayment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.closeType, closeType) || other.closeType == closeType)&&(identical(other.forceCloseReason, forceCloseReason) || other.forceCloseReason == forceCloseReason)&&(identical(other.forceCloseNote, forceCloseNote) || other.forceCloseNote == forceCloseNote)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.serviceChargeAmount, serviceChargeAmount) || other.serviceChargeAmount == serviceChargeAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.closedByUserId, closedByUserId) || other.closedByUserId == closedByUserId)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,paymentMethod,closeType,forceCloseReason,forceCloseNote,subtotal,taxAmount,serviceChargeAmount,totalAmount,closedByUserId,paidAt,createdAt);

@override
String toString() {
  return 'SessionPayment(id: $id, sessionId: $sessionId, paymentMethod: $paymentMethod, closeType: $closeType, forceCloseReason: $forceCloseReason, forceCloseNote: $forceCloseNote, subtotal: $subtotal, taxAmount: $taxAmount, serviceChargeAmount: $serviceChargeAmount, totalAmount: $totalAmount, closedByUserId: $closedByUserId, paidAt: $paidAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SessionPaymentCopyWith<$Res>  {
  factory $SessionPaymentCopyWith(SessionPayment value, $Res Function(SessionPayment) _then) = _$SessionPaymentCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, PaymentMethod paymentMethod, SessionCloseType closeType, ForceCloseReason? forceCloseReason, String? forceCloseNote,@MoneyConverter() Money subtotal,@MoneyConverter() Money taxAmount,@MoneyConverter() Money serviceChargeAmount,@MoneyConverter() Money totalAmount, String closedByUserId, DateTime paidAt, DateTime createdAt
});


$MoneyCopyWith<$Res> get subtotal;$MoneyCopyWith<$Res> get taxAmount;$MoneyCopyWith<$Res> get serviceChargeAmount;$MoneyCopyWith<$Res> get totalAmount;

}
/// @nodoc
class _$SessionPaymentCopyWithImpl<$Res>
    implements $SessionPaymentCopyWith<$Res> {
  _$SessionPaymentCopyWithImpl(this._self, this._then);

  final SessionPayment _self;
  final $Res Function(SessionPayment) _then;

/// Create a copy of SessionPayment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? paymentMethod = null,Object? closeType = null,Object? forceCloseReason = freezed,Object? forceCloseNote = freezed,Object? subtotal = null,Object? taxAmount = null,Object? serviceChargeAmount = null,Object? totalAmount = null,Object? closedByUserId = null,Object? paidAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,closeType: null == closeType ? _self.closeType : closeType // ignore: cast_nullable_to_non_nullable
as SessionCloseType,forceCloseReason: freezed == forceCloseReason ? _self.forceCloseReason : forceCloseReason // ignore: cast_nullable_to_non_nullable
as ForceCloseReason?,forceCloseNote: freezed == forceCloseNote ? _self.forceCloseNote : forceCloseNote // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as Money,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as Money,serviceChargeAmount: null == serviceChargeAmount ? _self.serviceChargeAmount : serviceChargeAmount // ignore: cast_nullable_to_non_nullable
as Money,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Money,closedByUserId: null == closedByUserId ? _self.closedByUserId : closedByUserId // ignore: cast_nullable_to_non_nullable
as String,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SessionPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get subtotal {
  
  return $MoneyCopyWith<$Res>(_self.subtotal, (value) {
    return _then(_self.copyWith(subtotal: value));
  });
}/// Create a copy of SessionPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get taxAmount {
  
  return $MoneyCopyWith<$Res>(_self.taxAmount, (value) {
    return _then(_self.copyWith(taxAmount: value));
  });
}/// Create a copy of SessionPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get serviceChargeAmount {
  
  return $MoneyCopyWith<$Res>(_self.serviceChargeAmount, (value) {
    return _then(_self.copyWith(serviceChargeAmount: value));
  });
}/// Create a copy of SessionPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get totalAmount {
  
  return $MoneyCopyWith<$Res>(_self.totalAmount, (value) {
    return _then(_self.copyWith(totalAmount: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionPayment].
extension SessionPaymentPatterns on SessionPayment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionPayment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionPayment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionPayment value)  $default,){
final _that = this;
switch (_that) {
case _SessionPayment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionPayment value)?  $default,){
final _that = this;
switch (_that) {
case _SessionPayment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  PaymentMethod paymentMethod,  SessionCloseType closeType,  ForceCloseReason? forceCloseReason,  String? forceCloseNote, @MoneyConverter()  Money subtotal, @MoneyConverter()  Money taxAmount, @MoneyConverter()  Money serviceChargeAmount, @MoneyConverter()  Money totalAmount,  String closedByUserId,  DateTime paidAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionPayment() when $default != null:
return $default(_that.id,_that.sessionId,_that.paymentMethod,_that.closeType,_that.forceCloseReason,_that.forceCloseNote,_that.subtotal,_that.taxAmount,_that.serviceChargeAmount,_that.totalAmount,_that.closedByUserId,_that.paidAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  PaymentMethod paymentMethod,  SessionCloseType closeType,  ForceCloseReason? forceCloseReason,  String? forceCloseNote, @MoneyConverter()  Money subtotal, @MoneyConverter()  Money taxAmount, @MoneyConverter()  Money serviceChargeAmount, @MoneyConverter()  Money totalAmount,  String closedByUserId,  DateTime paidAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SessionPayment():
return $default(_that.id,_that.sessionId,_that.paymentMethod,_that.closeType,_that.forceCloseReason,_that.forceCloseNote,_that.subtotal,_that.taxAmount,_that.serviceChargeAmount,_that.totalAmount,_that.closedByUserId,_that.paidAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  PaymentMethod paymentMethod,  SessionCloseType closeType,  ForceCloseReason? forceCloseReason,  String? forceCloseNote, @MoneyConverter()  Money subtotal, @MoneyConverter()  Money taxAmount, @MoneyConverter()  Money serviceChargeAmount, @MoneyConverter()  Money totalAmount,  String closedByUserId,  DateTime paidAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionPayment() when $default != null:
return $default(_that.id,_that.sessionId,_that.paymentMethod,_that.closeType,_that.forceCloseReason,_that.forceCloseNote,_that.subtotal,_that.taxAmount,_that.serviceChargeAmount,_that.totalAmount,_that.closedByUserId,_that.paidAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionPayment implements SessionPayment {
  const _SessionPayment({required this.id, required this.sessionId, required this.paymentMethod, this.closeType = SessionCloseType.payment, this.forceCloseReason, this.forceCloseNote, @MoneyConverter() required this.subtotal, @MoneyConverter() this.taxAmount = const Money(amountMinor: 0, currencyCode: 'USD'), @MoneyConverter() this.serviceChargeAmount = const Money(amountMinor: 0, currencyCode: 'USD'), @MoneyConverter() required this.totalAmount, required this.closedByUserId, required this.paidAt, required this.createdAt});
  factory _SessionPayment.fromJson(Map<String, dynamic> json) => _$SessionPaymentFromJson(json);

@override final  String id;
@override final  String sessionId;
@override final  PaymentMethod paymentMethod;
@override@JsonKey() final  SessionCloseType closeType;
@override final  ForceCloseReason? forceCloseReason;
@override final  String? forceCloseNote;
@override@MoneyConverter() final  Money subtotal;
@override@JsonKey()@MoneyConverter() final  Money taxAmount;
@override@JsonKey()@MoneyConverter() final  Money serviceChargeAmount;
@override@MoneyConverter() final  Money totalAmount;
@override final  String closedByUserId;
@override final  DateTime paidAt;
@override final  DateTime createdAt;

/// Create a copy of SessionPayment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionPaymentCopyWith<_SessionPayment> get copyWith => __$SessionPaymentCopyWithImpl<_SessionPayment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionPaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionPayment&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.closeType, closeType) || other.closeType == closeType)&&(identical(other.forceCloseReason, forceCloseReason) || other.forceCloseReason == forceCloseReason)&&(identical(other.forceCloseNote, forceCloseNote) || other.forceCloseNote == forceCloseNote)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.serviceChargeAmount, serviceChargeAmount) || other.serviceChargeAmount == serviceChargeAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.closedByUserId, closedByUserId) || other.closedByUserId == closedByUserId)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,paymentMethod,closeType,forceCloseReason,forceCloseNote,subtotal,taxAmount,serviceChargeAmount,totalAmount,closedByUserId,paidAt,createdAt);

@override
String toString() {
  return 'SessionPayment(id: $id, sessionId: $sessionId, paymentMethod: $paymentMethod, closeType: $closeType, forceCloseReason: $forceCloseReason, forceCloseNote: $forceCloseNote, subtotal: $subtotal, taxAmount: $taxAmount, serviceChargeAmount: $serviceChargeAmount, totalAmount: $totalAmount, closedByUserId: $closedByUserId, paidAt: $paidAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SessionPaymentCopyWith<$Res> implements $SessionPaymentCopyWith<$Res> {
  factory _$SessionPaymentCopyWith(_SessionPayment value, $Res Function(_SessionPayment) _then) = __$SessionPaymentCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, PaymentMethod paymentMethod, SessionCloseType closeType, ForceCloseReason? forceCloseReason, String? forceCloseNote,@MoneyConverter() Money subtotal,@MoneyConverter() Money taxAmount,@MoneyConverter() Money serviceChargeAmount,@MoneyConverter() Money totalAmount, String closedByUserId, DateTime paidAt, DateTime createdAt
});


@override $MoneyCopyWith<$Res> get subtotal;@override $MoneyCopyWith<$Res> get taxAmount;@override $MoneyCopyWith<$Res> get serviceChargeAmount;@override $MoneyCopyWith<$Res> get totalAmount;

}
/// @nodoc
class __$SessionPaymentCopyWithImpl<$Res>
    implements _$SessionPaymentCopyWith<$Res> {
  __$SessionPaymentCopyWithImpl(this._self, this._then);

  final _SessionPayment _self;
  final $Res Function(_SessionPayment) _then;

/// Create a copy of SessionPayment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? paymentMethod = null,Object? closeType = null,Object? forceCloseReason = freezed,Object? forceCloseNote = freezed,Object? subtotal = null,Object? taxAmount = null,Object? serviceChargeAmount = null,Object? totalAmount = null,Object? closedByUserId = null,Object? paidAt = null,Object? createdAt = null,}) {
  return _then(_SessionPayment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod,closeType: null == closeType ? _self.closeType : closeType // ignore: cast_nullable_to_non_nullable
as SessionCloseType,forceCloseReason: freezed == forceCloseReason ? _self.forceCloseReason : forceCloseReason // ignore: cast_nullable_to_non_nullable
as ForceCloseReason?,forceCloseNote: freezed == forceCloseNote ? _self.forceCloseNote : forceCloseNote // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as Money,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as Money,serviceChargeAmount: null == serviceChargeAmount ? _self.serviceChargeAmount : serviceChargeAmount // ignore: cast_nullable_to_non_nullable
as Money,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Money,closedByUserId: null == closedByUserId ? _self.closedByUserId : closedByUserId // ignore: cast_nullable_to_non_nullable
as String,paidAt: null == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SessionPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get subtotal {
  
  return $MoneyCopyWith<$Res>(_self.subtotal, (value) {
    return _then(_self.copyWith(subtotal: value));
  });
}/// Create a copy of SessionPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get taxAmount {
  
  return $MoneyCopyWith<$Res>(_self.taxAmount, (value) {
    return _then(_self.copyWith(taxAmount: value));
  });
}/// Create a copy of SessionPayment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get serviceChargeAmount {
  
  return $MoneyCopyWith<$Res>(_self.serviceChargeAmount, (value) {
    return _then(_self.copyWith(serviceChargeAmount: value));
  });
}/// Create a copy of SessionPayment
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
