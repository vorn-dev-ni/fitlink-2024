import 'package:dio/dio.dart';

class ApiClient {
  static final ApiClient _singleton = ApiClient._internal();
  late Dio dio;

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://us-central1-fitlink-b3d6b.cloudfunctions.net',
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
}
