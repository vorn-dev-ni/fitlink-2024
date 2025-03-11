import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/features/home/model/workout_activity.dart';
import 'package:demo/model/workouts/workout_response.dart';
import 'package:flutter/material.dart';

class ActivitiesRepository {
  late BaseActivitiesService baseService;

  ActivitiesRepository({
    required this.baseService,
  });

  Future updateWorkoutProcess(
      {required String workoutId, required DateTime date}) async {
    try {
      Map<String, dynamic> payload = {
        'completed': true,
        'updatedAt': Timestamp.now()
      };

      await baseService.updateProcessUser(workoutId, date, payload);
      debugPrint("Completed");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addWorkoutUser(
      {String? uid,
      DateTime? date,
      String? workoutId,
      ActivityWorkout? activities}) async {
    try {
      DateTime normalizedDate = DateTime(date!.year, date.month, date.day);
      Map<String, dynamic> payload = {
        'userId': uid,
        'date': normalizedDate,
        'completed': false
      };
      if (workoutId != '') {
        payload.putIfAbsent('workoutId', () => workoutId);
      } else {
        payload.putIfAbsent('workoutId', () => null);
        payload.putIfAbsent('desc', () => activities?.desc ?? "");
        payload.putIfAbsent('title', () => activities?.title ?? "");
        payload.putIfAbsent('endTime', () => activities?.endTime ?? "");
        payload.putIfAbsent('startTime', () => activities?.startTime ?? "");
      }
      await baseService.updateUserWorkout(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateActivity(
      {String? docId, ActivityWorkout? activities}) async {
    try {
      await baseService.updateUserActivity(docId!, activities!.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WorkoutExcerciseResponse>?> getUserActivities(
      {String? uid, DateTime? date}) async {
    try {
      DateTime normalizedDate = DateTime(date!.year, date.month, date.day);
      final querySnapshot = await baseService
          .getAllOneTime()
          .where('date', isEqualTo: normalizedDate)
          .where('userId', isEqualTo: uid)
          .get();

      List<DocumentReference> workoutIds = [];

      querySnapshot.docs.forEach((e) {
        final data = e.data() as Map<String, dynamic>;
        if (data.containsKey('workoutId') && data['workoutId'] != null) {
          var workoutRef = data['workoutId'] as DocumentReference;
          workoutIds.add(workoutRef);
        }
      });

      debugPrint('Snapshot is ${querySnapshot.docs.length}');

      List<WorkoutExcerciseResponse> data = [];
      if (workoutIds.isNotEmpty) {
        for (var workoutRef in workoutIds) {
          DocumentSnapshot workoutDoc = await workoutRef.get();
          if (workoutDoc.exists) {
            var workoutData = workoutDoc.data() as Map<String, dynamic>;
            workoutData['id'] = workoutDoc.id;
            CollectionReference exercisesRef =
                workoutRef.collection('excercises');
            QuerySnapshot exercisesSnapshot = await exercisesRef.get();

            List<Map<String, dynamic>> exercises = exercisesSnapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            var activityDoc = querySnapshot.docs.firstWhere(
              (doc) => doc.data()['workoutId'] == workoutRef,
            );

            bool completed = activityDoc.data()['completed'] ?? false;

            workoutData['excercises'] = exercises;
            workoutData['completed'] = completed;
            workoutData['parentId'] = activityDoc.id;

            data.add(WorkoutExcerciseResponse.fromJson(workoutData));
          }
        }
      }

      // Handle case where workoutId is null or missing
      for (var query in querySnapshot.docs) {
        final workoutData = query.data() as Map<String, dynamic>;
        if (workoutData['workoutId'] == null) {
          workoutData['parentId'] = query.id;
          workoutData['userActivity'] = true;
          data.add(WorkoutExcerciseResponse.fromJson(workoutData));
        }
      }

      debugPrint("Final data with exercises: ${data.length}");
      return data;
    } catch (e) {
      rethrow;
    }
  }

  // Future<List<WorkoutExcerciseResponse>?> getUserActivities(
  //     {String? uid, DateTime? date}) async {
  //   try {
  //     DateTime normalizedDate = DateTime(date!.year, date.month, date.day);
  //     final querySnapshot = await baseService
  //         .getAllOneTime()
  //         .where('date', isEqualTo: normalizedDate)
  //         .where('userId', isEqualTo: uid)
  //         .get();

  //     List<DocumentReference> workoutIds = [];

  //     querySnapshot.docs.forEach((e) {
  //       final data = e.data() as Map<String, dynamic>;
  //       if (data.containsKey('workoutId') && data['workoutId'] != null) {
  //         var workoutRef = data['workoutId'];
  //         workoutIds.add(workoutRef);
  //       }
  //     });

  //     debugPrint('snap shot is ${querySnapshot.docs.length}');

  //     List<WorkoutExcerciseResponse> data = [];
  //     if (workoutIds.length > 0) {
  //       for (var workoutRef in workoutIds) {
  //         DocumentSnapshot workoutDoc = await workoutRef.get();
  //         if (workoutDoc.exists) {
  //           var workoutData = workoutDoc.data() as Map<String, dynamic>;
  //           workoutData['id'] = workoutDoc.id;
  //           CollectionReference exercisesRef =
  //               workoutRef.collection('excercises');
  //           QuerySnapshot exercisesSnapshot = await exercisesRef.get();

  //           List<Map<String, dynamic>> exercises = exercisesSnapshot.docs
  //               .map((doc) => doc.data() as Map<String, dynamic>)
  //               .toList();
  //           var activityDoc = querySnapshot.docs.firstWhere(
  //             (doc) => doc.data()['workoutId'] == workoutRef,
  //           );
  //           bool completed = activityDoc.data()['completed'] ?? false;
  //           workoutData['excercises'] = exercises;
  //           workoutData['completed'] = completed;
  //           data.add(WorkoutExcerciseResponse.fromJson(workoutData));
  //         }
  //       }
  //     } else {
  //       for (var query in querySnapshot.docs) {
  //         final workoutData = query.data() as Map<String, dynamic>;
  //         workoutData['userActivity'] = true;

  //         data.add(WorkoutExcerciseResponse.fromJson(workoutData));
  //       }
  //     }

  //     debugPrint("Final data with exercises: ${data.length}");
  //     return data;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
