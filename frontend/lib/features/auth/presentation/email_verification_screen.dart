import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jeju_together/features/auth/providers/auth_state_provider.dart';
import 'package:jeju_together/features/auth/providers/email_verification_provider.dart';

/// F-2 03b. Email Verification Screen
/// 6자리 인증 코드를 입력해 이메일을 인증한다.
/// 인증 성공 후 자동 로그인하여 GoRouter redirect가 온보딩으로 이동시킨다.
/// 에러 상태(03b-err)와 재전송 쿨다운을 지원한다.
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(emailVerificationProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    // 붙여넣기 처리 (6자리 이상)
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 6) {
      ref.read(emailVerificationProvider.notifier).pasteCode(digits);
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = digits[i];
      }
      _focusNodes[5].requestFocus();
      return;
    }

    final single = digits.isEmpty ? '' : digits[digits.length - 1];
    ref.read(emailVerificationProvider.notifier).updateDigit(index, single);
    _controllers[index].text = single;

    if (single.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onBackspaceDetected(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      ref.read(emailVerificationProvider.notifier).updateDigit(index - 1, '');
      _controllers[index - 1].clear();
    }
  }

  Future<void> _verify() async {
    FocusScope.of(context).unfocus();
    final success = await ref
        .read(emailVerificationProvider.notifier)
        .verifyCode(email: widget.email);
    if (!mounted) return;
    if (success) {
      // 이메일 인증 완료 후 자동 로그인 → GoRouter가 onboarding으로 redirect
      await ref.read(authStateProvider.notifier).login(
            email: widget.email,
            password: widget.password,
          );
    }
  }

  Future<void> _resend() async {
    await ref
        .read(emailVerificationProvider.notifier)
        .resendCode(email: widget.email);
    if (!mounted) return;
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(emailVerificationProvider);
    final hasError = state.errorMessage != null;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAF7),
        elevation: 0,
        leading: Semantics(
          label: '뒤로 가기',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 20, color: Color(0xFF1A1A2E)),
            onPressed: () => context.pop(),
          ),
        ),
        title: const Text(
          '이메일 인증',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Pretendard',
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '코드를 입력해 주세요',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.email}으로\n인증 코드를 전송했습니다.',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777),
                  fontFamily: 'Pretendard',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),
              // 6자리 OTP 입력칸
              Semantics(
                label: '6자리 인증 코드 입력',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) {
                    return _OtpCell(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      hasError: hasError,
                      onChanged: (v) => _onDigitChanged(i, v),
                      onBackspace: () => _onBackspaceDetected(i),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              // 에러 메시지
              if (hasError)
                Row(
                  children: [
                    const Icon(Icons.error_outline,
                        size: 14, color: Color(0xFFEF4444)),
                    const SizedBox(width: 4),
                    Text(
                      state.errorMessage!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFEF4444),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              // 재전송 버튼
              Row(
                children: [
                  const Text(
                    '코드를 받지 못하셨나요?',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF888888),
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const SizedBox(width: 4),
                  Semantics(
                    label: state.canResend
                        ? '인증 코드 재전송'
                        : '재전송 대기 중 ${state.resendCooldown}초',
                    button: true,
                    child: GestureDetector(
                      onTap: state.canResend ? _resend : null,
                      child: Text(
                        state.resendCooldown > 0
                            ? '재전송 (${state.resendCooldown}초)'
                            : '재전송',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: state.canResend
                              ? const Color(0xFF0F4C5C)
                              : const Color(0xFFAAAAAA),
                          fontFamily: 'Pretendard',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // 인증 완료 버튼
              Semantics(
                label: '인증 완료',
                button: true,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed:
                        (state.isComplete && !state.isLoading) ? _verify : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F4C5C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor:
                          const Color(0xFF0F4C5C).withValues(alpha: 0.3),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            '인증 완료 →',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── OTP 셀 ─────────────────────────────────────────────────────────────────

class _OtpCell extends StatelessWidget {
  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    required this.onBackspace,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 2, // 2로 설정해 입력 변경 감지
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          fontFamily: 'Pretendard',
          color: Color(0xFF1A1A2E),
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: hasError ? const Color(0xFFEF4444) : const Color(0xFFE0E6ED),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: hasError ? const Color(0xFFEF4444) : const Color(0xFFE0E6ED),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: hasError ? const Color(0xFFEF4444) : const Color(0xFF0F4C5C),
              width: 2,
            ),
          ),
        ),
        onChanged: (v) {
          if (v.isEmpty) {
            onBackspace();
          } else {
            onChanged(v);
          }
        },
      ),
    );
  }
}
