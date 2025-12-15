import 'package:demo/network/dio/api_client.dart';
import 'package:flutter/material.dart';

class ReportService {
  late final ApiClient apiClient;
  ReportService(this.apiClient);

  Future<void> sendReport({
    required String type,
    required String postId,
  }) async {
    final data = {'type': type, 'postId': postId};

    try {
      final response =
          await this.apiClient.dio.post('/reportEndpoint', data: data);
      debugPrint('Report sent: ${response.data}');
    } catch (e) {
      debugPrint('Error sending report: $e');
      rethrow;
    }
  }
}
