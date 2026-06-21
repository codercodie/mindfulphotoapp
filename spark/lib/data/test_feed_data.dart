import '../models/post.dart';
import '../models/reaction.dart';

final List<Post> testFeedPosts = [
  Post(
    id: 'post_001',
    displayName: 'Codie',
    username: '@codie',
    prompt: 'Something small that made your day better.',
    caption: 'The light hit my coffee perfectly this morning.',
    imagePath: null,
    profileImagePath: null,
    createdAt: DateTime(2026, 6, 18),
    reactions: {
      Reaction.smile: 12,
      Reaction.sparkle: 5,
      Reaction.zen: 3,
    },
  ),
  Post(
    id: 'post_002',
    displayName: 'morgan',
    username: '@mosswatcher',
    prompt: 'a quiet moment worth remembering.',
    caption: 'rain on the window while the room stayed warm.',
    imagePath: null,
    profileImagePath: null,
    createdAt: DateTime(2026, 6, 17),
    reactions: {
      Reaction.reflective: 8,
      Reaction.hugs: 2,
      Reaction.zen: 10,
    },
  ),
  Post(
    id: 'post_003',
    displayName: 'ash',
    username: '@smalljoys',
    prompt: 'a colour that caught your eye.',
    caption: 'this tiny yellow flower growing through the pavement.',
    imagePath: null,
    profileImagePath: null,
    createdAt: DateTime(2026, 6, 16),
    reactions: {
      Reaction.wow: 4,
      Reaction.sparkle: 9,
      Reaction.smile: 6,
    },
  ),
];