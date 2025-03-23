import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'navigation_stack.g.dart';

@Riverpod(keepAlive: true)
class NavigationStackState extends _$NavigationStackState {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}
