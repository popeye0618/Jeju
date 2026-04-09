import 'package:jeju_together/core/network/dio_provider.dart';
import 'package:jeju_together/features/auth/data/auth_api.dart';
import 'package:jeju_together/features/auth/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
AuthApi authApi(AuthApiRef ref) => AuthApi(ref.watch(dioProvider));

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) =>
    AuthRepository(ref.watch(authApiProvider));
