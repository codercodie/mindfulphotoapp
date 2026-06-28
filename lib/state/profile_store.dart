import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

final profileStoreProvider =
    NotifierProvider<ProfileStore, UserProfile>(ProfileStore.new);

class ProfileStore extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    return const UserProfile(
      id: 'user_001',
      username: 'codie',
      displayName: 'Codie',
      pronouns: 'they/them',
      bio: 'bio here im a dev\nhehehehehe',
      profileImagePath: 'assets/defaults/default_profile_picture.jpg',
      cornerIds: ['cats', 'nature'],
      friendIds: ['user_002', 'user_003', 'user_004'],
      followerIds: ['user_002', 'user_003', 'user_004', 'user_005'],
      followingIds: ['user_002', 'user_006'],
      enabledThemePackId: 'soft_moss',
      unlockedThemePackIds: ['soft_moss', 'mist'],
      enabledPromptPackIds: ['mindful_moments'],
      unlockedPromptPackIds: ['mindful_moments', 'self_reflection'],
    );
  }
void updateProfile({
  required String username,
  required String displayName,
  required String? pronouns,
  required String bio,
  required String? profileImagePath,
}) {
  state = state.copyWith(
    username: username,
    displayName: displayName,
    pronouns: pronouns,
    bio: bio,
    profileImagePath: profileImagePath,
  );
}

  void updateProfilePicture(String? imagePath) {
    state = state.copyWith(profileImagePath: imagePath);
  }
}