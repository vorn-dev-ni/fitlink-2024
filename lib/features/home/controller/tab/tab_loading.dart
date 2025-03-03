import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'tab_loading.g.dart';

@Riverpod(keepAlive: true)
class TabLoadingController extends _$TabLoadingController {
  @override
  bool build() {
    return false;
  }

  void setState(bool isLoading) {
    state = isLoading;
  }

  void resetState() {
    state = false;
  }
}
