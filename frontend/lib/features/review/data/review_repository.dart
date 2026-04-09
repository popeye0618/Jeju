import 'package:dio/dio.dart';
import 'package:jeju_together/core/network/api_exception.dart';
import 'package:jeju_together/core/network/api_response.dart';
import 'package:jeju_together/features/review/data/models/review_item.dart';
import 'review_api.dart';

class ReviewRepository {
  ReviewRepository(this._api);

  final ReviewApi _api;

  Future<Map<String, dynamic>> createReview(
      Map<String, dynamic> body) async {
    try {
      final raw = await _api.createReview(body);
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PageResponse<ReviewItem>> getReviews({
    int? placeId,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final raw = await _api.getReviews(
        placeId: placeId,
        page: page,
        size: size,
      );
      final data = raw['data'] as Map<String, dynamic>;
      return PageResponse<ReviewItem>.fromJson(
        data,
        (json) => ReviewItem.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> deleteReview(int id) async {
    try {
      await _api.deleteReview(id);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
