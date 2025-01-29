import 'package:cloud_firestore/cloud_firestore.dart';

class EventRequestBody {
  final String? eventTitle;
  final String? descriptions;
  final String? startDate;
  final String? price;
  final String? endDate;
  DateTime? preStartDate;
  DateTime? preEndDate;
  final bool? freeEntry;
  final String? feature;
  final String? address;
  final DateTime? timeStart;
  final DateTime? timeEnd;
  final double? lat;
  final double? lng;
  List<dynamic>? participants;

  final String? authorId;
  final String? authorName;
  final String? authorEmail;
  final String? authorFeature;
  final String? establishment;

  EventRequestBody({
    this.authorFeature,
    this.eventTitle,
    this.preEndDate,
    this.participants,
    this.price,
    this.preStartDate,
    this.descriptions,
    this.startDate,
    this.endDate,
    this.freeEntry = true,
    this.feature,
    this.address,
    this.timeStart,
    this.establishment,
    this.timeEnd,
    this.lat,
    this.lng,
    this.authorId, // Added authorId
    this.authorName, // Added authorName
    this.authorEmail, // Added authorEmail
  });

  Map<String, dynamic> toJson() {
    return {
      'eventTitle': eventTitle,
      'descriptions': descriptions,
      'establishment': establishment,
      'preStartDate': preStartDate,
      'preEndDate': preEndDate,
      'endDate': endDate,
      'startDate': startDate,
      'freeEntry': freeEntry,
      'feature': feature,
      'address': address,
      'timeStart': timeStart,
      'timeEnd': timeEnd,
      'lat': lat,
      'price': price,
      'lng': lng,
      'participants': participants ?? [],
      'created_date': Timestamp.now(),
      'author_id': authorId,
      'author_name': authorName,
      'authorFeature': authorFeature,
      'author_email': authorEmail, // Adding authorEmail to the map
    };
  }

  EventRequestBody copyWith(
      {String? eventTitle,
      String? descriptions,
      String? startDate,
      String? establishment,
      String? endDate,
      DateTime? preStartDate,
      DateTime? preEndDate,
      bool? freeEntry,
      String? feature,
      String? address,
      String? distanceMeasurement,
      DateTime? timeStart,
      DateTime? timeEnd,
      double? lat,
      double? lng,
      String? price,
      List<dynamic>? participants,
      String? authorId,
      String? authorName,
      String? authorEmail,
      String? authorFeature}) {
    return EventRequestBody(
        eventTitle: eventTitle ?? this.eventTitle,
        descriptions: descriptions ?? this.descriptions,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        freeEntry: freeEntry ?? this.freeEntry,
        feature: feature ?? this.feature,
        address: address ?? this.address,
        preEndDate: preEndDate ?? this.preEndDate,
        preStartDate: preStartDate ?? this.preStartDate,
        timeStart: timeStart ?? this.timeStart,
        timeEnd: timeEnd ?? this.timeEnd,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        establishment: establishment ?? this.establishment,
        price: price ?? this.price,
        participants: participants ?? this.participants,
        authorId: authorId ?? this.authorId,
        authorName: authorName ?? this.authorName,
        authorEmail: authorEmail ?? this.authorEmail,
        authorFeature: authorFeature ?? this.authorFeature);
  }

  @override
  String toString() {
    return 'EventRequestBody(eventTitle: $eventTitle, descriptions: $descriptions, startDate: $startDate, price: $price, endDate: $endDate, preStartDate: $preStartDate, preEndDate: $preEndDate, freeEntry: $freeEntry, feature: $feature, address: $address, timeStart: $timeStart, timeEnd: $timeEnd, lat: $lat, lng: $lng, authorId: $authorId, authorName: $authorName, authorEmail: $authorEmail)';
  }
}
