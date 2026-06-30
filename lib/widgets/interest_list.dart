import 'package:flutter/material.dart';

import '../content/interests.dart';

class InterestList extends StatelessWidget {
  final List<String> interestIds;
  final int? maxItems;
  final String emptyText;

  const InterestList({
    super.key,
    required this.interestIds,
    this.maxItems,
    this.emptyText = 'no interests selected',
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final interests = interestIds
        .map(interestById)
        .whereType<InterestOption>()
        .toList();

    if (interests.isEmpty) {
      return Text(
        emptyText,
        style: TextStyle(color: colors.onSurface.withValues(alpha: 0.55)),
      );
    }

    final visibleInterests = maxItems == null
        ? interests
        : interests.take(maxItems!).toList();

    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: visibleInterests.map((interest) {
        return Chip(
          visualDensity: VisualDensity.compact,
          avatar: Text(interest.emoji),
          label: Text(interest.id),
        );
      }).toList(),
    );
  }
}
