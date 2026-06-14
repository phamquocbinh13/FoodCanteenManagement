// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RestaurantSettings {

 String get id; String get restaurantId; String get defaultCurrency;@PercentageConverter() Percentage get taxRateBps;@PercentageConverter() Percentage get serviceChargeBps; int get sessionTokenTtlMinutes; bool get allowQrOnReservedTable; bool get paymentSoftLockEnabled; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of RestaurantSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestaurantSettingsCopyWith<RestaurantSettings> get copyWith => _$RestaurantSettingsCopyWithImpl<RestaurantSettings>(this as RestaurantSettings, _$identity);

  /// Serializes this RestaurantSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.defaultCurrency, defaultCurrency) || other.defaultCurrency == defaultCurrency)&&(identical(other.taxRateBps, taxRateBps) || other.taxRateBps == taxRateBps)&&(identical(other.serviceChargeBps, serviceChargeBps) || other.serviceChargeBps == serviceChargeBps)&&(identical(other.sessionTokenTtlMinutes, sessionTokenTtlMinutes) || other.sessionTokenTtlMinutes == sessionTokenTtlMinutes)&&(identical(other.allowQrOnReservedTable, allowQrOnReservedTable) || other.allowQrOnReservedTable == allowQrOnReservedTable)&&(identical(other.paymentSoftLockEnabled, paymentSoftLockEnabled) || other.paymentSoftLockEnabled == paymentSoftLockEnabled)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,defaultCurrency,taxRateBps,serviceChargeBps,sessionTokenTtlMinutes,allowQrOnReservedTable,paymentSoftLockEnabled,createdAt,updatedAt);

@override
String toString() {
  return 'RestaurantSettings(id: $id, restaurantId: $restaurantId, defaultCurrency: $defaultCurrency, taxRateBps: $taxRateBps, serviceChargeBps: $serviceChargeBps, sessionTokenTtlMinutes: $sessionTokenTtlMinutes, allowQrOnReservedTable: $allowQrOnReservedTable, paymentSoftLockEnabled: $paymentSoftLockEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RestaurantSettingsCopyWith<$Res>  {
  factory $RestaurantSettingsCopyWith(RestaurantSettings value, $Res Function(RestaurantSettings) _then) = _$RestaurantSettingsCopyWithImpl;
@useResult
$Res call({
 String id, String restaurantId, String defaultCurrency,@PercentageConverter() Percentage taxRateBps,@PercentageConverter() Percentage serviceChargeBps, int sessionTokenTtlMinutes, bool allowQrOnReservedTable, bool paymentSoftLockEnabled, DateTime createdAt, DateTime updatedAt
});


$PercentageCopyWith<$Res> get taxRateBps;$PercentageCopyWith<$Res> get serviceChargeBps;

}
/// @nodoc
class _$RestaurantSettingsCopyWithImpl<$Res>
    implements $RestaurantSettingsCopyWith<$Res> {
  _$RestaurantSettingsCopyWithImpl(this._self, this._then);

  final RestaurantSettings _self;
  final $Res Function(RestaurantSettings) _then;

/// Create a copy of RestaurantSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? restaurantId = null,Object? defaultCurrency = null,Object? taxRateBps = null,Object? serviceChargeBps = null,Object? sessionTokenTtlMinutes = null,Object? allowQrOnReservedTable = null,Object? paymentSoftLockEnabled = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,defaultCurrency: null == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String,taxRateBps: null == taxRateBps ? _self.taxRateBps : taxRateBps // ignore: cast_nullable_to_non_nullable
as Percentage,serviceChargeBps: null == serviceChargeBps ? _self.serviceChargeBps : serviceChargeBps // ignore: cast_nullable_to_non_nullable
as Percentage,sessionTokenTtlMinutes: null == sessionTokenTtlMinutes ? _self.sessionTokenTtlMinutes : sessionTokenTtlMinutes // ignore: cast_nullable_to_non_nullable
as int,allowQrOnReservedTable: null == allowQrOnReservedTable ? _self.allowQrOnReservedTable : allowQrOnReservedTable // ignore: cast_nullable_to_non_nullable
as bool,paymentSoftLockEnabled: null == paymentSoftLockEnabled ? _self.paymentSoftLockEnabled : paymentSoftLockEnabled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of RestaurantSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageCopyWith<$Res> get taxRateBps {
  
  return $PercentageCopyWith<$Res>(_self.taxRateBps, (value) {
    return _then(_self.copyWith(taxRateBps: value));
  });
}/// Create a copy of RestaurantSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageCopyWith<$Res> get serviceChargeBps {
  
  return $PercentageCopyWith<$Res>(_self.serviceChargeBps, (value) {
    return _then(_self.copyWith(serviceChargeBps: value));
  });
}
}


