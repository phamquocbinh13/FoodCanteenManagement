// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch_item_status_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatchItemStatusHistory {

 String get id; String get batchItemId; BatchItemStatus? get fromStatus; BatchItemStatus get toStatus; String? get changedByUserId; DateTime get occurredAt;
/// Create a copy of BatchItemStatusHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatchItemStatusHistoryCopyWith<BatchItemStatusHistory> get copyWith => _$BatchItemStatusHistoryCopyWithImpl<BatchItemStatusHistory>(this as BatchItemStatusHistory, _$identity);

  /// Serializes this BatchItemStatusHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatchItemStatusHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.batchItemId, batchItemId) || other.batchItemId == batchItemId)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.changedByUserId, changedByUserId) || other.changedByUserId == changedByUserId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,batchItemId,fromStatus,toStatus,changedByUserId,occurredAt);

@override
String toString() {
  return 'BatchItemStatusHistory(id: $id, batchItemId: $batchItemId, fromStatus: $fromStatus, toStatus: $toStatus, changedByUserId: $changedByUserId, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $BatchItemStatusHistoryCopyWith<$Res>  {
  factory $BatchItemStatusHistoryCopyWith(BatchItemStatusHistory value, $Res Function(BatchItemStatusHistory) _then) = _$BatchItemStatusHistoryCopyWithImpl;
@useResult
$Res call({
 String id, String batchItemId, BatchItemStatus? fromStatus, BatchItemStatus toStatus, String? changedByUserId, DateTime occurredAt
});




}
/// @nodoc
class _$BatchItemStatusHistoryCopyWithImpl<$Res>
    implements $BatchItemStatusHistoryCopyWith<$Res> {
  _$BatchItemStatusHistoryCopyWithImpl(this._self, this._then);

  final BatchItemStatusHistory _self;
  final $Res Function(BatchItemStatusHistory) _then;

/// Create a copy of BatchItemStatusHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? batchItemId = null,Object? fromStatus = freezed,Object? toStatus = null,Object? changedByUserId = freezed,Object? occurredAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,batchItemId: null == batchItemId ? _self.batchItemId : batchItemId // ignore: cast_nullable_to_non_nullable
as String,fromStatus: freezed == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as BatchItemStatus?,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as BatchItemStatus,changedByUserId: freezed == changedByUserId ? _self.changedByUserId : changedByUserId // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [BatchItemStatusHistory].
extension BatchItemStatusHistoryPatterns on BatchItemStatusHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatchItemStatusHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatchItemStatusHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatchItemStatusHistory value)  $default,){
final _that = this;
switch (_that) {
case _BatchItemStatusHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatchItemStatusHistory value)?  $default,){
final _that = this;
switch (_that) {
case _BatchItemStatusHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String batchItemId,  BatchItemStatus? fromStatus,  BatchItemStatus toStatus,  String? changedByUserId,  DateTime occurredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatchItemStatusHistory() when $default != null:
return $default(_that.id,_that.batchItemId,_that.fromStatus,_that.toStatus,_that.changedByUserId,_that.occurredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String batchItemId,  BatchItemStatus? fromStatus,  BatchItemStatus toStatus,  String? changedByUserId,  DateTime occurredAt)  $default,) {final _that = this;
switch (_that) {
case _BatchItemStatusHistory():
return $default(_that.id,_that.batchItemId,_that.fromStatus,_that.toStatus,_that.changedByUserId,_that.occurredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String batchItemId,  BatchItemStatus? fromStatus,  BatchItemStatus toStatus,  String? changedByUserId,  DateTime occurredAt)?  $default,) {final _that = this;
switch (_that) {
case _BatchItemStatusHistory() when $default != null:
return $default(_that.id,_that.batchItemId,_that.fromStatus,_that.toStatus,_that.changedByUserId,_that.occurredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatchItemStatusHistory implements BatchItemStatusHistory {
  const _BatchItemStatusHistory({required this.id, required this.batchItemId, this.fromStatus, required this.toStatus, this.changedByUserId, required this.occurredAt});
  factory _BatchItemStatusHistory.fromJson(Map<String, dynamic> json) => _$BatchItemStatusHistoryFromJson(json);

@override final  String id;
@override final  String batchItemId;
@override final  BatchItemStatus? fromStatus;
@override final  BatchItemStatus toStatus;
@override final  String? changedByUserId;
@override final  DateTime occurredAt;

/// Create a copy of BatchItemStatusHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatchItemStatusHistoryCopyWith<_BatchItemStatusHistory> get copyWith => __$BatchItemStatusHistoryCopyWithImpl<_BatchItemStatusHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatchItemStatusHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatchItemStatusHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.batchItemId, batchItemId) || other.batchItemId == batchItemId)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.changedByUserId, changedByUserId) || other.changedByUserId == changedByUserId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,batchItemId,fromStatus,toStatus,changedByUserId,occurredAt);

@override
String toString() {
  return 'BatchItemStatusHistory(id: $id, batchItemId: $batchItemId, fromStatus: $fromStatus, toStatus: $toStatus, changedByUserId: $changedByUserId, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$BatchItemStatusHistoryCopyWith<$Res> implements $BatchItemStatusHistoryCopyWith<$Res> {
  factory _$BatchItemStatusHistoryCopyWith(_BatchItemStatusHistory value, $Res Function(_BatchItemStatusHistory) _then) = __$BatchItemStatusHistoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String batchItemId, BatchItemStatus? fromStatus, BatchItemStatus toStatus, String? changedByUserId, DateTime occurredAt
});




}
/// @nodoc
class __$BatchItemStatusHistoryCopyWithImpl<$Res>
    implements _$BatchItemStatusHistoryCopyWith<$Res> {
  __$BatchItemStatusHistoryCopyWithImpl(this._self, this._then);

  final _BatchItemStatusHistory _self;
  final $Res Function(_BatchItemStatusHistory) _then;

/// Create a copy of BatchItemStatusHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? batchItemId = null,Object? fromStatus = freezed,Object? toStatus = null,Object? changedByUserId = freezed,Object? occurredAt = null,}) {
  return _then(_BatchItemStatusHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,batchItemId: null == batchItemId ? _self.batchItemId : batchItemId // ignore: cast_nullable_to_non_nullable
as String,fromStatus: freezed == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as BatchItemStatus?,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as BatchItemStatus,changedByUserId: freezed == changedByUserId ? _self.changedByUserId : changedByUserId // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
