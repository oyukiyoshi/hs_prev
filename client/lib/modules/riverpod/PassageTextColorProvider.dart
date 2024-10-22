import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextColorNotifier extends StateNotifier<List<Map<int, String>>> {
  TextColorNotifier() : super([]);

  void setColor(int no, String textColor) {
    List<Map<int, String>> newState = List.from(state);
    bool exists = false;

    for (var tmpMap in state) {
      if (tmpMap.containsKey(no)) {
        tmpMap[no] = textColor;
        exists = true;
        break;
      }
    }

    if (!exists) {
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

final textColorSelectorProvider = Provider.family<String?, int>((ref, no) {
  final textColorState = ref.watch(textColorProvider);
  for (var tmpMap in textColorState) {
    if (tmpMap.containsKey(no)) {
      return tmpMap[no];
    }
  }
  return null;
});
