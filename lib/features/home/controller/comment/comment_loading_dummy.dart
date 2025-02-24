import 'package:demo/features/home/model/comment_loading.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comment_loading_dummy.g.dart';

@Riverpod(keepAlive: true)
class CommentLoadingDummy extends _$CommentLoadingDummy {
  @override
  CommentLoading build() {
    return CommentLoading();
  }

  void setState(CommentLoading? comment) {
    state = state.copyWith(
        comment: comment?.comment, isLoading: comment?.isLoading);
  }
}
