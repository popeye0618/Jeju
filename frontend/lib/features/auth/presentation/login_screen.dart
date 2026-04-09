import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:jeju_together/core/router/app_router.dart';
import 'package:jeju_together/features/auth/providers/auth_provider.dart';
import 'package:jeju_together/features/auth/providers/auth_state_provider.dart';

/// F-2 02. Login Screen
/// 카카오 OAuth, 구글 OAuth, 이메일 로그인 진입점을 제공한다.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const _LogoSection(),
              const SizedBox(height: 12),
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
                  onTap: () => _handleKakaoLogin(context, ref),
                ),
              ),
              const SizedBox(height: 12),
              // 구글 로그인
              Semantics(
                label: '구글로 로그인',
                button: true,
                child: _SocialLoginButton(
                  label: 'Google로 로그인하기',
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF3C4043),
                  borderColor: const Color(0xFFDADCE0),
                  icon: const _GoogleIcon(),
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

  Future<void> _handleKakaoLogin(BuildContext context, WidgetRef ref) async {
    try {
      // 카카오톡 앱 → 카카오 계정 순으로 시도
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      // 백엔드에 카카오 액세스 토큰 전달 → JWT 획득
      final repo = ref.read(authRepositoryProvider);
      final socialResponse = await repo.loginWithKakao(token.accessToken);
      await ref.read(authStateProvider.notifier).loginWithSocial(socialResponse);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('카카오 로그인 실패: $e')),
        );
      }
    }
  }

  void _handleGoogleLogin(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('구글 로그인 준비 중입니다.')),
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
    this.borderColor,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Widget icon;
  final VoidCallback onTap;
  final Color? borderColor;

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
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1)
              : null,
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

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFDADCE0), width: 1),
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4285F4),
          ),
        ),
      ),
    );
  }
}
