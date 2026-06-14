// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_auth_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionAuthToken {

 String get id; String get sessionId; String get tokenHash; DateTime get expiresAt; DateTime? get revokedAt; DateTime get createdAt;
/// Create a copy of SessionAuthToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionAuthTokenCopyWith<SessionAuthToken> get copyWith => _$SessionAuthTokenCopyWithImpl<SessionAuthToken>(this as SessionAuthToken, _$identity);

  /// Serializes this SessionAuthToken to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionAuthToken&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.tokenHash, tokenHash) || other.tokenHash == tokenHash)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.revokedAt, revokedAt) || other.revokedAt == revokedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,tokenHash,expiresAt,revokedAt,createdAt);

@override
String toString() {
  return 'SessionAuthToken(id: $id, sessionId: $sessionId, tokenHash: $tokenHash, expiresAt: $expiresAt, revokedAt: $revokedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SessionAuthTokenCopyWith<$Res>  {
  factory $SessionAuthTokenCopyWith(SessionAuthToken value, $Res Function(SessionAuthToken) _then) = _$SessionAuthTokenCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, String tokenHash, DateTime expiresAt, DateTime? revokedAt, DateTime createdAt
});




}
/// @nodoc
class _$SessionAuthTokenCopyWithImpl<$Res>
    implements $SessionAuthTokenCopyWith<$Res> {
  _$SessionAuthTokenCopyWithImpl(this._self, this._then);

  final SessionAuthToken _self;
  final $Res Function(SessionAuthToken) _then;

/// Create a copy of SessionAuthToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? tokenHash = null,Object? expiresAt = null,Object? revokedAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,tokenHash: null == tokenHash ? _self.tokenHash : tokenHash // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,revokedAt: freezed == revokedAt ? _self.revokedAt : revokedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionAuthToken].
extension SessionAuthTokenPatterns on SessionAuthToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionAuthToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionAuthToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionAuthToken value)  $default,){
final _that = this;
switch (_that) {
case _SessionAuthToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionAuthToken value)?  $default,){
final _that = this;
switch (_that) {
case _SessionAuthToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  String tokenHash,  DateTime expiresAt,  DateTime? revokedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionAuthToken() when $default != null:
return $default(_that.id,_that.sessionId,_that.tokenHash,_that.expiresAt,_that.revokedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  String tokenHash,  DateTime expiresAt,  DateTime? revokedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SessionAuthToken():
return $default(_that.id,_that.sessionId,_that.tokenHash,_that.expiresAt,_that.revokedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  String tokenHash,  DateTime expiresAt,  DateTime? revokedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionAuthToken() when $default != null:
return $default(_that.id,_that.sessionId,_that.tokenHash,_that.expiresAt,_that.revokedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionAuthToken implements SessionAuthToken {
  const _SessionAuthToken({required this.id, required this.sessionId, required this.tokenHash, required this.expiresAt, this.revokedAt, required this.createdAt});
  factory _SessionAuthToken.fromJson(Map<String, dynamic> json) => _$SessionAuthTokenFromJson(json);

@override final  String id;
@override final  String sessionId;
@override final  String tokenHash;
@override final  DateTime expiresAt;
@override final  DateTime? revokedAt;
@override final  DateTime createdAt;

/// Create a copy of SessionAuthToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionAuthTokenCopyWith<_SessionAuthToken> get copyWith => __$SessionAuthTokenCopyWithImpl<_SessionAuthToken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionAuthTokenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionAuthToken&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.tokenHash, tokenHash) || other.tokenHash == tokenHash)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.revokedAt, revokedAt) || other.revokedAt == revokedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,tokenHash,expiresAt,revokedAt,createdAt);

@override
String toString() {
  return 'SessionAuthToken(id: $id, sessionId: $sessionId, tokenHash: $tokenHash, expiresAt: $expiresAt, revokedAt: $revokedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SessionAuthTokenCopyWith<$Res> implements $SessionAuthTokenCopyWith<$Res> {
  factory _$SessionAuthTokenCopyWith(_SessionAuthToken value, $Res Function(_SessionAuthToken) _then) = __$SessionAuthTokenCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, String tokenHash, DateTime expiresAt, DateTime? revokedAt, DateTime createdAt
});




}
/// @nodoc
class __$SessionAuthTokenCopyWithImpl<$Res>
    implements _$SessionAuthTokenCopyWith<$Res> {
  __$SessionAuthTokenCopyWithImpl(this._self, this._then);

  final _SessionAuthToken _self;
  final $Res Function(_SessionAuthToken) _then;

/// Create a copy of SessionAuthToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? tokenHash = null,Object? expiresAt = null,Object? revokedAt = freezed,Object? createdAt = null,}) {
  return _then(_SessionAuthToken(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,tokenHash: null == tokenHash ? _self.tokenHash : tokenHash // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,revokedAt: freezed == revokedAt ? _self.revokedAt : revokedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
