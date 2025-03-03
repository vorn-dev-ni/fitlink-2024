import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comment_loading.g.dart';

@Riverpod(keepAlive: true)
class CommentPagingLoading extends _$CommentPagingLoading {
  @override
  bool build() {
    return false;
  }

  void setState(bool result) {
    state = result;
  }
}
