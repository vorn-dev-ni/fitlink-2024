import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_loading_controller.g.dart';

@Riverpod(keepAlive: false)
class ChatLoadingController extends _$ChatLoadingController {
  @override
  bool build() {
    return false;
  }

  void setState(bool result) {
    state = result;
  }
}
