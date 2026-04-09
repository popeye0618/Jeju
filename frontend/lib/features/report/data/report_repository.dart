import 'package:dio/dio.dart';
import 'package:jeju_together/core/network/api_exception.dart';
import 'report_api.dart';

class ReportRepository {
  ReportRepository(this._api);

  final ReportApi _api;

  Future<Map<String, dynamic>> createReport(
      Map<String, dynamic> body) async {
    try {
      final raw = await _api.createReport(body);
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
