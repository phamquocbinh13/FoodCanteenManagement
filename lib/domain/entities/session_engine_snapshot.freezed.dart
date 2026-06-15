// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_engine_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionEngineSnapshot {

 DineInSession get session; SessionAuthToken? get activeToken; String get tableLabel; List<String> get batchIds; List<String> get requestIds;
/// Create a copy of SessionEngineSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionEngineSnapshotCopyWith<SessionEngineSnapshot> get copyWith => _$SessionEngineSnapshotCopyWithImpl<SessionEngineSnapshot>(this as SessionEngineSnapshot, _$identity);

  /// Serializes this SessionEngineSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionEngineSnapshot&&(identical(other.session, session) || other.session == session)&&(identical(other.activeToken, activeToken) || other.activeToken == activeToken)&&(identical(other.tableLabel, tableLabel) || other.tableLabel == tableLabel)&&const DeepCollectionEquality().equals(other.batchIds, batchIds)&&const DeepCollectionEquality().equals(other.requestIds, requestIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,activeToken,tableLabel,const DeepCollectionEquality().hash(batchIds),const DeepCollectionEquality().hash(requestIds));

@override
String toString() {
  return 'SessionEngineSnapshot(session: $session, activeToken: $activeToken, tableLabel: $tableLabel, batchIds: $batchIds, requestIds: $requestIds)';
}


}

