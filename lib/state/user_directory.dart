import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/test_user_data.dart';
import '../models/user_profile.dart';
import 'profile_store.dart';

final userDirectoryProvider = Provider<Map<String, UserProfile>>((ref) {
  final currentUser = ref.watch(profileStoreProvider);

  return {
    ...testUsers,
    currentUser.id: currentUser,
  };
});

final userByIdProvider =
    Provider.family<UserProfile?, String>((ref, userId) {
  final users = ref.watch(userDirectoryProvider);

  return users[userId];
});