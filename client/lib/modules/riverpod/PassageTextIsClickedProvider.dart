import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClickedPassageTextNotifier extends StateNotifier<List<int>> {
  ClickedPassageTextNotifier() : super([]);

  void addNo(int no) {
    if (!state.contains(no)) {
      state = [...state, no];
    }
  }

  void removeNo(int no) {
    state = state.where((n) => n != no).toList();
  }

  void clearNo() {
    state = [];
  }
}

final clickedPassageTextProvider = StateNotifierProvider<ClickedPassageTextNotifier, List<int>>((ref) {
  return ClickedPassageTextNotifier();
});
