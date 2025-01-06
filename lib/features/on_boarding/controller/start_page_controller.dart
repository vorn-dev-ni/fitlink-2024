import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'start_page_controller.g.dart';

@riverpod
class StartPageController extends _$StartPageController {
  @override
  int build() {
    return 0;
  }

  void updatePage(int index) {
    state = index;
  }
}
