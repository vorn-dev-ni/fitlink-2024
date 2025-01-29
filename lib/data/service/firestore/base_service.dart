import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseService {
  Future delete({required String uid});
  Future save(Map<String, dynamic> data);
  Future update();
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRealTime();
  Future<QuerySnapshot<Map<String, dynamic>>> getAllOneTime();
  Future getById({required String uid});
  Future joinEvents(String docId);
  Future uploadCertificate(Map<String, dynamic> data);
}
