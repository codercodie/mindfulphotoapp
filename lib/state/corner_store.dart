import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/test_corner_data.dart';
import '../models/corner.dart';

final cornerStoreProvider =
    NotifierProvider<CornerStore, List<Corner>>(CornerStore.new);

class CornerStore extends Notifier<List<Corner>> {
  @override
  List<Corner> build() {
    return [...testCorners];
  }

  void joinCorner(String cornerId) {
    state = [
      for (final corner in state)
        if (corner.id == cornerId)
          corner.copyWith(isJoined: true)
        else
          corner,
    ];
  }

  void leaveCorner(String cornerId) {
    state = [
      for (final corner in state)
        if (corner.id == cornerId)
          corner.copyWith(isJoined: false)
        else
          corner,
    ];
  }
}