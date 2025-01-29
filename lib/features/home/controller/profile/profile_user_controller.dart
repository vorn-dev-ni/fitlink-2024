import 'package:demo/common/model/user_model.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'profile_user_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileUserController extends _$ProfileUserController {
  late FirestoreService firestoreService;

  @override
  Future<AuthModel?> build() async {
    firestoreService =
        FirestoreService(firebaseAuthService: FirebaseAuthService());
    return await getData();
  }

  FutureOr<AuthModel?> getData() async {
    AuthModel? authModel = await firestoreService
        .getEmail(firestoreService.firebaseAuthService.currentUser!.uid);

    return authModel;
  }
}
