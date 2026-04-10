import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeju_together/features/itinerary/data/models/itinerary_detail.dart';
import 'package:jeju_together/features/itinerary/data/models/place_in_itinerary.dart';
import 'package:jeju_together/features/itinerary/presentation/itinerary_detail_screen.dart';
import 'package:jeju_together/features/itinerary/providers/itinerary_detail_provider.dart';

// ── 테스트용 데이터 픽스처 ─────────────────────────────────────────────────────

const _tPlaceA = PlaceInItinerary(
  id: 1,
  name: '성산일출봉',
  order: 1,
  day: 1,
  lat: 33.458,
  lng: 126.942,
  estimatedMinutes: 90,
  hasRamp: true,
  hasElevator: true,
  hasAccessibleToilet: true,
  hasRestZone: true,
  hasAccessibleParking: false,
);

const _tPlaceB = PlaceInItinerary(
  id: 2,
  name: '우도',
  order: 2,
  day: 1,
  lat: 33.501,
  lng: 126.953,
  estimatedMinutes: 60,
  hasRamp: false,
  hasElevator: false,
  hasAccessibleToilet: false,
  hasRestZone: false,
  hasAccessibleParking: false,
);

const _tPlaceDay2 = PlaceInItinerary(
  id: 3,
  name: '한라산',
  order: 1,
  day: 2,
  lat: 33.361,
  lng: 126.533,
  estimatedMinutes: 180,
  hasRamp: true,
  hasElevator: false,
  hasAccessibleToilet: false,
  hasRestZone: true,
  hasAccessibleParking: true,
);

const _tDetailHighScore = ItineraryDetail(
  id: 1,
  title: '제주 무장애 2일 코스',
  days: 2,
  estimatedTime: 480,
  savedCount: 12,
  isSaved: false,
  places: [_tPlaceA, _tPlaceDay2],
);

const _tDetailLowScore = ItineraryDetail(
  id: 2,
  title: '제주 저점수 코스',
  days: 1,
  estimatedTime: 240,
  savedCount: 3,
  isSaved: false,
  places: [_tPlaceB],
);

const _tDetailSaved = ItineraryDetail(
  id: 3,
  title: '저장된 일정',
  days: 1,
  estimatedTime: 120,
  savedCount: 5,
  isSaved: true,
  places: [_tPlaceA],
);

const _tDetailEmpty = ItineraryDetail(
  id: 4,
  title: '장소 없는 일정',
  days: 1,
  estimatedTime: 0,
  savedCount: 0,
  isSaved: false,
);

const _tDetailSafeOnly = ItineraryDetail(
  id: 10,
  title: '안전 일정',
  days: 1,
  estimatedTime: 90,
  savedCount: 1,
  isSaved: false,
  places: [_tPlaceA], // score=100
);

// ── 위젯 테스트 헬퍼 ──────────────────────────────────────────────────────────

Widget _buildTestWidget(ItineraryDetail detail) {
  return ProviderScope(
    overrides: [
      itineraryDetailProvider(1).overrideWith(
        (ref) async => detail,
      ),
    ],
    child: const MaterialApp(
      home: ItineraryDetailScreen(itineraryId: 1),
    ),
  );
}

Widget _buildErrorWidget() {
  return ProviderScope(
    overrides: [
      itineraryDetailProvider(1).overrideWith(
        (ref) async => throw Exception('네트워크 오류'),
      ),
    ],
    child: const MaterialApp(
      home: ItineraryDetailScreen(itineraryId: 1),
    ),
  );
}

