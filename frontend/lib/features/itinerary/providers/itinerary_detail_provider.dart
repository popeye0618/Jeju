import 'package:jeju_together/features/itinerary/data/models/itinerary_detail.dart';
import 'package:jeju_together/features/itinerary/providers/itinerary_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'itinerary_detail_provider.g.dart';

/// 특정 일정의 상세 정보를 가져오는 AutoDispose FutureProvider family.
///
/// [id]는 일정 고유 식별자. 화면을 벗어나면 자동으로 캐시를 해제한다.
@riverpod
Future<ItineraryDetail> itineraryDetail(ItineraryDetailRef ref, int id) async {
  final repo = ref.watch(itineraryRepositoryProvider);
  return repo.getItineraryDetail(id);
}
