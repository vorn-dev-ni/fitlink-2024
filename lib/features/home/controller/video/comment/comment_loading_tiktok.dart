import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_loading_tiktok.g.dart';

@riverpod
class CommentLoadingTiktok extends _$CommentLoadingTiktok {
  @override
  bool build() => false;

  void setState(bool loading) {
    state = loading;
  }

  void reset() {
    state = false;
  }
}
