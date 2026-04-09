import 'package:dio/dio.dart';
import 'package:jeju_together/core/network/api_exception.dart';
import 'package:jeju_together/core/network/api_response.dart';
import 'package:jeju_together/features/place/data/models/autocomplete_item.dart';
import 'package:jeju_together/features/place/data/models/place_detail.dart';
import 'package:jeju_together/features/place/data/models/place_summary.dart';
import 'package:jeju_together/features/place/data/models/recent_place.dart';
import 'place_api.dart';

class PlaceRepository {
  PlaceRepository(this._api);

  final PlaceApi _api;

  Future<PageResponse<PlaceSummary>> getPlaces({
    String? category,
    String? accessibility,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final raw = await _api.getPlaces(
        category: category,
        accessibility: accessibility,
        page: page,
        size: size,
      );
      final data = raw['data'] as Map<String, dynamic>;
      return PageResponse<PlaceSummary>.fromJson(
        data,
        (json) => PlaceSummary.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PageResponse<PlaceSummary>> searchPlaces({
    required String keyword,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final raw = await _api.searchPlaces(keyword, page: page, size: size);
      final data = raw['data'] as Map<String, dynamic>;
      return PageResponse<PlaceSummary>.fromJson(
        data,
        (json) => PlaceSummary.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<AutocompleteItem>> autocomplete(String keyword) async {
    try {
      final raw = await _api.autocomplete(keyword);
      final list = raw['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => AutocompleteItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PageResponse<PlaceSummary>> getLikedPlaces({
    int page = 0,
    int size = 20,
  }) async {
    try {
      final raw = await _api.getLikedPlaces(page: page, size: size);
      final data = raw['data'] as Map<String, dynamic>;
      return PageResponse<PlaceSummary>.fromJson(
        data,
        (json) => PlaceSummary.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<RecentPlace>> getRecentPlaces() async {
    try {
      final raw = await _api.getRecentPlaces();
      final list = raw['data'] as List<dynamic>? ?? [];
      return list
          .map((e) => RecentPlace.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<PlaceDetail> getPlaceDetail(int id) async {
    try {
      final raw = await _api.getPlaceDetail(id);
      final data = raw['data'] as Map<String, dynamic>;
      return PlaceDetail.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<bool> likePlace(int id) async {
    try {
      final raw = await _api.likePlace(id);
      final data = raw['data'] as Map<String, dynamic>?;
      return data?['liked'] as bool? ?? true;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<bool> unlikePlace(int id) async {
    try {
      final raw = await _api.unlikePlace(id);
      final data = raw['data'] as Map<String, dynamic>?;
      return data?['liked'] as bool? ?? false;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
