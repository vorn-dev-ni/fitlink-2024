// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthUser {
  late String? email;
  late String? password;
  late String? phoneNumber;
  late String? fullname;
  late String? countryCode;
  late String? firstName;
  late String? lastname;
  AuthUser(
      {this.email,
      this.countryCode = '855',
      this.password,
      this.phoneNumber,
      this.fullname,
      this.firstName,
      this.lastname});

  AuthUser copyWith(
      {String? email,
      String? password,
      String? firstName,
      String? countryCode,
      String? lastname,
      String? phoneNumber,
      String? fullname}) {
    return AuthUser(
      lastname: lastname ?? this.lastname,
      fullname: fullname ?? this.fullname,
      countryCode: countryCode ?? this.countryCode,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  String toString() {
    return 'AuthUser(email: $email, password: $password, phoneNumber: $phoneNumber, fullname: $fullname, firstName: $firstName, lastname: $lastname)';
  }
}
