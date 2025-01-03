import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:demo/utils/exception/app_exception.dart';
import 'package:demo/utils/formatters/formatter_utils.dart';

class GeminiService {
  late final GenerativeModel model;
  GeminiService({required this.model});
  Future analyseContent(Iterable<Content> prompt) async {
    final response = await model.generateContent(prompt);
    final responseString = FormatterUtils.removeJsonString(response!.text!);
    print('Map response ${responseString}');
    Map<String, dynamic> mapResponse = json.decode(responseString);

    if (mapResponse.isNotEmpty) {
      if (mapResponse.containsKey('code')) {
        throw ValidationException(
          title: "Oops",
          message: mapResponse['message'],
        );
      }
    }

    return mapResponse;
  }
}
