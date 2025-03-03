import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logout_controller.g.dart';

@riverpod
class LogoutController extends _$LogoutController {
  @override
  bool build() => false;

  void logout() {
    state = true;
  }

  void reset() {
    state = false;
  }
}
