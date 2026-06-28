import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/test_data.dart';
import '../data/test_feed_data.dart';
import '../state/profile_store.dart';
import '../theme/text_styles.dart';
import '../widgets/feed_card.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_stat.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;
  final isCurrentUser = profile.id == loggedIn_user_id;

  const ProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userByIdProvider(userId));

    if (profile == null) {
      return const Scaffold(
        body: Center(
          child: Text('Profile not found'),
        ),
      );
    }
    final hasPronouns =
        profile.pronouns != null && profile.pronouns!.trim().isNotEmpty;

    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '@${profile.username}',
          style: Theme.of(context).textTheme.quicksandHeading.copyWith(
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Edit profile',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EditProfileScreen(),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              // Open settings later
            },
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        children: [
          // Profile identity
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileAvatar(
                imagePath: profile.profileImagePath,
                radius: 46,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            profile.displayName,
                            style: Theme.of(context).textTheme.quicksandHeading.copyWith(
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '✦',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    if (hasPronouns) ...[
                      const SizedBox(height: 2),
                      Text(
                        profile.pronouns!,
                        style: Theme.of(context).textTheme.quicksandBody.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.58),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '${sampleMemories.length} glimmers snapped',
                      style: Theme.of(context).textTheme.quicksandSmall.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Bio
          if (profile.bio?.trim().isNotEmpty == true)
            Text(
              profile.bio!.trim(),
              style: text.quicksandBody.copyWith(
                height: 1.35,
              ),
            ),

          const SizedBox(height: 20),

          // Social statistics
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
              ProfileStat(
                value: profile.cornerIds.length.toString(),
                label: 'corners',
              ),
            ],
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              Text(
                'favorite glimmers',
                style: Theme.of(context).textTheme.quicksandHeading.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('see all'),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ...favoritePosts.map(
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