// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customization_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomizationGroup _$CustomizationGroupFromJson(Map<String, dynamic> json) =>
    _CustomizationGroup(
      id: json['id'] as String,
      menuItemId: json['menu_item_id'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      selectionType: $enumDecode(
        _$CustomizationSelectionTypeEnumMap,
        json['selection_type'],
      ),
      isRequired: json['is_required'] as bool? ?? false,
      minSelections: (json['min_selections'] as num?)?.toInt() ?? 0,
      maxSelections: (json['max_selections'] as num?)?.toInt() ?? 1,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CustomizationGroupToJson(_CustomizationGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'menu_item_id': instance.menuItemId,
      'key': instance.key,
      'name': instance.name,
      'selection_type':
          _$CustomizationSelectionTypeEnumMap[instance.selectionType]!,
      'is_required': instance.isRequired,
      'min_selections': instance.minSelections,
      'max_selections': instance.maxSelections,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$CustomizationSelectionTypeEnumMap = {
  CustomizationSelectionType.singleSelect: 'single_select',
  CustomizationSelectionType.multiSelect: 'multi_select',
  CustomizationSelectionType.boolean: 'boolean',
};
