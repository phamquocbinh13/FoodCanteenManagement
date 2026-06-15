// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_payment_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionPaymentSummary {

 int get subtotalMinor; int get discountMinor; int get taxMinor; int get serviceChargeMinor; int get totalMinor;
/// Create a copy of SessionPaymentSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionPaymentSummaryCopyWith<SessionPaymentSummary> get copyWith => _$SessionPaymentSummaryCopyWithImpl<SessionPaymentSummary>(this as SessionPaymentSummary, _$identity);

  /// Serializes this SessionPaymentSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionPaymentSummary&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.taxMinor, taxMinor) || other.taxMinor == taxMinor)&&(identical(other.serviceChargeMinor, serviceChargeMinor) || other.serviceChargeMinor == serviceChargeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subtotalMinor,discountMinor,taxMinor,serviceChargeMinor,totalMinor);

@override
String toString() {
  return 'SessionPaymentSummary(subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, taxMinor: $taxMinor, serviceChargeMinor: $serviceChargeMinor, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class $SessionPaymentSummaryCopyWith<$Res>  {
  factory $SessionPaymentSummaryCopyWith(SessionPaymentSummary value, $Res Function(SessionPaymentSummary) _then) = _$SessionPaymentSummaryCopyWithImpl;
@useResult
$Res call({
 int subtotalMinor, int discountMinor, int taxMinor, int serviceChargeMinor, int totalMinor
});




}
/// @nodoc
class _$SessionPaymentSummaryCopyWithImpl<$Res>
    implements $SessionPaymentSummaryCopyWith<$Res> {
  _$SessionPaymentSummaryCopyWithImpl(this._self, this._then);

  final SessionPaymentSummary _self;
  final $Res Function(SessionPaymentSummary) _then;

/// Create a copy of SessionPaymentSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subtotalMinor = null,Object? discountMinor = null,Object? taxMinor = null,Object? serviceChargeMinor = null,Object? totalMinor = null,}) {
  return _then(_self.copyWith(
subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,taxMinor: null == taxMinor ? _self.taxMinor : taxMinor // ignore: cast_nullable_to_non_nullable
as int,serviceChargeMinor: null == serviceChargeMinor ? _self.serviceChargeMinor : serviceChargeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionPaymentSummary].
extension SessionPaymentSummaryPatterns on SessionPaymentSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionPaymentSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionPaymentSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionPaymentSummary value)  $default,){
final _that = this;
switch (_that) {
case _SessionPaymentSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionPaymentSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SessionPaymentSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int subtotalMinor,  int discountMinor,  int taxMinor,  int serviceChargeMinor,  int totalMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionPaymentSummary() when $default != null:
return $default(_that.subtotalMinor,_that.discountMinor,_that.taxMinor,_that.serviceChargeMinor,_that.totalMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int subtotalMinor,  int discountMinor,  int taxMinor,  int serviceChargeMinor,  int totalMinor)  $default,) {final _that = this;
switch (_that) {
case _SessionPaymentSummary():
return $default(_that.subtotalMinor,_that.discountMinor,_that.taxMinor,_that.serviceChargeMinor,_that.totalMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int subtotalMinor,  int discountMinor,  int taxMinor,  int serviceChargeMinor,  int totalMinor)?  $default,) {final _that = this;
switch (_that) {
case _SessionPaymentSummary() when $default != null:
return $default(_that.subtotalMinor,_that.discountMinor,_that.taxMinor,_that.serviceChargeMinor,_that.totalMinor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionPaymentSummary implements SessionPaymentSummary {
  const _SessionPaymentSummary({this.subtotalMinor = 0, this.discountMinor = 0, this.taxMinor = 0, this.serviceChargeMinor = 0, this.totalMinor = 0});
  factory _SessionPaymentSummary.fromJson(Map<String, dynamic> json) => _$SessionPaymentSummaryFromJson(json);

@override@JsonKey() final  int subtotalMinor;
@override@JsonKey() final  int discountMinor;
@override@JsonKey() final  int taxMinor;
@override@JsonKey() final  int serviceChargeMinor;
@override@JsonKey() final  int totalMinor;

/// Create a copy of SessionPaymentSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionPaymentSummaryCopyWith<_SessionPaymentSummary> get copyWith => __$SessionPaymentSummaryCopyWithImpl<_SessionPaymentSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionPaymentSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionPaymentSummary&&(identical(other.subtotalMinor, subtotalMinor) || other.subtotalMinor == subtotalMinor)&&(identical(other.discountMinor, discountMinor) || other.discountMinor == discountMinor)&&(identical(other.taxMinor, taxMinor) || other.taxMinor == taxMinor)&&(identical(other.serviceChargeMinor, serviceChargeMinor) || other.serviceChargeMinor == serviceChargeMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subtotalMinor,discountMinor,taxMinor,serviceChargeMinor,totalMinor);

@override
String toString() {
  return 'SessionPaymentSummary(subtotalMinor: $subtotalMinor, discountMinor: $discountMinor, taxMinor: $taxMinor, serviceChargeMinor: $serviceChargeMinor, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class _$SessionPaymentSummaryCopyWith<$Res> implements $SessionPaymentSummaryCopyWith<$Res> {
  factory _$SessionPaymentSummaryCopyWith(_SessionPaymentSummary value, $Res Function(_SessionPaymentSummary) _then) = __$SessionPaymentSummaryCopyWithImpl;
@override @useResult
$Res call({
 int subtotalMinor, int discountMinor, int taxMinor, int serviceChargeMinor, int totalMinor
});




}
/// @nodoc
class __$SessionPaymentSummaryCopyWithImpl<$Res>
    implements _$SessionPaymentSummaryCopyWith<$Res> {
  __$SessionPaymentSummaryCopyWithImpl(this._self, this._then);

  final _SessionPaymentSummary _self;
  final $Res Function(_SessionPaymentSummary) _then;

/// Create a copy of SessionPaymentSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subtotalMinor = null,Object? discountMinor = null,Object? taxMinor = null,Object? serviceChargeMinor = null,Object? totalMinor = null,}) {
  return _then(_SessionPaymentSummary(
subtotalMinor: null == subtotalMinor ? _self.subtotalMinor : subtotalMinor // ignore: cast_nullable_to_non_nullable
as int,discountMinor: null == discountMinor ? _self.discountMinor : discountMinor // ignore: cast_nullable_to_non_nullable
as int,taxMinor: null == taxMinor ? _self.taxMinor : taxMinor // ignore: cast_nullable_to_non_nullable
as int,serviceChargeMinor: null == serviceChargeMinor ? _self.serviceChargeMinor : serviceChargeMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
