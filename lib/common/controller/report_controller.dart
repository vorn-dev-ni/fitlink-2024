import 'package:demo/common/model/report_model.dart';
import 'package:demo/data/service/remote/report_service.dart';
import 'package:demo/network/dio/api_client.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'report_controller.g.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

@Riverpod(keepAlive: true)
class ReportController extends _$ReportController {
  late final ReportService reportService;

  @override
  void build() {
    final apiClient = ref.read(apiClientProvider);
    reportService = ReportService(apiClient);
  }

  Future<void> sendReport({
    required String reason,
    required String postId,
    required String type,
  }) async {
    final reportData = ReportData(
      reason: reason,
      postId: postId,
      type: type,
    );

    try {
      await reportService.sendReport(
          postId: reportData.postId, type: reportData.type);
      debugPrint('Report sent: $reportData');
      Fluttertoast.showToast(
          msg: "Our team will reivew your report shortly.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.secondaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      debugPrint('Error sending report: $e');
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.errorColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
