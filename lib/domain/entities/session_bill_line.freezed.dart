// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_bill_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionBillLine {

 String get id; String get sessionPaymentId; String get batchItemId; String get description;@QuantityConverter() Quantity get quantity;@MoneyConverter() Money get unitPrice;@MoneyConverter() Money get lineTotal; DateTime get createdAt;
/// Create a copy of SessionBillLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionBillLineCopyWith<SessionBillLine> get copyWith => _$SessionBillLineCopyWithImpl<SessionBillLine>(this as SessionBillLine, _$identity);

  /// Serializes this SessionBillLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionBillLine&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionPaymentId, sessionPaymentId) || other.sessionPaymentId == sessionPaymentId)&&(identical(other.batchItemId, batchItemId) || other.batchItemId == batchItemId)&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionPaymentId,batchItemId,description,quantity,unitPrice,lineTotal,createdAt);

@override
String toString() {
  return 'SessionBillLine(id: $id, sessionPaymentId: $sessionPaymentId, batchItemId: $batchItemId, description: $description, quantity: $quantity, unitPrice: $unitPrice, lineTotal: $lineTotal, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SessionBillLineCopyWith<$Res>  {
  factory $SessionBillLineCopyWith(SessionBillLine value, $Res Function(SessionBillLine) _then) = _$SessionBillLineCopyWithImpl;
@useResult
$Res call({
 String id, String sessionPaymentId, String batchItemId, String description,@QuantityConverter() Quantity quantity,@MoneyConverter() Money unitPrice,@MoneyConverter() Money lineTotal, DateTime createdAt
});


$QuantityCopyWith<$Res> get quantity;$MoneyCopyWith<$Res> get unitPrice;$MoneyCopyWith<$Res> get lineTotal;

}
/// @nodoc
class _$SessionBillLineCopyWithImpl<$Res>
    implements $SessionBillLineCopyWith<$Res> {
  _$SessionBillLineCopyWithImpl(this._self, this._then);

  final SessionBillLine _self;
  final $Res Function(SessionBillLine) _then;

/// Create a copy of SessionBillLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionPaymentId = null,Object? batchItemId = null,Object? description = null,Object? quantity = null,Object? unitPrice = null,Object? lineTotal = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionPaymentId: null == sessionPaymentId ? _self.sessionPaymentId : sessionPaymentId // ignore: cast_nullable_to_non_nullable
as String,batchItemId: null == batchItemId ? _self.batchItemId : batchItemId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as Money,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as Money,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SessionBillLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuantityCopyWith<$Res> get quantity {
  
  return $QuantityCopyWith<$Res>(_self.quantity, (value) {
    return _then(_self.copyWith(quantity: value));
  });
}/// Create a copy of SessionBillLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get unitPrice {
  
  return $MoneyCopyWith<$Res>(_self.unitPrice, (value) {
    return _then(_self.copyWith(unitPrice: value));
  });
}/// Create a copy of SessionBillLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get lineTotal {
  
  return $MoneyCopyWith<$Res>(_self.lineTotal, (value) {
    return _then(_self.copyWith(lineTotal: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionBillLine].
extension SessionBillLinePatterns on SessionBillLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionBillLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionBillLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionBillLine value)  $default,){
final _that = this;
switch (_that) {
case _SessionBillLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionBillLine value)?  $default,){
final _that = this;
switch (_that) {
case _SessionBillLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionPaymentId,  String batchItemId,  String description, @QuantityConverter()  Quantity quantity, @MoneyConverter()  Money unitPrice, @MoneyConverter()  Money lineTotal,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionBillLine() when $default != null:
return $default(_that.id,_that.sessionPaymentId,_that.batchItemId,_that.description,_that.quantity,_that.unitPrice,_that.lineTotal,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionPaymentId,  String batchItemId,  String description, @QuantityConverter()  Quantity quantity, @MoneyConverter()  Money unitPrice, @MoneyConverter()  Money lineTotal,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SessionBillLine():
return $default(_that.id,_that.sessionPaymentId,_that.batchItemId,_that.description,_that.quantity,_that.unitPrice,_that.lineTotal,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionPaymentId,  String batchItemId,  String description, @QuantityConverter()  Quantity quantity, @MoneyConverter()  Money unitPrice, @MoneyConverter()  Money lineTotal,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionBillLine() when $default != null:
return $default(_that.id,_that.sessionPaymentId,_that.batchItemId,_that.description,_that.quantity,_that.unitPrice,_that.lineTotal,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionBillLine implements SessionBillLine {
  const _SessionBillLine({required this.id, required this.sessionPaymentId, required this.batchItemId, required this.description, @QuantityConverter() required this.quantity, @MoneyConverter() required this.unitPrice, @MoneyConverter() required this.lineTotal, required this.createdAt});
  factory _SessionBillLine.fromJson(Map<String, dynamic> json) => _$SessionBillLineFromJson(json);

@override final  String id;
@override final  String sessionPaymentId;
@override final  String batchItemId;
@override final  String description;
@override@QuantityConverter() final  Quantity quantity;
@override@MoneyConverter() final  Money unitPrice;
@override@MoneyConverter() final  Money lineTotal;
@override final  DateTime createdAt;

/// Create a copy of SessionBillLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionBillLineCopyWith<_SessionBillLine> get copyWith => __$SessionBillLineCopyWithImpl<_SessionBillLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionBillLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionBillLine&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionPaymentId, sessionPaymentId) || other.sessionPaymentId == sessionPaymentId)&&(identical(other.batchItemId, batchItemId) || other.batchItemId == batchItemId)&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionPaymentId,batchItemId,description,quantity,unitPrice,lineTotal,createdAt);

@override
String toString() {
  return 'SessionBillLine(id: $id, sessionPaymentId: $sessionPaymentId, batchItemId: $batchItemId, description: $description, quantity: $quantity, unitPrice: $unitPrice, lineTotal: $lineTotal, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SessionBillLineCopyWith<$Res> implements $SessionBillLineCopyWith<$Res> {
  factory _$SessionBillLineCopyWith(_SessionBillLine value, $Res Function(_SessionBillLine) _then) = __$SessionBillLineCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionPaymentId, String batchItemId, String description,@QuantityConverter() Quantity quantity,@MoneyConverter() Money unitPrice,@MoneyConverter() Money lineTotal, DateTime createdAt
});


@override $QuantityCopyWith<$Res> get quantity;@override $MoneyCopyWith<$Res> get unitPrice;@override $MoneyCopyWith<$Res> get lineTotal;

}
/// @nodoc
class __$SessionBillLineCopyWithImpl<$Res>
    implements _$SessionBillLineCopyWith<$Res> {
  __$SessionBillLineCopyWithImpl(this._self, this._then);

  final _SessionBillLine _self;
  final $Res Function(_SessionBillLine) _then;

/// Create a copy of SessionBillLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionPaymentId = null,Object? batchItemId = null,Object? description = null,Object? quantity = null,Object? unitPrice = null,Object? lineTotal = null,Object? createdAt = null,}) {
  return _then(_SessionBillLine(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionPaymentId: null == sessionPaymentId ? _self.sessionPaymentId : sessionPaymentId // ignore: cast_nullable_to_non_nullable
as String,batchItemId: null == batchItemId ? _self.batchItemId : batchItemId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as Money,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as Money,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SessionBillLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuantityCopyWith<$Res> get quantity {
  
  return $QuantityCopyWith<$Res>(_self.quantity, (value) {
    return _then(_self.copyWith(quantity: value));
  });
}/// Create a copy of SessionBillLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get unitPrice {
  
  return $MoneyCopyWith<$Res>(_self.unitPrice, (value) {
    return _then(_self.copyWith(unitPrice: value));
  });
}/// Create a copy of SessionBillLine
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get lineTotal {
  
  return $MoneyCopyWith<$Res>(_self.lineTotal, (value) {
    return _then(_self.copyWith(lineTotal: value));
  });
}
}

// dart format on
