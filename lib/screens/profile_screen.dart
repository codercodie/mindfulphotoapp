import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/post_store.dart';
import '../state/profile_store.dart';
import '../state/user_directory.dart';
import '../theme/text_styles.dart';
import '../widgets/feed_card.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_stat.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import '../widgets/interest_list.dart';

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
      return const Scaffold(body: Center(child: Text('Profile not found')));
    }

    final isCurrentUser = profile.id == currentUser.id;

    final profilePosts = ref.watch(postsByUserProvider(profile.id));

    final hasPronouns =
        profile.pronouns != null && profile.pronouns!.trim().isNotEmpty;

    final hasBio = profile.bio != null && profile.bio!.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: userId == null,
        title: Text(
          '@${profile.username}',
          style: text.quicksandHeading.copyWith(fontSize: 20),
        ),
        actions: [
          if (isCurrentUser) ...[
            IconButton(
              tooltip: 'Edit profile',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'Settings',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
              icon: const Icon(Icons.settings_outlined),
            ),
          ] else
            IconButton(
              tooltip: 'Follow',
              onPressed: () {},
              icon: const Icon(Icons.person_add_outlined),
            ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
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
                            style: text.quicksandHeading.copyWith(
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text('✦', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    if (hasPronouns) ...[
                      const SizedBox(height: 2),
                      Text(
                        profile.pronouns!,
                        style: text.quicksandBody.copyWith(
                          color: colors.onSurface.withValues(alpha: 0.58),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '${profilePosts.length} glimmers',
                      style: text.quicksandSmall.copyWith(
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
            const SizedBox(height: 18),
            Text(
              profile.bio!.trim(),
              style: text.quicksandBody.copyWith(height: 1.35),
            ),
          ],
          if (profile.interestIds.isNotEmpty) ...[
            const SizedBox(height: 18),

            Row(
              children: [
                Text(
                  'interests',
                  style: text.quicksandHeading.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (profile.interestIds.length > 6)
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        showDragHandle: true,
                        useSafeArea: true,
                        builder: (sheetContext) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'interests',
                                  style: text.quicksandHeading.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                InterestList(interestIds: profile.interestIds),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('see all'),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            InterestList(interestIds: profile.interestIds, maxItems: 6),
          ],
          const SizedBox(height: 20),
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
              // ProfileStat(
              //   value: profile.cornerIds.length.toString(),
              //   label: 'corners',
              // ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Text(
                'glimmers',
                style: text.quicksandHeading.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          if (profilePosts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                "No glimmers yet :'(",
                style: text.quicksandBody.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.6),
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
}
