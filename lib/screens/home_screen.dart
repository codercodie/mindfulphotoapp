import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/post_store.dart';
import '../theme/text_styles.dart';
import '../widgets/feed_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final posts = ref.watch(postStoreProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('from your sphere', style: text.quicksandTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          const SizedBox(height: 6),
          const SizedBox(height: 20),

          ...posts.map((post) {
            return FeedCard(post: post);
          }),
        ],
      ),
    );
  }
}
