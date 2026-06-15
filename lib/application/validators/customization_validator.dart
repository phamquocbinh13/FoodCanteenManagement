import '../../core/errors/failures.dart';
import '../../core/result/result.dart';
import '../../domain/entities/customization_group.dart';
import '../../domain/entities/customization_option.dart';
import '../../domain/enums/domain_enums.dart';

/// Validates cart customization selections against modifier groups.
final class CustomizationValidator {
  const CustomizationValidator();

  Result<Map<String, List<String>>> validate({
    required List<CustomizationGroup> groups,
    required Map<String, List<CustomizationOption>> optionsByGroupId,
    required Map<String, dynamic> selectionsJson,
  }) {
    final groupsMap = _readGroups(selectionsJson);

    for (final group in groups) {
      if (!group.isActive) continue;
      final selectedKeys = groupsMap[group.key] ?? [];
      final options = optionsByGroupId[group.id] ?? [];

      if (group.isRequired && selectedKeys.isEmpty) {
        return Err(
          ValidationFailure(
            'Required modifier: ${group.name}',
            code: 'REQUIRED_MODIFIER_MISSING',
          ),
        );
      }

      if (selectedKeys.length < group.minSelections) {
        return Err(
          ValidationFailure(
            'Select at least ${group.minSelections} for ${group.name}',
            code: 'MODIFIER_MIN_NOT_MET',
          ),
        );
      }

      if (selectedKeys.length > group.maxSelections) {
        return Err(
          ValidationFailure(
            'Select at most ${group.maxSelections} for ${group.name}',
            code: 'MODIFIER_MAX_EXCEEDED',
          ),
        );
      }

      if (group.selectionType == CustomizationSelectionType.singleSelect &&
          selectedKeys.length > 1) {
        return Err(
          ValidationFailure(
            'Only one selection allowed for ${group.name}',
            code: 'MODIFIER_SINGLE_ONLY',
          ),
        );
      }

      for (final key in selectedKeys) {
        final valid = options.any((o) => o.key == key && o.isActive);
        if (!valid) {
          return Err(
            ValidationFailure(
              'Invalid option for ${group.name}',
              code: 'INVALID_MODIFIER_OPTION',
            ),
          );
        }
      }
    }

    return Success(groupsMap);
  }

  Map<String, List<String>> _readGroups(Map<String, dynamic> selectionsJson) {
    final raw = selectionsJson['groups'];
    if (raw is! Map) return {};

    final result = <String, List<String>>{};
    for (final entry in raw.entries) {
      final value = entry.value;
      if (value is Map && value['optionKeys'] is List) {
        result[entry.key.toString()] = (value['optionKeys'] as List)
            .map((e) => e.toString())
            .toList();
      }
    }
    return result;
  }
}

String? readCartNote(Map<String, dynamic> selectionsJson) {
  final note = selectionsJson['note'];
  if (note is String && note.trim().isNotEmpty) return note.trim();
  return null;
}

Map<String, dynamic> buildSelectionsJson({
  required Map<String, List<String>> groups,
  String? note,
}) {
  final groupsJson = <String, dynamic>{};
  for (final entry in groups.entries) {
    groupsJson[entry.key] = {'optionKeys': entry.value};
  }
  return {
    'groups': groupsJson,
    if (note != null && note.isNotEmpty) 'note': note,
  };
}
