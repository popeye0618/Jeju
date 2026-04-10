import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeju_together/features/itinerary/data/models/itinerary_summary.dart';
import 'package:jeju_together/features/itinerary/providers/itinerary_provider.dart';
import 'package:jeju_together/features/place/data/models/place_summary.dart';
import 'package:jeju_together/features/place/providers/place_provider.dart';

/// 홈 화면 데이터: 맞춤 추천 일정 (최대 3개)
final recommendedItinerariesProvider =
    FutureProvider<List<ItinerarySummary>>((ref) async {
  final repo = ref.watch(itineraryRepositoryProvider);
  final result = await repo.getRecommend(page: 0, size: 3);
  return result.content;
});

/// 홈 화면 데이터: 인기 장소 (무장애 필터, 최대 6개)
final popularPlacesProvider = FutureProvider<List<PlaceSummary>>((ref) async {
  final repo = ref.watch(placeRepositoryProvider);
  final result = await repo.getPlaces(page: 0, size: 6);
  return result.content;
});
