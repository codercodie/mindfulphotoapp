import 'package:flutter/material.dart';
import '../theme/text_styles.dart';

class ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStat({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: text.heading.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: text.small.copyWith(
              color: colors.onSurface.withValues(alpha: 0.62),
            ),
          ),
        ],
      ),
    );
  }
}