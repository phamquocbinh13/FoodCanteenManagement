// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'percentage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Percentage {

 int get basisPoints;
/// Create a copy of Percentage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PercentageCopyWith<Percentage> get copyWith => _$PercentageCopyWithImpl<Percentage>(this as Percentage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Percentage&&(identical(other.basisPoints, basisPoints) || other.basisPoints == basisPoints));
}


@override
int get hashCode => Object.hash(runtimeType,basisPoints);

@override
String toString() {
  return 'Percentage(basisPoints: $basisPoints)';
}


}

/// @nodoc
abstract mixin class $PercentageCopyWith<$Res>  {
  factory $PercentageCopyWith(Percentage value, $Res Function(Percentage) _then) = _$PercentageCopyWithImpl;
@useResult
$Res call({
 int basisPoints
});




}
/// @nodoc
class _$PercentageCopyWithImpl<$Res>
    implements $PercentageCopyWith<$Res> {
  _$PercentageCopyWithImpl(this._self, this._then);

  final Percentage _self;
  final $Res Function(Percentage) _then;

/// Create a copy of Percentage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? basisPoints = null,}) {
  return _then(_self.copyWith(
basisPoints: null == basisPoints ? _self.basisPoints : basisPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Percentage].
extension PercentagePatterns on Percentage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Percentage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Percentage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Percentage value)  $default,){
final _that = this;
switch (_that) {
case _Percentage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Percentage value)?  $default,){
final _that = this;
switch (_that) {
case _Percentage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int basisPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Percentage() when $default != null:
return $default(_that.basisPoints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int basisPoints)  $default,) {final _that = this;
switch (_that) {
case _Percentage():
return $default(_that.basisPoints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int basisPoints)?  $default,) {final _that = this;
switch (_that) {
case _Percentage() when $default != null:
return $default(_that.basisPoints);case _:
  return null;

}
}

}

/// @nodoc


class _Percentage extends Percentage {
  const _Percentage(this.basisPoints): assert(basisPoints >= 0, 'Percentage cannot be negative'),super._();
  

@override final  int basisPoints;

/// Create a copy of Percentage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PercentageCopyWith<_Percentage> get copyWith => __$PercentageCopyWithImpl<_Percentage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Percentage&&(identical(other.basisPoints, basisPoints) || other.basisPoints == basisPoints));
}


@override
int get hashCode => Object.hash(runtimeType,basisPoints);

@override
String toString() {
  return 'Percentage(basisPoints: $basisPoints)';
}


}

/// @nodoc
abstract mixin class _$PercentageCopyWith<$Res> implements $PercentageCopyWith<$Res> {
  factory _$PercentageCopyWith(_Percentage value, $Res Function(_Percentage) _then) = __$PercentageCopyWithImpl;
@override @useResult
$Res call({
 int basisPoints
});




}
/// @nodoc
class __$PercentageCopyWithImpl<$Res>
    implements _$PercentageCopyWith<$Res> {
  __$PercentageCopyWithImpl(this._self, this._then);

  final _Percentage _self;
  final $Res Function(_Percentage) _then;

/// Create a copy of Percentage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? basisPoints = null,}) {
  return _then(_Percentage(
null == basisPoints ? _self.basisPoints : basisPoints // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
