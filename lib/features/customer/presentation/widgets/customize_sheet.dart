import 'package:flutter/material.dart';

import '../../../../application/menu/menu_item_detail_view.dart';
import '../../../../application/validators/customization_validator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../domain/entities/customization_group.dart';
import '../../../../domain/enums/domain_enums.dart';

/// Menu item customization sheet (add or edit cart line).
///
/// UX gain: required options obvious, large option rows, single sticky submit.
class CustomizeSheet extends StatefulWidget {
  const CustomizeSheet({
    super.key,
    required this.detail,
    required this.onSubmit,
    required this.submitLabel,
    this.initialSelections,
    this.isSubmitting = false,
  });

  final MenuItemDetailView detail;
  final Map<String, dynamic>? initialSelections;
  final String submitLabel;
  final bool isSubmitting;
  final Future<void> Function(Map<String, dynamic> selections) onSubmit;

  @override
  State<CustomizeSheet> createState() => _CustomizeSheetState();
}

class _CustomizeSheetState extends State<CustomizeSheet> {
  final _noteController = TextEditingController();
  final _selections = <String, List<String>>{};

  @override
  void initState() {
    super.initState();
    _initFromSelections(widget.initialSelections);
  }

  void _initFromSelections(Map<String, dynamic>? json) {
    if (json == null) return;
    final groups = json['groups'];
    if (groups is Map) {
      for (final entry in groups.entries) {
        final value = entry.value;
        if (value is Map && value['optionKeys'] is List) {
          _selections[entry.key.toString()] =
              (value['optionKeys'] as List).map((e) => e.toString()).toList();
        }
      }
    }
    final note = readCartNote(json);
    if (note != null) _noteController.text = note;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final item = detail.item;
    final groups = detail.groups;
    final theme = Theme.of(context);

    return RomsBottomSheetScaffold(
      title: item.name,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final group in groups) ...[
              Text(
                '${group.name}${group.isRequired ? ' *' : ''}',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              ..._buildGroupOptions(group, detail.optionsByGroupId[group.id]),
              const SizedBox(height: AppSpacing.md),
            ],
            RomsTextField(
              controller: _noteController,
              label: 'Kitchen note',
              hint: 'Less salt, no onion…',
              maxLines: 2,
              enabled: !widget.isSubmitting,
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: widget.submitLabel,
              isExpanded: true,
              isLoading: widget.isSubmitting,
              onPressed: widget.isSubmitting
                  ? null
                  : () => widget.onSubmit(_buildSelectionsJson()),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGroupOptions(
    CustomizationGroup group,
    List<dynamic>? options,
  ) {
    if (options == null) return [];
    final single = group.selectionType == CustomizationSelectionType.singleSelect ||
        group.selectionType == CustomizationSelectionType.boolean;

    return options.map((opt) {
      final key = opt.key as String;
      final name = opt.name as String;
      final selected = _selections[group.key]?.contains(key) ?? false;

      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Material(
          color: selected ? AppColors.brandSoft : AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            onTap: widget.isSubmitting
                ? null
                : () {
                    setState(() {
                      if (single) {
                        _selections[group.key] = [key];
                      } else {
                        final list =
                            List<String>.from(_selections[group.key] ?? []);
                        if (selected) {
                          list.remove(key);
                        } else {
                          list.add(key);
                        }
                        _selections[group.key] = list;
                      }
                    });
                  },
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(
                      single
                          ? (selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off)
                          : (selected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank),
                      color: selected ? AppColors.brand : AppColors.inkMuted,
                      size: 22,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Map<String, dynamic> _buildSelectionsJson() {
    return buildSelectionsJson(
      groups: _selections,
      note: _noteController.text,
    );
  }
}
