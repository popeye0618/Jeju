import 'package:dio/dio.dart';

class PlaceApi {
  PlaceApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> getPlaces({
    String? category,
    String? accessibility,
    int? page,
    int? size,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/places',
      queryParameters: {
        if (category != null) 'category': category,
        if (accessibility != null) 'accessibility': accessibility,
        if (page != null) 'page': page,
        if (size != null) 'size': size,
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> searchPlaces(
    String keyword, {
    int? page,
    int? size,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/places/search',
      queryParameters: {
        'keyword': keyword,
        if (page != null) 'page': page,
        if (size != null) 'size': size,
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> autocomplete(String keyword) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/places/search/autocomplete',
      queryParameters: {'keyword': keyword},
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> getLikedPlaces({
    int? page,
    int? size,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/places/liked',
      queryParameters: {
        if (page != null) 'page': page,
        if (size != null) 'size': size,
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> getRecentPlaces() async {
    final response = await _dio.get<Map<String, dynamic>>('/places/recent');
    return response.data!;
  }

  Future<Map<String, dynamic>> getPlaceDetail(int id) async {
    final response = await _dio.get<Map<String, dynamic>>('/places/$id');
    return response.data!;
  }

  Future<Map<String, dynamic>> likePlace(int id) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/places/$id/like');
    return response.data!;
  }

  Future<Map<String, dynamic>> unlikePlace(int id) async {
    final response =
        await _dio.delete<Map<String, dynamic>>('/places/$id/like');
    return response.data!;
  }
}
