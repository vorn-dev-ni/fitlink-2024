import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'post_loading_paging.g.dart';

@Riverpod(keepAlive: true)
class PostLoadingPaging extends _$PostLoadingPaging {
  @override
  bool build() {
    return false;
  }

  void setState(bool result) {
    state = result;
  }
}
