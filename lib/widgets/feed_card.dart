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

  void _showReactionLimitBar(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();

    messenger.showSnackBar(
      const SnackBar(
        content: Text('you can select up to five reactions.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  const FeedCard({super.key, required this.post, this.onAuthorTap});

  Future<void> _showReactionPicker(BuildContext context, WidgetRef ref) async {
    final selectedReactions = Set<Reaction>.from(post.currentUserReactions);

    bool isLimitDialogOpen = false;

    void saveSelections() {
      ref
          .read(postStoreProvider.notifier)
          .setUserReactions(post.id, Set<Reaction>.from(selectedReactions));
    }

    final result = await showModalBottomSheet<Set<Reaction>>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final text = Theme.of(context).textTheme;
            final colors = Theme.of(context).colorScheme;

            return SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.9,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'choose reactions',
                                  style: text.quicksandHeading.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                '${selectedReactions.length}/5',
                                style: text.quicksandSmall.copyWith(
                                  color: colors.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'select up to five reactions.',
                            style: text.quicksandSmall.copyWith(
                              color: colors.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: Reaction.values.map((reaction) {
                              final isSelected = selectedReactions.contains(
                                reaction,
                              );

                              return InkWell(
                                onTap: () async {
                                  if (isSelected) {
                                    setSheetState(() {
                                      selectedReactions.remove(reaction);
                                    });

                                    saveSelections();
                                    return;
                                  }

                                  if (selectedReactions.length >= 5) {
                                    if (isLimitDialogOpen) {
                                      return;
                                    }

                                    isLimitDialogOpen = true;

                                    await showDialog<void>(
                                      context: sheetContext,
                                      builder: (dialogContext) {
                                        return AlertDialog(
                                          title: const Text('reaction limit'),
                                          content: const Text(
                                            'you can select up to five reactions. '
                                            'remove one before choosing another.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
                                              },
                                              child: const Text('got it'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    isLimitDialogOpen = false;
                                    return;
                                  }

                                  setSheetState(() {
                                    selectedReactions.add(reaction);
                                  });

                                  saveSelections();
                                },
                                borderRadius: BorderRadius.circular(18),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 92,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? colors.primary.withValues(alpha: 0.16)
                                        : colors.surface,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: isSelected
                                          ? colors.primary
                                          : colors.onSurface.withValues(
                                              alpha: 0.12,
                                            ),
                                    ),
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
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                  ),

                  // Fixed action row above Android navigation
                  SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        border: Border(
                          top: BorderSide(
                            color: colors.onSurface.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: selectedReactions.isEmpty
                                ? null
                                : () {
                                    setSheetState(() {
                                      selectedReactions.clear();
                                    });

                                    saveSelections();
                                  },
                            child: const Text('clear'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(sheetContext).pop();
                            },
                            child: const Text('done'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result == null) {
      return;
    }

    ref.read(postStoreProvider.notifier).setUserReactions(post.id, result);
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
              child: Text(
                post.prompt,
                style: text.prompt.copyWith(fontSize: 14, height: 1.15),
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
                        isSelected: post.currentUserReactions.contains(
                          entry.key,
                        ),
                        onTap: () {
                          final selectedReactions = Set<Reaction>.from(
                            post.currentUserReactions,
                          );

                          if (selectedReactions.contains(entry.key)) {
                            selectedReactions.remove(entry.key);
                          } else {
                            if (selectedReactions.length >= 5) {
                              _showReactionLimitBar(context);
                              return;
                            }

                            selectedReactions.add(entry.key);
                          }

                          ref
                              .read(postStoreProvider.notifier)
                              .setUserReactions(post.id, selectedReactions);
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: post.currentUserReactions.isEmpty
                      ? 'add reactions'
                      : 'change reactions',
                  onPressed: () {
                    _showReactionPicker(context, ref);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 42,
                    minHeight: 42,
                  ),
                  icon: Icon(
                    post.currentUserReactions.isEmpty
                        ? Icons.add_reaction_outlined
                        : Icons.add_reaction,
                    color: post.currentUserReactions.isEmpty
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
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
