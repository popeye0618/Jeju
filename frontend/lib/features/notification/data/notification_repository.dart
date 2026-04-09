import 'package:dio/dio.dart';
import 'package:jeju_together/core/network/api_exception.dart';
import 'package:jeju_together/features/notification/data/models/notification_item.dart';
import 'notification_api.dart';

class NotificationRepository {
  NotificationRepository(this._api);

  final NotificationApi _api;

  Future<Map<String, dynamic>> getNotifications() async {
    try {
      final raw = await _api.getNotifications();
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<NotificationItem>> getNotificationList() async {
    final data = await getNotifications();
    final list = data['notifications'] as List<dynamic>? ?? [];
    return list
        .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<int> readAll() async {
    try {
      final raw = await _api.readAll();
      final data = raw['data'] as Map<String, dynamic>?;
      return data?['updatedCount'] as int? ?? 0;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> readOne(int id) async {
    try {
      final raw = await _api.readOne(id);
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      await _api.deleteNotification(id);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
