// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutExcerciseResponse {
  int? totalExercises;
  int? totalBurn;
  String? title;
  String? imageUrl;
  int? totalDuration;
  String? type;
  String? parentId;
  DateTime? createdAt;
  String? id;
  String? planName;
  List<Exercises>? exercises;
  bool? completed;
  DateTime? endTime;
  String? desc;
  DateTime? startTime;
  bool? userActivity;
  WorkoutExcerciseResponse({
    this.totalExercises,
    this.totalBurn,
    this.title,
    this.parentId,
    this.imageUrl,
    this.desc,
    this.totalDuration,
    this.type,
    this.createdAt,
    this.id,
    this.planName,
    this.exercises,
    this.completed,
    this.endTime,
    this.startTime,
    this.userActivity = false,
  });

  WorkoutExcerciseResponse.fromJson(Map<String, dynamic> json) {
    parentId = json['parentId'];
    userActivity = json['userActivity'];
    endTime = json['endTime'] != null
        ? (json['endTime'] is Timestamp
            ? (json['endTime'] as Timestamp).toDate()
            : DateTime.tryParse(json['endTime']))
        : null;
    startTime = json['startTime'] != null
        ? (json['startTime'] is Timestamp
            ? (json['startTime'] as Timestamp).toDate()
            : DateTime.tryParse(json['startTime']))
        : null;
    totalExercises = json['totalExercises'];
    totalBurn = json['total_burn'];
    title = json['title'];
    imageUrl = json['imageUrl'];
    totalDuration = json['totalDuration'];
    type = json['type'];
    desc = json['desc'];
    completed = json['completed'];
    // Handle Firestore Timestamp
    createdAt = json['createdAt'] != null
        ? (json['createdAt'] is Timestamp
            ? (json['createdAt'] as Timestamp).toDate()
            : DateTime.tryParse(json['createdAt']))
        : null;

    id = json['id'];
    planName = json['planName'];
    if (json['excercises'] != null) {
      exercises = <Exercises>[];
      json['excercises'].forEach((v) {
        exercises!.add(Exercises.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalExercises'] = this.totalExercises;
    data['total_burn'] = this.totalBurn;
    data['title'] = this.title;
    data['imageUrl'] = this.imageUrl;
    data['totalDuration'] = this.totalDuration;
    data['type'] = this.type;
    if (this.createdAt != null) {
      data['createdAt'] = Timestamp.fromDate(this.createdAt!);
    }

    data['id'] = this.id;
    data['planName'] = this.planName;
    if (this.exercises != null) {
      data['excercises'] = this.exercises!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Exercises {
  String? reps;
  String? sets;
  String? imageUrl;
  String? title;
  String? totalDuration;
  String? duration;

  Exercises(
      {this.reps,
      this.sets,
      this.imageUrl,
      this.title,
      this.totalDuration,
      this.duration});

  Exercises.fromJson(Map<String, dynamic> json) {
    reps = json['reps'];
    sets = json['sets'];
    imageUrl = json['imageUrl'];
    title = json['title'];
    totalDuration = json['totalDuration'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reps'] = this.reps;
    data['sets'] = this.sets;
    data['imageUrl'] = this.imageUrl;
    data['title'] = this.title;
    data['totalDuration'] = this.totalDuration;
    data['duration'] = this.duration;
    return data;
  }
}