/// @nodoc
abstract mixin class $SessionEngineSnapshotCopyWith<$Res>  {
  factory $SessionEngineSnapshotCopyWith(SessionEngineSnapshot value, $Res Function(SessionEngineSnapshot) _then) = _$SessionEngineSnapshotCopyWithImpl;
@useResult
$Res call({
 DineInSession session, SessionAuthToken? activeToken, String tableLabel, List<String> batchIds, List<String> requestIds
});


$DineInSessionCopyWith<$Res> get session;$SessionAuthTokenCopyWith<$Res>? get activeToken;

}
/// @nodoc
class _$SessionEngineSnapshotCopyWithImpl<$Res>
    implements $SessionEngineSnapshotCopyWith<$Res> {
  _$SessionEngineSnapshotCopyWithImpl(this._self, this._then);

  final SessionEngineSnapshot _self;
  final $Res Function(SessionEngineSnapshot) _then;

/// Create a copy of SessionEngineSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? activeToken = freezed,Object? tableLabel = null,Object? batchIds = null,Object? requestIds = null,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as DineInSession,activeToken: freezed == activeToken ? _self.activeToken : activeToken // ignore: cast_nullable_to_non_nullable
as SessionAuthToken?,tableLabel: null == tableLabel ? _self.tableLabel : tableLabel // ignore: cast_nullable_to_non_nullable
as String,batchIds: null == batchIds ? _self.batchIds : batchIds // ignore: cast_nullable_to_non_nullable
as List<String>,requestIds: null == requestIds ? _self.requestIds : requestIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of SessionEngineSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DineInSessionCopyWith<$Res> get session {
  
  return $DineInSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of SessionEngineSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionAuthTokenCopyWith<$Res>? get activeToken {
    if (_self.activeToken == null) {
    return null;
  }

  return $SessionAuthTokenCopyWith<$Res>(_self.activeToken!, (value) {
    return _then(_self.copyWith(activeToken: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionEngineSnapshot].
extension SessionEngineSnapshotPatterns on SessionEngineSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionEngineSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionEngineSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionEngineSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _SessionEngineSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionEngineSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _SessionEngineSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DineInSession session,  SessionAuthToken? activeToken,  String tableLabel,  List<String> batchIds,  List<String> requestIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionEngineSnapshot() when $default != null:
return $default(_that.session,_that.activeToken,_that.tableLabel,_that.batchIds,_that.requestIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DineInSession session,  SessionAuthToken? activeToken,  String tableLabel,  List<String> batchIds,  List<String> requestIds)  $default,) {final _that = this;
switch (_that) {
case _SessionEngineSnapshot():
return $default(_that.session,_that.activeToken,_that.tableLabel,_that.batchIds,_that.requestIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DineInSession session,  SessionAuthToken? activeToken,  String tableLabel,  List<String> batchIds,  List<String> requestIds)?  $default,) {final _that = this;
switch (_that) {
case _SessionEngineSnapshot() when $default != null:
return $default(_that.session,_that.activeToken,_that.tableLabel,_that.batchIds,_that.requestIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionEngineSnapshot implements SessionEngineSnapshot {
  const _SessionEngineSnapshot({required this.session, this.activeToken, required this.tableLabel, final  List<String> batchIds = const [], final  List<String> requestIds = const []}): _batchIds = batchIds,_requestIds = requestIds;
  factory _SessionEngineSnapshot.fromJson(Map<String, dynamic> json) => _$SessionEngineSnapshotFromJson(json);

@override final  DineInSession session;
@override final  SessionAuthToken? activeToken;
@override final  String tableLabel;
 final  List<String> _batchIds;
@override@JsonKey() List<String> get batchIds {
  if (_batchIds is EqualUnmodifiableListView) return _batchIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_batchIds);
}

 final  List<String> _requestIds;
@override@JsonKey() List<String> get requestIds {
  if (_requestIds is EqualUnmodifiableListView) return _requestIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requestIds);
}


/// Create a copy of SessionEngineSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionEngineSnapshotCopyWith<_SessionEngineSnapshot> get copyWith => __$SessionEngineSnapshotCopyWithImpl<_SessionEngineSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionEngineSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionEngineSnapshot&&(identical(other.session, session) || other.session == session)&&(identical(other.activeToken, activeToken) || other.activeToken == activeToken)&&(identical(other.tableLabel, tableLabel) || other.tableLabel == tableLabel)&&const DeepCollectionEquality().equals(other._batchIds, _batchIds)&&const DeepCollectionEquality().equals(other._requestIds, _requestIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,activeToken,tableLabel,const DeepCollectionEquality().hash(_batchIds),const DeepCollectionEquality().hash(_requestIds));

@override
String toString() {
  return 'SessionEngineSnapshot(session: $session, activeToken: $activeToken, tableLabel: $tableLabel, batchIds: $batchIds, requestIds: $requestIds)';
}


}

/// @nodoc
abstract mixin class _$SessionEngineSnapshotCopyWith<$Res> implements $SessionEngineSnapshotCopyWith<$Res> {
  factory _$SessionEngineSnapshotCopyWith(_SessionEngineSnapshot value, $Res Function(_SessionEngineSnapshot) _then) = __$SessionEngineSnapshotCopyWithImpl;
@override @useResult
$Res call({
 DineInSession session, SessionAuthToken? activeToken, String tableLabel, List<String> batchIds, List<String> requestIds
});


@override $DineInSessionCopyWith<$Res> get session;@override $SessionAuthTokenCopyWith<$Res>? get activeToken;

}
/// @nodoc
class __$SessionEngineSnapshotCopyWithImpl<$Res>
    implements _$SessionEngineSnapshotCopyWith<$Res> {
  __$SessionEngineSnapshotCopyWithImpl(this._self, this._then);

  final _SessionEngineSnapshot _self;
  final $Res Function(_SessionEngineSnapshot) _then;

/// Create a copy of SessionEngineSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? activeToken = freezed,Object? tableLabel = null,Object? batchIds = null,Object? requestIds = null,}) {
  return _then(_SessionEngineSnapshot(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as DineInSession,activeToken: freezed == activeToken ? _self.activeToken : activeToken // ignore: cast_nullable_to_non_nullable
as SessionAuthToken?,tableLabel: null == tableLabel ? _self.tableLabel : tableLabel // ignore: cast_nullable_to_non_nullable
as String,batchIds: null == batchIds ? _self._batchIds : batchIds // ignore: cast_nullable_to_non_nullable
as List<String>,requestIds: null == requestIds ? _self._requestIds : requestIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of SessionEngineSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DineInSessionCopyWith<$Res> get session {
  
  return $DineInSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of SessionEngineSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionAuthTokenCopyWith<$Res>? get activeToken {
    if (_self.activeToken == null) {
    return null;
  }

  return $SessionAuthTokenCopyWith<$Res>(_self.activeToken!, (value) {
    return _then(_self.copyWith(activeToken: value));
  });
}
}

/// @nodoc
mixin _$SessionAccess {

 SessionEngineSnapshot get snapshot; String get sessionTokenValue;
/// Create a copy of SessionAccess
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionAccessCopyWith<SessionAccess> get copyWith => _$SessionAccessCopyWithImpl<SessionAccess>(this as SessionAccess, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionAccess&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.sessionTokenValue, sessionTokenValue) || other.sessionTokenValue == sessionTokenValue));
}


@override
int get hashCode => Object.hash(runtimeType,snapshot,sessionTokenValue);

@override
String toString() {
  return 'SessionAccess(snapshot: $snapshot, sessionTokenValue: $sessionTokenValue)';
}


}

/// @nodoc
abstract mixin class $SessionAccessCopyWith<$Res>  {
  factory $SessionAccessCopyWith(SessionAccess value, $Res Function(SessionAccess) _then) = _$SessionAccessCopyWithImpl;
@useResult
$Res call({
 SessionEngineSnapshot snapshot, String sessionTokenValue
});


$SessionEngineSnapshotCopyWith<$Res> get snapshot;

}
/// @nodoc
class _$SessionAccessCopyWithImpl<$Res>
    implements $SessionAccessCopyWith<$Res> {
  _$SessionAccessCopyWithImpl(this._self, this._then);

  final SessionAccess _self;
  final $Res Function(SessionAccess) _then;

/// Create a copy of SessionAccess
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? snapshot = null,Object? sessionTokenValue = null,}) {
  return _then(_self.copyWith(
snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as SessionEngineSnapshot,sessionTokenValue: null == sessionTokenValue ? _self.sessionTokenValue : sessionTokenValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of SessionAccess
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionEngineSnapshotCopyWith<$Res> get snapshot {
  
  return $SessionEngineSnapshotCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionAccess].
extension SessionAccessPatterns on SessionAccess {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionAccess value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionAccess() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionAccess value)  $default,){
final _that = this;
switch (_that) {
case _SessionAccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionAccess value)?  $default,){
final _that = this;
switch (_that) {
case _SessionAccess() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SessionEngineSnapshot snapshot,  String sessionTokenValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionAccess() when $default != null:
return $default(_that.snapshot,_that.sessionTokenValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SessionEngineSnapshot snapshot,  String sessionTokenValue)  $default,) {final _that = this;
switch (_that) {
case _SessionAccess():
return $default(_that.snapshot,_that.sessionTokenValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SessionEngineSnapshot snapshot,  String sessionTokenValue)?  $default,) {final _that = this;
switch (_that) {
case _SessionAccess() when $default != null:
return $default(_that.snapshot,_that.sessionTokenValue);case _:
  return null;

}
}

}

/// @nodoc


class _SessionAccess implements SessionAccess {
  const _SessionAccess({required this.snapshot, required this.sessionTokenValue});
  

@override final  SessionEngineSnapshot snapshot;
@override final  String sessionTokenValue;

/// Create a copy of SessionAccess
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionAccessCopyWith<_SessionAccess> get copyWith => __$SessionAccessCopyWithImpl<_SessionAccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionAccess&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&(identical(other.sessionTokenValue, sessionTokenValue) || other.sessionTokenValue == sessionTokenValue));
}


@override
int get hashCode => Object.hash(runtimeType,snapshot,sessionTokenValue);

@override
String toString() {
  return 'SessionAccess(snapshot: $snapshot, sessionTokenValue: $sessionTokenValue)';
}


}

/// @nodoc
abstract mixin class _$SessionAccessCopyWith<$Res> implements $SessionAccessCopyWith<$Res> {
  factory _$SessionAccessCopyWith(_SessionAccess value, $Res Function(_SessionAccess) _then) = __$SessionAccessCopyWithImpl;
@override @useResult
$Res call({
 SessionEngineSnapshot snapshot, String sessionTokenValue
});


@override $SessionEngineSnapshotCopyWith<$Res> get snapshot;

}
/// @nodoc
class __$SessionAccessCopyWithImpl<$Res>
    implements _$SessionAccessCopyWith<$Res> {
  __$SessionAccessCopyWithImpl(this._self, this._then);

  final _SessionAccess _self;
  final $Res Function(_SessionAccess) _then;

/// Create a copy of SessionAccess
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? snapshot = null,Object? sessionTokenValue = null,}) {
  return _then(_SessionAccess(
snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as SessionEngineSnapshot,sessionTokenValue: null == sessionTokenValue ? _self.sessionTokenValue : sessionTokenValue // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of SessionAccess
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionEngineSnapshotCopyWith<$Res> get snapshot {
  
  return $SessionEngineSnapshotCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}

// dart format on
