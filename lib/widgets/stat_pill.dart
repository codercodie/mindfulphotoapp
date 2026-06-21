import 'package:flutter/material.dart';

class StatPill extends StatelessWidget {
  final String label;

  const StatPill({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colors.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}