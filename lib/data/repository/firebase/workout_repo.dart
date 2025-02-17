import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/model/workouts/workout_response.dart';

class WorkoutRepository {
  late BaseService baseService;

  WorkoutRepository({
    required this.baseService,
  });

  Future<List<WorkoutExcerciseResponse>> getAllWorkouts(
      {String? type, DateTime? date}) async {
    try {
      final querySnapshot = await baseService
          .getAllOneTime()
          .where('type', isEqualTo: type)
          .get();
      final workoutsWithExercises =
          await Future.wait(querySnapshot.docs.map((doc) async {
        Map<String, dynamic> workoutData = doc.data() as Map<String, dynamic>;
        workoutData['id'] = doc.id;
        final subCollectionSnapshot =
            await doc.reference.collection("excercises").get();
        final excercises = subCollectionSnapshot.docs.map((subDoc) {
          return subDoc.data();
        }).toList();
        workoutData['excercises'] = excercises;
        return WorkoutExcerciseResponse.fromJson(workoutData);
      }));

      return workoutsWithExercises;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Exercises>> getExcercises({String? docId}) async {
    try {
      final querySnapshot = await baseService
          .getAllOneTime()
          .doc(docId)
          .collection('excercises')
          .get();
      final exercises = querySnapshot.docs
          .map((doc) => Exercises.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return exercises;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WorkoutExcerciseResponse>> getFeatureWorkouts(
      {DateTime? date}) async {
    try {
      final querySnapshot = await baseService
          .getAllOneTime()
          .where('type', isEqualTo: 'feature')
          .get();
      final workoutsWithExercises =
          await Future.wait(querySnapshot.docs.map((doc) async {
        Map<String, dynamic> workoutData = doc.data() as Map<String, dynamic>;
        workoutData['id'] = doc.id;
        final subCollectionSnapshot =
            await doc.reference.collection("excercises").get();
        final excercises = subCollectionSnapshot.docs.map((subDoc) {
          return subDoc.data();
        }).toList();
        workoutData['excercises'] = excercises;
        return WorkoutExcerciseResponse.fromJson(workoutData);
      }));

      return workoutsWithExercises;
    } catch (e) {
      rethrow;
    }
  }
}
