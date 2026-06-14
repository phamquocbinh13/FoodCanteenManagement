import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/domain_enums.dart';

part 'role.freezed.dart';
part 'role.g.dart';

/// Reference role catalog (seed data). DATA_MODEL §3.26.
@freezed
abstract class Role with _$Role {
  const factory Role({
    required String id,
    required RoleKey key,
    required String name,
    required DateTime createdAt,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}
