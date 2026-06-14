// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatchItem {

 String get id; String get batchId; String get menuItemId; String get menuItemNameSnapshot;@MoneyConverter() Money get unitPriceSnapshot;@QuantityConverter() Quantity get quantity;@MoneyConverter() Money get lineTotal; String get kitchenNotesRendered; BatchItemStatus get status; DateTime get statusUpdatedAt; DateTime get createdAt;
/// Create a copy of BatchItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatchItemCopyWith<BatchItem> get copyWith => _$BatchItemCopyWithImpl<BatchItem>(this as BatchItem, _$identity);

  /// Serializes this BatchItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatchItem&&(identical(other.id, id) || other.id == id)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.menuItemId, menuItemId) || other.menuItemId == menuItemId)&&(identical(other.menuItemNameSnapshot, menuItemNameSnapshot) || other.menuItemNameSnapshot == menuItemNameSnapshot)&&(identical(other.unitPriceSnapshot, unitPriceSnapshot) || other.unitPriceSnapshot == unitPriceSnapshot)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.kitchenNotesRendered, kitchenNotesRendered) || other.kitchenNotesRendered == kitchenNotesRendered)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusUpdatedAt, statusUpdatedAt) || other.statusUpdatedAt == statusUpdatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,batchId,menuItemId,menuItemNameSnapshot,unitPriceSnapshot,quantity,lineTotal,kitchenNotesRendered,status,statusUpdatedAt,createdAt);

@override
String toString() {
  return 'BatchItem(id: $id, batchId: $batchId, menuItemId: $menuItemId, menuItemNameSnapshot: $menuItemNameSnapshot, unitPriceSnapshot: $unitPriceSnapshot, quantity: $quantity, lineTotal: $lineTotal, kitchenNotesRendered: $kitchenNotesRendered, status: $status, statusUpdatedAt: $statusUpdatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BatchItemCopyWith<$Res>  {
  factory $BatchItemCopyWith(BatchItem value, $Res Function(BatchItem) _then) = _$BatchItemCopyWithImpl;
@useResult
$Res call({
 String id, String batchId, String menuItemId, String menuItemNameSnapshot,@MoneyConverter() Money unitPriceSnapshot,@QuantityConverter() Quantity quantity,@MoneyConverter() Money lineTotal, String kitchenNotesRendered, BatchItemStatus status, DateTime statusUpdatedAt, DateTime createdAt
});


$MoneyCopyWith<$Res> get unitPriceSnapshot;$QuantityCopyWith<$Res> get quantity;$MoneyCopyWith<$Res> get lineTotal;

}
/// @nodoc
class _$BatchItemCopyWithImpl<$Res>
    implements $BatchItemCopyWith<$Res> {
  _$BatchItemCopyWithImpl(this._self, this._then);

  final BatchItem _self;
  final $Res Function(BatchItem) _then;

/// Create a copy of BatchItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? batchId = null,Object? menuItemId = null,Object? menuItemNameSnapshot = null,Object? unitPriceSnapshot = null,Object? quantity = null,Object? lineTotal = null,Object? kitchenNotesRendered = null,Object? status = null,Object? statusUpdatedAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,batchId: null == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String,menuItemId: null == menuItemId ? _self.menuItemId : menuItemId // ignore: cast_nullable_to_non_nullable
as String,menuItemNameSnapshot: null == menuItemNameSnapshot ? _self.menuItemNameSnapshot : menuItemNameSnapshot // ignore: cast_nullable_to_non_nullable
as String,unitPriceSnapshot: null == unitPriceSnapshot ? _self.unitPriceSnapshot : unitPriceSnapshot // ignore: cast_nullable_to_non_nullable
as Money,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as Money,kitchenNotesRendered: null == kitchenNotesRendered ? _self.kitchenNotesRendered : kitchenNotesRendered // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BatchItemStatus,statusUpdatedAt: null == statusUpdatedAt ? _self.statusUpdatedAt : statusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of BatchItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get unitPriceSnapshot {
  
  return $MoneyCopyWith<$Res>(_self.unitPriceSnapshot, (value) {
    return _then(_self.copyWith(unitPriceSnapshot: value));
  });
}/// Create a copy of BatchItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuantityCopyWith<$Res> get quantity {
  
  return $QuantityCopyWith<$Res>(_self.quantity, (value) {
    return _then(_self.copyWith(quantity: value));
  });
}/// Create a copy of BatchItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get lineTotal {
  
  return $MoneyCopyWith<$Res>(_self.lineTotal, (value) {
    return _then(_self.copyWith(lineTotal: value));
  });
}
}


