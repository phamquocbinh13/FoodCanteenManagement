// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kitchen_batch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KitchenBatch {

 String get id; String get restaurantId; String? get sessionId; String? get orderId; int get batchNumber; DateTime get confirmedAt; ActorType get confirmedByActorType; String? get confirmedByActorId; DateTime get createdAt;
/// Create a copy of KitchenBatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KitchenBatchCopyWith<KitchenBatch> get copyWith => _$KitchenBatchCopyWithImpl<KitchenBatch>(this as KitchenBatch, _$identity);

  /// Serializes this KitchenBatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KitchenBatch&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.confirmedByActorType, confirmedByActorType) || other.confirmedByActorType == confirmedByActorType)&&(identical(other.confirmedByActorId, confirmedByActorId) || other.confirmedByActorId == confirmedByActorId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,sessionId,orderId,batchNumber,confirmedAt,confirmedByActorType,confirmedByActorId,createdAt);

@override
String toString() {
  return 'KitchenBatch(id: $id, restaurantId: $restaurantId, sessionId: $sessionId, orderId: $orderId, batchNumber: $batchNumber, confirmedAt: $confirmedAt, confirmedByActorType: $confirmedByActorType, confirmedByActorId: $confirmedByActorId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $KitchenBatchCopyWith<$Res>  {
  factory $KitchenBatchCopyWith(KitchenBatch value, $Res Function(KitchenBatch) _then) = _$KitchenBatchCopyWithImpl;
@useResult
$Res call({
 String id, String restaurantId, String? sessionId, String? orderId, int batchNumber, DateTime confirmedAt, ActorType confirmedByActorType, String? confirmedByActorId, DateTime createdAt
});




}
/// @nodoc
class _$KitchenBatchCopyWithImpl<$Res>
    implements $KitchenBatchCopyWith<$Res> {
  _$KitchenBatchCopyWithImpl(this._self, this._then);

  final KitchenBatch _self;
  final $Res Function(KitchenBatch) _then;

/// Create a copy of KitchenBatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? restaurantId = null,Object? sessionId = freezed,Object? orderId = freezed,Object? batchNumber = null,Object? confirmedAt = null,Object? confirmedByActorType = null,Object? confirmedByActorId = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: null == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as int,confirmedAt: null == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime,confirmedByActorType: null == confirmedByActorType ? _self.confirmedByActorType : confirmedByActorType // ignore: cast_nullable_to_non_nullable
as ActorType,confirmedByActorId: freezed == confirmedByActorId ? _self.confirmedByActorId : confirmedByActorId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [KitchenBatch].
extension KitchenBatchPatterns on KitchenBatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KitchenBatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KitchenBatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KitchenBatch value)  $default,){
final _that = this;
switch (_that) {
case _KitchenBatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KitchenBatch value)?  $default,){
final _that = this;
switch (_that) {
case _KitchenBatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String? sessionId,  String? orderId,  int batchNumber,  DateTime confirmedAt,  ActorType confirmedByActorType,  String? confirmedByActorId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KitchenBatch() when $default != null:
return $default(_that.id,_that.restaurantId,_that.sessionId,_that.orderId,_that.batchNumber,_that.confirmedAt,_that.confirmedByActorType,_that.confirmedByActorId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String? sessionId,  String? orderId,  int batchNumber,  DateTime confirmedAt,  ActorType confirmedByActorType,  String? confirmedByActorId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _KitchenBatch():
return $default(_that.id,_that.restaurantId,_that.sessionId,_that.orderId,_that.batchNumber,_that.confirmedAt,_that.confirmedByActorType,_that.confirmedByActorId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String restaurantId,  String? sessionId,  String? orderId,  int batchNumber,  DateTime confirmedAt,  ActorType confirmedByActorType,  String? confirmedByActorId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _KitchenBatch() when $default != null:
return $default(_that.id,_that.restaurantId,_that.sessionId,_that.orderId,_that.batchNumber,_that.confirmedAt,_that.confirmedByActorType,_that.confirmedByActorId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KitchenBatch implements KitchenBatch {
  const _KitchenBatch({required this.id, required this.restaurantId, this.sessionId, this.orderId, required this.batchNumber, required this.confirmedAt, required this.confirmedByActorType, this.confirmedByActorId, required this.createdAt});
  factory _KitchenBatch.fromJson(Map<String, dynamic> json) => _$KitchenBatchFromJson(json);

@override final  String id;
@override final  String restaurantId;
@override final  String? sessionId;
@override final  String? orderId;
@override final  int batchNumber;
@override final  DateTime confirmedAt;
@override final  ActorType confirmedByActorType;
@override final  String? confirmedByActorId;
@override final  DateTime createdAt;

/// Create a copy of KitchenBatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KitchenBatchCopyWith<_KitchenBatch> get copyWith => __$KitchenBatchCopyWithImpl<_KitchenBatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KitchenBatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KitchenBatch&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.confirmedByActorType, confirmedByActorType) || other.confirmedByActorType == confirmedByActorType)&&(identical(other.confirmedByActorId, confirmedByActorId) || other.confirmedByActorId == confirmedByActorId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,sessionId,orderId,batchNumber,confirmedAt,confirmedByActorType,confirmedByActorId,createdAt);

@override
String toString() {
  return 'KitchenBatch(id: $id, restaurantId: $restaurantId, sessionId: $sessionId, orderId: $orderId, batchNumber: $batchNumber, confirmedAt: $confirmedAt, confirmedByActorType: $confirmedByActorType, confirmedByActorId: $confirmedByActorId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$KitchenBatchCopyWith<$Res> implements $KitchenBatchCopyWith<$Res> {
  factory _$KitchenBatchCopyWith(_KitchenBatch value, $Res Function(_KitchenBatch) _then) = __$KitchenBatchCopyWithImpl;
@override @useResult
$Res call({
 String id, String restaurantId, String? sessionId, String? orderId, int batchNumber, DateTime confirmedAt, ActorType confirmedByActorType, String? confirmedByActorId, DateTime createdAt
});




}
/// @nodoc
class __$KitchenBatchCopyWithImpl<$Res>
    implements _$KitchenBatchCopyWith<$Res> {
  __$KitchenBatchCopyWithImpl(this._self, this._then);

  final _KitchenBatch _self;
  final $Res Function(_KitchenBatch) _then;

/// Create a copy of KitchenBatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantId = null,Object? sessionId = freezed,Object? orderId = freezed,Object? batchNumber = null,Object? confirmedAt = null,Object? confirmedByActorType = null,Object? confirmedByActorId = freezed,Object? createdAt = null,}) {
  return _then(_KitchenBatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,batchNumber: null == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as int,confirmedAt: null == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime,confirmedByActorType: null == confirmedByActorType ? _self.confirmedByActorType : confirmedByActorType // ignore: cast_nullable_to_non_nullable
as ActorType,confirmedByActorId: freezed == confirmedByActorId ? _self.confirmedByActorId : confirmedByActorId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
