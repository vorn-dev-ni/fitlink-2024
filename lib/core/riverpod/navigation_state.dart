import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/local_storage/local_storage_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'navigation_state.g.dart';

@Riverpod(keepAlive: true)
class NavigationState extends _$NavigationState {
  @override
  int build() {
    return 0;
  }

  void changeIndex(int p1) {
    state = p1;
  }
}
