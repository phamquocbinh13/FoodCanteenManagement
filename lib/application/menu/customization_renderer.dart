import '../../core/clock/clock.dart';
import '../../core/id/id_generator.dart';
import '../../core/result/result.dart';
import '../../domain/entities/batch_item_customization.dart';
import '../../domain/entities/customization_group.dart';
import '../../domain/entities/customization_option.dart';
import '../../domain/value_objects/money.dart';
import '../validators/customization_validator.dart';

/// Flattens cart selections into kitchen-readable text and batch snapshots.
final class CustomizationRenderer {
  const CustomizationRenderer();

  ({Money unitPrice, String kitchenNotes, List<BatchItemCustomization> mods})
      render({
    required String batchItemId,
    required Money basePrice,
    required List<CustomizationGroup> groups,
    required Map<String, List<CustomizationOption>> optionsByGroupId,
    required Map<String, dynamic> selectionsJson,
    required IdGenerator idGenerator,
    required Clock clock,
  }) {
    final validated = const CustomizationValidator().validate(
      groups: groups,
      optionsByGroupId: optionsByGroupId,
      selectionsJson: selectionsJson,
    );

    final selected = switch (validated) {
      Success<Map<String, List<String>>>(:final value) => value,
      Err<Map<String, List<String>>>() => <String, List<String>>{},
    };

    var unitPrice = basePrice;
    final noteParts = <String>[];
    final customizations = <BatchItemCustomization>[];
    final now = clock.now();

    for (final group in groups) {
      final keys = selected[group.key] ?? [];
      final options = optionsByGroupId[group.id] ?? [];

      for (final key in keys) {
        final option = options.firstWhere((o) => o.key == key);
        unitPrice = unitPrice + option.priceDelta;
        customizations.add(
          BatchItemCustomization(
            id: idGenerator.nextId(),
            batchItemId: batchItemId,
            groupKey: group.key,
            groupNameSnapshot: group.name,
            optionKey: option.key,
            optionNameSnapshot: option.name,
            priceDeltaSnapshot: option.priceDelta,
            kitchenLabelRendered: option.kitchenLabel,
            createdAt: now,
          ),
        );
        noteParts.add(option.kitchenLabel);
      }
    }

    final freeNote = readCartNote(selectionsJson);
    if (freeNote != null) {
      customizations.add(
        BatchItemCustomization(
          id: idGenerator.nextId(),
          batchItemId: batchItemId,
          groupKey: 'note',
          groupNameSnapshot: 'Note',
          valueJson: {'text': freeNote},
          kitchenLabelRendered: freeNote,
          createdAt: now,
        ),
      );
      noteParts.add(freeNote);
    }

    return (
      unitPrice: unitPrice,
      kitchenNotes: noteParts.join(' · '),
      mods: customizations,
    );
  }
}
