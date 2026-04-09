import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jeju_together/core/router/app_router.dart';
import 'package:jeju_together/features/auth/providers/signup_provider.dart';

/// F-2 03. Signup Screen
/// 이메일, 비밀번호, 이름을 입력해 회원가입 후 이메일 인증 화면으로 이동한다.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    // Provider 상태 동기화
    final notifier = ref.read(signupProvider.notifier);
    notifier.updateEmail(_emailController.text.trim());
    notifier.updatePassword(_passwordController.text);
    notifier.updatePasswordConfirm(_passwordConfirmController.text);
    notifier.updateName(_nameController.text.trim());

    final success = await notifier.submit();
    if (!mounted) return;

    if (success) {
      context.push(
        AppRoutes.emailVerification,
        extra: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupProvider);
    final isLoading = signupState.isLoading;

    // 에러 메시지 스낵바
    ref.listen(signupProvider, (prev, next) {
      if (next.errorMessage != null &&
          next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    });

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
          '회원가입',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Pretendard',
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '환영해요!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '아래 정보를 입력해 계정을 만들어 주세요.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF777777),
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(height: 32),
                // 이메일
                const _FieldLabel('이메일'),
                const SizedBox(height: 8),
                Semantics(
                  label: '이메일 입력',
                  child: _TextField(
                    controller: _emailController,
                    hint: 'example@email.com',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    errorText: signupState.emailError,
                    onChanged: (v) =>
                        ref.read(signupProvider.notifier).updateEmail(v),
                  ),
                ),
                const SizedBox(height: 20),
                // 비밀번호
                const _FieldLabel('비밀번호'),
                const SizedBox(height: 8),
                Semantics(
                  label: '비밀번호 입력, 8자 이상',
                  child: _TextField(
                    controller: _passwordController,
                    hint: '비밀번호 (8자 이상)',
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    errorText: signupState.passwordError,
                    onChanged: (v) =>
                        ref.read(signupProvider.notifier).updatePassword(v),
                    suffixIcon: _ToggleVisibilityButton(
                      isObscure: _obscurePassword,
                      onTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 비밀번호 확인
                const _FieldLabel('비밀번호 확인'),
                const SizedBox(height: 8),
                Semantics(
                  label: '비밀번호 확인 입력',
                  child: _TextField(
                    controller: _passwordConfirmController,
                    hint: '비밀번호를 다시 입력해 주세요',
                    obscureText: _obscurePasswordConfirm,
                    textInputAction: TextInputAction.done,
                    errorText: signupState.passwordConfirmError,
                    onChanged: (v) => ref
                        .read(signupProvider.notifier)
                        .updatePasswordConfirm(v),
                    onSubmitted: (_) => _submit(),
                    suffixIcon: _ToggleVisibilityButton(
                      isObscure: _obscurePasswordConfirm,
                      onTap: () => setState(() =>
                          _obscurePasswordConfirm = !_obscurePasswordConfirm),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // 개인정보 동의 안내
                const Text(
                  '이 서비스는 개인정보 처리방침에 따라 정보를 보호합니다.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFAAAAAA),
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(height: 32),
                // 인증 메일 받기 버튼
                Semantics(
                  label: '인증 메일 받기',
                  button: true,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F4C5C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor:
                            const Color(0xFF0F4C5C).withValues(alpha: 0.5),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              '인증 메일 받기 →',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                    ),
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

// ─── 공용 내부 위젯 ──────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF444444),
        fontFamily: 'Pretendard',
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          style: const TextStyle(fontFamily: 'Pretendard', fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFFAAAAAA),
              fontFamily: 'Pretendard',
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? const Color(0xFFEF4444) : const Color(0xFFE0E6ED),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: hasError ? const Color(0xFFEF4444) : const Color(0xFFE0E6ED),
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
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFEF4444),
              fontFamily: 'Pretendard',
            ),
          ),
        ],
      ],
    );
  }
}

class _ToggleVisibilityButton extends StatelessWidget {
  const _ToggleVisibilityButton({
    required this.isObscure,
    required this.onTap,
  });

  final bool isObscure;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isObscure ? '비밀번호 표시' : '비밀번호 숨기기',
      button: true,
      child: IconButton(
        icon: Icon(
          isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: const Color(0xFF888888),
          size: 20,
        ),
        onPressed: onTap,
      ),
    );
  }
}
