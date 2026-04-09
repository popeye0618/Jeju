import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jeju_together/features/auth/providers/auth_state_provider.dart';

// 라우트 경로 상수
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
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

      // 비로그인 + 보호 경로 → 로그인
      final isProtected = _protectedRoutes.any(
        (r) => location == r || location.startsWith(r.replaceAll(':id', '')),
      );
      if (!isLoggedIn && isProtected) {
        return AppRoutes.login;
      }

      // 로그인 + /login 접근 → 홈
      if (isLoggedIn && location == AppRoutes.login) {
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
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const _PlaceholderPage('로그인'),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const _PlaceholderPage('조건 입력'),
      ),
      GoRoute(
        path: AppRoutes.itineraryResult,
        builder: (context, state) => const _PlaceholderPage('동선 추천 결과'),
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

// ── 임시 스플래시 ──────────────────────────────────────────────────
class _SplashPage extends StatefulWidget {
  const _SplashPage();

  @override
  State<_SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<_SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go(AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1E6BB0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.accessible_forward, size: 64, color: Colors.white),
            SizedBox(height: 24),
            Text(
              '같이가는 제주',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Pretendard',
              ),
            ),
            SizedBox(height: 8),
            Text(
              '무장애 여행 일정 설계 서비스',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontFamily: 'Pretendard',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
