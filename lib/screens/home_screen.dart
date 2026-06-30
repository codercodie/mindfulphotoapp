import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../content/interests.dart';
import '../models/post.dart';
import '../models/user_profile.dart';
import '../state/moderation_store.dart';
import '../state/post_store.dart';
import '../state/profile_store.dart';
import '../state/user_directory.dart';
import '../theme/text_styles.dart';
import '../widgets/feed_card.dart';
import '../widgets/profile_avatar.dart';
import 'interest_selection_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final currentUser = ref.watch(profileStoreProvider);
    final posts = ref.watch(postStoreProvider);
    final userDirectory = ref.watch(userDirectoryProvider);
    final moderation = ref.watch(moderationStoreProvider);

    final visiblePosts = posts.where((post) {
      return !moderation.hiddenPostIds.contains(post.id) &&
          !moderation.blockedUserIds.contains(post.authorId);
    }).toList();

    final followingPosts = visiblePosts.where((post) {
      return post.authorId == currentUser.id ||
          currentUser.followingIds.contains(post.authorId);
    }).toList();

    final suggestedUsers =
        userDirectory.values
            .where((user) => user.id != currentUser.id)
            .where((user) => !moderation.blockedUserIds.contains(user.id))
            .where((user) => _sharedInterestCount(currentUser, user) > 0)
            .toList()
          ..sort((first, second) {
            final firstShared = _sharedInterestCount(currentUser, first);
            final secondShared = _sharedInterestCount(currentUser, second);
            return secondShared.compareTo(firstShared);
          });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          scrolledUnderElevation: 0,
          bottom: TabBar(
            indicatorColor: colors.primary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: colors.onSurface.withValues(alpha: 0.08),
            labelColor: colors.onSurface,
            unselectedLabelColor: colors.onSurface.withValues(alpha: 0.58),
            labelStyle: text.quicksandSmall.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
            unselectedLabelStyle: text.quicksandSmall.copyWith(fontSize: 15),
            tabs: const [
              Tab(text: 'home'),
              Tab(text: 'discover'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _FollowingTab(posts: followingPosts),
            _DiscoverTab(currentUser: currentUser, users: suggestedUsers),
          ],
        ),
      ),
    );
  }
}

class _FollowingTab extends StatelessWidget {
  final List<Post> posts;

  const _FollowingTab({required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const _EmptyFollowingView();
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 100),
      children: posts.map((post) {
        return FeedCard(
          post: post,
          onAuthorTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProfileScreen(userId: post.authorId),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class _EmptyFollowingView extends StatelessWidget {
  const _EmptyFollowingView();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 48,
              color: colors.onSurface.withValues(alpha: 0.72),
            ),
            const SizedBox(height: 16),
            Text(
              'your home feed is quiet',
              textAlign: TextAlign.center,
              style: text.quicksandHeading.copyWith(
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'follow people from Discover to see their glimmers here.',
              textAlign: TextAlign.center,
              style: text.quicksandBody.copyWith(
                color: colors.onSurface.withValues(alpha: 0.68),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscoverTab extends StatelessWidget {
  final UserProfile currentUser;
  final List<UserProfile> users;

  const _DiscoverTab({required this.currentUser, required this.users});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    if (users.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(24, 64, 24, 100),
        children: [
          Icon(
            Icons.interests_outlined,
            size: 52,
            color: colors.onSurface.withValues(alpha: 0.78),
          ),
          const SizedBox(height: 18),
          Text(
            'no shared-interest matches yet',
            textAlign: TextAlign.center,
            style: text.quicksandHeading.copyWith(
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'add a few more interests and we’ll look for people '
            'with things in common.',
            textAlign: TextAlign.center,
            style: text.quicksandBody.copyWith(
              color: colors.onSurface.withValues(alpha: 0.68),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const InterestSelectionScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined),
              label: const Text('edit interests'),
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        Text(
          'people you may like',
          style: text.quicksandHeading.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'based on the interests you share.',
          style: text.quicksandSmall.copyWith(
            color: colors.onSurface.withValues(alpha: 0.68),
          ),
        ),
        const SizedBox(height: 16),
        ...users.map((user) {
          final sharedInterestIds = user.interestIds
              .where(currentUser.interestIds.contains)
              .toList();

          return _SuggestedUserCard(
            user: user,
            sharedInterestIds: sharedInterestIds,
          );
        }),
      ],
    );
  }
}

class _SuggestedUserCard extends StatelessWidget {
  final UserProfile user;
  final List<String> sharedInterestIds;

  const _SuggestedUserCard({
    required this.user,
    required this.sharedInterestIds,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ProfileScreen(userId: user.id)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileAvatar(imagePath: user.profileImagePath, radius: 28),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: text.quicksandBody.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '@${user.username}',
                      style: text.quicksandSmall.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.68),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: sharedInterestIds.take(3).map((interestId) {
                        final interest = interestById(interestId);

                        if (interest == null) {
                          return const SizedBox.shrink();
                        }

                        return Chip(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: colors.surface.withValues(
                            alpha: 0.85,
                          ),
                          side: BorderSide(
                            color: colors.onSurface.withValues(alpha: 0.14),
                          ),
                          label: Text('${interest.emoji} ${interest.id}'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colors.onSurface.withValues(alpha: 0.58),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

int _sharedInterestCount(UserProfile first, UserProfile second) {
  return first.interestIds.where(second.interestIds.contains).length;
}
