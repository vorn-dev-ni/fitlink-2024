import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'workout_date_controller.g.dart';

@Riverpod(keepAlive: true)
class WorkoutDateController extends _$WorkoutDateController {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void updateDate(DateTime newDate) {
    state = newDate;
  }
}
