// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRequester {
  String? firstName;
  String? lastName;
  String? avatar;
  String? bio;

  ProfileRequester({
    this.firstName,
    this.lastName,
    this.avatar,
    this.bio,
  });

  factory ProfileRequester.fromJson(Map<String, dynamic> json) {
    return ProfileRequester(
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
      bio: json['bio'],
    );
  }

  String? get fullname =>
      firstName != null && lastName != null ? '$firstName $lastName' : null;

  // Method to convert ProfileRequester to JSON
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'bio': bio,
      'fullName': fullname,
      'updatedAt': Timestamp.now()
    };
  }

  ProfileRequester copyWith({
    String? firstName,
    String? lastName,
    String? avatar,
    String? bio,
  }) {
    return ProfileRequester(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
    );
  }

  @override
  String toString() {
    return 'ProfileRequester(firstName: $firstName, lastName: $lastName, avatar: $avatar, bio: $bio)';
  }
}
