import 'package:demo/common/widget/video_tiktok.dart';
import 'package:demo/data/repository/firebase/video_repo.dart';
import 'package:demo/data/service/firebase/firebase_service.dart';
import 'package:demo/data/service/firestore/video/video_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'video_search_controller.g.dart';

@Riverpod(keepAlive: false)
class VideoSearchController extends _$VideoSearchController {
  late VideoRepository videoRepository;
  @override
  Future<List<VideoTikTok>> build(String query, List<String>? tag) async {
    videoRepository = VideoRepository(
        videoService: VideoService(firebaseAuthService: FirebaseAuthService()));

    return await getSearchData();
  }

  FutureOr<List<VideoTikTok>> getSearchData() async {
    try {
      return await videoRepository.searchVideo(
          searchQuery: query.trim(), tag: tag);
    } catch (e) {
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
class RecentSearchController extends _$RecentSearchController {
  static const String _recentSearchesKey = 'recent_searches';
  @override
  Future<List<String>> build() async {
    return await _getRecentSearches();
  }

  Future<List<String>> _getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentSearchesKey) ?? [];
  }

  Future<void> addSearch(String query) async {
    if (query.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    List<String> searches = await _getRecentSearches();

    searches.remove(query);
    searches.insert(0, query);

    if (searches.length > 10) {
      searches = searches.sublist(0, 10);
    }
    await prefs.setStringList(_recentSearchesKey, searches);
    ref.invalidateSelf();
  }

  Future<void> deleteRecentSearch(int index) async {
    if (index < 0) return;

    final prefs = await SharedPreferences.getInstance();
    List<String> searches = await _getRecentSearches();

    if (index >= searches.length) return;

    searches.removeAt(index);

    await prefs.setStringList(_recentSearchesKey, searches);

    ref.invalidateSelf();
  }

  Future<void> clearSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
    ref.invalidateSelf();
  }
}
