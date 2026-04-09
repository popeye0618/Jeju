import 'package:jeju_together/core/network/dio_provider.dart';
import 'package:jeju_together/features/notification/data/notification_api.dart';
import 'package:jeju_together/features/notification/data/notification_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

@riverpod
NotificationApi notificationApi(NotificationApiRef ref) =>
    NotificationApi(ref.watch(dioProvider));

@riverpod
NotificationRepository notificationRepository(
        NotificationRepositoryRef ref) =>
    NotificationRepository(ref.watch(notificationApiProvider));
