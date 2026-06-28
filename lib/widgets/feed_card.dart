import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../state/user_directory.dart';
import '../theme/text_styles.dart';
import 'profile_avatar.dart';
import 'reaction_chip.dart';
import 'post_image.dart';

import '../models/reaction.dart';
import '../state/post_store.dart';
import '../state/app_settings_store.dart';

class FeedCard extends ConsumerWidget {
  final Post post;
  final VoidCallback? onAuthorTap;

  const FeedCard({super.key, required this.post, this.onAuthorTap});

  Future<void> _showReactionPicker(BuildContext context, WidgetRef ref) async {
    final selectedReaction = await showModalBottomSheet<Reaction>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final text = Theme.of(context).textTheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'choose a reaction',
                  style: text.quicksandHeading.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: Reaction.values.map((reaction) {
                    final isSelected = post.currentUserReaction == reaction;

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop(reaction);
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: 74,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.15)
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            Text(
                              reaction.emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              reaction.label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedReaction == null) {
      return;
    }

    ref.read(postStoreProvider.notifier).reactToPost(post.id, selectedReaction);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final showReactionCounts = ref.watch(
      appSettingsProvider.select((settings) => settings.showReactionCounts),
    );
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
            InkWell(
              onTap: onAuthorTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
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
              ),
            ),

            const SizedBox(height: 16),

            // Prompt
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.prompt,
                    style: text.prompt.copyWith(fontSize: 14, height: 1.15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Image
            PostImage(imagePath: post.imagePath),

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

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: post.reactions.entries.map((entry) {
                      return ReactionChip(
                        reaction: entry.key,
                        count: entry.value,
                        showCount: showReactionCounts,
                        isSelected: post.currentUserReaction == entry.key,
                        onTap: () {
                          ref
                              .read(postStoreProvider.notifier)
                              .reactToPost(post.id, entry.key);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: post.currentUserReaction == null
                      ? 'Add reaction'
                      : 'Change reaction',
                  onPressed: () {
                    _showReactionPicker(context, ref);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 42,
                    minHeight: 42,
                  ),
                  icon: Icon(
                    post.currentUserReaction == null
                        ? Icons.add_reaction_outlined
                        : Icons.add_reaction,
                    color: post.currentUserReaction == null
                        ? colors.onSurface.withValues(alpha: 0.65)
                        : colors.primary,
                  ),
                ),
              ],
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
