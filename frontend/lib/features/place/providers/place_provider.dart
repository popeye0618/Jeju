import 'package:jeju_together/core/network/dio_provider.dart';
import 'package:jeju_together/features/place/data/place_api.dart';
import 'package:jeju_together/features/place/data/place_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'place_provider.g.dart';

@riverpod
PlaceApi placeApi(PlaceApiRef ref) => PlaceApi(ref.watch(dioProvider));

@riverpod
PlaceRepository placeRepository(PlaceRepositoryRef ref) =>
    PlaceRepository(ref.watch(placeApiProvider));
