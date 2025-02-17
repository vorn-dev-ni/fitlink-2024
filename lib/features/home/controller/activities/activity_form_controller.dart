import 'package:demo/data/repository/firebase/activities_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/activities/activities_service.dart';
import 'package:demo/features/home/model/workout_activity.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'activity_form_controller.g.dart';

@riverpod
class ActivityFormWorkoutController extends _$ActivityFormWorkoutController {
  late ActivitiesRepository activitiesRepository;
  @override
  ActivityWorkout build() {
    activitiesRepository = ActivitiesRepository(
        baseService:
            ActivitiesService(firebaseAuthService: FirebaseAuthService()));
    return ActivityWorkout();
  }

  void updateName(String name) {
    state = state.copyWith(title: name);
  }

  void updateNote(String note) {
    state = state.copyWith(desc: note);
  }

  void updateDate(DateTime? date) {
    DateTime normalizedDate = DateTime(date!.year, date.month, date.day);

    state = state.copyWith(date: normalizedDate);
  }

  void updateTimeStart(DateTime start) {
    state = state.copyWith(startTime: start);
  }

  void updateTimeEnd(DateTime end) {
    state = state.copyWith(endTime: end);
  }

  Future save() async {
    try {
      await activitiesRepository.addWorkoutUser(
          date: state.date,
          uid: FirebaseAuth.instance.currentUser!.uid,
          workoutId: '',
          activities: state);
      Fluttertoast.showToast(
          msg: "Successfully added to your activity !!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: AppColors.successColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future updateActivity(String docId) async {
    try {
      await activitiesRepository.updateActivity(
          docId: docId, activities: state);
      Fluttertoast.showToast(
          msg: "Successfully updated to your activity !!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: AppColors.successColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
