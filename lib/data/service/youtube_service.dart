import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/https/https_client.dart';
import 'package:dio/dio.dart';

class YoutubeService {
  // final ApiRepository repository;
  final HttpsClient httpClient;
  final String url;
  YoutubeService({required this.httpClient, required this.url});

  Future<dynamic> getYoutubeList() async {
    try {
      final Response? response = await httpClient.get(url);
      print("Response > url is ${url}");
      if (response != null) {
        return HelpersUtils.validateResponse(response)
            .data; // Validate response here
      } else {
        throw Exception("No response received");
      }
    } catch (e) {
      rethrow;
    }
  }
}
