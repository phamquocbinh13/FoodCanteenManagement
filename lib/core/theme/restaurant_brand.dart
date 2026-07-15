import 'package:flutter/foundation.dart';

/// Tenant-facing restaurant identity. Platform UI stays restaurant-agnostic;
/// brand is applied only where guest-facing trust signals need a name.
///
/// Demo default: **The Forest** (`demo-restaurant` backend id).
@immutable
final class RestaurantBrand {
  const RestaurantBrand({
    required this.id,
    required this.displayName,
    this.tagline,
    this.shortName,
  });

  /// Backend restaurant id (e.g. `demo-restaurant`).
  final String id;

  /// Guest-facing name.
  final String displayName;

  /// Optional one-line support under the name.
  final String? tagline;

  /// Compact label for badges (defaults to [displayName]).
  final String? shortName;

  String get label => shortName ?? displayName;

  /// Demo restaurant used with Nest seed data.
  static const theForest = RestaurantBrand(
    id: 'demo-restaurant',
    displayName: 'The Forest',
    shortName: 'Forest',
    tagline: 'Calm dining. Precise service.',
  );

  /// Active brand for this build (swap later for multi-tenant).
  static RestaurantBrand current = theForest;
}
