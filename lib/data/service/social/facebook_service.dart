import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookService {
  late final FacebookAuth _facebookAuth;
  FacebookService() {
    _facebookAuth = FacebookAuth.instance;
  }

  Future<LoginResult> loginFacebook({
    LoginBehavior? LoginBehavior,
    List<String>? permissions,
  }) async {
    final facebookResult = await _facebookAuth.login();
    return facebookResult;
//  final FacebookAuthCredential =
  }

  Future logoutFacebook() async {
    await _facebookAuth.logOut();
  }
}
