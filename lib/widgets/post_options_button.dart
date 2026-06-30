import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/report_reason.dart';
import '../state/moderation_store.dart';
import '../theme/text_styles.dart';

class PostOptionsButton extends ConsumerWidget {
  final String postId;
  final String authorId;
  final String authorUsername;
  final bool isOwnPost;

  const PostOptionsButton({
    super.key,
    required this.postId,
    required this.authorId,
    required this.authorUsername,
    required this.isOwnPost,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: 'post options',
      onPressed: () {
        _showPostOptions(context, ref);
      },
      icon: const Icon(Icons.more_horiz),
    );
  }

  Future<void> _showPostOptions(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isOwnPost) ...[
                  ListTile(
                    leading: const Icon(Icons.visibility_off_outlined),
                    title: const Text('hide this post'),
                    subtitle: const Text('Remove it from your feed.'),
                    onTap: () {
                      Navigator.of(sheetContext).pop();

                      ref
                          .read(moderationStoreProvider.notifier)
                          .hidePost(postId);

                      _showMessage(context, 'post hidden');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.flag_outlined),
                    title: const Text('report this post'),
                    subtitle: const Text(
                      'Tell us about a safety or policy concern.',
                    ),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _showReportReasons(context, ref);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.block_outlined),
                    title: Text('block @$authorUsername'),
                    subtitle: const Text('You will no longer see each other.'),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      _confirmBlock(context, ref);
                    },
                  ),
                ] else
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('your post'),
                    subtitle: Text(
                      'Editing and deleting your own posts can be added next.',
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showReportReasons(BuildContext context, WidgetRef ref) async {
    final reason = await showModalBottomSheet<ReportReason>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        final text = Theme.of(sheetContext).textTheme;

        return SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.78,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Text(
                    'why are you reporting this?',
                    style: text.quicksandHeading.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                    children: ReportReason.values.map((item) {
                      return ListTile(
                        title: Text(item.label),
                        subtitle: Text(item.description),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(sheetContext).pop(item);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (reason == null) {
      return;
    }

    ref
        .read(moderationStoreProvider.notifier)
        .reportPost(postId: postId, reportedUserId: authorId, reason: reason);

    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('report received'),
          content: const Text(
            'Thank you. This prototype stores the report locally. '
            'A production version will send it to the moderation service.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmBlock(BuildContext context, WidgetRef ref) async {
    final shouldBlock = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('block @$authorUsername?'),
          content: const Text(
            'Their posts and profile will be hidden from you. '
            'They will not be notified.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('block'),
            ),
          ],
        );
      },
    );

    if (shouldBlock != true) {
      return;
    }

    ref.read(moderationStoreProvider.notifier).blockUser(authorId);

    if (context.mounted) {
      _showMessage(context, '@$authorUsername blocked');
    }
  }

  void _showMessage(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}
