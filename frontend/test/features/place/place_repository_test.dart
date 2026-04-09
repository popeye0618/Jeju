import 'package:flutter_test/flutter_test.dart';
import 'package:jeju_together/core/network/api_response.dart';
import 'package:jeju_together/features/place/data/models/autocomplete_item.dart';
import 'package:jeju_together/features/place/data/models/place_summary.dart';
import 'package:jeju_together/features/place/data/place_api.dart';
import 'package:jeju_together/features/place/data/place_repository.dart';

class MockPlaceApi implements PlaceApi {
  final Map<String, dynamic> _placesResponse = {
    'success': true,
    'code': 'SUCCESS',
    'message': '',
    'data': {
      'content': [
        {
          'id': 1,
          'name': '성산일출봉',
          'category': '관광지',
          'address': '제주특별자치도 서귀포시',
          'thumbnail': null,
          'hasRamp': true,
          'hasElevator': false,
          'hasAccessibleToilet': true,
          'hasRestZone': true,
          'hasAccessibleParking': false,
          'isLiked': false,
        }
      ],
      'page': 0,
      'size': 20,
      'totalElements': 1,
      'totalPages': 1,
      'hasNext': false,
    },
  };

  @override
  Future<Map<String, dynamic>> getPlaces({
    String? category,
    String? accessibility,
    int? page,
    int? size,
  }) async =>
      _placesResponse;

  @override
  Future<Map<String, dynamic>> searchPlaces(
    String keyword, {
    int? page,
    int? size,
  }) async =>
      _placesResponse;

  @override
  Future<Map<String, dynamic>> autocomplete(String keyword) async => {
        'success': true,
        'code': 'SUCCESS',
        'message': '',
        'data': [
          {'id': 1, 'name': '성산일출봉', 'category': '관광지'},
        ],
      };

  @override
  Future<Map<String, dynamic>> getLikedPlaces({
    int? page,
    int? size,
  }) async =>
      _placesResponse;

  @override
  Future<Map<String, dynamic>> getRecentPlaces() async => {
        'success': true,
        'code': 'SUCCESS',
        'message': '',
        'data': [],
      };

  @override
  Future<Map<String, dynamic>> getPlaceDetail(int id) async => {
        'success': true,
        'code': 'SUCCESS',
        'message': '',
        'data': {
          'id': 1,
          'name': '성산일출봉',
          'category': '관광지',
          'address': '제주특별자치도 서귀포시',
          'thumbnail': null,
          'hasRamp': true,
          'hasElevator': false,
          'hasAccessibleToilet': true,
          'hasRestZone': true,
          'hasAccessibleParking': false,
          'isLiked': false,
          'lat': 33.458,
          'lng': 126.942,
          'reviewCount': 0,
          'avgRating': 0.0,
          'images': [],
        },
      };

  @override
  Future<Map<String, dynamic>> likePlace(int id) async => {
        'success': true,
        'code': 'SUCCESS',
        'message': '',
        'data': {'liked': true},
      };

  @override
  Future<Map<String, dynamic>> unlikePlace(int id) async => {
        'success': true,
        'code': 'SUCCESS',
        'message': '',
        'data': {'liked': false},
      };
}

void main() {
  group('PlaceRepository', () {
    late PlaceRepository sut;

    setUp(() {
      sut = PlaceRepository(MockPlaceApi());
    });

    test('getPlaces가 PageResponse<PlaceSummary>를 반환한다', () async {
      final result = await sut.getPlaces();

      expect(result, isA<PageResponse<PlaceSummary>>());
    });

    test('searchPlaces가 PageResponse<PlaceSummary>를 반환한다', () async {
      final result = await sut.searchPlaces(keyword: '성산');

      expect(result, isA<PageResponse<PlaceSummary>>());
    });

    test('autocomplete가 AutocompleteItem 목록을 반환한다', () async {
      final result = await sut.autocomplete('성산');

      expect(result, isA<List<AutocompleteItem>>());
    });

    test('likePlace가 true를 반환한다', () async {
      final result = await sut.likePlace(1);
      expect(result, isTrue);
    });

    test('unlikePlace가 false를 반환한다', () async {
      final result = await sut.unlikePlace(1);
      expect(result, isFalse);
    });
  });
}
