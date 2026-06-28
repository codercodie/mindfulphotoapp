const Object _notProvided = Object();

class UserProfile {
  final String id;
  final String username;
  final String displayName;
  final String? pronouns;
  final String? bio;
  final String profileImagePath;

  final List<String> cornerIds;
  final List<String> friendIds;
  final List<String> followerIds;
  final List<String> followingIds;

  final String enabledThemePackId;
  final List<String> unlockedThemePackIds;

  final List<String> enabledPromptPackIds;
  final List<String> unlockedPromptPackIds;

  const UserProfile({
    required this.id,
    required this.username,
    required this.displayName,
    this.pronouns,
    this.bio,
    required this.profileImagePath,
    required this.cornerIds,
    required this.friendIds,
    required this.followerIds,
    required this.followingIds,
    required this.enabledThemePackId,
    required this.unlockedThemePackIds,
    required this.enabledPromptPackIds,
    required this.unlockedPromptPackIds,
  });

  UserProfile copyWith({
    String? username,
    String? displayName,
    Object? pronouns = _notProvided,
    Object? bio = _notProvided,
    String? profileImagePath,
    List<String>? cornerIds,
    List<String>? friendIds,
    List<String>? followerIds,
    List<String>? followingIds,
    String? enabledThemePackId,
    List<String>? unlockedThemePackIds,
    List<String>? enabledPromptPackIds,
    List<String>? unlockedPromptPackIds,
  }) {
    return UserProfile(
      id: id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,

      pronouns: identical(pronouns, _notProvided)
          ? this.pronouns
          : pronouns as String?,

      bio: identical(bio, _notProvided) ? this.bio : bio as String?,

      cornerIds: cornerIds ?? this.cornerIds,
      friendIds: friendIds ?? this.friendIds,
      followerIds: followerIds ?? this.followerIds,
      followingIds: followingIds ?? this.followingIds,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      enabledThemePackId: enabledThemePackId ?? this.enabledThemePackId,
      unlockedThemePackIds: unlockedThemePackIds ?? this.unlockedThemePackIds,
      enabledPromptPackIds: enabledPromptPackIds ?? this.enabledPromptPackIds,
      unlockedPromptPackIds:
          unlockedPromptPackIds ?? this.unlockedPromptPackIds,
    );
  }
}
