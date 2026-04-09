import 'package:dio/dio.dart';

class NotificationApi {
  NotificationApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> getNotifications() async {
    final response = await _dio.get<Map<String, dynamic>>('/notifications');
    return response.data!;
  }

  Future<Map<String, dynamic>> readAll() async {
    final response =
        await _dio.patch<Map<String, dynamic>>('/notifications/read-all');
    return response.data!;
  }

  Future<Map<String, dynamic>> readOne(int id) async {
    final response =
        await _dio.patch<Map<String, dynamic>>('/notifications/$id/read');
    return response.data!;
  }

  Future<Map<String, dynamic>> deleteNotification(int id) async {
    final response =
        await _dio.delete<Map<String, dynamic>>('/notifications/$id');
    return response.data!;
  }
}
