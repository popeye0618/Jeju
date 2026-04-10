import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jeju_together/features/auth/presentation/email_login_screen.dart';
import 'package:jeju_together/features/auth/presentation/email_verification_screen.dart';
import 'package:jeju_together/features/auth/presentation/login_screen.dart';
import 'package:jeju_together/features/auth/presentation/onboarding_screen.dart';
import 'package:jeju_together/features/auth/presentation/signup_screen.dart';
import 'package:jeju_together/features/auth/presentation/splash_screen.dart';
import 'package:jeju_together/features/auth/providers/auth_state_provider.dart';
import 'package:jeju_together/features/home/presentation/home_screen.dart';
import 'package:jeju_together/features/itinerary/presentation/itinerary_detail_screen.dart';

// ── 라우트 경로 상수 ──────────────────────────────────────────────────────────
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const emailLogin = '/login/email';
  static const signup = '/signup';
  static const emailVerification = '/signup/verify';
  static const onboarding = '/onboarding';
  static const itineraryResult = '/itinerary/result';
  static const itineraryDetail = '/itinerary/:id';
  static const spotSearch = '/spots';
  static const spotDetail = '/spots/:id';
  static const mypage = '/mypage';
}

// 인증이 필요한 경로 목록
const _protectedRoutes = [
  AppRoutes.itineraryResult,
  AppRoutes.itineraryDetail,
  AppRoutes.mypage,
];

final appRouterProvider = Provider<GoRouter>((ref) {
  final authStateNotifier = ValueNotifier<bool>(false);

  ref.listen(authStateProvider, (_, next) {
    authStateNotifier.value = !authStateNotifier.value;
  });

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: authStateNotifier,
    redirect: (context, state) {
      final authAsync = ref.read(authStateProvider);
      final isLoading = authAsync.isLoading;

      if (isLoading) return null;

      final user = authAsync.valueOrNull;
      final isLoggedIn = user != null;
      final location = state.matchedLocation;

      // 인증 관련 화면 (리다이렉트 제외 경로)
      const authPaths = [
        AppRoutes.splash,
        AppRoutes.login,
        AppRoutes.emailLogin,
        AppRoutes.signup,
        AppRoutes.emailVerification,
        AppRoutes.onboarding,
      ];
      final isAuthPath = authPaths.any((p) => location.startsWith(p));

      // 비로그인 + 보호 경로 → 로그인
      final isProtected = _protectedRoutes.any(
        (r) => location == r || location.startsWith(r.replaceAll(':id', '')),
      );
      if (!isLoggedIn && isProtected) {
        return AppRoutes.login;
      }

      // 로그인 + 인증 경로 접근 → 홈
      if (isLoggedIn && isAuthPath && location != AppRoutes.splash) {
        if (user.onboardingComplete == false) {
          return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
        }
        return AppRoutes.itineraryResult;
      }

      // 로그인 + 온보딩 미완료 → 온보딩
      if (isLoggedIn &&
          user.onboardingComplete == false &&
          location != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }

      return null;
    },
    routes: [
      // 스플래시
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // 로그인 (소셜)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // 이메일 로그인
      GoRoute(
        path: AppRoutes.emailLogin,
        builder: (context, state) => const EmailLoginScreen(),
      ),
      // 회원가입
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      // 이메일 인증
      GoRoute(
        path: AppRoutes.emailVerification,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final email = extra?['email'] as String? ?? '';
          final password = extra?['password'] as String? ?? '';
          return EmailVerificationScreen(email: email, password: password);
        },
      ),
      // 온보딩
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      // 홈 화면
      GoRoute(
        path: AppRoutes.itineraryResult,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.itineraryDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ItineraryDetailScreen(itineraryId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.spotSearch,
        builder: (context, state) => const _PlaceholderPage('관광지 탐색'),
      ),
      GoRoute(
        path: AppRoutes.mypage,
        builder: (context, state) => const _PlaceholderPage('마이페이지'),
      ),
    ],
  );
});

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title 화면 개발 예정')),
    );
  }
}
