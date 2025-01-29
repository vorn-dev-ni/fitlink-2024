import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'form_loading.g.dart';

@Riverpod(keepAlive: true)
class FormLoadingController extends _$FormLoadingController {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}
