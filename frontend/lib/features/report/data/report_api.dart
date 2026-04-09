import 'package:dio/dio.dart';

class ReportApi {
  ReportApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> createReport(Map<String, dynamic> body) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/reports', data: body);
    return response.data!;
  }
}
