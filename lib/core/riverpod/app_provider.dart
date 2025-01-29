import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_provider.g.dart';

@Riverpod(keepAlive: true)
class AppLoadingState extends _$AppLoadingState {
  @override
  bool build() {
    return false;
  }

  void setState(bool value) {
    state = value;
  }
}
