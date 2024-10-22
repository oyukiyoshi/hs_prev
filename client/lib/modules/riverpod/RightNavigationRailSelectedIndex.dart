import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'RightNavigationRailSelectedIndex.g.dart';

@riverpod
class RightNavigationRailSelectedIndexNotifier extends _$RightNavigationRailSelectedIndexNotifier {
  @override
  int build() {
    return 0;
  }

  // データを変更する関数
  void updateState(int menuSelectedIndex) {
    state = menuSelectedIndex;
  }
}