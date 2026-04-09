import 'package:dio/dio.dart';
import 'package:jeju_together/core/network/api_exception.dart';
import 'package:jeju_together/core/network/api_response.dart';
import 'package:jeju_together/features/itinerary/data/models/alternative_itinerary.dart';
import 'package:jeju_together/features/itinerary/data/models/itinerary_detail.dart';
import 'package:jeju_together/features/itinerary/data/models/itinerary_summary.dart';
import 'itinerary_api.dart';

class ItineraryRepository {
  ItineraryRepository(this._api);

  final ItineraryApi _api;

  Future<PageResponse<ItinerarySummary>> getRecommend({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final raw = await _api.getRecommend(page: page, size: size);
      final data = raw['data'] as Map<String, dynamic>;
      return PageResponse<ItinerarySummary>.fromJson(
        data,
        (json) =>
            ItinerarySummary.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PageResponse<ItinerarySummary>> getMyItineraries({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final raw = await _api.getMyItineraries(page: page, size: size);
      final data = raw['data'] as Map<String, dynamic>;
      return PageResponse<ItinerarySummary>.fromJson(
        data,
        (json) =>
            ItinerarySummary.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> createItinerary(
      Map<String, dynamic> body) async {
    try {
      final raw = await _api.createItinerary(body);
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<ItineraryDetail> getItineraryDetail(int id) async {
    try {
      final raw = await _api.getItineraryDetail(id);
      final data = raw['data'] as Map<String, dynamic>;
      return ItineraryDetail.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> updateItinerary(
      int id, Map<String, dynamic> body) async {
    try {
      final raw = await _api.updateItinerary(id, body);
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> deleteItinerary(int id) async {
    try {
      await _api.deleteItinerary(id);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> saveItinerary(int id) async {
    try {
      final raw = await _api.saveItinerary(id);
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> unsaveItinerary(int id) async {
    try {
      final raw = await _api.unsaveItinerary(id);
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<AlternativeItinerary>> getAlternative(int id) async {
    try {
      final raw = await _api.getAlternative(id);
      final list = raw['data'] as List<dynamic>? ?? [];
      return list
          .map((e) =>
              AlternativeItinerary.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Map<String, dynamic>> shareItinerary(int id) async {
    try {
      final raw = await _api.shareItinerary(id);
      return raw['data'] as Map<String, dynamic>? ?? {};
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
