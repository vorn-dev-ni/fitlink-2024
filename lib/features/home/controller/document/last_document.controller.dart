import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'last_document.controller.g.dart';

@riverpod
class LastDocumentNotifier extends _$LastDocumentNotifier {
  DocumentSnapshot? lastDocument;

  @override
  DocumentSnapshot? build() {
    return lastDocument; // Ensure we return the correct type here.
  }

  void setLastDocument(DocumentSnapshot document) {
    lastDocument = document;
  }

  void clearLastDocument() {
    lastDocument = null;
  }
}
