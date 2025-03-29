import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_load_more.g.dart';

@Riverpod(keepAlive: false)
class ChatLoadMore extends _$ChatLoadMore {
  @override
  bool build() {
    return false;
  }

  void setState(bool result) {
    state = result;
  }
}
