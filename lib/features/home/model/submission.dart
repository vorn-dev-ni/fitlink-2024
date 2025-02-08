import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class FormSubmission {
  String? userId; // User ID
  String? address;
  String? code;
  String? contactName;
  String? email;
  String? phoneNumber;
  List<String>? proofDocuments;
  String? status;
  List<File>? temporaryFiles;
  Timestamp? submissionDate;
  bool? trainerCertification;
  String? website;
  String? zipCode;
  String? country;
  FormSubmission({
    this.userId,
    this.address,
    this.code = '855',
    this.temporaryFiles,
    this.country,
    this.contactName,
    this.email,
    this.phoneNumber,
    this.proofDocuments,
    this.status,
    this.submissionDate,
    this.trainerCertification,
    this.website,
    this.zipCode,
  });

  factory FormSubmission.fromMap(Map<String, dynamic> map) {
    return FormSubmission(
      userId: map['user_id'] as String?,
      address: map['address'] as String?,
      country: map['country'] as String?,
      contactName: map['contact_name'] as String?,
      email: map['email'] as String?,
      phoneNumber: map['phone_number'] as String?,
      proofDocuments: (map['proof_documents'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: map['status'] as String?,
      submissionDate: map['submission_date'] as Timestamp?,
      trainerCertification: map['trainer_certification'] as bool?,
      website: map['website'] as String?,
      zipCode: map['zip_code'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'address': address,
      'contact_name': contactName,
      'email': email,
      'phone_number': '${code}${phoneNumber}',
      'proof_documents': proofDocuments,
      'status': 'pending',
      'country': country,
      'submission_date': Timestamp.now(),
      'trainer_certification': trainerCertification,
      'website': website,
      'zip_code': zipCode, // Include the zip code field in the map
    };
  }

  FormSubmission copyWith(
      {String? userId,
      String? address,
      String? contactName,
      String? email,
      List<File>? temporaryFiles,
      String? phoneNumber,
      List<String>? proofDocuments,
      String? status,
      Timestamp? submissionDate,
      bool? trainerCertification,
      String? website,
      String? country,
      String? zipCode,
      String? code}) {
    return FormSubmission(
      code: code ?? this.code,
      userId: userId ?? this.userId,
      temporaryFiles: temporaryFiles ?? this.temporaryFiles,
      address: address ?? this.address,
      contactName: contactName ?? this.contactName,
      email: email ?? this.email,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      proofDocuments: proofDocuments ?? this.proofDocuments,
      status: status ?? this.status,
      submissionDate: submissionDate ?? this.submissionDate,
      trainerCertification: trainerCertification ?? this.trainerCertification,
      website: website ?? this.website,
      zipCode: zipCode ?? this.zipCode,
    );
  }
}
