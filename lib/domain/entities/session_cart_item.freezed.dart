// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionCartItem {

 String get id; String get sessionCartId; String get menuItemId;@QuantityConverter() Quantity get quantity; Map<String, dynamic> get selectionsJson;@MoneyConverter() Money get unitPriceSnapshot; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of SessionCartItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCartItemCopyWith<SessionCartItem> get copyWith => _$SessionCartItemCopyWithImpl<SessionCartItem>(this as SessionCartItem, _$identity);

  /// Serializes this SessionCartItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionCartItem&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionCartId, sessionCartId) || other.sessionCartId == sessionCartId)&&(identical(other.menuItemId, menuItemId) || other.menuItemId == menuItemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other.selectionsJson, selectionsJson)&&(identical(other.unitPriceSnapshot, unitPriceSnapshot) || other.unitPriceSnapshot == unitPriceSnapshot)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionCartId,menuItemId,quantity,const DeepCollectionEquality().hash(selectionsJson),unitPriceSnapshot,createdAt,updatedAt);

@override
String toString() {
  return 'SessionCartItem(id: $id, sessionCartId: $sessionCartId, menuItemId: $menuItemId, quantity: $quantity, selectionsJson: $selectionsJson, unitPriceSnapshot: $unitPriceSnapshot, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SessionCartItemCopyWith<$Res>  {
  factory $SessionCartItemCopyWith(SessionCartItem value, $Res Function(SessionCartItem) _then) = _$SessionCartItemCopyWithImpl;
@useResult
$Res call({
 String id, String sessionCartId, String menuItemId,@QuantityConverter() Quantity quantity, Map<String, dynamic> selectionsJson,@MoneyConverter() Money unitPriceSnapshot, DateTime createdAt, DateTime updatedAt
});


$QuantityCopyWith<$Res> get quantity;$MoneyCopyWith<$Res> get unitPriceSnapshot;

}
/// @nodoc
class _$SessionCartItemCopyWithImpl<$Res>
    implements $SessionCartItemCopyWith<$Res> {
  _$SessionCartItemCopyWithImpl(this._self, this._then);

  final SessionCartItem _self;
  final $Res Function(SessionCartItem) _then;

/// Create a copy of SessionCartItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionCartId = null,Object? menuItemId = null,Object? quantity = null,Object? selectionsJson = null,Object? unitPriceSnapshot = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionCartId: null == sessionCartId ? _self.sessionCartId : sessionCartId // ignore: cast_nullable_to_non_nullable
as String,menuItemId: null == menuItemId ? _self.menuItemId : menuItemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,selectionsJson: null == selectionsJson ? _self.selectionsJson : selectionsJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,unitPriceSnapshot: null == unitPriceSnapshot ? _self.unitPriceSnapshot : unitPriceSnapshot // ignore: cast_nullable_to_non_nullable
as Money,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of SessionCartItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuantityCopyWith<$Res> get quantity {
  
  return $QuantityCopyWith<$Res>(_self.quantity, (value) {
    return _then(_self.copyWith(quantity: value));
  });
}/// Create a copy of SessionCartItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get unitPriceSnapshot {
  
  return $MoneyCopyWith<$Res>(_self.unitPriceSnapshot, (value) {
    return _then(_self.copyWith(unitPriceSnapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionCartItem].
extension SessionCartItemPatterns on SessionCartItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionCartItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionCartItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionCartItem value)  $default,){
final _that = this;
switch (_that) {
case _SessionCartItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionCartItem value)?  $default,){
final _that = this;
switch (_that) {
case _SessionCartItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionCartId,  String menuItemId, @QuantityConverter()  Quantity quantity,  Map<String, dynamic> selectionsJson, @MoneyConverter()  Money unitPriceSnapshot,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionCartItem() when $default != null:
return $default(_that.id,_that.sessionCartId,_that.menuItemId,_that.quantity,_that.selectionsJson,_that.unitPriceSnapshot,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionCartId,  String menuItemId, @QuantityConverter()  Quantity quantity,  Map<String, dynamic> selectionsJson, @MoneyConverter()  Money unitPriceSnapshot,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SessionCartItem():
return $default(_that.id,_that.sessionCartId,_that.menuItemId,_that.quantity,_that.selectionsJson,_that.unitPriceSnapshot,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionCartId,  String menuItemId, @QuantityConverter()  Quantity quantity,  Map<String, dynamic> selectionsJson, @MoneyConverter()  Money unitPriceSnapshot,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionCartItem() when $default != null:
return $default(_that.id,_that.sessionCartId,_that.menuItemId,_that.quantity,_that.selectionsJson,_that.unitPriceSnapshot,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionCartItem implements SessionCartItem {
  const _SessionCartItem({required this.id, required this.sessionCartId, required this.menuItemId, @QuantityConverter() required this.quantity, final  Map<String, dynamic> selectionsJson = const {}, @MoneyConverter() required this.unitPriceSnapshot, required this.createdAt, required this.updatedAt}): _selectionsJson = selectionsJson;
  factory _SessionCartItem.fromJson(Map<String, dynamic> json) => _$SessionCartItemFromJson(json);

@override final  String id;
@override final  String sessionCartId;
@override final  String menuItemId;
@override@QuantityConverter() final  Quantity quantity;
 final  Map<String, dynamic> _selectionsJson;
@override@JsonKey() Map<String, dynamic> get selectionsJson {
  if (_selectionsJson is EqualUnmodifiableMapView) return _selectionsJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_selectionsJson);
}

@override@MoneyConverter() final  Money unitPriceSnapshot;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of SessionCartItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCartItemCopyWith<_SessionCartItem> get copyWith => __$SessionCartItemCopyWithImpl<_SessionCartItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionCartItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionCartItem&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionCartId, sessionCartId) || other.sessionCartId == sessionCartId)&&(identical(other.menuItemId, menuItemId) || other.menuItemId == menuItemId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other._selectionsJson, _selectionsJson)&&(identical(other.unitPriceSnapshot, unitPriceSnapshot) || other.unitPriceSnapshot == unitPriceSnapshot)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionCartId,menuItemId,quantity,const DeepCollectionEquality().hash(_selectionsJson),unitPriceSnapshot,createdAt,updatedAt);

@override
String toString() {
  return 'SessionCartItem(id: $id, sessionCartId: $sessionCartId, menuItemId: $menuItemId, quantity: $quantity, selectionsJson: $selectionsJson, unitPriceSnapshot: $unitPriceSnapshot, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SessionCartItemCopyWith<$Res> implements $SessionCartItemCopyWith<$Res> {
  factory _$SessionCartItemCopyWith(_SessionCartItem value, $Res Function(_SessionCartItem) _then) = __$SessionCartItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionCartId, String menuItemId,@QuantityConverter() Quantity quantity, Map<String, dynamic> selectionsJson,@MoneyConverter() Money unitPriceSnapshot, DateTime createdAt, DateTime updatedAt
});


@override $QuantityCopyWith<$Res> get quantity;@override $MoneyCopyWith<$Res> get unitPriceSnapshot;

}
/// @nodoc
class __$SessionCartItemCopyWithImpl<$Res>
    implements _$SessionCartItemCopyWith<$Res> {
  __$SessionCartItemCopyWithImpl(this._self, this._then);

  final _SessionCartItem _self;
  final $Res Function(_SessionCartItem) _then;

/// Create a copy of SessionCartItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionCartId = null,Object? menuItemId = null,Object? quantity = null,Object? selectionsJson = null,Object? unitPriceSnapshot = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_SessionCartItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionCartId: null == sessionCartId ? _self.sessionCartId : sessionCartId // ignore: cast_nullable_to_non_nullable
as String,menuItemId: null == menuItemId ? _self.menuItemId : menuItemId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,selectionsJson: null == selectionsJson ? _self._selectionsJson : selectionsJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,unitPriceSnapshot: null == unitPriceSnapshot ? _self.unitPriceSnapshot : unitPriceSnapshot // ignore: cast_nullable_to_non_nullable
as Money,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of SessionCartItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuantityCopyWith<$Res> get quantity {
  
  return $QuantityCopyWith<$Res>(_self.quantity, (value) {
    return _then(_self.copyWith(quantity: value));
  });
}/// Create a copy of SessionCartItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get unitPriceSnapshot {
  
  return $MoneyCopyWith<$Res>(_self.unitPriceSnapshot, (value) {
    return _then(_self.copyWith(unitPriceSnapshot: value));
  });
}
}

// dart format on
