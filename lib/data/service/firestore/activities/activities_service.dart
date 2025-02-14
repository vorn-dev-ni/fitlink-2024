// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ActivitiesService extends BaseActivitiesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuthService firebaseAuthService;
  ActivitiesService({
    required this.firebaseAuthService,
  });

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRealTime() {
    throw UnimplementedError();
  }

  @override
  Future updateUserWorkout(Map<String, dynamic> data) async {
    try {
      if (data['workoutId'] == "") {
        final result = await _firestore.collection('activities').add(data);
        return result;
      }
      DocumentReference workoutRef =
          _firestore.collection('workouts').doc(data['workoutId']);
      Timestamp dateTimestamp = Timestamp.fromDate(data['date'] as DateTime);

      data['workoutId'] = workoutRef;
      QuerySnapshot querySnapshot = await _firestore
          .collection('activities')
          .where('userId', isEqualTo: firebaseAuthService.currentUser!.uid)
          .where('date', isEqualTo: dateTimestamp)
          .where('workoutId', isEqualTo: workoutRef)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Fluttertoast.showToast(
            msg: 'This workout has already in progress... ',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColors.secondaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
        return null;
      }

      final result = await _firestore.collection('activities').add(data);
      Fluttertoast.showToast(
          msg: 'Successfully added to your activity !!!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: AppColors.successColor,
          textColor: Colors.white,
          fontSize: 16.0);

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  CollectionReference<Map<String, dynamic>> getAllOneTime() {
    try {
      return _firestore.collection('activities');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future updateProcessUser(
      String id, DateTime date, Map<String, dynamic> data) async {
    try {
      final workoutRef = _firestore.collection('workouts').doc(id);
      final snapshot = await FirebaseFirestore.instance
          .collection('activities')
          .where('workoutId', isEqualTo: workoutRef)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('date', isEqualTo: date)
          .get();
      if (snapshot.docs.isEmpty) {
        debugPrint('No matching document found');
        return;
      }

      final doc = snapshot.docs[0];
      await doc.reference.update(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future updateUserActivity(String docId, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('activities')
          .doc(docId)
          .update(data);
    } catch (e) {
      rethrow;
    }
  }
}
