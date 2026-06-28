import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../state/user_directory.dart';
import '../theme/text_styles.dart';
import 'profile_avatar.dart';
import 'reaction_chip.dart';

class FeedCard extends ConsumerWidget {
  final Post post;

  const FeedCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final author = ref.watch(userByIdProvider(post.authorId));

    if (author == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User information
            Row(
              children: [
                ProfileAvatar(
                  imagePath: author.profileImagePath,
                  radius: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author.displayName,
                        style: text.body.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '@${author.username}',
                        style: text.small.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
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
                  Text(
                    'Prompt',
                    style: text.small.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post.prompt,
                    style: text.prompt,
                  ),
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
                border: Border.all(
                  color: colors.onSurface.withValues(alpha: 0.16),
                ),
              ),
              child: Icon(
                Icons.photo_camera_outlined,
                size: 48,
                color: colors.onSurface.withValues(alpha: 0.55),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              post.caption,
              style: text.body,
            ),

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
              children: post.reactions.map((entry) {
                return ReactionChip(
                  reaction: entry.emoji,
                  count: entry.count,
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}