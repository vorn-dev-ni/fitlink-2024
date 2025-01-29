import 'package:demo/data/repository/firebase/events_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/events/event_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'events_detail_controller.g.dart';

@Riverpod(keepAlive: true)
class EventsDetailController extends _$EventsDetailController {
  late EventsRepository eventsRepository;
  @override
  bool build() {
    eventsRepository = EventsRepository(
        baseService: EventService(firebaseAuthService: FirebaseAuthService()));
    return false;
  }

  Future joinEvents(String docId) async {
    try {
      await eventsRepository.joinEvents(docId);
    } catch (e) {
      rethrow;
    }
  }

  void updateState(bool value) {
    state = value;
  }
}