/// Adds pattern-matching-related methods to [RestaurantSettings].
extension RestaurantSettingsPatterns on RestaurantSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestaurantSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestaurantSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestaurantSettings value)  $default,){
final _that = this;
switch (_that) {
case _RestaurantSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestaurantSettings value)?  $default,){
final _that = this;
switch (_that) {
case _RestaurantSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String defaultCurrency, @PercentageConverter()  Percentage taxRateBps, @PercentageConverter()  Percentage serviceChargeBps,  int sessionTokenTtlMinutes,  bool allowQrOnReservedTable,  bool paymentSoftLockEnabled,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestaurantSettings() when $default != null:
return $default(_that.id,_that.restaurantId,_that.defaultCurrency,_that.taxRateBps,_that.serviceChargeBps,_that.sessionTokenTtlMinutes,_that.allowQrOnReservedTable,_that.paymentSoftLockEnabled,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String restaurantId,  String defaultCurrency, @PercentageConverter()  Percentage taxRateBps, @PercentageConverter()  Percentage serviceChargeBps,  int sessionTokenTtlMinutes,  bool allowQrOnReservedTable,  bool paymentSoftLockEnabled,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RestaurantSettings():
return $default(_that.id,_that.restaurantId,_that.defaultCurrency,_that.taxRateBps,_that.serviceChargeBps,_that.sessionTokenTtlMinutes,_that.allowQrOnReservedTable,_that.paymentSoftLockEnabled,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String restaurantId,  String defaultCurrency, @PercentageConverter()  Percentage taxRateBps, @PercentageConverter()  Percentage serviceChargeBps,  int sessionTokenTtlMinutes,  bool allowQrOnReservedTable,  bool paymentSoftLockEnabled,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RestaurantSettings() when $default != null:
return $default(_that.id,_that.restaurantId,_that.defaultCurrency,_that.taxRateBps,_that.serviceChargeBps,_that.sessionTokenTtlMinutes,_that.allowQrOnReservedTable,_that.paymentSoftLockEnabled,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RestaurantSettings implements RestaurantSettings {
  const _RestaurantSettings({required this.id, required this.restaurantId, required this.defaultCurrency, @PercentageConverter() this.taxRateBps = const Percentage(0), @PercentageConverter() this.serviceChargeBps = const Percentage(0), this.sessionTokenTtlMinutes = 480, this.allowQrOnReservedTable = false, this.paymentSoftLockEnabled = true, required this.createdAt, required this.updatedAt});
  factory _RestaurantSettings.fromJson(Map<String, dynamic> json) => _$RestaurantSettingsFromJson(json);

@override final  String id;
@override final  String restaurantId;
@override final  String defaultCurrency;
@override@JsonKey()@PercentageConverter() final  Percentage taxRateBps;
@override@JsonKey()@PercentageConverter() final  Percentage serviceChargeBps;
@override@JsonKey() final  int sessionTokenTtlMinutes;
@override@JsonKey() final  bool allowQrOnReservedTable;
@override@JsonKey() final  bool paymentSoftLockEnabled;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of RestaurantSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestaurantSettingsCopyWith<_RestaurantSettings> get copyWith => __$RestaurantSettingsCopyWithImpl<_RestaurantSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestaurantSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestaurantSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.defaultCurrency, defaultCurrency) || other.defaultCurrency == defaultCurrency)&&(identical(other.taxRateBps, taxRateBps) || other.taxRateBps == taxRateBps)&&(identical(other.serviceChargeBps, serviceChargeBps) || other.serviceChargeBps == serviceChargeBps)&&(identical(other.sessionTokenTtlMinutes, sessionTokenTtlMinutes) || other.sessionTokenTtlMinutes == sessionTokenTtlMinutes)&&(identical(other.allowQrOnReservedTable, allowQrOnReservedTable) || other.allowQrOnReservedTable == allowQrOnReservedTable)&&(identical(other.paymentSoftLockEnabled, paymentSoftLockEnabled) || other.paymentSoftLockEnabled == paymentSoftLockEnabled)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,defaultCurrency,taxRateBps,serviceChargeBps,sessionTokenTtlMinutes,allowQrOnReservedTable,paymentSoftLockEnabled,createdAt,updatedAt);

@override
String toString() {
  return 'RestaurantSettings(id: $id, restaurantId: $restaurantId, defaultCurrency: $defaultCurrency, taxRateBps: $taxRateBps, serviceChargeBps: $serviceChargeBps, sessionTokenTtlMinutes: $sessionTokenTtlMinutes, allowQrOnReservedTable: $allowQrOnReservedTable, paymentSoftLockEnabled: $paymentSoftLockEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RestaurantSettingsCopyWith<$Res> implements $RestaurantSettingsCopyWith<$Res> {
  factory _$RestaurantSettingsCopyWith(_RestaurantSettings value, $Res Function(_RestaurantSettings) _then) = __$RestaurantSettingsCopyWithImpl;
@override @useResult
$Res call({
 String id, String restaurantId, String defaultCurrency,@PercentageConverter() Percentage taxRateBps,@PercentageConverter() Percentage serviceChargeBps, int sessionTokenTtlMinutes, bool allowQrOnReservedTable, bool paymentSoftLockEnabled, DateTime createdAt, DateTime updatedAt
});


@override $PercentageCopyWith<$Res> get taxRateBps;@override $PercentageCopyWith<$Res> get serviceChargeBps;

}
/// @nodoc
class __$RestaurantSettingsCopyWithImpl<$Res>
    implements _$RestaurantSettingsCopyWith<$Res> {
  __$RestaurantSettingsCopyWithImpl(this._self, this._then);

  final _RestaurantSettings _self;
  final $Res Function(_RestaurantSettings) _then;

/// Create a copy of RestaurantSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantId = null,Object? defaultCurrency = null,Object? taxRateBps = null,Object? serviceChargeBps = null,Object? sessionTokenTtlMinutes = null,Object? allowQrOnReservedTable = null,Object? paymentSoftLockEnabled = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_RestaurantSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,defaultCurrency: null == defaultCurrency ? _self.defaultCurrency : defaultCurrency // ignore: cast_nullable_to_non_nullable
as String,taxRateBps: null == taxRateBps ? _self.taxRateBps : taxRateBps // ignore: cast_nullable_to_non_nullable
as Percentage,serviceChargeBps: null == serviceChargeBps ? _self.serviceChargeBps : serviceChargeBps // ignore: cast_nullable_to_non_nullable
as Percentage,sessionTokenTtlMinutes: null == sessionTokenTtlMinutes ? _self.sessionTokenTtlMinutes : sessionTokenTtlMinutes // ignore: cast_nullable_to_non_nullable
as int,allowQrOnReservedTable: null == allowQrOnReservedTable ? _self.allowQrOnReservedTable : allowQrOnReservedTable // ignore: cast_nullable_to_non_nullable
as bool,paymentSoftLockEnabled: null == paymentSoftLockEnabled ? _self.paymentSoftLockEnabled : paymentSoftLockEnabled // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of RestaurantSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageCopyWith<$Res> get taxRateBps {
  
  return $PercentageCopyWith<$Res>(_self.taxRateBps, (value) {
    return _then(_self.copyWith(taxRateBps: value));
  });
}/// Create a copy of RestaurantSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PercentageCopyWith<$Res> get serviceChargeBps {
  
  return $PercentageCopyWith<$Res>(_self.serviceChargeBps, (value) {
    return _then(_self.copyWith(serviceChargeBps: value));
  });
}
}

// dart format on
