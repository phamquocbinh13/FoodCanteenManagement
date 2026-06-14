// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_qr_token_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TableQrTokenRecord {

 String get id; String get restaurantId; String get tableId; String get tokenHash; bool get isActive; DateTime get createdAt;
/// Create a copy of TableQrTokenRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TableQrTokenRecordCopyWith<TableQrTokenRecord> get copyWith => _$TableQrTokenRecordCopyWithImpl<TableQrTokenRecord>(this as TableQrTokenRecord, _$identity);

  /// Serializes this TableQrTokenRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TableQrTokenRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.tokenHash, tokenHash) || other.tokenHash == tokenHash)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,tableId,tokenHash,isActive,createdAt);

@override
String toString() {
  return 'TableQrTokenRecord(id: $id, restaurantId: $restaurantId, tableId: $tableId, tokenHash: $tokenHash, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TableQrTokenRecordCopyWith<$Res>  {
  factory $TableQrTokenRecordCopyWith(TableQrTokenRecord value, $Res Function(TableQrTokenRecord) _then) = _$TableQrTokenRecordCopyWithImpl;
@useResult
$Res call({
 String id, String restaurantId, String tableId, String tokenHash, bool isActive, DateTime createdAt
});




}
/// @nodoc
class _$TableQrTokenRecordCopyWithImpl<$Res>
    implements $TableQrTokenRecordCopyWith<$Res> {
  _$TableQrTokenRecordCopyWithImpl(this._self, this._then);

  final TableQrTokenRecord _self;
  final $Res Function(TableQrTokenRecord) _then;

/// Create a copy of TableQrTokenRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? restaurantId = null,Object? tableId = null,Object? tokenHash = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,tokenHash: null == tokenHash ? _self.tokenHash : tokenHash // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TableQrTokenRecord].
extension TableQrTokenRecordPatterns on TableQrTokenRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TableQrTokenRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TableQrTokenRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TableQrTokenRecord value)  $default,){
final _that = this;
switch (_that) {
case _TableQrTokenRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TableQrTokenRecord value)?  $default,){
final _that = this;
switch (_that) {
case _TableQrTokenRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String tableId,  String tokenHash,  bool isActive,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TableQrTokenRecord() when $default != null:
return $default(_that.id,_that.restaurantId,_that.tableId,_that.tokenHash,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String tableId,  String tokenHash,  bool isActive,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TableQrTokenRecord():
return $default(_that.id,_that.restaurantId,_that.tableId,_that.tokenHash,_that.isActive,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String restaurantId,  String tableId,  String tokenHash,  bool isActive,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TableQrTokenRecord() when $default != null:
return $default(_that.id,_that.restaurantId,_that.tableId,_that.tokenHash,_that.isActive,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TableQrTokenRecord implements TableQrTokenRecord {
  const _TableQrTokenRecord({required this.id, required this.restaurantId, required this.tableId, required this.tokenHash, this.isActive = true, required this.createdAt});
  factory _TableQrTokenRecord.fromJson(Map<String, dynamic> json) => _$TableQrTokenRecordFromJson(json);

@override final  String id;
@override final  String restaurantId;
@override final  String tableId;
@override final  String tokenHash;
@override@JsonKey() final  bool isActive;
@override final  DateTime createdAt;

/// Create a copy of TableQrTokenRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TableQrTokenRecordCopyWith<_TableQrTokenRecord> get copyWith => __$TableQrTokenRecordCopyWithImpl<_TableQrTokenRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TableQrTokenRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TableQrTokenRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.tableId, tableId) || other.tableId == tableId)&&(identical(other.tokenHash, tokenHash) || other.tokenHash == tokenHash)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,tableId,tokenHash,isActive,createdAt);

@override
String toString() {
  return 'TableQrTokenRecord(id: $id, restaurantId: $restaurantId, tableId: $tableId, tokenHash: $tokenHash, isActive: $isActive, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TableQrTokenRecordCopyWith<$Res> implements $TableQrTokenRecordCopyWith<$Res> {
  factory _$TableQrTokenRecordCopyWith(_TableQrTokenRecord value, $Res Function(_TableQrTokenRecord) _then) = __$TableQrTokenRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String restaurantId, String tableId, String tokenHash, bool isActive, DateTime createdAt
});




}
/// @nodoc
class __$TableQrTokenRecordCopyWithImpl<$Res>
    implements _$TableQrTokenRecordCopyWith<$Res> {
  __$TableQrTokenRecordCopyWithImpl(this._self, this._then);

  final _TableQrTokenRecord _self;
  final $Res Function(_TableQrTokenRecord) _then;

/// Create a copy of TableQrTokenRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantId = null,Object? tableId = null,Object? tokenHash = null,Object? isActive = null,Object? createdAt = null,}) {
  return _then(_TableQrTokenRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,tableId: null == tableId ? _self.tableId : tableId // ignore: cast_nullable_to_non_nullable
as String,tokenHash: null == tokenHash ? _self.tokenHash : tokenHash // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
