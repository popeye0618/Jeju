import 'package:dio/dio.dart';

class ReviewApi {
  ReviewApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> createReview(Map<String, dynamic> body) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/reviews', data: body);
    return response.data!;
  }

  Future<Map<String, dynamic>> getReviews({
    int? placeId,
    int? page,
    int? size,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/reviews',
      queryParameters: {
        if (placeId != null) 'placeId': placeId,
        if (page != null) 'page': page,
        if (size != null) 'size': size,
      },
    );
    return response.data!;
  }

  Future<Map<String, dynamic>> deleteReview(int id) async {
    final response = await _dio.delete<Map<String, dynamic>>('/reviews/$id');
    return response.data!;
  }
}
