import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/repository/firebase/profile_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/profiles/profile_service.dart';
import 'package:demo/features/home/controller/chat/chat_load_more.dart';
import 'package:demo/features/home/controller/chat/chat_loading_controller.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_following_search.g.dart';

@Riverpod(keepAlive: false)
class UserFollowingSearch extends _$UserFollowingSearch {
  late ProfileRepository profileRepository;
  DocumentSnapshot? lastDoc;
  int _pageSize = 15;
  @override
  Future<List<UserData>?> build() async {
    profileRepository = ProfileRepository(
        baseService:
            ProfileService(firebaseAuthService: FirebaseAuthService()));

    try {
      final searchQuery = ref.watch(searchFriendControllerProvider);
      return await getData(searchQuery);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  FutureOr<List<UserData>?> getData(String query) async {
    return await profileRepository.searchUserFollowingLists(
        FirebaseAuth.instance.currentUser?.uid ?? "",
        searchTerm: query,
        lastDoc: lastDoc,
        limit: _pageSize);
  }

  Future loadNextPage(searchQuery) async {
    try {
      ref.read(chatLoadingControllerProvider.notifier).setState(true);

      final totalFollowings = await profileRepository
          .getTotalFollowings(FirebaseAuth.instance.currentUser?.uid ?? "");

      if (totalFollowings >= _pageSize) {
        return;
      }
      _pageSize = _pageSize + 10;
      final latestItem = await profileRepository.searchUserFollowingLists(
          FirebaseAuth.instance.currentUser?.uid ?? "",
          searchTerm: searchQuery,
          lastDoc: lastDoc,
          limit: _pageSize);
      if (latestItem.isNotEmpty) {
        lastDoc = latestItem.last.documentSnapshot;
        state = AsyncData([
          ...(state.value ?? []),
          ...latestItem,
        ]);
      }
      debugPrint("Scrolled down to near top, loading older messages...");
      ref.read(chatLoadingControllerProvider.notifier).setState(true);
      _pageSize = _pageSize + 10;
      ref.invalidateSelf();
      ref.read(chatLoadMoreProvider.notifier).setState(true);
      ref.read(chatLoadingControllerProvider.notifier).setState(false);
    } catch (e) {
      ref.read(chatLoadMoreProvider.notifier).setState(true);
      ref.read(chatLoadingControllerProvider.notifier).setState(false);
    }
  }
}

@Riverpod(keepAlive: false)
class SearchFriendController extends _$SearchFriendController {
  @override
  String build() {
    return "";
  }

  void updateState(String value) {
    state = value;
  }

  void clearState() {
    state = "";
  }
}
