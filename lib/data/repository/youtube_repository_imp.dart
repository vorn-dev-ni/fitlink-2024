// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:demo/common/model/youtube_model.dart';
import 'package:demo/data/repository/api_repository.dart';
import 'package:demo/data/service/youtube_service.dart';

class YoutubeRepository implements ApiRepository<YouTubeSearchResponse> {
  late YoutubeService youtubeService;
  YoutubeRepository({required this.youtubeService});

  @override
  Future<YouTubeSearchResponse> create(Map<String, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future deleteById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<YouTubeSearchResponse?> getAll() async {
    try {
      final response = await youtubeService.getYoutubeList();
      if (response != null) {
        return YouTubeSearchResponse?.fromJson(response);
      }
      return null;
    } catch (e) {
      print("Error in YoutubeRepository.fetch: $e");
      rethrow;
    }
  }

  @override
  Future updateById(String id, Map<String, dynamic> data) {
    throw UnimplementedError();
  }
}
