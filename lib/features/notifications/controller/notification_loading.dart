import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'notification_loading.g.dart';

@Riverpod(keepAlive: false)
class NotificationLoading extends _$NotificationLoading {
  @override
  bool build() {
    return false;
  }

  void clearState() {
    state = false;
  }

  void setState(bool value) async {
    state = value;
  }
}
