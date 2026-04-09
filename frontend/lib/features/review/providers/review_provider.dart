import 'package:jeju_together/core/network/dio_provider.dart';
import 'package:jeju_together/features/review/data/review_api.dart';
import 'package:jeju_together/features/review/data/review_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_provider.g.dart';

@riverpod
ReviewApi reviewApi(ReviewApiRef ref) => ReviewApi(ref.watch(dioProvider));

@riverpod
ReviewRepository reviewRepository(ReviewRepositoryRef ref) =>
    ReviewRepository(ref.watch(reviewApiProvider));
