// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demo/utils/constant/enums.dart';

class AuthModel {
  String? fullname;
  String? email;
  String? avatar;
  UserRoles? userRoles;
  AuthModel({this.fullname, this.email, this.avatar, this.userRoles});

  @override
  String toString() =>
      'AuthModel(fullname: $fullname, email: $email, avatar: $avatar)';

  AuthModel copyWith(
      {String? fullname, String? email, String? avatar, UserRoles? userRoles}) {
    return AuthModel(
        fullname: fullname ?? this.fullname,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        userRoles: userRoles ?? this.userRoles);
  }
}
