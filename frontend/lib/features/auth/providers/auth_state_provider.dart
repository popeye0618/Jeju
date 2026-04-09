import 'package:jeju_together/core/network/dio_provider.dart';
import 'package:jeju_together/core/storage/secure_storage_service.dart';
import 'package:jeju_together/features/auth/data/models/auth_user.dart';
import 'package:jeju_together/features/auth/data/models/social_login_response.dart';
import 'package:jeju_together/features/auth/data/models/token_response.dart';
import 'package:jeju_together/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  AsyncValue<AuthUser?> build() {
    _initialize();
    return const AsyncValue.loading();
  }

  Future<void> _initialize() async {
    final storage = ref.read(secureStorageServiceProvider);
    final accessToken = await storage.getAccessToken();
    if (accessToken == null) {
      state = const AsyncValue.data(null);
      return;
    }

    // 저장된 토큰으로 세션 복원 시도
    state = await AsyncValue.guard(() async {
      final dio = ref.read(dioProvider);
      final res = await dio.get<Map<String, dynamic>>('/users/me');
      final data = (res.data?['data'] as Map<String, dynamic>?) ?? {};
      return AuthUser(
        userId: (data['userId'] as int?) ?? 0,
        email: data['email'] as String? ?? '',
        nickname: data['nickname'] as String?,
        onboardingComplete: data['onboardingComplete'] as bool? ?? false,
      );
    });

    // 토큰 만료 등으로 실패 시 로컬 토큰 삭제
    if (state.hasError) {
      await storage.clearTokens();
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final storage = ref.read(secureStorageServiceProvider);
      final TokenResponse token = await repo.login(
        email: email,
        password: password,
      );
      await storage.saveTokens(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken,
      );

      // 실제 유저 정보(onboardingComplete 포함)를 서버에서 조회
      final dio = ref.read(dioProvider);
      final res = await dio.get<Map<String, dynamic>>('/users/me');
      final data = (res.data?['data'] as Map<String, dynamic>?) ?? {};
      return AuthUser(
        userId: (data['userId'] as int?) ?? 0,
        email: email,
        nickname: data['nickname'] as String?,
        onboardingComplete: data['onboardingComplete'] as bool? ?? false,
      );
    });
  }

  Future<void> loginWithSocial(SocialLoginResponse response) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final storage = ref.read(secureStorageServiceProvider);
      await storage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      final dio = ref.read(dioProvider);
      final res = await dio.get<Map<String, dynamic>>('/users/me');
      final data = (res.data?['data'] as Map<String, dynamic>?) ?? {};
      return AuthUser(
        userId: (data['userId'] as int?) ?? 0,
        email: data['email'] as String? ?? '',
        nickname: data['nickname'] as String?,
        isNewUser: response.isNewUser,
        onboardingComplete: data['onboardingComplete'] as bool? ?? !response.isNewUser,
      );
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.logout();
    } catch (_) {
      // 로그아웃 API 실패해도 로컬 토큰 삭제 진행
    }
    final storage = ref.read(secureStorageServiceProvider);
    await storage.clearTokens();
    state = const AsyncValue.data(null);
  }

  Future<void> refreshToken() async {
    final storage = ref.read(secureStorageServiceProvider);
    final refreshTokenValue = await storage.getRefreshToken();
    if (refreshTokenValue == null) {
      state = const AsyncValue.data(null);
      return;
    }
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.refreshAccessToken(
          refreshToken: refreshTokenValue);
      final newAccessToken = result['accessToken'] as String?;
      if (newAccessToken != null) {
        await storage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: refreshTokenValue,
        );
      }
    } catch (_) {
      await storage.clearTokens();
      state = const AsyncValue.data(null);
    }
  }

  void setUser(AuthUser user) {
    state = AsyncValue.data(user);
  }
}
