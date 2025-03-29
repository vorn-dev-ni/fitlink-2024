import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'profile_loading_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileLoadingController extends _$ProfileLoadingController {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}
