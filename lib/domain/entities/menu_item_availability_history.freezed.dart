// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_item_availability_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MenuItemAvailabilityHistory {

 String get id; String get menuItemId; MenuAvailability get fromAvailability; MenuAvailability get toAvailability; String get changedByUserId; DateTime get occurredAt;
/// Create a copy of MenuItemAvailabilityHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuItemAvailabilityHistoryCopyWith<MenuItemAvailabilityHistory> get copyWith => _$MenuItemAvailabilityHistoryCopyWithImpl<MenuItemAvailabilityHistory>(this as MenuItemAvailabilityHistory, _$identity);

  /// Serializes this MenuItemAvailabilityHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuItemAvailabilityHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.menuItemId, menuItemId) || other.menuItemId == menuItemId)&&(identical(other.fromAvailability, fromAvailability) || other.fromAvailability == fromAvailability)&&(identical(other.toAvailability, toAvailability) || other.toAvailability == toAvailability)&&(identical(other.changedByUserId, changedByUserId) || other.changedByUserId == changedByUserId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,menuItemId,fromAvailability,toAvailability,changedByUserId,occurredAt);

@override
String toString() {
  return 'MenuItemAvailabilityHistory(id: $id, menuItemId: $menuItemId, fromAvailability: $fromAvailability, toAvailability: $toAvailability, changedByUserId: $changedByUserId, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class $MenuItemAvailabilityHistoryCopyWith<$Res>  {
  factory $MenuItemAvailabilityHistoryCopyWith(MenuItemAvailabilityHistory value, $Res Function(MenuItemAvailabilityHistory) _then) = _$MenuItemAvailabilityHistoryCopyWithImpl;
@useResult
$Res call({
 String id, String menuItemId, MenuAvailability fromAvailability, MenuAvailability toAvailability, String changedByUserId, DateTime occurredAt
});




}
/// @nodoc
class _$MenuItemAvailabilityHistoryCopyWithImpl<$Res>
    implements $MenuItemAvailabilityHistoryCopyWith<$Res> {
  _$MenuItemAvailabilityHistoryCopyWithImpl(this._self, this._then);

  final MenuItemAvailabilityHistory _self;
  final $Res Function(MenuItemAvailabilityHistory) _then;

/// Create a copy of MenuItemAvailabilityHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? menuItemId = null,Object? fromAvailability = null,Object? toAvailability = null,Object? changedByUserId = null,Object? occurredAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,menuItemId: null == menuItemId ? _self.menuItemId : menuItemId // ignore: cast_nullable_to_non_nullable
as String,fromAvailability: null == fromAvailability ? _self.fromAvailability : fromAvailability // ignore: cast_nullable_to_non_nullable
as MenuAvailability,toAvailability: null == toAvailability ? _self.toAvailability : toAvailability // ignore: cast_nullable_to_non_nullable
as MenuAvailability,changedByUserId: null == changedByUserId ? _self.changedByUserId : changedByUserId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MenuItemAvailabilityHistory].
extension MenuItemAvailabilityHistoryPatterns on MenuItemAvailabilityHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuItemAvailabilityHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuItemAvailabilityHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuItemAvailabilityHistory value)  $default,){
final _that = this;
switch (_that) {
case _MenuItemAvailabilityHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuItemAvailabilityHistory value)?  $default,){
final _that = this;
switch (_that) {
case _MenuItemAvailabilityHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String menuItemId,  MenuAvailability fromAvailability,  MenuAvailability toAvailability,  String changedByUserId,  DateTime occurredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuItemAvailabilityHistory() when $default != null:
return $default(_that.id,_that.menuItemId,_that.fromAvailability,_that.toAvailability,_that.changedByUserId,_that.occurredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String menuItemId,  MenuAvailability fromAvailability,  MenuAvailability toAvailability,  String changedByUserId,  DateTime occurredAt)  $default,) {final _that = this;
switch (_that) {
case _MenuItemAvailabilityHistory():
return $default(_that.id,_that.menuItemId,_that.fromAvailability,_that.toAvailability,_that.changedByUserId,_that.occurredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String menuItemId,  MenuAvailability fromAvailability,  MenuAvailability toAvailability,  String changedByUserId,  DateTime occurredAt)?  $default,) {final _that = this;
switch (_that) {
case _MenuItemAvailabilityHistory() when $default != null:
return $default(_that.id,_that.menuItemId,_that.fromAvailability,_that.toAvailability,_that.changedByUserId,_that.occurredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MenuItemAvailabilityHistory implements MenuItemAvailabilityHistory {
  const _MenuItemAvailabilityHistory({required this.id, required this.menuItemId, required this.fromAvailability, required this.toAvailability, required this.changedByUserId, required this.occurredAt});
  factory _MenuItemAvailabilityHistory.fromJson(Map<String, dynamic> json) => _$MenuItemAvailabilityHistoryFromJson(json);

@override final  String id;
@override final  String menuItemId;
@override final  MenuAvailability fromAvailability;
@override final  MenuAvailability toAvailability;
@override final  String changedByUserId;
@override final  DateTime occurredAt;

/// Create a copy of MenuItemAvailabilityHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuItemAvailabilityHistoryCopyWith<_MenuItemAvailabilityHistory> get copyWith => __$MenuItemAvailabilityHistoryCopyWithImpl<_MenuItemAvailabilityHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MenuItemAvailabilityHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuItemAvailabilityHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.menuItemId, menuItemId) || other.menuItemId == menuItemId)&&(identical(other.fromAvailability, fromAvailability) || other.fromAvailability == fromAvailability)&&(identical(other.toAvailability, toAvailability) || other.toAvailability == toAvailability)&&(identical(other.changedByUserId, changedByUserId) || other.changedByUserId == changedByUserId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,menuItemId,fromAvailability,toAvailability,changedByUserId,occurredAt);

@override
String toString() {
  return 'MenuItemAvailabilityHistory(id: $id, menuItemId: $menuItemId, fromAvailability: $fromAvailability, toAvailability: $toAvailability, changedByUserId: $changedByUserId, occurredAt: $occurredAt)';
}


}

/// @nodoc
abstract mixin class _$MenuItemAvailabilityHistoryCopyWith<$Res> implements $MenuItemAvailabilityHistoryCopyWith<$Res> {
  factory _$MenuItemAvailabilityHistoryCopyWith(_MenuItemAvailabilityHistory value, $Res Function(_MenuItemAvailabilityHistory) _then) = __$MenuItemAvailabilityHistoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String menuItemId, MenuAvailability fromAvailability, MenuAvailability toAvailability, String changedByUserId, DateTime occurredAt
});




}
/// @nodoc
class __$MenuItemAvailabilityHistoryCopyWithImpl<$Res>
    implements _$MenuItemAvailabilityHistoryCopyWith<$Res> {
  __$MenuItemAvailabilityHistoryCopyWithImpl(this._self, this._then);

  final _MenuItemAvailabilityHistory _self;
  final $Res Function(_MenuItemAvailabilityHistory) _then;

/// Create a copy of MenuItemAvailabilityHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? menuItemId = null,Object? fromAvailability = null,Object? toAvailability = null,Object? changedByUserId = null,Object? occurredAt = null,}) {
  return _then(_MenuItemAvailabilityHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,menuItemId: null == menuItemId ? _self.menuItemId : menuItemId // ignore: cast_nullable_to_non_nullable
as String,fromAvailability: null == fromAvailability ? _self.fromAvailability : fromAvailability // ignore: cast_nullable_to_non_nullable
as MenuAvailability,toAvailability: null == toAvailability ? _self.toAvailability : toAvailability // ignore: cast_nullable_to_non_nullable
as MenuAvailability,changedByUserId: null == changedByUserId ? _self.changedByUserId : changedByUserId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
