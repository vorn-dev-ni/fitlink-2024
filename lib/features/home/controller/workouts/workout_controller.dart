import 'package:demo/data/repository/firebase/workout_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/workouts/workout_service.dart';
import 'package:demo/model/workouts/workout_response.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/enums.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'workout_controller.g.dart';

@Riverpod(keepAlive: true)
class WorkoutController extends _$WorkoutController {
  late WorkoutRepository workoutRepository;

  @override
  Future<List<WorkoutExcerciseResponse>?> build(WorkoutType workoutType) async {
    debugPrint("re render workout");
    workoutRepository = WorkoutRepository(
        baseService:
            WorkoutService(firebaseAuthService: FirebaseAuthService()));

    return workoutType == WorkoutType.feature
        ? await getFeature()
        : await getWorkout(workoutType);
  }

  FutureOr<List<WorkoutExcerciseResponse>?> getFeature() async {
    try {
      return await workoutRepository.getFeatureWorkouts();
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
    return null;
  }

  FutureOr<List<WorkoutExcerciseResponse>?> getWorkout(WorkoutType type) async {
    try {
      return await workoutRepository.getAllWorkouts(type: type.name);
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

    return null;
  }
}
