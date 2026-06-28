import 'reaction.dart';

const Object _notProvided = Object();

class Post {
  final String id;
  final String authorId;
  final String prompt;
  final String caption;
  final String? imagePath;
  final DateTime createdAt;
  final Map<Reaction, int> reactions;

  final Reaction? currentUserReaction;

  const Post({
    required this.id,
    required this.authorId,
    required this.prompt,
    required this.caption,
    this.imagePath,
    required this.createdAt,
    required this.reactions,
    this.currentUserReaction,
  });

  Post copyWith({
    String? id,
    String? authorId,
    String? prompt,
    String? caption,
    Object? imagePath = _notProvided,
    DateTime? createdAt,
    Map<Reaction, int>? reactions,
    Object? currentUserReaction = _notProvided,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      prompt: prompt ?? this.prompt,
      caption: caption ?? this.caption,
      imagePath: identical(imagePath, _notProvided)
          ? this.imagePath
          : imagePath as String?,
      createdAt: createdAt ?? this.createdAt,
      reactions: reactions ?? this.reactions,
      currentUserReaction: identical(currentUserReaction, _notProvided)
          ? this.currentUserReaction
          : currentUserReaction as Reaction?,
    );
  }
}
