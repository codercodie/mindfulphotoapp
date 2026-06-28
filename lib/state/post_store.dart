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

  void reactToPost(String postId, Reaction reaction) {
    state = [
      for (final post in state)
        if (post.id == postId) _updateReaction(post, reaction) else post,
    ];
  }

  Post _updateReaction(Post post, Reaction selectedReaction) {
    final updatedReactions = Map<Reaction, int>.from(post.reactions);

    final previousReaction = post.currentUserReaction;

    // Selecting the same reaction removes it.
    if (previousReaction == selectedReaction) {
      _decreaseReactionCount(updatedReactions, selectedReaction);

      return post.copyWith(
        reactions: updatedReactions,
        currentUserReaction: null,
      );
    }

    // Remove the user's previous reaction first.
    if (previousReaction != null) {
      _decreaseReactionCount(updatedReactions, previousReaction);
    }

    // Add their newly selected reaction.
    updatedReactions[selectedReaction] =
        (updatedReactions[selectedReaction] ?? 0) + 1;

    return post.copyWith(
      reactions: updatedReactions,
      currentUserReaction: selectedReaction,
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
