// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/utils/constant/enums.dart';

class AuthModel {
  String? id;
  String? fullname;
  String? email;
  String? avatar;
  String? bio;
  String? cover_feature;
  UserRoles? userRoles;
  AuthModel(
      {this.fullname,
      this.id,
      this.email,
      this.avatar,
      this.userRoles,
      this.cover_feature,
      this.bio});
  factory AuthModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    if (data == null) return AuthModel();

    return AuthModel(
        id: data['id'],
        fullname: data['fullName'] as String?,
        email: data['email'] as String?,
        avatar: data['avatar'] as String?,
        bio: data['bio'] as String?,
        cover_feature: data['cover_feature'] as String?);
  }
  @override
  String toString() =>
      'AuthModel(fullname: $fullname, email: $email, avatar: $avatar)';
  AuthModel copyWith(
      {String? fullname,
      String? email,
      String? avatar,
      UserRoles? userRoles,
      String? bio,
      String? cover_feature}) {
    return AuthModel(
        fullname: fullname ?? this.fullname,
        bio: bio ?? this.bio,
        cover_feature: cover_feature ?? this.cover_feature,
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        userRoles: userRoles ?? this.userRoles);
  }
}
