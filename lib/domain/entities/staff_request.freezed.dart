// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StaffRequest {

 String get id; String get restaurantId; String get sessionId; RequestType get requestType; RequestStatus get status; String? get note; DateTime get requestedAt; DateTime? get handledAt; String? get handledByUserId; DateTime get createdAt;
/// Create a copy of StaffRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffRequestCopyWith<StaffRequest> get copyWith => _$StaffRequestCopyWithImpl<StaffRequest>(this as StaffRequest, _$identity);

  /// Serializes this StaffRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.requestType, requestType) || other.requestType == requestType)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.handledAt, handledAt) || other.handledAt == handledAt)&&(identical(other.handledByUserId, handledByUserId) || other.handledByUserId == handledByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,sessionId,requestType,status,note,requestedAt,handledAt,handledByUserId,createdAt);

@override
String toString() {
  return 'StaffRequest(id: $id, restaurantId: $restaurantId, sessionId: $sessionId, requestType: $requestType, status: $status, note: $note, requestedAt: $requestedAt, handledAt: $handledAt, handledByUserId: $handledByUserId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StaffRequestCopyWith<$Res>  {
  factory $StaffRequestCopyWith(StaffRequest value, $Res Function(StaffRequest) _then) = _$StaffRequestCopyWithImpl;
@useResult
$Res call({
 String id, String restaurantId, String sessionId, RequestType requestType, RequestStatus status, String? note, DateTime requestedAt, DateTime? handledAt, String? handledByUserId, DateTime createdAt
});




}
/// @nodoc
class _$StaffRequestCopyWithImpl<$Res>
    implements $StaffRequestCopyWith<$Res> {
  _$StaffRequestCopyWithImpl(this._self, this._then);

  final StaffRequest _self;
  final $Res Function(StaffRequest) _then;

/// Create a copy of StaffRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? restaurantId = null,Object? sessionId = null,Object? requestType = null,Object? status = null,Object? note = freezed,Object? requestedAt = null,Object? handledAt = freezed,Object? handledByUserId = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,requestType: null == requestType ? _self.requestType : requestType // ignore: cast_nullable_to_non_nullable
as RequestType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,handledAt: freezed == handledAt ? _self.handledAt : handledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,handledByUserId: freezed == handledByUserId ? _self.handledByUserId : handledByUserId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StaffRequest].
extension StaffRequestPatterns on StaffRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffRequest value)  $default,){
final _that = this;
switch (_that) {
case _StaffRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffRequest value)?  $default,){
final _that = this;
switch (_that) {
case _StaffRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String sessionId,  RequestType requestType,  RequestStatus status,  String? note,  DateTime requestedAt,  DateTime? handledAt,  String? handledByUserId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffRequest() when $default != null:
return $default(_that.id,_that.restaurantId,_that.sessionId,_that.requestType,_that.status,_that.note,_that.requestedAt,_that.handledAt,_that.handledByUserId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String sessionId,  RequestType requestType,  RequestStatus status,  String? note,  DateTime requestedAt,  DateTime? handledAt,  String? handledByUserId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _StaffRequest():
return $default(_that.id,_that.restaurantId,_that.sessionId,_that.requestType,_that.status,_that.note,_that.requestedAt,_that.handledAt,_that.handledByUserId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String restaurantId,  String sessionId,  RequestType requestType,  RequestStatus status,  String? note,  DateTime requestedAt,  DateTime? handledAt,  String? handledByUserId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StaffRequest() when $default != null:
return $default(_that.id,_that.restaurantId,_that.sessionId,_that.requestType,_that.status,_that.note,_that.requestedAt,_that.handledAt,_that.handledByUserId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffRequest implements StaffRequest {
  const _StaffRequest({required this.id, required this.restaurantId, required this.sessionId, required this.requestType, this.status = RequestStatus.pending, this.note, required this.requestedAt, this.handledAt, this.handledByUserId, required this.createdAt});
  factory _StaffRequest.fromJson(Map<String, dynamic> json) => _$StaffRequestFromJson(json);

@override final  String id;
@override final  String restaurantId;
@override final  String sessionId;
@override final  RequestType requestType;
@override@JsonKey() final  RequestStatus status;
@override final  String? note;
@override final  DateTime requestedAt;
@override final  DateTime? handledAt;
@override final  String? handledByUserId;
@override final  DateTime createdAt;

/// Create a copy of StaffRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffRequestCopyWith<_StaffRequest> get copyWith => __$StaffRequestCopyWithImpl<_StaffRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.requestType, requestType) || other.requestType == requestType)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.requestedAt, requestedAt) || other.requestedAt == requestedAt)&&(identical(other.handledAt, handledAt) || other.handledAt == handledAt)&&(identical(other.handledByUserId, handledByUserId) || other.handledByUserId == handledByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,sessionId,requestType,status,note,requestedAt,handledAt,handledByUserId,createdAt);

@override
String toString() {
  return 'StaffRequest(id: $id, restaurantId: $restaurantId, sessionId: $sessionId, requestType: $requestType, status: $status, note: $note, requestedAt: $requestedAt, handledAt: $handledAt, handledByUserId: $handledByUserId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StaffRequestCopyWith<$Res> implements $StaffRequestCopyWith<$Res> {
  factory _$StaffRequestCopyWith(_StaffRequest value, $Res Function(_StaffRequest) _then) = __$StaffRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String restaurantId, String sessionId, RequestType requestType, RequestStatus status, String? note, DateTime requestedAt, DateTime? handledAt, String? handledByUserId, DateTime createdAt
});




}
/// @nodoc
class __$StaffRequestCopyWithImpl<$Res>
    implements _$StaffRequestCopyWith<$Res> {
  __$StaffRequestCopyWithImpl(this._self, this._then);

  final _StaffRequest _self;
  final $Res Function(_StaffRequest) _then;

/// Create a copy of StaffRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantId = null,Object? sessionId = null,Object? requestType = null,Object? status = null,Object? note = freezed,Object? requestedAt = null,Object? handledAt = freezed,Object? handledByUserId = freezed,Object? createdAt = null,}) {
  return _then(_StaffRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,requestType: null == requestType ? _self.requestType : requestType // ignore: cast_nullable_to_non_nullable
as RequestType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,requestedAt: null == requestedAt ? _self.requestedAt : requestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,handledAt: freezed == handledAt ? _self.handledAt : handledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,handledByUserId: freezed == handledByUserId ? _self.handledByUserId : handledByUserId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
