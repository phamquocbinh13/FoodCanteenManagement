// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionCart {

 String get id; String get sessionId; int get version; DateTime get updatedAt; DateTime get createdAt;
/// Create a copy of SessionCart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCartCopyWith<SessionCart> get copyWith => _$SessionCartCopyWithImpl<SessionCart>(this as SessionCart, _$identity);

  /// Serializes this SessionCart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionCart&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,version,updatedAt,createdAt);

@override
String toString() {
  return 'SessionCart(id: $id, sessionId: $sessionId, version: $version, updatedAt: $updatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SessionCartCopyWith<$Res>  {
  factory $SessionCartCopyWith(SessionCart value, $Res Function(SessionCart) _then) = _$SessionCartCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, int version, DateTime updatedAt, DateTime createdAt
});




}
/// @nodoc
class _$SessionCartCopyWithImpl<$Res>
    implements $SessionCartCopyWith<$Res> {
  _$SessionCartCopyWithImpl(this._self, this._then);

  final SessionCart _self;
  final $Res Function(SessionCart) _then;

/// Create a copy of SessionCart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? version = null,Object? updatedAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionCart].
extension SessionCartPatterns on SessionCart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionCart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionCart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionCart value)  $default,){
final _that = this;
switch (_that) {
case _SessionCart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionCart value)?  $default,){
final _that = this;
switch (_that) {
case _SessionCart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  int version,  DateTime updatedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionCart() when $default != null:
return $default(_that.id,_that.sessionId,_that.version,_that.updatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  int version,  DateTime updatedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SessionCart():
return $default(_that.id,_that.sessionId,_that.version,_that.updatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  int version,  DateTime updatedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionCart() when $default != null:
return $default(_that.id,_that.sessionId,_that.version,_that.updatedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionCart implements SessionCart {
  const _SessionCart({required this.id, required this.sessionId, this.version = 1, required this.updatedAt, required this.createdAt});
  factory _SessionCart.fromJson(Map<String, dynamic> json) => _$SessionCartFromJson(json);

@override final  String id;
@override final  String sessionId;
@override@JsonKey() final  int version;
@override final  DateTime updatedAt;
@override final  DateTime createdAt;

/// Create a copy of SessionCart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCartCopyWith<_SessionCart> get copyWith => __$SessionCartCopyWithImpl<_SessionCart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionCartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionCart&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.version, version) || other.version == version)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,version,updatedAt,createdAt);

@override
String toString() {
  return 'SessionCart(id: $id, sessionId: $sessionId, version: $version, updatedAt: $updatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SessionCartCopyWith<$Res> implements $SessionCartCopyWith<$Res> {
  factory _$SessionCartCopyWith(_SessionCart value, $Res Function(_SessionCart) _then) = __$SessionCartCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, int version, DateTime updatedAt, DateTime createdAt
});




}
/// @nodoc
class __$SessionCartCopyWithImpl<$Res>
    implements _$SessionCartCopyWith<$Res> {
  __$SessionCartCopyWithImpl(this._self, this._then);

  final _SessionCart _self;
  final $Res Function(_SessionCart) _then;

/// Create a copy of SessionCart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? version = null,Object? updatedAt = null,Object? createdAt = null,}) {
  return _then(_SessionCart(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
