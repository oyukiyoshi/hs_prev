import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextColorNotifier extends StateNotifier<List<Map<int, String>>> {
  TextColorNotifier() : super([]);

  void setColor(int no, String textColor) {
    final newState = List<Map<int, String>>.from(state);
    
    final index = newState.indexWhere((map) => map.containsKey(no));
    if (index != -1) {
      newState[index][no] = textColor;
    } else {
      newState.add({no: textColor});
    }
    
    state = newState;
  }

  void clearColor() {
    state = [];
  }
}

final textColorProvider = StateNotifierProvider<TextColorNotifier, List<Map<int, String>>>((ref) {
  return TextColorNotifier();
});
