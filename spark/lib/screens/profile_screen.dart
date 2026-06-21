import 'package:flutter/material.dart';
import '../data/test_feed_data.dart';
import '../theme/text_styles.dart';
import '../widgets/feed_card.dart';
import '../widgets/profile_stat.dart';
import '../data/test_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final favoritePosts = testFeedPosts.take(2).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 52,
              color: colors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: colors.onSecondary),
                  const Spacer(),
                  Text(
                    '@codie',
                    style: text.bodyMedium?.copyWith(
                      color: colors.onSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 90),
                child: Column(
                  children: [
                    Text('codie ✦', style: text.heading),
                    Text(
                      '(they/them)',
                      style: text.body.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 58,
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        Icons.account_circle_outlined,
                        size: 125,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${sampleMemories.length} glimmers snapped',
                      style: text.heading.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'bio here im a dev\nhehehehehe',
                      textAlign: TextAlign.center,
                      style: text.body.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        ProfileStat(value: '193', label: 'friends'),
                        ProfileStat(value: '227', label: 'following'),
                        ProfileStat(value: '472', label: 'followers'),
                        ProfileStat(value: '12', label: 'clusters'),
                      ],
                    ),
                    const SizedBox(height: 36),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'favorite glimmers',
                        style: text.heading.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...favoritePosts.map((post) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: FeedCard(post: post),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}