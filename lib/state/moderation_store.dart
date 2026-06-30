import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/report_reason.dart';

class PostReport {
  final String postId;
  final String reportedUserId;
  final ReportReason reason;
  final DateTime createdAt;

  const PostReport({
    required this.postId,
    required this.reportedUserId,
    required this.reason,
    required this.createdAt,
  });
}

class ModerationState {
  final Set<String> hiddenPostIds;
  final Set<String> blockedUserIds;
  final List<PostReport> reports;

  const ModerationState({
    this.hiddenPostIds = const {},
    this.blockedUserIds = const {},
    this.reports = const [],
  });

  ModerationState copyWith({
    Set<String>? hiddenPostIds,
    Set<String>? blockedUserIds,
    List<PostReport>? reports,
  }) {
    return ModerationState(
      hiddenPostIds: hiddenPostIds ?? this.hiddenPostIds,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      reports: reports ?? this.reports,
    );
  }
}

final moderationStoreProvider =
    NotifierProvider<ModerationStore, ModerationState>(ModerationStore.new);

class ModerationStore extends Notifier<ModerationState> {
  @override
  ModerationState build() {
    return const ModerationState();
  }

  void hidePost(String postId) {
    state = state.copyWith(hiddenPostIds: {...state.hiddenPostIds, postId});
  }

  void blockUser(String userId) {
    state = state.copyWith(blockedUserIds: {...state.blockedUserIds, userId});
  }

  void unblockUser(String userId) {
    state = state.copyWith(
      blockedUserIds: {
        for (final id in state.blockedUserIds)
          if (id != userId) id,
      },
    );
  }

  void reportPost({
    required String postId,
    required String reportedUserId,
    required ReportReason reason,
  }) {
    state = state.copyWith(
      reports: [
        ...state.reports,
        PostReport(
          postId: postId,
          reportedUserId: reportedUserId,
          reason: reason,
          createdAt: DateTime.now(),
        ),
      ],
    );
  }
}
