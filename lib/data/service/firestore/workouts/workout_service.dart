// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';

class WorkoutService extends BaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;
  WorkoutService({
    required this.firebaseAuthService,
  });

  @override
  Future delete({required String uid}) {
    throw UnimplementedError();
  }

  @override
  Future getById({required String uid}) {
    throw UnimplementedError();
  }

  @override
  Future joinEvents(String docId) {
    // TODO: implement joinEvents
    throw UnimplementedError();
  }

  @override
  Future save(Map<String, dynamic> data) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future update() {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future uploadCertificate(Map<String, dynamic> data) {
    // TODO: implement uploadCertificate
    throw UnimplementedError();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRealTime() {
    // TODO: implement getAllRealTime
    throw UnimplementedError();
  }

  @override
  CollectionReference<Map<String, dynamic>> getAllOneTime(
      {Object? collectionName}) {
    try {
      return _firestore.collection('workouts');
    } catch (e) {
      rethrow;
    }
  }
}
