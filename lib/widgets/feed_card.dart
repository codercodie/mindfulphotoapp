import 'package:flutter/material.dart';
import '../models/post.dart';
import '../theme/text_styles.dart';
import 'reaction_chip.dart';

class FeedCard extends StatelessWidget {
  final Post post;

  const FeedCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User row
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: colors.secondary,
                  child: Text(
                    post.displayName[0],
                    style: TextStyle(
                      color: colors.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.displayName, style: text.body.copyWith(fontWeight: FontWeight.w700)),
                    Text(
                      post.username,
                      style: text.small.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Prompt
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prompt', style: text.small.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(post.prompt, style: text.prompt),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Image placeholder
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.secondary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: colors.onSurface.withValues(alpha: 0.16)),
              ),
              child: Icon(
                Icons.photo_camera_outlined,
                size: 48,
                color: colors.onSurface.withValues(alpha: 0.55),
              ),
            ),

            const SizedBox(height: 14),

            Text(post.caption, style: text.body),

            const SizedBox(height: 12),

            Text(
              _formatDate(post.createdAt),
              style: text.small.copyWith(
                color: colors.onSurface.withValues(alpha: 0.6),
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.reactions.entries.map((entry) {
                return ReactionChip(
                  reaction: entry.key,
                  count: entry.value,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}