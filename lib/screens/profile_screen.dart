import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/post_store.dart';
import '../state/profile_store.dart';
import '../state/user_directory.dart';
import '../theme/text_styles.dart';
import '../widgets/feed_card.dart';
import '../widgets/interest_list.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_stat.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final currentUser = ref.watch(profileStoreProvider);
    final targetUserId = userId ?? currentUser.id;
    final profile = ref.watch(userByIdProvider(targetUserId));

    if (profile == null) {
      return const Scaffold(body: Center(child: Text('profile not found')));
    }

    final isCurrentUser = profile.id == currentUser.id;
    final profilePosts = ref.watch(postsByUserProvider(profile.id));

    final hasPronouns =
        profile.pronouns != null && profile.pronouns!.trim().isNotEmpty;
    final hasBio = profile.bio!.trim().isNotEmpty;

    final glimmerCount = profilePosts.length;
    final glimmerLabel = glimmerCount == 1 ? 'glimmer' : 'glimmers';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: userId != null,
        titleSpacing: 20,
        title: Text(
          '@${profile.username}',
          style: text.quicksandHeading.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (isCurrentUser) ...[
            IconButton(
              tooltip: 'edit profile',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'settings',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
              icon: const Icon(Icons.settings_outlined),
            ),
          ] else
            IconButton(
              tooltip: 'follow',
              onPressed: () {
                // Add follow/unfollow behaviour later.
              },
              icon: const Icon(Icons.person_add_outlined),
            ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileAvatar(imagePath: profile.profileImagePath, radius: 46),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            profile.displayName,
                            overflow: TextOverflow.ellipsis,
                            style: text.quicksandHeading.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text('✦', style: TextStyle(fontSize: 19)),
                      ],
                    ),
                    if (hasPronouns) ...[
                      const SizedBox(height: 3),
                      Text(
                        profile.pronouns!,
                        style: text.quicksandSmall.copyWith(
                          fontSize: 16,
                          color: colors.onSurface.withValues(alpha: 0.68),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      '$glimmerCount $glimmerLabel',
                      style: text.quicksandSmall.copyWith(
                        fontSize: 14,
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasBio) ...[
            const SizedBox(height: 20),
            Text(
              profile.bio!.trim(),
              style: text.quicksandBody.copyWith(fontSize: 14, height: 1.35),
            ),
          ],
          if (profile.interestIds.isNotEmpty) ...[
            const SizedBox(height: 5),
            InterestList(
              interestIds: profile.interestIds,
              maxItems: 10,
              alignment: WrapAlignment.spaceEvenly,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: profile.interestIds.length > 10
                        ? TextButton(
                            onPressed: () {
                              _showAllInterests(
                                context,
                                profile.displayName,
                                profile.interestIds,
                              );
                            },
                            child: const Text('see all 👀'),
                          )
                        : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              ProfileStat(
                value: profile.friendIds.length.toString(),
                label: 'friends',
              ),
              ProfileStat(
                value: profile.followingIds.length.toString(),
                label: 'following',
              ),
              ProfileStat(
                value: profile.followerIds.length.toString(),
                label: 'followers',
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (profilePosts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Text(
                  'no posts yet 🥺',
                  textAlign: TextAlign.center,
                  style: text.quicksandBody.copyWith(
                    fontSize: 15,
                    color: colors.onSurface.withValues(alpha: 0.68),
                  ),
                ),
              ),
            )
          else
            ...profilePosts.map(
              (post) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: FeedCard(post: post),
              ),
            ),
        ],
      ),
    );
  }

  void _showAllInterests(
    BuildContext context,
    String displayName,
    List<String> interestIds,
  ) {
    final text = Theme.of(context).textTheme;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.7,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '$displayName’s interests',
                    textAlign: TextAlign.center,
                    style: text.quicksandHeading.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  InterestList(
                    interestIds: interestIds,
                    alignment: WrapAlignment.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
