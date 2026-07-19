// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductVelocity {

 String get id; String get name; int get quantitySold; String? get imageUrl; String get currencyCode; int get basePriceMinor;
/// Create a copy of ProductVelocity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductVelocityCopyWith<ProductVelocity> get copyWith => _$ProductVelocityCopyWithImpl<ProductVelocity>(this as ProductVelocity, _$identity);

  /// Serializes this ProductVelocity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductVelocity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,quantitySold,imageUrl,currencyCode,basePriceMinor);

@override
String toString() {
  return 'ProductVelocity(id: $id, name: $name, quantitySold: $quantitySold, imageUrl: $imageUrl, currencyCode: $currencyCode, basePriceMinor: $basePriceMinor)';
}


}

/// @nodoc
abstract mixin class $ProductVelocityCopyWith<$Res>  {
  factory $ProductVelocityCopyWith(ProductVelocity value, $Res Function(ProductVelocity) _then) = _$ProductVelocityCopyWithImpl;
@useResult
$Res call({
 String id, String name, int quantitySold, String? imageUrl, String currencyCode, int basePriceMinor
});




}
/// @nodoc
class _$ProductVelocityCopyWithImpl<$Res>
    implements $ProductVelocityCopyWith<$Res> {
  _$ProductVelocityCopyWithImpl(this._self, this._then);

  final ProductVelocity _self;
  final $Res Function(ProductVelocity) _then;

/// Create a copy of ProductVelocity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? quantitySold = null,Object? imageUrl = freezed,Object? currencyCode = null,Object? basePriceMinor = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductVelocity].
extension ProductVelocityPatterns on ProductVelocity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductVelocity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductVelocity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductVelocity value)  $default,){
final _that = this;
switch (_that) {
case _ProductVelocity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductVelocity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductVelocity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int quantitySold,  String? imageUrl,  String currencyCode,  int basePriceMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductVelocity() when $default != null:
return $default(_that.id,_that.name,_that.quantitySold,_that.imageUrl,_that.currencyCode,_that.basePriceMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int quantitySold,  String? imageUrl,  String currencyCode,  int basePriceMinor)  $default,) {final _that = this;
switch (_that) {
case _ProductVelocity():
return $default(_that.id,_that.name,_that.quantitySold,_that.imageUrl,_that.currencyCode,_that.basePriceMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int quantitySold,  String? imageUrl,  String currencyCode,  int basePriceMinor)?  $default,) {final _that = this;
switch (_that) {
case _ProductVelocity() when $default != null:
return $default(_that.id,_that.name,_that.quantitySold,_that.imageUrl,_that.currencyCode,_that.basePriceMinor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductVelocity implements ProductVelocity {
  const _ProductVelocity({required this.id, required this.name, required this.quantitySold, this.imageUrl, required this.currencyCode, required this.basePriceMinor});
  factory _ProductVelocity.fromJson(Map<String, dynamic> json) => _$ProductVelocityFromJson(json);

@override final  String id;
@override final  String name;
@override final  int quantitySold;
@override final  String? imageUrl;
@override final  String currencyCode;
@override final  int basePriceMinor;

/// Create a copy of ProductVelocity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductVelocityCopyWith<_ProductVelocity> get copyWith => __$ProductVelocityCopyWithImpl<_ProductVelocity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductVelocityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductVelocity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.basePriceMinor, basePriceMinor) || other.basePriceMinor == basePriceMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,quantitySold,imageUrl,currencyCode,basePriceMinor);

@override
String toString() {
  return 'ProductVelocity(id: $id, name: $name, quantitySold: $quantitySold, imageUrl: $imageUrl, currencyCode: $currencyCode, basePriceMinor: $basePriceMinor)';
}


}

/// @nodoc
abstract mixin class _$ProductVelocityCopyWith<$Res> implements $ProductVelocityCopyWith<$Res> {
  factory _$ProductVelocityCopyWith(_ProductVelocity value, $Res Function(_ProductVelocity) _then) = __$ProductVelocityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int quantitySold, String? imageUrl, String currencyCode, int basePriceMinor
});




}
/// @nodoc
class __$ProductVelocityCopyWithImpl<$Res>
    implements _$ProductVelocityCopyWith<$Res> {
  __$ProductVelocityCopyWithImpl(this._self, this._then);

  final _ProductVelocity _self;
  final $Res Function(_ProductVelocity) _then;

/// Create a copy of ProductVelocity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? quantitySold = null,Object? imageUrl = freezed,Object? currencyCode = null,Object? basePriceMinor = null,}) {
  return _then(_ProductVelocity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,basePriceMinor: null == basePriceMinor ? _self.basePriceMinor : basePriceMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ProductVelocityData {

 List<ProductVelocity> get bestSellers; List<ProductVelocity> get worstSellers;
/// Create a copy of ProductVelocityData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductVelocityDataCopyWith<ProductVelocityData> get copyWith => _$ProductVelocityDataCopyWithImpl<ProductVelocityData>(this as ProductVelocityData, _$identity);

  /// Serializes this ProductVelocityData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductVelocityData&&const DeepCollectionEquality().equals(other.bestSellers, bestSellers)&&const DeepCollectionEquality().equals(other.worstSellers, worstSellers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bestSellers),const DeepCollectionEquality().hash(worstSellers));

@override
String toString() {
  return 'ProductVelocityData(bestSellers: $bestSellers, worstSellers: $worstSellers)';
}


}

/// @nodoc
abstract mixin class $ProductVelocityDataCopyWith<$Res>  {
  factory $ProductVelocityDataCopyWith(ProductVelocityData value, $Res Function(ProductVelocityData) _then) = _$ProductVelocityDataCopyWithImpl;
@useResult
$Res call({
 List<ProductVelocity> bestSellers, List<ProductVelocity> worstSellers
});




}
/// @nodoc
class _$ProductVelocityDataCopyWithImpl<$Res>
    implements $ProductVelocityDataCopyWith<$Res> {
  _$ProductVelocityDataCopyWithImpl(this._self, this._then);

  final ProductVelocityData _self;
  final $Res Function(ProductVelocityData) _then;

/// Create a copy of ProductVelocityData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bestSellers = null,Object? worstSellers = null,}) {
  return _then(_self.copyWith(
bestSellers: null == bestSellers ? _self.bestSellers : bestSellers // ignore: cast_nullable_to_non_nullable
as List<ProductVelocity>,worstSellers: null == worstSellers ? _self.worstSellers : worstSellers // ignore: cast_nullable_to_non_nullable
as List<ProductVelocity>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductVelocityData].
extension ProductVelocityDataPatterns on ProductVelocityData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductVelocityData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductVelocityData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductVelocityData value)  $default,){
final _that = this;
switch (_that) {
case _ProductVelocityData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductVelocityData value)?  $default,){
final _that = this;
switch (_that) {
case _ProductVelocityData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProductVelocity> bestSellers,  List<ProductVelocity> worstSellers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductVelocityData() when $default != null:
return $default(_that.bestSellers,_that.worstSellers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProductVelocity> bestSellers,  List<ProductVelocity> worstSellers)  $default,) {final _that = this;
switch (_that) {
case _ProductVelocityData():
return $default(_that.bestSellers,_that.worstSellers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProductVelocity> bestSellers,  List<ProductVelocity> worstSellers)?  $default,) {final _that = this;
switch (_that) {
case _ProductVelocityData() when $default != null:
return $default(_that.bestSellers,_that.worstSellers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductVelocityData implements ProductVelocityData {
  const _ProductVelocityData({final  List<ProductVelocity> bestSellers = const [], final  List<ProductVelocity> worstSellers = const []}): _bestSellers = bestSellers,_worstSellers = worstSellers;
  factory _ProductVelocityData.fromJson(Map<String, dynamic> json) => _$ProductVelocityDataFromJson(json);

 final  List<ProductVelocity> _bestSellers;
@override@JsonKey() List<ProductVelocity> get bestSellers {
  if (_bestSellers is EqualUnmodifiableListView) return _bestSellers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bestSellers);
}

 final  List<ProductVelocity> _worstSellers;
@override@JsonKey() List<ProductVelocity> get worstSellers {
  if (_worstSellers is EqualUnmodifiableListView) return _worstSellers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_worstSellers);
}


/// Create a copy of ProductVelocityData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductVelocityDataCopyWith<_ProductVelocityData> get copyWith => __$ProductVelocityDataCopyWithImpl<_ProductVelocityData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductVelocityDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductVelocityData&&const DeepCollectionEquality().equals(other._bestSellers, _bestSellers)&&const DeepCollectionEquality().equals(other._worstSellers, _worstSellers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bestSellers),const DeepCollectionEquality().hash(_worstSellers));

@override
String toString() {
  return 'ProductVelocityData(bestSellers: $bestSellers, worstSellers: $worstSellers)';
}


}

/// @nodoc
abstract mixin class _$ProductVelocityDataCopyWith<$Res> implements $ProductVelocityDataCopyWith<$Res> {
  factory _$ProductVelocityDataCopyWith(_ProductVelocityData value, $Res Function(_ProductVelocityData) _then) = __$ProductVelocityDataCopyWithImpl;
@override @useResult
$Res call({
 List<ProductVelocity> bestSellers, List<ProductVelocity> worstSellers
});




}
/// @nodoc
class __$ProductVelocityDataCopyWithImpl<$Res>
    implements _$ProductVelocityDataCopyWith<$Res> {
  __$ProductVelocityDataCopyWithImpl(this._self, this._then);

  final _ProductVelocityData _self;
  final $Res Function(_ProductVelocityData) _then;

/// Create a copy of ProductVelocityData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bestSellers = null,Object? worstSellers = null,}) {
  return _then(_ProductVelocityData(
bestSellers: null == bestSellers ? _self._bestSellers : bestSellers // ignore: cast_nullable_to_non_nullable
as List<ProductVelocity>,worstSellers: null == worstSellers ? _self._worstSellers : worstSellers // ignore: cast_nullable_to_non_nullable
as List<ProductVelocity>,
  ));
}


}


/// @nodoc
mixin _$PredictiveInsightsData {

 List<String> get alerts;
/// Create a copy of PredictiveInsightsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PredictiveInsightsDataCopyWith<PredictiveInsightsData> get copyWith => _$PredictiveInsightsDataCopyWithImpl<PredictiveInsightsData>(this as PredictiveInsightsData, _$identity);

  /// Serializes this PredictiveInsightsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PredictiveInsightsData&&const DeepCollectionEquality().equals(other.alerts, alerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(alerts));

@override
String toString() {
  return 'PredictiveInsightsData(alerts: $alerts)';
}


}

/// @nodoc
abstract mixin class $PredictiveInsightsDataCopyWith<$Res>  {
  factory $PredictiveInsightsDataCopyWith(PredictiveInsightsData value, $Res Function(PredictiveInsightsData) _then) = _$PredictiveInsightsDataCopyWithImpl;
@useResult
$Res call({
 List<String> alerts
});




}
/// @nodoc
class _$PredictiveInsightsDataCopyWithImpl<$Res>
    implements $PredictiveInsightsDataCopyWith<$Res> {
  _$PredictiveInsightsDataCopyWithImpl(this._self, this._then);

  final PredictiveInsightsData _self;
  final $Res Function(PredictiveInsightsData) _then;

/// Create a copy of PredictiveInsightsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? alerts = null,}) {
  return _then(_self.copyWith(
alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PredictiveInsightsData].
extension PredictiveInsightsDataPatterns on PredictiveInsightsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PredictiveInsightsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PredictiveInsightsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PredictiveInsightsData value)  $default,){
final _that = this;
switch (_that) {
case _PredictiveInsightsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PredictiveInsightsData value)?  $default,){
final _that = this;
switch (_that) {
case _PredictiveInsightsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> alerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PredictiveInsightsData() when $default != null:
return $default(_that.alerts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> alerts)  $default,) {final _that = this;
switch (_that) {
case _PredictiveInsightsData():
return $default(_that.alerts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> alerts)?  $default,) {final _that = this;
switch (_that) {
case _PredictiveInsightsData() when $default != null:
return $default(_that.alerts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PredictiveInsightsData implements PredictiveInsightsData {
  const _PredictiveInsightsData({final  List<String> alerts = const []}): _alerts = alerts;
  factory _PredictiveInsightsData.fromJson(Map<String, dynamic> json) => _$PredictiveInsightsDataFromJson(json);

 final  List<String> _alerts;
@override@JsonKey() List<String> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}


/// Create a copy of PredictiveInsightsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PredictiveInsightsDataCopyWith<_PredictiveInsightsData> get copyWith => __$PredictiveInsightsDataCopyWithImpl<_PredictiveInsightsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PredictiveInsightsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PredictiveInsightsData&&const DeepCollectionEquality().equals(other._alerts, _alerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_alerts));

@override
String toString() {
  return 'PredictiveInsightsData(alerts: $alerts)';
}


}

/// @nodoc
abstract mixin class _$PredictiveInsightsDataCopyWith<$Res> implements $PredictiveInsightsDataCopyWith<$Res> {
  factory _$PredictiveInsightsDataCopyWith(_PredictiveInsightsData value, $Res Function(_PredictiveInsightsData) _then) = __$PredictiveInsightsDataCopyWithImpl;
@override @useResult
$Res call({
 List<String> alerts
});




}
/// @nodoc
class __$PredictiveInsightsDataCopyWithImpl<$Res>
    implements _$PredictiveInsightsDataCopyWith<$Res> {
  __$PredictiveInsightsDataCopyWithImpl(this._self, this._then);

  final _PredictiveInsightsData _self;
  final $Res Function(_PredictiveInsightsData) _then;

/// Create a copy of PredictiveInsightsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? alerts = null,}) {
  return _then(_PredictiveInsightsData(
alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$RevenuePoint {

 String get date; int get revenueMinor;
/// Create a copy of RevenuePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RevenuePointCopyWith<RevenuePoint> get copyWith => _$RevenuePointCopyWithImpl<RevenuePoint>(this as RevenuePoint, _$identity);

  /// Serializes this RevenuePoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RevenuePoint&&(identical(other.date, date) || other.date == date)&&(identical(other.revenueMinor, revenueMinor) || other.revenueMinor == revenueMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,revenueMinor);

@override
String toString() {
  return 'RevenuePoint(date: $date, revenueMinor: $revenueMinor)';
}


}

/// @nodoc
abstract mixin class $RevenuePointCopyWith<$Res>  {
  factory $RevenuePointCopyWith(RevenuePoint value, $Res Function(RevenuePoint) _then) = _$RevenuePointCopyWithImpl;
@useResult
$Res call({
 String date, int revenueMinor
});




}
/// @nodoc
class _$RevenuePointCopyWithImpl<$Res>
    implements $RevenuePointCopyWith<$Res> {
  _$RevenuePointCopyWithImpl(this._self, this._then);

  final RevenuePoint _self;
  final $Res Function(RevenuePoint) _then;

/// Create a copy of RevenuePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? revenueMinor = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,revenueMinor: null == revenueMinor ? _self.revenueMinor : revenueMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RevenuePoint].
extension RevenuePointPatterns on RevenuePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RevenuePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RevenuePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RevenuePoint value)  $default,){
final _that = this;
switch (_that) {
case _RevenuePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RevenuePoint value)?  $default,){
final _that = this;
switch (_that) {
case _RevenuePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int revenueMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RevenuePoint() when $default != null:
return $default(_that.date,_that.revenueMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int revenueMinor)  $default,) {final _that = this;
switch (_that) {
case _RevenuePoint():
return $default(_that.date,_that.revenueMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int revenueMinor)?  $default,) {final _that = this;
switch (_that) {
case _RevenuePoint() when $default != null:
return $default(_that.date,_that.revenueMinor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RevenuePoint implements RevenuePoint {
  const _RevenuePoint({required this.date, required this.revenueMinor});
  factory _RevenuePoint.fromJson(Map<String, dynamic> json) => _$RevenuePointFromJson(json);

@override final  String date;
@override final  int revenueMinor;

/// Create a copy of RevenuePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RevenuePointCopyWith<_RevenuePoint> get copyWith => __$RevenuePointCopyWithImpl<_RevenuePoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RevenuePointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RevenuePoint&&(identical(other.date, date) || other.date == date)&&(identical(other.revenueMinor, revenueMinor) || other.revenueMinor == revenueMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,revenueMinor);

@override
String toString() {
  return 'RevenuePoint(date: $date, revenueMinor: $revenueMinor)';
}


}

/// @nodoc
abstract mixin class _$RevenuePointCopyWith<$Res> implements $RevenuePointCopyWith<$Res> {
  factory _$RevenuePointCopyWith(_RevenuePoint value, $Res Function(_RevenuePoint) _then) = __$RevenuePointCopyWithImpl;
@override @useResult
$Res call({
 String date, int revenueMinor
});




}
/// @nodoc
class __$RevenuePointCopyWithImpl<$Res>
    implements _$RevenuePointCopyWith<$Res> {
  __$RevenuePointCopyWithImpl(this._self, this._then);

  final _RevenuePoint _self;
  final $Res Function(_RevenuePoint) _then;

/// Create a copy of RevenuePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? revenueMinor = null,}) {
  return _then(_RevenuePoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,revenueMinor: null == revenueMinor ? _self.revenueMinor : revenueMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HeatmapPoint {

 int get hour; int get intensity;
/// Create a copy of HeatmapPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeatmapPointCopyWith<HeatmapPoint> get copyWith => _$HeatmapPointCopyWithImpl<HeatmapPoint>(this as HeatmapPoint, _$identity);

  /// Serializes this HeatmapPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeatmapPoint&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.intensity, intensity) || other.intensity == intensity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,intensity);

@override
String toString() {
  return 'HeatmapPoint(hour: $hour, intensity: $intensity)';
}


}

/// @nodoc
abstract mixin class $HeatmapPointCopyWith<$Res>  {
  factory $HeatmapPointCopyWith(HeatmapPoint value, $Res Function(HeatmapPoint) _then) = _$HeatmapPointCopyWithImpl;
@useResult
$Res call({
 int hour, int intensity
});




}
/// @nodoc
class _$HeatmapPointCopyWithImpl<$Res>
    implements $HeatmapPointCopyWith<$Res> {
  _$HeatmapPointCopyWithImpl(this._self, this._then);

  final HeatmapPoint _self;
  final $Res Function(HeatmapPoint) _then;

/// Create a copy of HeatmapPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hour = null,Object? intensity = null,}) {
  return _then(_self.copyWith(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,intensity: null == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HeatmapPoint].
extension HeatmapPointPatterns on HeatmapPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeatmapPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeatmapPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeatmapPoint value)  $default,){
final _that = this;
switch (_that) {
case _HeatmapPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeatmapPoint value)?  $default,){
final _that = this;
switch (_that) {
case _HeatmapPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hour,  int intensity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeatmapPoint() when $default != null:
return $default(_that.hour,_that.intensity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hour,  int intensity)  $default,) {final _that = this;
switch (_that) {
case _HeatmapPoint():
return $default(_that.hour,_that.intensity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hour,  int intensity)?  $default,) {final _that = this;
switch (_that) {
case _HeatmapPoint() when $default != null:
return $default(_that.hour,_that.intensity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HeatmapPoint implements HeatmapPoint {
  const _HeatmapPoint({required this.hour, required this.intensity});
  factory _HeatmapPoint.fromJson(Map<String, dynamic> json) => _$HeatmapPointFromJson(json);

@override final  int hour;
@override final  int intensity;

/// Create a copy of HeatmapPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeatmapPointCopyWith<_HeatmapPoint> get copyWith => __$HeatmapPointCopyWithImpl<_HeatmapPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HeatmapPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeatmapPoint&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.intensity, intensity) || other.intensity == intensity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,intensity);

@override
String toString() {
  return 'HeatmapPoint(hour: $hour, intensity: $intensity)';
}


}

/// @nodoc
abstract mixin class _$HeatmapPointCopyWith<$Res> implements $HeatmapPointCopyWith<$Res> {
  factory _$HeatmapPointCopyWith(_HeatmapPoint value, $Res Function(_HeatmapPoint) _then) = __$HeatmapPointCopyWithImpl;
@override @useResult
$Res call({
 int hour, int intensity
});




}
/// @nodoc
class __$HeatmapPointCopyWithImpl<$Res>
    implements _$HeatmapPointCopyWith<$Res> {
  __$HeatmapPointCopyWithImpl(this._self, this._then);

  final _HeatmapPoint _self;
  final $Res Function(_HeatmapPoint) _then;

/// Create a copy of HeatmapPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hour = null,Object? intensity = null,}) {
  return _then(_HeatmapPoint(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,intensity: null == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PaymentMethodSummary {

 String get method; int get totalMinor;
/// Create a copy of PaymentMethodSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentMethodSummaryCopyWith<PaymentMethodSummary> get copyWith => _$PaymentMethodSummaryCopyWithImpl<PaymentMethodSummary>(this as PaymentMethodSummary, _$identity);

  /// Serializes this PaymentMethodSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentMethodSummary&&(identical(other.method, method) || other.method == method)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,totalMinor);

@override
String toString() {
  return 'PaymentMethodSummary(method: $method, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class $PaymentMethodSummaryCopyWith<$Res>  {
  factory $PaymentMethodSummaryCopyWith(PaymentMethodSummary value, $Res Function(PaymentMethodSummary) _then) = _$PaymentMethodSummaryCopyWithImpl;
@useResult
$Res call({
 String method, int totalMinor
});




}
/// @nodoc
class _$PaymentMethodSummaryCopyWithImpl<$Res>
    implements $PaymentMethodSummaryCopyWith<$Res> {
  _$PaymentMethodSummaryCopyWithImpl(this._self, this._then);

  final PaymentMethodSummary _self;
  final $Res Function(PaymentMethodSummary) _then;

/// Create a copy of PaymentMethodSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? totalMinor = null,}) {
  return _then(_self.copyWith(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentMethodSummary].
extension PaymentMethodSummaryPatterns on PaymentMethodSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentMethodSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentMethodSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentMethodSummary value)  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentMethodSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String method,  int totalMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentMethodSummary() when $default != null:
return $default(_that.method,_that.totalMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String method,  int totalMinor)  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodSummary():
return $default(_that.method,_that.totalMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String method,  int totalMinor)?  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodSummary() when $default != null:
return $default(_that.method,_that.totalMinor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentMethodSummary implements PaymentMethodSummary {
  const _PaymentMethodSummary({required this.method, required this.totalMinor});
  factory _PaymentMethodSummary.fromJson(Map<String, dynamic> json) => _$PaymentMethodSummaryFromJson(json);

@override final  String method;
@override final  int totalMinor;

/// Create a copy of PaymentMethodSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentMethodSummaryCopyWith<_PaymentMethodSummary> get copyWith => __$PaymentMethodSummaryCopyWithImpl<_PaymentMethodSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentMethodSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentMethodSummary&&(identical(other.method, method) || other.method == method)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,totalMinor);

@override
String toString() {
  return 'PaymentMethodSummary(method: $method, totalMinor: $totalMinor)';
}


}

/// @nodoc
abstract mixin class _$PaymentMethodSummaryCopyWith<$Res> implements $PaymentMethodSummaryCopyWith<$Res> {
  factory _$PaymentMethodSummaryCopyWith(_PaymentMethodSummary value, $Res Function(_PaymentMethodSummary) _then) = __$PaymentMethodSummaryCopyWithImpl;
@override @useResult
$Res call({
 String method, int totalMinor
});




}
/// @nodoc
class __$PaymentMethodSummaryCopyWithImpl<$Res>
    implements _$PaymentMethodSummaryCopyWith<$Res> {
  __$PaymentMethodSummaryCopyWithImpl(this._self, this._then);

  final _PaymentMethodSummary _self;
  final $Res Function(_PaymentMethodSummary) _then;

/// Create a copy of PaymentMethodSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? totalMinor = null,}) {
  return _then(_PaymentMethodSummary(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$KpiMetrics {

 int get averageOrderValueMinor; int get totalSessions; int get totalRevenueMinor; List<PaymentMethodSummary> get paymentMethods;
/// Create a copy of KpiMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$KpiMetricsCopyWith<KpiMetrics> get copyWith => _$KpiMetricsCopyWithImpl<KpiMetrics>(this as KpiMetrics, _$identity);

  /// Serializes this KpiMetrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KpiMetrics&&(identical(other.averageOrderValueMinor, averageOrderValueMinor) || other.averageOrderValueMinor == averageOrderValueMinor)&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.totalRevenueMinor, totalRevenueMinor) || other.totalRevenueMinor == totalRevenueMinor)&&const DeepCollectionEquality().equals(other.paymentMethods, paymentMethods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,averageOrderValueMinor,totalSessions,totalRevenueMinor,const DeepCollectionEquality().hash(paymentMethods));

@override
String toString() {
  return 'KpiMetrics(averageOrderValueMinor: $averageOrderValueMinor, totalSessions: $totalSessions, totalRevenueMinor: $totalRevenueMinor, paymentMethods: $paymentMethods)';
}


}

/// @nodoc
abstract mixin class $KpiMetricsCopyWith<$Res>  {
  factory $KpiMetricsCopyWith(KpiMetrics value, $Res Function(KpiMetrics) _then) = _$KpiMetricsCopyWithImpl;
@useResult
$Res call({
 int averageOrderValueMinor, int totalSessions, int totalRevenueMinor, List<PaymentMethodSummary> paymentMethods
});




}
/// @nodoc
class _$KpiMetricsCopyWithImpl<$Res>
    implements $KpiMetricsCopyWith<$Res> {
  _$KpiMetricsCopyWithImpl(this._self, this._then);

  final KpiMetrics _self;
  final $Res Function(KpiMetrics) _then;

/// Create a copy of KpiMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? averageOrderValueMinor = null,Object? totalSessions = null,Object? totalRevenueMinor = null,Object? paymentMethods = null,}) {
  return _then(_self.copyWith(
averageOrderValueMinor: null == averageOrderValueMinor ? _self.averageOrderValueMinor : averageOrderValueMinor // ignore: cast_nullable_to_non_nullable
as int,totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,totalRevenueMinor: null == totalRevenueMinor ? _self.totalRevenueMinor : totalRevenueMinor // ignore: cast_nullable_to_non_nullable
as int,paymentMethods: null == paymentMethods ? _self.paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<PaymentMethodSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [KpiMetrics].
extension KpiMetricsPatterns on KpiMetrics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _KpiMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _KpiMetrics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _KpiMetrics value)  $default,){
final _that = this;
switch (_that) {
case _KpiMetrics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _KpiMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _KpiMetrics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int averageOrderValueMinor,  int totalSessions,  int totalRevenueMinor,  List<PaymentMethodSummary> paymentMethods)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _KpiMetrics() when $default != null:
return $default(_that.averageOrderValueMinor,_that.totalSessions,_that.totalRevenueMinor,_that.paymentMethods);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int averageOrderValueMinor,  int totalSessions,  int totalRevenueMinor,  List<PaymentMethodSummary> paymentMethods)  $default,) {final _that = this;
switch (_that) {
case _KpiMetrics():
return $default(_that.averageOrderValueMinor,_that.totalSessions,_that.totalRevenueMinor,_that.paymentMethods);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int averageOrderValueMinor,  int totalSessions,  int totalRevenueMinor,  List<PaymentMethodSummary> paymentMethods)?  $default,) {final _that = this;
switch (_that) {
case _KpiMetrics() when $default != null:
return $default(_that.averageOrderValueMinor,_that.totalSessions,_that.totalRevenueMinor,_that.paymentMethods);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _KpiMetrics implements KpiMetrics {
  const _KpiMetrics({required this.averageOrderValueMinor, required this.totalSessions, required this.totalRevenueMinor, final  List<PaymentMethodSummary> paymentMethods = const []}): _paymentMethods = paymentMethods;
  factory _KpiMetrics.fromJson(Map<String, dynamic> json) => _$KpiMetricsFromJson(json);

@override final  int averageOrderValueMinor;
@override final  int totalSessions;
@override final  int totalRevenueMinor;
 final  List<PaymentMethodSummary> _paymentMethods;
@override@JsonKey() List<PaymentMethodSummary> get paymentMethods {
  if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paymentMethods);
}


/// Create a copy of KpiMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KpiMetricsCopyWith<_KpiMetrics> get copyWith => __$KpiMetricsCopyWithImpl<_KpiMetrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$KpiMetricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KpiMetrics&&(identical(other.averageOrderValueMinor, averageOrderValueMinor) || other.averageOrderValueMinor == averageOrderValueMinor)&&(identical(other.totalSessions, totalSessions) || other.totalSessions == totalSessions)&&(identical(other.totalRevenueMinor, totalRevenueMinor) || other.totalRevenueMinor == totalRevenueMinor)&&const DeepCollectionEquality().equals(other._paymentMethods, _paymentMethods));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,averageOrderValueMinor,totalSessions,totalRevenueMinor,const DeepCollectionEquality().hash(_paymentMethods));

@override
String toString() {
  return 'KpiMetrics(averageOrderValueMinor: $averageOrderValueMinor, totalSessions: $totalSessions, totalRevenueMinor: $totalRevenueMinor, paymentMethods: $paymentMethods)';
}


}

/// @nodoc
abstract mixin class _$KpiMetricsCopyWith<$Res> implements $KpiMetricsCopyWith<$Res> {
  factory _$KpiMetricsCopyWith(_KpiMetrics value, $Res Function(_KpiMetrics) _then) = __$KpiMetricsCopyWithImpl;
@override @useResult
$Res call({
 int averageOrderValueMinor, int totalSessions, int totalRevenueMinor, List<PaymentMethodSummary> paymentMethods
});




}
/// @nodoc
class __$KpiMetricsCopyWithImpl<$Res>
    implements _$KpiMetricsCopyWith<$Res> {
  __$KpiMetricsCopyWithImpl(this._self, this._then);

  final _KpiMetrics _self;
  final $Res Function(_KpiMetrics) _then;

/// Create a copy of KpiMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? averageOrderValueMinor = null,Object? totalSessions = null,Object? totalRevenueMinor = null,Object? paymentMethods = null,}) {
  return _then(_KpiMetrics(
averageOrderValueMinor: null == averageOrderValueMinor ? _self.averageOrderValueMinor : averageOrderValueMinor // ignore: cast_nullable_to_non_nullable
as int,totalSessions: null == totalSessions ? _self.totalSessions : totalSessions // ignore: cast_nullable_to_non_nullable
as int,totalRevenueMinor: null == totalRevenueMinor ? _self.totalRevenueMinor : totalRevenueMinor // ignore: cast_nullable_to_non_nullable
as int,paymentMethods: null == paymentMethods ? _self._paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<PaymentMethodSummary>,
  ));
}


}

// dart format on
