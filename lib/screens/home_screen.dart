import 'package:flutter/material.dart';
import '../data/test_feed_data.dart';
import '../theme/text_styles.dart';
import '../widgets/feed_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('from your sphere', style: text.quicksandTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          const SizedBox(height: 6),
          const SizedBox(height: 20),

          ...testFeedPosts.map((post) {
            return FeedCard(post: post);
          }),
        ],
      ),
    );
  }
}