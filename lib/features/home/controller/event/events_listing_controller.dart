import 'package:demo/data/repository/firebase/events_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/events/event_service.dart';
import 'package:demo/features/home/model/event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'events_listing_controller.g.dart';

@Riverpod(keepAlive: true)
class EventsListingController extends _$EventsListingController {
  late EventsRepository eventsRepository;
  @override
  Stream<List<Event>> build() {
    eventsRepository = EventsRepository(
        baseService: EventService(firebaseAuthService: FirebaseAuthService()));
    return getAllEvents();
  }

  Stream<List<Event>> getAllEvents() async* {
    try {
      final stream = eventsRepository.getAllRealTimeEvents();
      yield* stream;
    } catch (e) {
      rethrow;
    }
  }

  // FutureOr<List<Event>?> build() {
  //   eventsRepository = EventsRepository(
  //       baseService: EventService(firebaseAuthService: FirebaseAuthService()));
  //   return fetchEvents();
  // }

  // Future<List<Event>?> fetchEvents() async {
  //   try {
  //     return await eventsRepository.getAllOneTimeEvent();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
