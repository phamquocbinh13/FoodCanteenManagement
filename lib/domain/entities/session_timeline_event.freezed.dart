// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_timeline_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionTimelineEvent {

 String get id; String get sessionId; SessionTimelineEventType get eventType; Map<String, dynamic> get payloadJson; ActorType get actorType; String? get actorId; DateTime get occurredAt;
/// Create a copy of SessionTimelineEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionTimelineEventCopyWith<SessionTimelineEvent> get copyWith => _$SessionTimelineEventCopyWithImpl<SessionTimelineEvent>(this as SessionTimelineEvent, _$identity);

  /// Serializes this SessionTimelineEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionTimelineEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&const DeepCollectionEquality().equals(other.payloadJson, payloadJson)&&(identical(other.actorType, actorType) || other.actorType == actorType)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,eventType,const DeepCollectionEquality().hash(payloadJson),actorType,actorId,occurredAt);

@override
String toString() {
  return 'SessionTimelineEvent(id: $id, sessionId: $sessionId, eventType: $eventType, payloadJson: $payloadJson, actorType: $actorType, actorId: $actorId, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $SessionTimelineEventCopyWith<$Res>  {
  factory $SessionTimelineEventCopyWith(SessionTimelineEvent value, $Res Function(SessionTimelineEvent) _then) = _$SessionTimelineEventCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, SessionTimelineEventType eventType, Map<String, dynamic> payloadJson, ActorType actorType, String? actorId, DateTime occurredAt
});




}
/// @nodoc
class _$SessionTimelineEventCopyWithImpl<$Res>
    implements $SessionTimelineEventCopyWith<$Res> {
  _$SessionTimelineEventCopyWithImpl(this._self, this._then);

  final SessionTimelineEvent _self;
  final $Res Function(SessionTimelineEvent) _then;

/// Create a copy of SessionTimelineEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? eventType = null,Object? payloadJson = null,Object? actorType = null,Object? actorId = freezed,Object? occurredAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as SessionTimelineEventType,payloadJson: null == payloadJson ? _self.payloadJson : payloadJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,actorType: null == actorType ? _self.actorType : actorType // ignore: cast_nullable_to_non_nullable
as ActorType,actorId: freezed == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionTimelineEvent].
extension SessionTimelineEventPatterns on SessionTimelineEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionTimelineEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionTimelineEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionTimelineEvent value)  $default,){
final _that = this;
switch (_that) {
case _SessionTimelineEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionTimelineEvent value)?  $default,){
final _that = this;
switch (_that) {
case _SessionTimelineEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  SessionTimelineEventType eventType,  Map<String, dynamic> payloadJson,  ActorType actorType,  String? actorId,  DateTime occurredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionTimelineEvent() when $default != null:
return $default(_that.id,_that.sessionId,_that.eventType,_that.payloadJson,_that.actorType,_that.actorId,_that.occurredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  SessionTimelineEventType eventType,  Map<String, dynamic> payloadJson,  ActorType actorType,  String? actorId,  DateTime occurredAt)  $default,) {final _that = this;
switch (_that) {
case _SessionTimelineEvent():
return $default(_that.id,_that.sessionId,_that.eventType,_that.payloadJson,_that.actorType,_that.actorId,_that.occurredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  SessionTimelineEventType eventType,  Map<String, dynamic> payloadJson,  ActorType actorType,  String? actorId,  DateTime occurredAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionTimelineEvent() when $default != null:
return $default(_that.id,_that.sessionId,_that.eventType,_that.payloadJson,_that.actorType,_that.actorId,_that.occurredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionTimelineEvent implements SessionTimelineEvent {
  const _SessionTimelineEvent({required this.id, required this.sessionId, required this.eventType, final  Map<String, dynamic> payloadJson = const {}, required this.actorType, this.actorId, required this.occurredAt}): _payloadJson = payloadJson;
  factory _SessionTimelineEvent.fromJson(Map<String, dynamic> json) => _$SessionTimelineEventFromJson(json);

@override final  String id;
@override final  String sessionId;
@override final  SessionTimelineEventType eventType;
 final  Map<String, dynamic> _payloadJson;
@override@JsonKey() Map<String, dynamic> get payloadJson {
  if (_payloadJson is EqualUnmodifiableMapView) return _payloadJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payloadJson);
}

@override final  ActorType actorType;
@override final  String? actorId;
@override final  DateTime occurredAt;

/// Create a copy of SessionTimelineEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionTimelineEventCopyWith<_SessionTimelineEvent> get copyWith => __$SessionTimelineEventCopyWithImpl<_SessionTimelineEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionTimelineEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionTimelineEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&const DeepCollectionEquality().equals(other._payloadJson, _payloadJson)&&(identical(other.actorType, actorType) || other.actorType == actorType)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,eventType,const DeepCollectionEquality().hash(_payloadJson),actorType,actorId,occurredAt);

@override
String toString() {
  return 'SessionTimelineEvent(id: $id, sessionId: $sessionId, eventType: $eventType, payloadJson: $payloadJson, actorType: $actorType, actorId: $actorId, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$SessionTimelineEventCopyWith<$Res> implements $SessionTimelineEventCopyWith<$Res> {
  factory _$SessionTimelineEventCopyWith(_SessionTimelineEvent value, $Res Function(_SessionTimelineEvent) _then) = __$SessionTimelineEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, SessionTimelineEventType eventType, Map<String, dynamic> payloadJson, ActorType actorType, String? actorId, DateTime occurredAt
});




}
/// @nodoc
class __$SessionTimelineEventCopyWithImpl<$Res>
    implements _$SessionTimelineEventCopyWith<$Res> {
  __$SessionTimelineEventCopyWithImpl(this._self, this._then);

  final _SessionTimelineEvent _self;
  final $Res Function(_SessionTimelineEvent) _then;

/// Create a copy of SessionTimelineEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? eventType = null,Object? payloadJson = null,Object? actorType = null,Object? actorId = freezed,Object? occurredAt = null,}) {
  return _then(_SessionTimelineEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as SessionTimelineEventType,payloadJson: null == payloadJson ? _self._payloadJson : payloadJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,actorType: null == actorType ? _self.actorType : actorType // ignore: cast_nullable_to_non_nullable
as ActorType,actorId: freezed == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
