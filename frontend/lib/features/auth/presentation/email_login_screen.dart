import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jeju_together/core/router/app_router.dart';
import 'package:jeju_together/features/auth/providers/auth_state_provider.dart';

/// F-2 02b. Email Login Screen
/// 이메일과 비밀번호를 입력해 로그인한다.
class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    await ref.read(authStateProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;
    final authState = ref.read(authStateProvider);
    authState.when(
      data: (user) {
        if (user != null) {
          context.go(AppRoutes.itineraryResult);
        }
      },
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateProvider);
    final isLoading = authAsync.isLoading;

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
          '이메일 로그인',
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    '다시 만나서 반가워요!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '이메일과 비밀번호를 입력해 주세요.',
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
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 15,
                      ),
                      decoration: _inputDecoration('example@email.com'),
                      validator: (v) {
                        if (v == null || v.isEmpty) return '이메일을 입력해 주세요.';
                        final regex =
                            RegExp(r'^[\w\-.]+@[\w\-]+\.[a-zA-Z]{2,}$');
                        if (!regex.hasMatch(v)) return '올바른 이메일 형식을 입력해 주세요.';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 비밀번호
                  const _FieldLabel('비밀번호'),
                  const SizedBox(height: 8),
                  Semantics(
                    label: '비밀번호 입력',
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submit(),
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 15,
                      ),
                      decoration: _inputDecoration('비밀번호').copyWith(
                        suffixIcon: Semantics(
                          label: _obscurePassword ? '비밀번호 표시' : '비밀번호 숨기기',
                          button: true,
                          child: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF888888),
                              size: 20,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return '비밀번호를 입력해 주세요.';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 로그인 버튼
                  Semantics(
                    label: '로그인',
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
                                '로그인',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 회원가입 링크
                  Center(
                    child: Row(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E6ED)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E6ED)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF0F4C5C), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
    );
  }
}

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
