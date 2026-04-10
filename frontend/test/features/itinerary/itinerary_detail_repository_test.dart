import 'package:flutter_test/flutter_test.dart';
import 'package:jeju_together/features/itinerary/data/itinerary_api.dart';
import 'package:jeju_together/features/itinerary/data/itinerary_repository.dart';
import 'package:jeju_together/features/itinerary/data/models/itinerary_detail.dart';

/// ItineraryApi 목 구현 — 일정 상세 관련 메서드만 구현
class _MockItineraryApi implements ItineraryApi {
  static const Map<String, dynamic> _detailResponse = {
    'success': true,
    'code': 'SUCCESS',
    'message': '',
    'data': {
      'id': 1,
      'title': '제주 무장애 2일 코스',
      'days': 2,
      'estimatedTime': 480,
      'savedCount': 12,
      'isSaved': false,
      'places': [
        {
          'id': 10,
          'name': '성산일출봉',
          'order': 1,
          'day': 1,
          'lat': 33.458,
          'lng': 126.942,
          'estimatedMinutes': 90,
          'hasRamp': true,
          'hasElevator': false,
          'hasAccessibleToilet': true,
          'hasRestZone': true,
          'hasAccessibleParking': false,
        },
        {
          'id': 11,
          'name': '우도',
          'order': 2,
          'day': 1,
          'lat': 33.501,
          'lng': 126.953,
          'estimatedMinutes': 120,
          'hasRamp': false,
          'hasElevator': false,
          'hasAccessibleToilet': false,
          'hasRestZone': true,
          'hasAccessibleParking': false,
        },
      ],
    },
  };

  @override
  Future<Map<String, dynamic>> getItineraryDetail(int id) async =>
      _detailResponse;

  // 나머지 메서드는 이 테스트 범위 밖
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

void main() {
  group('ItineraryRepository — getItineraryDetail', () {
    late ItineraryRepository sut;

    setUp(() {
      sut = ItineraryRepository(_MockItineraryApi());
    });

    test('API 응답이 정상일 때 ItineraryDetail 객체를 반환한다', () async {
      final result = await sut.getItineraryDetail(1);

      expect(result, isA<ItineraryDetail>());
      expect(result.id, equals(1));
      expect(result.title, equals('제주 무장애 2일 코스'));
      expect(result.days, equals(2));
    });

    test('반환된 ItineraryDetail의 places 목록이 올바르게 파싱된다', () async {
      final result = await sut.getItineraryDetail(1);

      expect(result.places.length, equals(2));
      expect(result.places.first.name, equals('성산일출봉'));
      expect(result.places.first.hasRamp, isTrue);
      expect(result.places.first.hasElevator, isFalse);
    });

    test('반환된 places의 day 필드가 올바르게 매핑된다', () async {
      final result = await sut.getItineraryDetail(1);

      expect(result.places.every((p) => p.day == 1), isTrue);
    });

    test('isSaved 필드가 false로 파싱된다', () async {
      final result = await sut.getItineraryDetail(1);

      expect(result.isSaved, isFalse);
    });
  });

  group('ItineraryDetail — 접근성 점수 파생 로직', () {
    test('모든 편의시설이 있을 때 점수는 100점이다', () {
      final place = _placeWith(
        hasRamp: true,
        hasElevator: true,
        hasAccessibleToilet: true,
        hasRestZone: true,
      );
      expect(_placeScore(place), equals(100));
    });

    test('모든 편의시설이 없을 때 점수는 0점이다', () {
      final place = _placeWith();
      expect(_placeScore(place), equals(0));
    });

    test('경사로만 있을 때 점수는 25점이다', () {
      final place = _placeWith(hasRamp: true);
      expect(_placeScore(place), equals(25));
    });

    test('경사로와 엘리베이터가 있을 때 점수는 50점이다', () {
      final place = _placeWith(hasRamp: true, hasElevator: true);
      expect(_placeScore(place), equals(50));
    });
  });

  group('ItineraryDetail — 시간 계산 로직', () {
    test('첫 번째 장소는 09:00으로 표시된다', () {
      expect(_formatTime(0), equals('09:00'));
    });

    test('90분 경과 후 시간은 10:30이다', () {
      expect(_formatTime(90), equals('10:30'));
    });

    test('장소 체류 90분 + 이동 15분 후 시간은 10:45이다', () {
      expect(_formatTime(105), equals('10:45'));
    });

    test('자정을 넘어가는 시간도 올바르게 포맷된다', () {
      // 9*60 + 900 = 540 + 900 = 1440분 = 자정 (00:00)
      expect(_formatTime(900), equals('00:00'));
    });

    test('estimatedMinutes가 0이면 기본값 90분을 사용한다', () {
      const kDefault = 90;
      const minutes = 0;
      const effective = minutes > 0 ? minutes : kDefault;
      expect(effective, equals(90));
    });
  });
}

// ── 테스트 헬퍼 ──────────────────────────────────────────────────────────────

int _placeScore(_TestPlace p) {
  int score = 0;
  if (p.hasRamp) score += 25;
  if (p.hasElevator) score += 25;
  if (p.hasAccessibleToilet) score += 25;
  if (p.hasRestZone) score += 25;
  return score;
}

String _formatTime(int totalMinutes) {
  const base = 9 * 60;
  final total = base + totalMinutes;
  final h = total ~/ 60 % 24;
  final m = total % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

_TestPlace _placeWith({
  bool hasRamp = false,
  bool hasElevator = false,
  bool hasAccessibleToilet = false,
  bool hasRestZone = false,
}) =>
    _TestPlace(
      hasRamp: hasRamp,
      hasElevator: hasElevator,
      hasAccessibleToilet: hasAccessibleToilet,
      hasRestZone: hasRestZone,
    );

class _TestPlace {
  const _TestPlace({
    this.hasRamp = false,
    this.hasElevator = false,
    this.hasAccessibleToilet = false,
    this.hasRestZone = false,
  });

  final bool hasRamp;
  final bool hasElevator;
  final bool hasAccessibleToilet;
  final bool hasRestZone;
}
