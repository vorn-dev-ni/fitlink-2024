import 'package:dio/dio.dart';

class HttpsClient {
  static HttpsClient instances = HttpsClient._internal();

  factory HttpsClient() {
    return instances;
  }

  late final Dio httpClients;

  HttpsClient._internal() {
    initHttpClients();
  }

  Future<void> initHttpClients() async {
    httpClients = Dio();
    httpClients.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        // Modify or log the request here
        // print("Request [${options.method}] => PATH: ${options.path}");
        return handler.next(options); // Continue the request
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // Handle or log the response
        // print("Response [${response.statusCode}] => DATA: ${response.data}");
        return handler.next(response); // Continue to pass the response
      },
      onError: (DioError error, ErrorInterceptorHandler handler) {
        // Handle or log the error
        print(
            "Error [${error.response?.statusCode}] => MESSAGE: ${error.message}");
        return handler.next(error); // Continue to pass the error
      },
    ));
  }

  Future<Response?> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await httpClients.get(url, queryParameters: queryParameters);
      return response;
    } catch (e) {
      print("GET request error: $e");
      return null;
    }
  }

  Future<Response?> post(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await httpClients.post(url, data: data);
      return response;
    } catch (e) {
      print("POST request error: $e");
      return null;
    }
  }

  Future<Response?> put(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await httpClients.put(url, data: data);
      return response;
    } catch (e) {
      print("PUT request error: $e");
      return null;
    }
  }

  Future<Response?> delete(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await httpClients.delete(url, data: data);
      return response;
    } catch (e) {
      print("DELETE request error: $e");
      return null;
    }
  }
}
