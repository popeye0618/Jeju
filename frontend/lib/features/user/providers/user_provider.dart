import 'package:jeju_together/core/network/dio_provider.dart';
import 'package:jeju_together/features/user/data/user_api.dart';
import 'package:jeju_together/features/user/data/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
UserApi userApi(UserApiRef ref) => UserApi(ref.watch(dioProvider));

@riverpod
UserRepository userRepository(UserRepositoryRef ref) =>
    UserRepository(ref.watch(userApiProvider));
