// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditLog {

 String get id; String get restaurantId; ActorType get actorType; String? get actorId; String get entityType; String get entityId; AuditAction get action; Map<String, dynamic>? get beforeJson; Map<String, dynamic>? get afterJson; Map<String, dynamic> get metadataJson; DateTime get occurredAt;
/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogCopyWith<AuditLog> get copyWith => _$AuditLogCopyWithImpl<AuditLog>(this as AuditLog, _$identity);

  /// Serializes this AuditLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLog&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.actorType, actorType) || other.actorType == actorType)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.action, action) || other.action == action)&&const DeepCollectionEquality().equals(other.beforeJson, beforeJson)&&const DeepCollectionEquality().equals(other.afterJson, afterJson)&&const DeepCollectionEquality().equals(other.metadataJson, metadataJson)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,actorType,actorId,entityType,entityId,action,const DeepCollectionEquality().hash(beforeJson),const DeepCollectionEquality().hash(afterJson),const DeepCollectionEquality().hash(metadataJson),occurredAt);

@override
String toString() {
  return 'AuditLog(id: $id, restaurantId: $restaurantId, actorType: $actorType, actorId: $actorId, entityType: $entityType, entityId: $entityId, action: $action, beforeJson: $beforeJson, afterJson: $afterJson, metadataJson: $metadataJson, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $AuditLogCopyWith<$Res>  {
  factory $AuditLogCopyWith(AuditLog value, $Res Function(AuditLog) _then) = _$AuditLogCopyWithImpl;
@useResult
$Res call({
 String id, String restaurantId, ActorType actorType, String? actorId, String entityType, String entityId, AuditAction action, Map<String, dynamic>? beforeJson, Map<String, dynamic>? afterJson, Map<String, dynamic> metadataJson, DateTime occurredAt
});




}
/// @nodoc
class _$AuditLogCopyWithImpl<$Res>
    implements $AuditLogCopyWith<$Res> {
  _$AuditLogCopyWithImpl(this._self, this._then);

  final AuditLog _self;
  final $Res Function(AuditLog) _then;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? restaurantId = null,Object? actorType = null,Object? actorId = freezed,Object? entityType = null,Object? entityId = null,Object? action = null,Object? beforeJson = freezed,Object? afterJson = freezed,Object? metadataJson = null,Object? occurredAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,actorType: null == actorType ? _self.actorType : actorType // ignore: cast_nullable_to_non_nullable
as ActorType,actorId: freezed == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String?,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AuditAction,beforeJson: freezed == beforeJson ? _self.beforeJson : beforeJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,afterJson: freezed == afterJson ? _self.afterJson : afterJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,metadataJson: null == metadataJson ? _self.metadataJson : metadataJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLog].
extension AuditLogPatterns on AuditLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLog value)  $default,){
final _that = this;
switch (_that) {
case _AuditLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLog value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String restaurantId,  ActorType actorType,  String? actorId,  String entityType,  String entityId,  AuditAction action,  Map<String, dynamic>? beforeJson,  Map<String, dynamic>? afterJson,  Map<String, dynamic> metadataJson,  DateTime occurredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
return $default(_that.id,_that.restaurantId,_that.actorType,_that.actorId,_that.entityType,_that.entityId,_that.action,_that.beforeJson,_that.afterJson,_that.metadataJson,_that.occurredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String restaurantId,  ActorType actorType,  String? actorId,  String entityType,  String entityId,  AuditAction action,  Map<String, dynamic>? beforeJson,  Map<String, dynamic>? afterJson,  Map<String, dynamic> metadataJson,  DateTime occurredAt)  $default,) {final _that = this;
switch (_that) {
case _AuditLog():
return $default(_that.id,_that.restaurantId,_that.actorType,_that.actorId,_that.entityType,_that.entityId,_that.action,_that.beforeJson,_that.afterJson,_that.metadataJson,_that.occurredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String restaurantId,  ActorType actorType,  String? actorId,  String entityType,  String entityId,  AuditAction action,  Map<String, dynamic>? beforeJson,  Map<String, dynamic>? afterJson,  Map<String, dynamic> metadataJson,  DateTime occurredAt)?  $default,) {final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
return $default(_that.id,_that.restaurantId,_that.actorType,_that.actorId,_that.entityType,_that.entityId,_that.action,_that.beforeJson,_that.afterJson,_that.metadataJson,_that.occurredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditLog implements AuditLog {
  const _AuditLog({required this.id, required this.restaurantId, required this.actorType, this.actorId, required this.entityType, required this.entityId, required this.action, final  Map<String, dynamic>? beforeJson, final  Map<String, dynamic>? afterJson, final  Map<String, dynamic> metadataJson = const {}, required this.occurredAt}): _beforeJson = beforeJson,_afterJson = afterJson,_metadataJson = metadataJson;
  factory _AuditLog.fromJson(Map<String, dynamic> json) => _$AuditLogFromJson(json);

@override final  String id;
@override final  String restaurantId;
@override final  ActorType actorType;
@override final  String? actorId;
@override final  String entityType;
@override final  String entityId;
@override final  AuditAction action;
 final  Map<String, dynamic>? _beforeJson;
@override Map<String, dynamic>? get beforeJson {
  final value = _beforeJson;
  if (value == null) return null;
  if (_beforeJson is EqualUnmodifiableMapView) return _beforeJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _afterJson;
@override Map<String, dynamic>? get afterJson {
  final value = _afterJson;
  if (value == null) return null;
  if (_afterJson is EqualUnmodifiableMapView) return _afterJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic> _metadataJson;
@override@JsonKey() Map<String, dynamic> get metadataJson {
  if (_metadataJson is EqualUnmodifiableMapView) return _metadataJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadataJson);
}

@override final  DateTime occurredAt;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogCopyWith<_AuditLog> get copyWith => __$AuditLogCopyWithImpl<_AuditLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLog&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.actorType, actorType) || other.actorType == actorType)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.action, action) || other.action == action)&&const DeepCollectionEquality().equals(other._beforeJson, _beforeJson)&&const DeepCollectionEquality().equals(other._afterJson, _afterJson)&&const DeepCollectionEquality().equals(other._metadataJson, _metadataJson)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,actorType,actorId,entityType,entityId,action,const DeepCollectionEquality().hash(_beforeJson),const DeepCollectionEquality().hash(_afterJson),const DeepCollectionEquality().hash(_metadataJson),occurredAt);

@override
String toString() {
  return 'AuditLog(id: $id, restaurantId: $restaurantId, actorType: $actorType, actorId: $actorId, entityType: $entityType, entityId: $entityId, action: $action, beforeJson: $beforeJson, afterJson: $afterJson, metadataJson: $metadataJson, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$AuditLogCopyWith<$Res> implements $AuditLogCopyWith<$Res> {
  factory _$AuditLogCopyWith(_AuditLog value, $Res Function(_AuditLog) _then) = __$AuditLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String restaurantId, ActorType actorType, String? actorId, String entityType, String entityId, AuditAction action, Map<String, dynamic>? beforeJson, Map<String, dynamic>? afterJson, Map<String, dynamic> metadataJson, DateTime occurredAt
});




}
/// @nodoc
class __$AuditLogCopyWithImpl<$Res>
    implements _$AuditLogCopyWith<$Res> {
  __$AuditLogCopyWithImpl(this._self, this._then);

  final _AuditLog _self;
  final $Res Function(_AuditLog) _then;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantId = null,Object? actorType = null,Object? actorId = freezed,Object? entityType = null,Object? entityId = null,Object? action = null,Object? beforeJson = freezed,Object? afterJson = freezed,Object? metadataJson = null,Object? occurredAt = null,}) {
  return _then(_AuditLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,actorType: null == actorType ? _self.actorType : actorType // ignore: cast_nullable_to_non_nullable
as ActorType,actorId: freezed == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String?,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AuditAction,beforeJson: freezed == beforeJson ? _self._beforeJson : beforeJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,afterJson: freezed == afterJson ? _self._afterJson : afterJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,metadataJson: null == metadataJson ? _self._metadataJson : metadataJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
