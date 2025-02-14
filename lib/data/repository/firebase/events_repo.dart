// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/features/home/model/event.dart';
import 'package:demo/model/events/event_request_body.dart';
import 'package:flutter/material.dart';

class EventsRepository {
  late BaseService baseService;

  EventsRepository({
    required this.baseService,
  });

  Future createEvent(EventRequestBody eventForm) async {
    try {
      await baseService.save(eventForm.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Event>> getAllRealTimeEvents() {
    return baseService.getAllRealTime().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromJson(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> joinEvents(String docId) async {
    try {
      await baseService.joinEvents(docId);
    } catch (e) {
      rethrow;
    }
  }

  Future uploadCertificate(Map<String, dynamic> params) async {
    try {
      await baseService.uploadCertificate(params);
      debugPrint("Upload certificate successfully !!!");
    } catch (e) {
      rethrow;
    }
  }
}