/// Adds pattern-matching-related methods to [BatchItem].
extension BatchItemPatterns on BatchItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatchItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatchItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatchItem value)  $default,){
final _that = this;
switch (_that) {
case _BatchItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatchItem value)?  $default,){
final _that = this;
switch (_that) {
case _BatchItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String batchId,  String menuItemId,  String menuItemNameSnapshot, @MoneyConverter()  Money unitPriceSnapshot, @QuantityConverter()  Quantity quantity, @MoneyConverter()  Money lineTotal,  String kitchenNotesRendered,  BatchItemStatus status,  DateTime statusUpdatedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatchItem() when $default != null:
return $default(_that.id,_that.batchId,_that.menuItemId,_that.menuItemNameSnapshot,_that.unitPriceSnapshot,_that.quantity,_that.lineTotal,_that.kitchenNotesRendered,_that.status,_that.statusUpdatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String batchId,  String menuItemId,  String menuItemNameSnapshot, @MoneyConverter()  Money unitPriceSnapshot, @QuantityConverter()  Quantity quantity, @MoneyConverter()  Money lineTotal,  String kitchenNotesRendered,  BatchItemStatus status,  DateTime statusUpdatedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BatchItem():
return $default(_that.id,_that.batchId,_that.menuItemId,_that.menuItemNameSnapshot,_that.unitPriceSnapshot,_that.quantity,_that.lineTotal,_that.kitchenNotesRendered,_that.status,_that.statusUpdatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String batchId,  String menuItemId,  String menuItemNameSnapshot, @MoneyConverter()  Money unitPriceSnapshot, @QuantityConverter()  Quantity quantity, @MoneyConverter()  Money lineTotal,  String kitchenNotesRendered,  BatchItemStatus status,  DateTime statusUpdatedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BatchItem() when $default != null:
return $default(_that.id,_that.batchId,_that.menuItemId,_that.menuItemNameSnapshot,_that.unitPriceSnapshot,_that.quantity,_that.lineTotal,_that.kitchenNotesRendered,_that.status,_that.statusUpdatedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatchItem implements BatchItem {
  const _BatchItem({required this.id, required this.batchId, required this.menuItemId, required this.menuItemNameSnapshot, @MoneyConverter() required this.unitPriceSnapshot, @QuantityConverter() required this.quantity, @MoneyConverter() required this.lineTotal, required this.kitchenNotesRendered, this.status = BatchItemStatus.preparing, required this.statusUpdatedAt, required this.createdAt});
  factory _BatchItem.fromJson(Map<String, dynamic> json) => _$BatchItemFromJson(json);

@override final  String id;
@override final  String batchId;
@override final  String menuItemId;
@override final  String menuItemNameSnapshot;
@override@MoneyConverter() final  Money unitPriceSnapshot;
@override@QuantityConverter() final  Quantity quantity;
@override@MoneyConverter() final  Money lineTotal;
@override final  String kitchenNotesRendered;
@override@JsonKey() final  BatchItemStatus status;
@override final  DateTime statusUpdatedAt;
@override final  DateTime createdAt;

/// Create a copy of BatchItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatchItemCopyWith<_BatchItem> get copyWith => __$BatchItemCopyWithImpl<_BatchItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatchItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatchItem&&(identical(other.id, id) || other.id == id)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&(identical(other.menuItemId, menuItemId) || other.menuItemId == menuItemId)&&(identical(other.menuItemNameSnapshot, menuItemNameSnapshot) || other.menuItemNameSnapshot == menuItemNameSnapshot)&&(identical(other.unitPriceSnapshot, unitPriceSnapshot) || other.unitPriceSnapshot == unitPriceSnapshot)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.kitchenNotesRendered, kitchenNotesRendered) || other.kitchenNotesRendered == kitchenNotesRendered)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusUpdatedAt, statusUpdatedAt) || other.statusUpdatedAt == statusUpdatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,batchId,menuItemId,menuItemNameSnapshot,unitPriceSnapshot,quantity,lineTotal,kitchenNotesRendered,status,statusUpdatedAt,createdAt);

@override
String toString() {
  return 'BatchItem(id: $id, batchId: $batchId, menuItemId: $menuItemId, menuItemNameSnapshot: $menuItemNameSnapshot, unitPriceSnapshot: $unitPriceSnapshot, quantity: $quantity, lineTotal: $lineTotal, kitchenNotesRendered: $kitchenNotesRendered, status: $status, statusUpdatedAt: $statusUpdatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BatchItemCopyWith<$Res> implements $BatchItemCopyWith<$Res> {
  factory _$BatchItemCopyWith(_BatchItem value, $Res Function(_BatchItem) _then) = __$BatchItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String batchId, String menuItemId, String menuItemNameSnapshot,@MoneyConverter() Money unitPriceSnapshot,@QuantityConverter() Quantity quantity,@MoneyConverter() Money lineTotal, String kitchenNotesRendered, BatchItemStatus status, DateTime statusUpdatedAt, DateTime createdAt
});


@override $MoneyCopyWith<$Res> get unitPriceSnapshot;@override $QuantityCopyWith<$Res> get quantity;@override $MoneyCopyWith<$Res> get lineTotal;

}
/// @nodoc
class __$BatchItemCopyWithImpl<$Res>
    implements _$BatchItemCopyWith<$Res> {
  __$BatchItemCopyWithImpl(this._self, this._then);

  final _BatchItem _self;
  final $Res Function(_BatchItem) _then;

/// Create a copy of BatchItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? batchId = null,Object? menuItemId = null,Object? menuItemNameSnapshot = null,Object? unitPriceSnapshot = null,Object? quantity = null,Object? lineTotal = null,Object? kitchenNotesRendered = null,Object? status = null,Object? statusUpdatedAt = null,Object? createdAt = null,}) {
  return _then(_BatchItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,batchId: null == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String,menuItemId: null == menuItemId ? _self.menuItemId : menuItemId // ignore: cast_nullable_to_non_nullable
as String,menuItemNameSnapshot: null == menuItemNameSnapshot ? _self.menuItemNameSnapshot : menuItemNameSnapshot // ignore: cast_nullable_to_non_nullable
as String,unitPriceSnapshot: null == unitPriceSnapshot ? _self.unitPriceSnapshot : unitPriceSnapshot // ignore: cast_nullable_to_non_nullable
as Money,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as Money,kitchenNotesRendered: null == kitchenNotesRendered ? _self.kitchenNotesRendered : kitchenNotesRendered // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BatchItemStatus,statusUpdatedAt: null == statusUpdatedAt ? _self.statusUpdatedAt : statusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of BatchItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get unitPriceSnapshot {
  
  return $MoneyCopyWith<$Res>(_self.unitPriceSnapshot, (value) {
    return _then(_self.copyWith(unitPriceSnapshot: value));
  });
}/// Create a copy of BatchItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuantityCopyWith<$Res> get quantity {
  
  return $QuantityCopyWith<$Res>(_self.quantity, (value) {
    return _then(_self.copyWith(quantity: value));
  });
}/// Create a copy of BatchItem
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
