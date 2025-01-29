import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'step_header_controller.g.dart';

@riverpod
class StepHeaderController extends _$StepHeaderController {
  @override
  int build() {
    return 0;
  }

  void updateIndex(int index) {
    state = index;
  }

  void backIndex() {
    if (state > 0) state = state - 1;
  }
}
