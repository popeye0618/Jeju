import 'package:jeju_together/core/network/dio_provider.dart';
import 'package:jeju_together/features/itinerary/data/itinerary_api.dart';
import 'package:jeju_together/features/itinerary/data/itinerary_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'itinerary_provider.g.dart';

@riverpod
ItineraryApi itineraryApi(ItineraryApiRef ref) =>
    ItineraryApi(ref.watch(dioProvider));

@riverpod
ItineraryRepository itineraryRepository(ItineraryRepositoryRef ref) =>
    ItineraryRepository(ref.watch(itineraryApiProvider));
