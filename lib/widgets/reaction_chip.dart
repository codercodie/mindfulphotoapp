import 'package:flutter/material.dart';
import '../models/reaction.dart';

class ReactionChip extends StatelessWidget {
  final Reaction reaction;
  final int count;

  const ReactionChip({
    super.key,
    required this.reaction,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colors.onSurface.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        '${reaction.emoji} $count',
        style: TextStyle(
          color: colors.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          fontFamily: 'Dustismo',
        ),
      ),
    );
  }
}