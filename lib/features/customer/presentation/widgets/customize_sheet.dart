import 'package:flutter/material.dart';

import '../../../../application/menu/menu_item_detail_view.dart';
import '../../../../application/validators/customization_validator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../domain/entities/customization_group.dart';
import '../../../../domain/enums/domain_enums.dart';

/// Menu item customization bottom sheet (add or edit cart line).
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

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            for (final group in groups) ...[
              Text('${group.name}${group.isRequired ? ' *' : ''}'),
              const SizedBox(height: AppSpacing.xs),
              ..._buildGroupOptions(group, detail.optionsByGroupId[group.id]),
              const SizedBox(height: AppSpacing.sm),
            ],
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Ghi chú',
                hintText: 'Ít muối, không hành…',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: widget.isSubmitting
                  ? null
                  : () => widget.onSubmit(_buildSelectionsJson()),
              child: widget.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.submitLabel),
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
    return options.map((opt) {
      final selected = _selections[group.key]?.contains(opt.key) ?? false;
      if (group.selectionType == CustomizationSelectionType.singleSelect ||
          group.selectionType == CustomizationSelectionType.boolean) {
        return RadioListTile<String>(
          title: Text(opt.name as String),
          value: opt.key as String,
          groupValue: _selections[group.key]?.isNotEmpty == true
              ? _selections[group.key]!.first
              : null,
          onChanged: widget.isSubmitting
              ? null
              : (value) {
                  setState(() => _selections[group.key] = [value!]);
                },
        );
      }
      return CheckboxListTile(
        title: Text(opt.name as String),
        value: selected,
        onChanged: widget.isSubmitting
            ? null
            : (value) {
                setState(() {
                  final list = List<String>.from(_selections[group.key] ?? []);
                  if (value == true) {
                    list.add(opt.key as String);
                  } else {
                    list.remove(opt.key);
                  }
                  _selections[group.key] = list;
                });
              },
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
