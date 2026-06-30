import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/test_feed_data.dart';
import '../models/post.dart';
import '../models/reaction.dart';

final postStoreProvider = NotifierProvider<PostStore, List<Post>>(
  PostStore.new,
);

final postsByUserProvider = Provider.family<List<Post>, String>((ref, userId) {
  final posts = ref.watch(postStoreProvider);

  return posts.where((post) => post.authorId == userId).toList();
});

class PostStore extends Notifier<List<Post>> {
  @override
  List<Post> build() {
    return [...testFeedPosts];
  }

  void addPost(Post post) {
    state = [post, ...state];
  }

  void setUserReactions(String postId, Set<Reaction> selectedReactions) {
    final limitedReactions = selectedReactions.take(5).toSet();

    state = [
      for (final post in state)
        if (post.id == postId)
          _updateUserReactions(post, limitedReactions)
        else
          post,
    ];
  }

  Post _updateUserReactions(Post post, Set<Reaction> selectedReactions) {
    final updatedCounts = Map<Reaction, int>.from(post.reactions);

    final previousReactions = post.currentUserReactions;

    final removedReactions = previousReactions.difference(selectedReactions);

    final addedReactions = selectedReactions.difference(previousReactions);

    for (final reaction in removedReactions) {
      _decreaseReactionCount(updatedCounts, reaction);
    }

    for (final reaction in addedReactions) {
      updatedCounts[reaction] = (updatedCounts[reaction] ?? 0) + 1;
    }

    return post.copyWith(
      reactions: updatedCounts,
      currentUserReactions: Set<Reaction>.unmodifiable(selectedReactions),
    );
  }

  void _decreaseReactionCount(Map<Reaction, int> reactions, Reaction reaction) {
    final updatedCount = (reactions[reaction] ?? 0) - 1;

    if (updatedCount <= 0) {
      reactions.remove(reaction);
    } else {
      reactions[reaction] = updatedCount;
    }
  }
}
