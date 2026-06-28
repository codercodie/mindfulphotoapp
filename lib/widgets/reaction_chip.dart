import 'package:flutter/material.dart';

import '../models/reaction.dart';

class ReactionChip extends StatelessWidget {
  final Reaction reaction;
  final int count;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showCount;

  const ReactionChip({
    super.key,
    required this.reaction,
    required this.count,
    this.isSelected = false,
    this.onTap,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.18)
              : colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.onSurface.withValues(alpha: 0.15),
          ),
        ),
        child: Text(
          showCount ? '${reaction.emoji} $count' : reaction.emoji,
          style: TextStyle(
            color: isSelected ? colors.primary : colors.onSurface,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
