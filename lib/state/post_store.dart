import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/test_feed_data.dart';
import '../models/post.dart';

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
}
