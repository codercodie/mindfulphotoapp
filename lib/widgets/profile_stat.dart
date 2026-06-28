import 'package:flutter/material.dart';
import '../theme/text_styles.dart';

class ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback? onTap;

  const ProfileStat({
    super.key,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: text.quicksandHeading.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: text.quicksandSmall.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.58),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
