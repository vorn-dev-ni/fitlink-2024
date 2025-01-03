import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_provider.g.dart';

@riverpod
class AppLoadingState extends _$AppLoadingState {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}
