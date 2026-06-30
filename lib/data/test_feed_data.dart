import '../models/post.dart';
import '../models/reaction.dart';

final List<Post> testFeedPosts = [
  Post(
    id: 'post_001',
    authorId: 'user_001',
    prompt: 'Something small that made your day better.',
    caption: 'The light hit my coffee perfectly this morning.',
    imagePath: 'assets/posts/coffee.jpeg',
    createdAt: DateTime(2026, 6, 18),
    reactions: {Reaction.smile: 12, Reaction.heart: 5, Reaction.zen: 3},
  ),
  Post(
    id: 'post_002',
    authorId: 'user_002',
    prompt: 'A quiet moment worth remembering.',
    caption: 'Palm in the moment.',
    imagePath: 'assets/posts/palm.jpeg',
    createdAt: DateTime(2026, 6, 17),
    reactions: {
      Reaction.reflective: 8,
      Reaction.hugs: 2,
      Reaction.zen: 10,
      Reaction.smile: 1,
      Reaction.fire: 3,
      Reaction.awe: 6,
    },
  ),
  Post(
    id: 'post_003',
    authorId: 'user_003',
    prompt: 'A colour that caught your eye.',
    caption: 'So bright and beautiful.',
    imagePath: 'assets/posts/flower.jpeg',
    createdAt: DateTime(2026, 6, 16),
    reactions: {
      Reaction.wow: 4,
      Reaction.party: 9,
      Reaction.smile: 6,
      Reaction.beautiful: 2,
    },
  ),
];
