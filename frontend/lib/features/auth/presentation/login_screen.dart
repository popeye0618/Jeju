import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jeju_together/core/router/app_router.dart';

/// F-2 02. Login Screen
/// 카카오 OAuth, 구글 OAuth, 이메일 로그인 진입점을 제공한다.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // 로고 + 앱 이름
              const _LogoSection(),
              const SizedBox(height: 12),
              // 서브타이틀
              const Text(
                '조건만 입력하면,\n최적 안내를 해드립니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF555555),
                  fontFamily: 'Pretendard',
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),
              // 카카오 로그인
              Semantics(
                label: '카카오로 로그인',
                button: true,
                child: _SocialLoginButton(
                  label: '카카오로 로그인하기',
                  backgroundColor: const Color(0xFFFEE500),
                  textColor: const Color(0xFF3B2F1D),
                  icon: const _KakaoIcon(),
                  onTap: () => _handleKakaoLogin(context),
                ),
              ),
              const SizedBox(height: 12),
              // 구글 로그인
              Semantics(
                label: '구글로 로그인',
                button: true,
                child: _SocialLoginButton(
                  label: 'Apple로 계속하기',
                  backgroundColor: const Color(0xFF000000),
                  textColor: Colors.white,
                  icon: const Icon(Icons.apple, color: Colors.white, size: 22),
                  onTap: () => _handleGoogleLogin(context),
                ),
              ),
              const SizedBox(height: 24),
              // 이메일 로그인
              Semantics(
                label: '이메일로 로그인',
                button: true,
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.emailLogin),
                  child: const Text(
                    '이메일로 로그인',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF777777),
                      fontFamily: 'Pretendard',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 회원가입
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '계정이 없으신가요?',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF888888),
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const SizedBox(width: 4),
                  Semantics(
                    label: '회원가입 페이지로 이동',
                    button: true,
                    child: GestureDetector(
                      onTap: () => context.push(AppRoutes.signup),
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F4C5C),
                          fontFamily: 'Pretendard',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _handleKakaoLogin(BuildContext context) {
    // TODO: Kakao OAuth WebView 연동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('카카오 로그인 준비 중입니다.')),
    );
  }

  void _handleGoogleLogin(BuildContext context) {
    // TODO: Google OAuth WebView 연동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple 로그인 준비 중입니다.')),
    );
  }
}

// ─── 내부 위젯 ───────────────────────────────────────────────────────────────

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: const Color(0xFF0F4C5C),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Icon(
              Icons.accessible_forward_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '같이가는 제주',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F4C5C),
            fontFamily: 'Pretendard',
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'BARRIER FREE · ACCESSIBLE TRIP',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF888888),
            fontFamily: 'Pretendard',
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textColor,
                fontFamily: 'Pretendard',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KakaoIcon extends StatelessWidget {
  const _KakaoIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Color(0xFF3B2F1D),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.chat_bubble,
        size: 14,
        color: Color(0xFFFEE500),
      ),
    );
  }
}
