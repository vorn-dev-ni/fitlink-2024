import 'package:demo/data/repository/firebase/workout_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/workouts/workout_service.dart';
import 'package:demo/model/workouts/workout_response.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'excercises_controller.g.dart';

@Riverpod(keepAlive: true)
class ExcercisesController extends _$ExcercisesController {
  late WorkoutRepository workoutRepository;

  @override
  Future<List<Exercises>?> build(String docId) async {
    workoutRepository = WorkoutRepository(
        baseService:
            WorkoutService(firebaseAuthService: FirebaseAuthService()));
    return await getData(docId);
  }

  FutureOr<List<Exercises>?> getData(String docId) async {
    try {
      return await workoutRepository.getExcercises(docId: docId);
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
