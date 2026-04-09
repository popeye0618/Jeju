import 'package:dio/dio.dart';

class ItineraryApi {
  ItineraryApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> getRecommend({int? page, int? size}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/itineraries/recommend',
      queryParameters: {
        if (page != null) 'page': page,
        if (size != null) 'size': size,
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> getMyItineraries({int? page, int? size}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/itineraries/my',
      queryParameters: {
        if (page != null) 'page': page,
        if (size != null) 'size': size,
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> createItinerary(
      Map<String, dynamic> body) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/itineraries', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> getItineraryDetail(int id) async {
    final response =
        await _dio.get<Map<String, dynamic>>('/itineraries/$id');
    return response.data!;
  }

  Future<Map<String, dynamic>> updateItinerary(
      int id, Map<String, dynamic> body) async {
    final response =
        await _dio.put<Map<String, dynamic>>('/itineraries/$id', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> deleteItinerary(int id) async {
    final response =
        await _dio.delete<Map<String, dynamic>>('/itineraries/$id');
    return response.data!;
  }

  Future<Map<String, dynamic>> saveItinerary(int id) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/itineraries/$id/save');
    return response.data!;
  }

  Future<Map<String, dynamic>> unsaveItinerary(int id) async {
    final response =
        await _dio.delete<Map<String, dynamic>>('/itineraries/$id/save');
    return response.data!;
  }

  Future<Map<String, dynamic>> getAlternative(int id) async {
    final response =
        await _dio.get<Map<String, dynamic>>('/itineraries/$id/alternative');
    return response.data!;
  }

  Future<Map<String, dynamic>> shareItinerary(int id) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/itineraries/$id/share');
    return response.data!;
  }
}
