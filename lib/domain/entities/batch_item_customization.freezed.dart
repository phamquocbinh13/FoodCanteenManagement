// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch_item_customization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatchItemCustomization {

 String get id; String get batchItemId; String get groupKey; String get groupNameSnapshot; String? get optionKey; String? get optionNameSnapshot; Map<String, dynamic> get valueJson;@MoneyConverter() Money get priceDeltaSnapshot; String get kitchenLabelRendered; DateTime get createdAt;
/// Create a copy of BatchItemCustomization
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatchItemCustomizationCopyWith<BatchItemCustomization> get copyWith => _$BatchItemCustomizationCopyWithImpl<BatchItemCustomization>(this as BatchItemCustomization, _$identity);

  /// Serializes this BatchItemCustomization to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatchItemCustomization&&(identical(other.id, id) || other.id == id)&&(identical(other.batchItemId, batchItemId) || other.batchItemId == batchItemId)&&(identical(other.groupKey, groupKey) || other.groupKey == groupKey)&&(identical(other.groupNameSnapshot, groupNameSnapshot) || other.groupNameSnapshot == groupNameSnapshot)&&(identical(other.optionKey, optionKey) || other.optionKey == optionKey)&&(identical(other.optionNameSnapshot, optionNameSnapshot) || other.optionNameSnapshot == optionNameSnapshot)&&const DeepCollectionEquality().equals(other.valueJson, valueJson)&&(identical(other.priceDeltaSnapshot, priceDeltaSnapshot) || other.priceDeltaSnapshot == priceDeltaSnapshot)&&(identical(other.kitchenLabelRendered, kitchenLabelRendered) || other.kitchenLabelRendered == kitchenLabelRendered)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,batchItemId,groupKey,groupNameSnapshot,optionKey,optionNameSnapshot,const DeepCollectionEquality().hash(valueJson),priceDeltaSnapshot,kitchenLabelRendered,createdAt);

