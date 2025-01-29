import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String authorName;
  final String address;
  final Timestamp preStartDate;
  final double lng;
  final String endDate;
  final String descriptions;
  final Timestamp preEndDate;
  final String authorFeature;
  final String eventTitle;
  final Timestamp timeStart;
  final String feature;
  final String? price;
  final String authorEmail;
  final Timestamp createdDate;
  final String authorId;
  final double lat;
  final String startDate;
  final List<Participant> participants;
  final bool freeEntry;
  final String establishment;
  final String docId;
  final Timestamp endTime;

  Event({
    required this.authorName,
    required this.address,
    required this.preStartDate,
    required this.lng,
    required this.endDate,
    required this.descriptions,
    required this.preEndDate,
    required this.authorFeature,
    required this.eventTitle,
    required this.timeStart,
    required this.feature,
    this.price,
    required this.authorEmail,
    required this.createdDate,
    required this.authorId,
    required this.lat,
    required this.startDate,
    required this.participants,
    required this.freeEntry,
    required this.establishment,
    required this.docId,
    required this.endTime,
  });

  factory Event.fromJson(Map<String, dynamic> json, String docId) {
    return Event(
      authorName: json['author_name'] ?? '',
      address: json['address'] ?? '',
      preStartDate: json['preStartDate'] ?? Timestamp.now(),
      lng: json['lng'] ?? 0.0,
      endDate: json['endDate'] ?? '',
      descriptions: json['descriptions'] ?? '',
      preEndDate: json['preEndDate'] ?? Timestamp.now(),
      authorFeature: json['authorFeature'] ?? '',
      eventTitle: json['eventTitle'] ?? '',
      timeStart: json['timeStart'] ?? Timestamp.now(),
      feature: json['feature'] ?? '',
      price: json['price'],
      authorEmail: json['author_email'] ?? '',
      createdDate: json['created_date'] ?? Timestamp.now(),
      authorId: json['author_id'] ?? '',
      lat: json['lat'] ?? 0.0,
      startDate: json['startDate'] ?? '',
      participants: (json['participants'] as List<dynamic>? ?? [])
          .map((participant) => Participant.fromJson(participant))
          .toList(),
      freeEntry: json['freeEntry'] ?? false,
      establishment: json['establishment'] ?? '',
      docId: docId, // Set the docId here
      endTime: json['endTime'] ?? Timestamp.now(),
    );
  }
}

class Participant {
  final String userId;
  final String avatarImage;

  Participant({
    required this.userId,
    required this.avatarImage,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      userId: json['userId'] ?? '',
      avatarImage: json['avatarImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'avatarImage': avatarImage,
    };
  }
}
