import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/theme_pack.dart';
import '../theme/themes.dart';
import 'profile_store.dart';

final activeThemePackProvider = Provider<ThemePack>((ref) {
  final profile = ref.watch(profileStoreProvider);

  return themePacks.firstWhere(
    (pack) => pack.id == profile.enabledThemePackId,
    orElse: () => peachCalmPack,
  );
});
