import 'reaction.dart';

class Post {
  final String id;
  final String authorId;
  final String prompt;
  final String caption;
  final String? imagePath;
  final DateTime createdAt;
  final List<Reaction> reactions;

  const Post({
    required this.id,
    required this.authorId,
    required this.prompt,
    required this.caption,
    this.imagePath,
    required this.createdAt,
    required this.reactions,
  });
}