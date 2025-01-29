class AuthUser {
  late String? email;
  late String? password;
  late String? phoneNumber;
  late String? fullname;
  AuthUser({this.email, this.password, this.phoneNumber, this.fullname});

  AuthUser copyWith(
      {String? email,
      String? password,
      String? phoneNumber,
      String? fullname}) {
    return AuthUser(
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
