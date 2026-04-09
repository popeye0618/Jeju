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
    final token = await storage.getAccessToken();
    if (token == null) {
      state = const AsyncValue.data(null);
    } else {
      // 토큰이 있으면 로그인 상태로 간주 (실제 유저 정보는 UserRepository에서 로드)
      state = const AsyncValue.data(null); // placeholder — 실제 구현 시 /users/me 호출
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
      return AuthUser(
        userId: 0,
        email: email,
        onboardingComplete: false,
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
      return AuthUser(
        userId: 0,
        email: '',
        isNewUser: response.isNewUser,
        onboardingComplete: !response.isNewUser,
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
