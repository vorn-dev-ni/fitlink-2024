import 'package:demo/data/repository/firebase/activities_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/activities/activities_service.dart';
import 'package:demo/features/home/controller/logout_controller.dart';
import 'package:demo/features/home/model/workout_activity.dart';
import 'package:demo/model/workouts/workout_response.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'activities_controller.g.dart';

@Riverpod(keepAlive: true)
class ActivitiesController extends _$ActivitiesController {
  late ActivitiesRepository activitiesRepository;

  @override
  Future<List<WorkoutExcerciseResponse>?> build(
      DateTime? date, String userId) async {
    activitiesRepository = ActivitiesRepository(
        baseService:
            ActivitiesService(firebaseAuthService: FirebaseAuthService()));
    debugPrint("re build activity controler ${date} ${userId}");

    if (date != null) {
      return getWorkout(date, userId);
    }
    return null;
  }

  Future addWorkout(
      {String? workoutId,
      String? uid,
      DateTime? date,
      ActivityWorkout? activities}) async {
    try {
      await activitiesRepository.addWorkoutUser(
          date: date,
          uid: FirebaseAuth.instance.currentUser!.uid,
          workoutId: workoutId,
          activities: activities);

      debugPrint(
          "addWorkout with date ${date} ${FirebaseAuth.instance.currentUser?.uid}");

      ref.invalidate(activitiesControllerProvider(
          date, FirebaseAuth.instance.currentUser?.uid ?? ""));
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future updateWorkoutCompleted({
    String? workoutId,
    DateTime? datetime,
  }) async {
    try {
      DateTime normalizedDate =
          DateTime(datetime!.year, datetime.month, datetime.day);
      await activitiesRepository.updateWorkoutProcess(
          workoutId: workoutId!, date: normalizedDate);
      debugPrint(
          "updateWorkoutCompleted with date ${normalizedDate} ${FirebaseAuth.instance.currentUser?.uid}");
      ref.invalidate(activitiesControllerProvider(
          datetime, FirebaseAuth.instance.currentUser?.uid ?? ""));
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  FutureOr<List<WorkoutExcerciseResponse>?> getWorkout(
      DateTime date, String? userId) async {
    try {
      debugPrint("activite x2 date is ${date} ${userId}");

      return await activitiesRepository.getUserActivities(
          date: date,
          uid: userId == "" ? FirebaseAuth.instance.currentUser?.uid : userId);
    } catch (e) {
      rethrow;
    }
  }
}