@override
String toString() {
  return 'BatchItemCustomization(id: $id, batchItemId: $batchItemId, groupKey: $groupKey, groupNameSnapshot: $groupNameSnapshot, optionKey: $optionKey, optionNameSnapshot: $optionNameSnapshot, valueJson: $valueJson, priceDeltaSnapshot: $priceDeltaSnapshot, kitchenLabelRendered: $kitchenLabelRendered, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BatchItemCustomizationCopyWith<$Res>  {
  factory $BatchItemCustomizationCopyWith(BatchItemCustomization value, $Res Function(BatchItemCustomization) _then) = _$BatchItemCustomizationCopyWithImpl;
@useResult
$Res call({
 String id, String batchItemId, String groupKey, String groupNameSnapshot, String? optionKey, String? optionNameSnapshot, Map<String, dynamic> valueJson,@MoneyConverter() Money priceDeltaSnapshot, String kitchenLabelRendered, DateTime createdAt
});


$MoneyCopyWith<$Res> get priceDeltaSnapshot;

}
/// @nodoc
class _$BatchItemCustomizationCopyWithImpl<$Res>
    implements $BatchItemCustomizationCopyWith<$Res> {
  _$BatchItemCustomizationCopyWithImpl(this._self, this._then);

  final BatchItemCustomization _self;
  final $Res Function(BatchItemCustomization) _then;

/// Create a copy of BatchItemCustomization
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? batchItemId = null,Object? groupKey = null,Object? groupNameSnapshot = null,Object? optionKey = freezed,Object? optionNameSnapshot = freezed,Object? valueJson = null,Object? priceDeltaSnapshot = null,Object? kitchenLabelRendered = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,batchItemId: null == batchItemId ? _self.batchItemId : batchItemId // ignore: cast_nullable_to_non_nullable
as String,groupKey: null == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String,groupNameSnapshot: null == groupNameSnapshot ? _self.groupNameSnapshot : groupNameSnapshot // ignore: cast_nullable_to_non_nullable
as String,optionKey: freezed == optionKey ? _self.optionKey : optionKey // ignore: cast_nullable_to_non_nullable
as String?,optionNameSnapshot: freezed == optionNameSnapshot ? _self.optionNameSnapshot : optionNameSnapshot // ignore: cast_nullable_to_non_nullable
as String?,valueJson: null == valueJson ? _self.valueJson : valueJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,priceDeltaSnapshot: null == priceDeltaSnapshot ? _self.priceDeltaSnapshot : priceDeltaSnapshot // ignore: cast_nullable_to_non_nullable
as Money,kitchenLabelRendered: null == kitchenLabelRendered ? _self.kitchenLabelRendered : kitchenLabelRendered // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of BatchItemCustomization
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get priceDeltaSnapshot {
  
  return $MoneyCopyWith<$Res>(_self.priceDeltaSnapshot, (value) {
    return _then(_self.copyWith(priceDeltaSnapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [BatchItemCustomization].
extension BatchItemCustomizationPatterns on BatchItemCustomization {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatchItemCustomization value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatchItemCustomization() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatchItemCustomization value)  $default,){
final _that = this;
switch (_that) {
case _BatchItemCustomization():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatchItemCustomization value)?  $default,){
final _that = this;
switch (_that) {
case _BatchItemCustomization() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String batchItemId,  String groupKey,  String groupNameSnapshot,  String? optionKey,  String? optionNameSnapshot,  Map<String, dynamic> valueJson, @MoneyConverter()  Money priceDeltaSnapshot,  String kitchenLabelRendered,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatchItemCustomization() when $default != null:
return $default(_that.id,_that.batchItemId,_that.groupKey,_that.groupNameSnapshot,_that.optionKey,_that.optionNameSnapshot,_that.valueJson,_that.priceDeltaSnapshot,_that.kitchenLabelRendered,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String batchItemId,  String groupKey,  String groupNameSnapshot,  String? optionKey,  String? optionNameSnapshot,  Map<String, dynamic> valueJson, @MoneyConverter()  Money priceDeltaSnapshot,  String kitchenLabelRendered,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _BatchItemCustomization():
return $default(_that.id,_that.batchItemId,_that.groupKey,_that.groupNameSnapshot,_that.optionKey,_that.optionNameSnapshot,_that.valueJson,_that.priceDeltaSnapshot,_that.kitchenLabelRendered,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String batchItemId,  String groupKey,  String groupNameSnapshot,  String? optionKey,  String? optionNameSnapshot,  Map<String, dynamic> valueJson, @MoneyConverter()  Money priceDeltaSnapshot,  String kitchenLabelRendered,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BatchItemCustomization() when $default != null:
return $default(_that.id,_that.batchItemId,_that.groupKey,_that.groupNameSnapshot,_that.optionKey,_that.optionNameSnapshot,_that.valueJson,_that.priceDeltaSnapshot,_that.kitchenLabelRendered,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatchItemCustomization implements BatchItemCustomization {
  const _BatchItemCustomization({required this.id, required this.batchItemId, required this.groupKey, required this.groupNameSnapshot, this.optionKey, this.optionNameSnapshot, final  Map<String, dynamic> valueJson = const {}, @MoneyConverter() this.priceDeltaSnapshot = const Money(amountMinor: 0, currencyCode: 'USD'), required this.kitchenLabelRendered, required this.createdAt}): _valueJson = valueJson;
  factory _BatchItemCustomization.fromJson(Map<String, dynamic> json) => _$BatchItemCustomizationFromJson(json);

@override final  String id;
@override final  String batchItemId;
@override final  String groupKey;
@override final  String groupNameSnapshot;
@override final  String? optionKey;
@override final  String? optionNameSnapshot;
 final  Map<String, dynamic> _valueJson;
@override@JsonKey() Map<String, dynamic> get valueJson {
  if (_valueJson is EqualUnmodifiableMapView) return _valueJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_valueJson);
}

@override@JsonKey()@MoneyConverter() final  Money priceDeltaSnapshot;
@override final  String kitchenLabelRendered;
@override final  DateTime createdAt;

/// Create a copy of BatchItemCustomization
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatchItemCustomizationCopyWith<_BatchItemCustomization> get copyWith => __$BatchItemCustomizationCopyWithImpl<_BatchItemCustomization>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatchItemCustomizationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatchItemCustomization&&(identical(other.id, id) || other.id == id)&&(identical(other.batchItemId, batchItemId) || other.batchItemId == batchItemId)&&(identical(other.groupKey, groupKey) || other.groupKey == groupKey)&&(identical(other.groupNameSnapshot, groupNameSnapshot) || other.groupNameSnapshot == groupNameSnapshot)&&(identical(other.optionKey, optionKey) || other.optionKey == optionKey)&&(identical(other.optionNameSnapshot, optionNameSnapshot) || other.optionNameSnapshot == optionNameSnapshot)&&const DeepCollectionEquality().equals(other._valueJson, _valueJson)&&(identical(other.priceDeltaSnapshot, priceDeltaSnapshot) || other.priceDeltaSnapshot == priceDeltaSnapshot)&&(identical(other.kitchenLabelRendered, kitchenLabelRendered) || other.kitchenLabelRendered == kitchenLabelRendered)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,batchItemId,groupKey,groupNameSnapshot,optionKey,optionNameSnapshot,const DeepCollectionEquality().hash(_valueJson),priceDeltaSnapshot,kitchenLabelRendered,createdAt);

@override
String toString() {
  return 'BatchItemCustomization(id: $id, batchItemId: $batchItemId, groupKey: $groupKey, groupNameSnapshot: $groupNameSnapshot, optionKey: $optionKey, optionNameSnapshot: $optionNameSnapshot, valueJson: $valueJson, priceDeltaSnapshot: $priceDeltaSnapshot, kitchenLabelRendered: $kitchenLabelRendered, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BatchItemCustomizationCopyWith<$Res> implements $BatchItemCustomizationCopyWith<$Res> {
  factory _$BatchItemCustomizationCopyWith(_BatchItemCustomization value, $Res Function(_BatchItemCustomization) _then) = __$BatchItemCustomizationCopyWithImpl;
@override @useResult
$Res call({
 String id, String batchItemId, String groupKey, String groupNameSnapshot, String? optionKey, String? optionNameSnapshot, Map<String, dynamic> valueJson,@MoneyConverter() Money priceDeltaSnapshot, String kitchenLabelRendered, DateTime createdAt
});


@override $MoneyCopyWith<$Res> get priceDeltaSnapshot;

}
/// @nodoc
class __$BatchItemCustomizationCopyWithImpl<$Res>
    implements _$BatchItemCustomizationCopyWith<$Res> {
  __$BatchItemCustomizationCopyWithImpl(this._self, this._then);

  final _BatchItemCustomization _self;
  final $Res Function(_BatchItemCustomization) _then;

/// Create a copy of BatchItemCustomization
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? batchItemId = null,Object? groupKey = null,Object? groupNameSnapshot = null,Object? optionKey = freezed,Object? optionNameSnapshot = freezed,Object? valueJson = null,Object? priceDeltaSnapshot = null,Object? kitchenLabelRendered = null,Object? createdAt = null,}) {
  return _then(_BatchItemCustomization(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,batchItemId: null == batchItemId ? _self.batchItemId : batchItemId // ignore: cast_nullable_to_non_nullable
as String,groupKey: null == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String,groupNameSnapshot: null == groupNameSnapshot ? _self.groupNameSnapshot : groupNameSnapshot // ignore: cast_nullable_to_non_nullable
as String,optionKey: freezed == optionKey ? _self.optionKey : optionKey // ignore: cast_nullable_to_non_nullable
as String?,optionNameSnapshot: freezed == optionNameSnapshot ? _self.optionNameSnapshot : optionNameSnapshot // ignore: cast_nullable_to_non_nullable
as String?,valueJson: null == valueJson ? _self._valueJson : valueJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,priceDeltaSnapshot: null == priceDeltaSnapshot ? _self.priceDeltaSnapshot : priceDeltaSnapshot // ignore: cast_nullable_to_non_nullable
as Money,kitchenLabelRendered: null == kitchenLabelRendered ? _self.kitchenLabelRendered : kitchenLabelRendered // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of BatchItemCustomization
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MoneyCopyWith<$Res> get priceDeltaSnapshot {
  
  return $MoneyCopyWith<$Res>(_self.priceDeltaSnapshot, (value) {
    return _then(_self.copyWith(priceDeltaSnapshot: value));
  });
}
}

// dart format on
