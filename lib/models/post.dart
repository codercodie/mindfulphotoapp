import 'reaction.dart';

class Post {
  final String id;
  final String displayName;
  final String username;
  final String? profileImagePath;
  final String prompt;
  final String caption;
  final String? imagePath;
  final DateTime createdAt;
  final Map<Reaction, int> reactions;

  const Post({
    required this.id,
    required this.displayName,
    required this.username,
    this.profileImagePath,
    required this.prompt,
    required this.caption,
    this.imagePath,
    required this.createdAt,
    required this.reactions,
  });
}