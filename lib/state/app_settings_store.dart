import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppSettings {
  final bool showReactionCounts;
  final bool dailyPromptReminder;
  final bool reduceMotion;

  const AppSettings({
    this.showReactionCounts = true,
    this.dailyPromptReminder = false,
    this.reduceMotion = false,
  });

  AppSettings copyWith({
    bool? showReactionCounts,
    bool? dailyPromptReminder,
    bool? reduceMotion,
  }) {
    return AppSettings(
      showReactionCounts: showReactionCounts ?? this.showReactionCounts,
      dailyPromptReminder: dailyPromptReminder ?? this.dailyPromptReminder,
      reduceMotion: reduceMotion ?? this.reduceMotion,
    );
  }
}

final appSettingsProvider = NotifierProvider<AppSettingsStore, AppSettings>(
  AppSettingsStore.new,
);

class AppSettingsStore extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return const AppSettings();
  }

  void setShowReactionCounts(bool value) {
    state = state.copyWith(showReactionCounts: value);
  }

  void setDailyPromptReminder(bool value) {
    state = state.copyWith(dailyPromptReminder: value);
  }

  void setReduceMotion(bool value) {
    state = state.copyWith(reduceMotion: value);
  }
}