void main() {
  group('ItineraryDetailScreen — 로딩 상태', () {
    testWidgets('로딩 중일 때 CircularProgressIndicator가 표시된다', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            itineraryDetailProvider(1).overrideWith(
              (ref) => Future.delayed(const Duration(seconds: 10)),
            ),
          ],
          child: const MaterialApp(
            home: ItineraryDetailScreen(itineraryId: 1),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('ItineraryDetailScreen — 에러 상태', () {
    testWidgets('API 오류 시 에러 메시지와 돌아가기 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_buildErrorWidget());
      await tester.pump();

      expect(find.text('일정을 불러오지 못했어요'), findsOneWidget);
      expect(find.text('돌아가기'), findsOneWidget);
    });
  });

  group('ItineraryDetailScreen — 데이터 정상 표시', () {
    testWidgets('일정 제목이 커버 영역에 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailHighScore));
      await tester.pump();

      expect(find.text('제주 무장애 2일 코스'), findsOneWidget);
    });

    testWidgets('N일 코스 eyebrow 텍스트가 올바른 일수로 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailHighScore));
      await tester.pump();

      expect(find.text('2일 코스'), findsOneWidget);
    });

    testWidgets('안전 점수 카드가 렌더링된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailHighScore));
      await tester.pump();

      expect(find.text('이 일정의 안전 점수'), findsOneWidget);
      expect(find.text('SAFE'), findsOneWidget);
    });

    testWidgets('뷰 토글 탭 2개가 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailHighScore));
      await tester.pump();

      expect(find.textContaining('타임라인'), findsOneWidget);
      expect(find.textContaining('지도 보기'), findsOneWidget);
    });

    testWidgets('Day 탭이 places의 day 수만큼 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailHighScore));
      await tester.pump();

      // _tDetailHighScore: day 1, day 2 → 탭 2개
      expect(find.text('1일차'), findsOneWidget);
      expect(find.text('2일차'), findsOneWidget);
    });

    testWidgets('타임라인에 1일차 장소명이 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailHighScore));
      await tester.pump();

      expect(find.text('성산일출봉'), findsOneWidget);
    });

    testWidgets('타임라인 시작 시간이 09:00으로 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailHighScore));
      await tester.pump();

      expect(find.text('09:00'), findsOneWidget);
    });
  });

  group('ItineraryDetailScreen — 경고 배너', () {
    testWidgets('접근성 점수가 낮을 때 경고 배너가 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailLowScore));
      await tester.pump();

      expect(find.text('일부 구간 주의가 필요해요'), findsOneWidget);
    });

    testWidgets('접근성 점수가 100점일 때 경고 배너가 표시되지 않는다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailSafeOnly));
      await tester.pump();

      expect(find.text('일부 구간 주의가 필요해요'), findsNothing);
    });
  });

  group('ItineraryDetailScreen — 빈 장소 상태', () {
    testWidgets('장소가 없을 때 빈 상태 메시지가 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailEmpty));
      await tester.pump();

      expect(find.text('아직 장소 정보가 없어요'), findsOneWidget);
    });
  });

  group('ItineraryDetailScreen — 저장 상태', () {
    testWidgets('isSaved가 true이면 저장됨 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailSaved));
      await tester.pump();

      expect(find.text('저장됨'), findsOneWidget);
    });

    testWidgets('isSaved가 false이면 일정 저장하기 버튼이 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailHighScore));
      await tester.pump();

      expect(find.text('일정 저장하기'), findsOneWidget);
    });

    testWidgets('저장 버튼 탭 시 저장됨 텍스트로 변경된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailHighScore));
      await tester.pump();

      await tester.tap(find.text('일정 저장하기'));
      await tester.pump();

      expect(find.text('저장됨'), findsOneWidget);
    });
  });

  group('ItineraryDetailScreen — 뷰 토글', () {
    testWidgets('지도 보기 탭 선택 시 지도 플레이스홀더가 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailHighScore));
      await tester.pump();

      await tester.tap(find.textContaining('지도 보기'));
      await tester.pump();

      expect(find.text('지도 보기 준비 중이에요'), findsOneWidget);
    });
  });

  group('ItineraryDetailScreen — 하단 액션 바', () {
    testWidgets('다른 코스 버튼이 항상 표시된다', (tester) async {
      await tester.pumpWidget(_buildTestWidget(_tDetailHighScore));
      await tester.pump();

      expect(find.text('다른 코스'), findsOneWidget);
    });
  });
}
