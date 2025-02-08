import 'dart:async';
import 'package:demo/common/model/user_model.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'event_detail_participant.g.dart';

@riverpod
class EventDetailParticipant extends _$EventDetailParticipant {
  late FirestoreService firestoreService;
  @override
  Future<AuthModel?> build(String id) async {
    firestoreService =
        FirestoreService(firebaseAuthService: FirebaseAuthService());
    return await getUser(id);
  }

  FutureOr<AuthModel?> getUser(uid) async {
    AuthModel? authModel = await firestoreService.getAvatar(uid);
    // debugPrint("Auth model is ${authModel.avatar}");
    return authModel;
  }
}
