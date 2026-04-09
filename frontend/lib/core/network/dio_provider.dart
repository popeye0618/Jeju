import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'api_client.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(DioRef ref) => ApiClient.instance;
