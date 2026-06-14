// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'idempotency_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IdempotencyRecord {

 String get id; String get restaurantId; String get idempotencyKey; String get mutationType; Map<String, dynamic> get responseJson; DateTime get createdAt; DateTime get expiresAt;
/// Create a copy of IdempotencyRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IdempotencyRecordCopyWith<IdempotencyRecord> get copyWith => _$IdempotencyRecordCopyWithImpl<IdempotencyRecord>(this as IdempotencyRecord, _$identity);

  /// Serializes this IdempotencyRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IdempotencyRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.mutationType, mutationType) || other.mutationType == mutationType)&&const DeepCollectionEquality().equals(other.responseJson, responseJson)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,idempotencyKey,mutationType,const DeepCollectionEquality().hash(responseJson),createdAt,expiresAt);

@override
String toString() {
  return 'IdempotencyRecord(id: $id, restaurantId: $restaurantId, idempotencyKey: $idempotencyKey, mutationType: $mutationType, responseJson: $responseJson, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $IdempotencyRecordCopyWith<$Res>  {
  factory $IdempotencyRecordCopyWith(IdempotencyRecord value, $Res Function(IdempotencyRecord) _then) = _$IdempotencyRecordCopyWithImpl;
@useResult
$Res call({
 String id, String restaurantId, String idempotencyKey, String mutationType, Map<String, dynamic> responseJson, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class _$IdempotencyRecordCopyWithImpl<$Res>
    implements $IdempotencyRecordCopyWith<$Res> {
  _$IdempotencyRecordCopyWithImpl(this._self, this._then);

  final IdempotencyRecord _self;
  final $Res Function(IdempotencyRecord) _then;

/// Create a copy of IdempotencyRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? restaurantId = null,Object? idempotencyKey = null,Object? mutationType = null,Object? responseJson = null,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,mutationType: null == mutationType ? _self.mutationType : mutationType // ignore: cast_nullable_to_non_nullable
as String,responseJson: null == responseJson ? _self.responseJson : responseJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [IdempotencyRecord].
extension IdempotencyRecordPatterns on IdempotencyRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IdempotencyRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IdempotencyRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IdempotencyRecord value)  $default,){
final _that = this;
switch (_that) {
case _IdempotencyRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IdempotencyRecord value)?  $default,){
final _that = this;
switch (_that) {
case _IdempotencyRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String idempotencyKey,  String mutationType,  Map<String, dynamic> responseJson,  DateTime createdAt,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IdempotencyRecord() when $default != null:
return $default(_that.id,_that.restaurantId,_that.idempotencyKey,_that.mutationType,_that.responseJson,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String idempotencyKey,  String mutationType,  Map<String, dynamic> responseJson,  DateTime createdAt,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _IdempotencyRecord():
return $default(_that.id,_that.restaurantId,_that.idempotencyKey,_that.mutationType,_that.responseJson,_that.createdAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String restaurantId,  String idempotencyKey,  String mutationType,  Map<String, dynamic> responseJson,  DateTime createdAt,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _IdempotencyRecord() when $default != null:
return $default(_that.id,_that.restaurantId,_that.idempotencyKey,_that.mutationType,_that.responseJson,_that.createdAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IdempotencyRecord implements IdempotencyRecord {
  const _IdempotencyRecord({required this.id, required this.restaurantId, required this.idempotencyKey, required this.mutationType, required final  Map<String, dynamic> responseJson, required this.createdAt, required this.expiresAt}): _responseJson = responseJson;
  factory _IdempotencyRecord.fromJson(Map<String, dynamic> json) => _$IdempotencyRecordFromJson(json);

@override final  String id;
@override final  String restaurantId;
@override final  String idempotencyKey;
@override final  String mutationType;
 final  Map<String, dynamic> _responseJson;
@override Map<String, dynamic> get responseJson {
  if (_responseJson is EqualUnmodifiableMapView) return _responseJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_responseJson);
}

@override final  DateTime createdAt;
@override final  DateTime expiresAt;

/// Create a copy of IdempotencyRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IdempotencyRecordCopyWith<_IdempotencyRecord> get copyWith => __$IdempotencyRecordCopyWithImpl<_IdempotencyRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IdempotencyRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IdempotencyRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.mutationType, mutationType) || other.mutationType == mutationType)&&const DeepCollectionEquality().equals(other._responseJson, _responseJson)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,idempotencyKey,mutationType,const DeepCollectionEquality().hash(_responseJson),createdAt,expiresAt);

@override
String toString() {
  return 'IdempotencyRecord(id: $id, restaurantId: $restaurantId, idempotencyKey: $idempotencyKey, mutationType: $mutationType, responseJson: $responseJson, createdAt: $createdAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$IdempotencyRecordCopyWith<$Res> implements $IdempotencyRecordCopyWith<$Res> {
  factory _$IdempotencyRecordCopyWith(_IdempotencyRecord value, $Res Function(_IdempotencyRecord) _then) = __$IdempotencyRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String restaurantId, String idempotencyKey, String mutationType, Map<String, dynamic> responseJson, DateTime createdAt, DateTime expiresAt
});




}
/// @nodoc
class __$IdempotencyRecordCopyWithImpl<$Res>
    implements _$IdempotencyRecordCopyWith<$Res> {
  __$IdempotencyRecordCopyWithImpl(this._self, this._then);

  final _IdempotencyRecord _self;
  final $Res Function(_IdempotencyRecord) _then;

/// Create a copy of IdempotencyRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantId = null,Object? idempotencyKey = null,Object? mutationType = null,Object? responseJson = null,Object? createdAt = null,Object? expiresAt = null,}) {
  return _then(_IdempotencyRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: null == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String,mutationType: null == mutationType ? _self.mutationType : mutationType // ignore: cast_nullable_to_non_nullable
as String,responseJson: null == responseJson ? _self._responseJson : responseJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
