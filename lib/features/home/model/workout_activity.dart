// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityWorkout {
  late final DateTime? startTime;
  late final DateTime? endTime;
  late final DateTime? date;

  late String? title;
  late String? desc;
  ActivityWorkout({
    this.startTime,
    this.date,
    this.endTime,
    this.title,
    this.desc,
  });
  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'title': title,
      'desc': desc,
      'updatedAt': Timestamp.now()
    };
  }

  ActivityWorkout copyWith({
    DateTime? startTime,
    DateTime? endTime,
    String? title,
    String? desc,
    DateTime? date,
  }) {
    return ActivityWorkout(
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      title: title ?? this.title,
      desc: desc ?? this.desc,
    );
  }

  @override
  String toString() {
    return 'ActivityWorkout(startTime: $startTime, endTime: $endTime, date: $date, title: $title, desc: $desc)';
  }
}
