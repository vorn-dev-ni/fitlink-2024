import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_like_controller.g.dart';

@Riverpod(keepAlive: true)
class UserLikeController extends _$UserLikeController {
  @override
  bool build(String? postId) {
    if (postId == null) {
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
