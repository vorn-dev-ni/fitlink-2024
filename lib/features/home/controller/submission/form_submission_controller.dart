import 'dart:io';

import 'package:demo/data/repository/firebase/events_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firebase/storage_service.dart';
import 'package:demo/data/service/firestore/events/event_service.dart';
import 'package:demo/features/home/model/submission.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'form_submission_controller.g.dart';

@Riverpod(keepAlive: true)
class FormSubmissionController extends _$FormSubmissionController {
  late StorageService storageService;
  late EventsRepository eventsRepository;
  late FirebaseAuthService firebaseAuthService;
  @override
  FormSubmission build() {
    firebaseAuthService = FirebaseAuthService();
    storageService = StorageService();
    eventsRepository = EventsRepository(
        baseService: EventService(firebaseAuthService: firebaseAuthService));
    return FormSubmission();
  }

  void updatePersonalInfo(
      {String? fullName, String? email, String? phoneNumber}) {
    state = state.copyWith(
        contactName: fullName, email: email, phoneNumber: phoneNumber);
  }

  void updateAddressInfo({String? address, String? country, String? zipCode}) {
    state =
        state.copyWith(address: address, country: country, zipCode: zipCode);
  }

  void updateDocumentInfo(
      {String? websiteUrl,
      List<String>? downloadUrlFiles,
      List<File>? temp_files}) {
    state = state.copyWith(
        website: websiteUrl,
        temporaryFiles: temp_files,
        userId: firebaseAuthService.currentUser!.uid,
        trainerCertification: temp_files != null ? true : false,
        proofDocuments: downloadUrlFiles);
  }

  Future save() async {
    try {
      Map<String, dynamic> data = state.toMap();
      await eventsRepository.uploadCertificate(data);
    } catch (e) {
      rethrow;
    }
  }

  Future getPdfDownloadUrls() async {
    try {
      List<String> urls = [];
      for (final uploadFile in state.temporaryFiles ?? []) {
        String fileName = HelpersUtils.getLastFileName(uploadFile.path);
        final result = await storageService.uploadFile(
            rootDir: 'files', file: uploadFile, fileName: fileName);
        if (result != null && result.containsKey('downloadUrl')) {
          urls.add(result['downloadUrl']);
        }
      }
      state = state.copyWith(
          proofDocuments: urls,
          trainerCertification: urls.isNotEmpty ? true : false);
    } catch (e) {
      rethrow;
    }
  }
}
