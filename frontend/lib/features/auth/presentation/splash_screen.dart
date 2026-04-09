import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jeju_together/core/router/app_router.dart';
import 'package:jeju_together/features/auth/providers/auth_state_provider.dart';

/// F-2 01. Splash Screen
/// 앱 시작 시 로고를 보여주고, 저장된 토큰 유효성 확인 후 홈 or 로그인으로 이동한다.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _minDelayPassed = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _minDelayPassed = true;
      _tryNavigate();
    });
  }

  void _tryNavigate() {
    if (_navigated || !_minDelayPassed) return;
    final authAsync = ref.read(authStateProvider);
    if (authAsync.isLoading) return; // auth 초기화 아직 중 → listener가 다시 호출

    _navigated = true;
    final user = authAsync.valueOrNull;
    if (user != null) {
      context.go(user.onboardingComplete ? AppRoutes.itineraryResult : AppRoutes.onboarding);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // auth 초기화 완료 시 navigate 시도 (딜레이가 이미 지났을 경우 즉시 이동)
    ref.listen(authStateProvider, (_, next) {
      if (!next.isLoading) _tryNavigate();
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F4C5C),
      body: Semantics(
        label: '같이가는 제주 앱 로딩 중',
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _AppLogo(),
                SizedBox(height: 24),
                Text(
                  '같이가는 제주',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Pretendard',
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '무장애 여행 일정 설계 서비스',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xCCFFFFFF),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: Icon(
          Icons.accessible_forward_rounded,
          size: 56,
          color: Colors.white,
        ),
      ),
    );
  }
}
