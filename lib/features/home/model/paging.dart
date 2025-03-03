// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Paging {
  final int? totalItem;
  final int? currentPage;
  final int? pageSize;
  final DocumentSnapshot? lastDocument;

  Paging({
    this.totalItem,
    this.currentPage,
    this.pageSize,
    this.lastDocument,
  });

  Paging copyWith({
    int? totalItem,
    int? currentPage,
    int? pageSize,
    DocumentSnapshot? lastDocument,
  }) {
    return Paging(
      totalItem: totalItem ?? this.totalItem,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }

  @override
  String toString() {
    return 'Paging(totalItem: $totalItem, currentPage: $currentPage, pageSize: $pageSize, lastDocument: $lastDocument)';
  }
}
