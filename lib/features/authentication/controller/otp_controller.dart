import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'otp_controller.g.dart';

@Riverpod(keepAlive: true)
class OtpControlelr extends _$OtpControlelr {
  @override
  String build() {
    return '';
  }

  void updateCode(String code) {
    state = code;
  }
}
