import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comment_like_controller.g.dart';

@Riverpod(keepAlive: true)
class CommentLikeController extends _$CommentLikeController {
  @override
  bool build(String? commentId) {
    if (commentId == null) {
      return false;
    }
    return false;
  }

  void toggleLike() {
    state = !state;
  }

  void setLikeStatus(bool status) {
    state = status;
  }
}
