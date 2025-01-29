// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:flutter/material.dart';

class EventService extends BaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;
  EventService({
    required this.firebaseAuthService,
  });

  @override
  Future delete({required String uid}) {
    throw UnimplementedError();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRealTime() {
    return _firestore.collection('events').snapshots();
  }

  @override
  Future getById({required String uid}) {
    throw UnimplementedError();
  }

  @override
  Future save(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('events').add(data);
    } on FirebaseException catch (e) {
      throw AppException(
          title: 'Error Adding document: ', message: e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future update() {
    throw UnimplementedError();
  }

  @override
  Future joinEvents(String docId) async {
    try {
      final ref = _firestore.collection('events').doc(docId);
      final collections = await ref.get();
      final userData = await _firestore
          .collection('users')
          .doc(firebaseAuthService.currentUser!.uid)
          .get();
      final allParticpants = collections.data()!['participants'] as List;
      bool isExisted = allParticpants.any((element) =>
          element['userId'] == firebaseAuthService.currentUser!.uid);

      if (isExisted) {
        allParticpants.removeWhere(
          (element) =>
              element['userId'] == firebaseAuthService.currentUser!.uid,
        );
      } else {
        // Add the participant if they do not exist
        allParticpants.add({
          'userId': firebaseAuthService.currentUser!.uid,
          'avatarImage': userData['avatar'],
        });
      }
      await ref.update({'participants': allParticpants});
      debugPrint("Successfully updated");
    } on FirebaseException catch (e) {
      throw AppException(
          title: 'Error Adding document: ', message: e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getAllOneTime() async {
    try {
      return await _firestore.collection('events').get();
    } on FirebaseException catch (e) {
      throw AppException(
          title: 'Error Adding document: ', message: e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future uploadCertificate(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('submissions').add(data);
    } on FirebaseException catch (e) {
      throw AppException(
          title: 'Error Adding document: ', message: e.toString());
    } catch (e) {
      rethrow;
    }
  }
}
