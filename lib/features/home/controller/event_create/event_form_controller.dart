import 'package:demo/common/model/user_model.dart';
import 'package:demo/data/repository/firebase/events_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/events/event_service.dart';
import 'package:demo/data/service/firestore/firestore_service.dart';
import 'package:demo/model/events/event_request_body.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'event_form_controller.g.dart';

@riverpod
class EventFormController extends _$EventFormController {
  late EventsRepository eventsRepository;
  late FirebaseAuthService firebaseAuthService;

  @override
  EventRequestBody build() {
    firebaseAuthService = FirebaseAuthService();
    eventsRepository = EventsRepository(
        baseService: EventService(firebaseAuthService: firebaseAuthService));
    return EventRequestBody();
  }

  void updateEventDetails(
      {String? newTitle, String? newDescription, String? establishment}) {
    state = state.copyWith(
        eventTitle: newTitle,
        descriptions: newDescription,
        establishment: establishment);
  }

  void updateDateTime({
    DateTime? start,
    DateTime? end,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    state = state.copyWith(
        startDate: FormatterUtils.formatDateToString(start),
        endDate: FormatterUtils.formatDateToString(end),
        timeEnd: endTime,
        preEndDate: end,
        preStartDate: start,
        timeStart: startTime);
  }

  void updateEntryLevel({bool? freeEntry, String? pricing}) {
    state = state.copyWith(
      freeEntry: freeEntry,
      price: pricing != null ? double.parse(pricing).toStringAsFixed(2) : null,
    );
  }

  void updateAddressMap({String? address, double? lat, double? lng}) {
    state = state.copyWith(address: address, lat: lat, lng: lng);
  }

  void updateImage(String? feature) {
    state = state.copyWith(feature: feature);
  }

  Future onSave() async {
    try {
      AuthModel authModel =
          await FirestoreService(firebaseAuthService: firebaseAuthService)
              .getEmail(firebaseAuthService.currentUser!.uid);

      state = state.copyWith(
          authorEmail: authModel.email,
          authorId: firebaseAuthService.currentUser?.uid,
          authorName: authModel.fullname,
          authorFeature: authModel.avatar);

      await eventsRepository.createEvent(state);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  String? validateForm() {
    if (state.eventTitle == null ||
        state.eventTitle == "" ||
        state.descriptions == null ||
        state.descriptions == "" ||
        state.establishment == "" ||
        state.establishment == null) {
      return 'Please provide title, description and establishment for your event.';
    }
    if (state.address == null || state.address == "") {
      return 'Please provide specific map location for your event.';
    }
    if (state.freeEntry == false && state.price == null || state.price == "") {
      return 'Please provide price for your event tickets.';
    }

    if (state.timeEnd == null || state.timeStart == "") {
      return 'Please provide schedule time for your event.';
    }
    if (state.startDate == null || state.endDate == "") {
      return 'Please provide date for your event.';
    }
    return null;
  }
}
