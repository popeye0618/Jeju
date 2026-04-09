import 'dart:async';

import 'package:jeju_together/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email_verification_provider.g.dart';

// ── 상태 ───────────────────────────────────────────────────────────────────

class EmailVerificationState {
  const EmailVerificationState({
    this.digits = const ['', '', '', '', '', ''],
    this.errorMessage,
    this.isLoading = false,
    this.isVerified = false,
    this.resendCooldown = 0,
  });

  /// 6자리 각 칸의 입력값
  final List<String> digits;
  final String? errorMessage;
  final bool isLoading;
  final bool isVerified;

  /// 0이면 재전송 가능, 양수이면 남은 초
  final int resendCooldown;

  bool get canResend => resendCooldown == 0 && !isLoading;

  String get code => digits.join();

  bool get isComplete => digits.every((d) => d.isNotEmpty);

  EmailVerificationState copyWith({
    List<String>? digits,
    String? errorMessage,
    bool clearError = false,
    bool? isLoading,
    bool? isVerified,
    int? resendCooldown,
  }) {
    return EmailVerificationState(
      digits: digits ?? this.digits,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
      isVerified: isVerified ?? this.isVerified,
      resendCooldown: resendCooldown ?? this.resendCooldown,
    );
  }
}

// ── Notifier ───────────────────────────────────────────────────────────────

@riverpod
class EmailVerification extends _$EmailVerification {
  Timer? _cooldownTimer;

  @override
  EmailVerificationState build() {
    ref.onDispose(() => _cooldownTimer?.cancel());
    return const EmailVerificationState();
  }

  /// 특정 인덱스(0~5)의 숫자 입력 갱신
  void updateDigit(int index, String value) {
    if (index < 0 || index > 5) return;
    final newDigits = List<String>.from(state.digits);
    newDigits[index] = value.length > 1 ? value[value.length - 1] : value;
    state = state.copyWith(digits: newDigits, clearError: true);
  }

  /// 코드 일괄 붙여넣기 처리 (6자리)
  void pasteCode(String pasted) {
    final digits = pasted.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 6) return;
    final newDigits = digits.substring(0, 6).split('');
    state = state.copyWith(digits: newDigits, clearError: true);
  }

  /// 이메일 인증 코드 확인
  Future<bool> verifyCode({required String email}) async {
    if (!state.isComplete) return false;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repo = ref.read(authRepositoryProvider);
      final verified = await repo.verifyEmail(
        email: email,
        code: state.code,
      );
      if (verified) {
        state = state.copyWith(isLoading: false, isVerified: true);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: '인증 코드가 올바르지 않습니다.',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '인증에 실패했습니다. 다시 시도해주세요.',
      );
      return false;
    }
  }

  /// 인증 코드 재전송
  Future<void> resendCode({required String email}) async {
    if (!state.canResend) return;
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.resendEmail(email: email);
      state = state.copyWith(
        isLoading: false,
        digits: ['', '', '', '', '', ''],
        resendCooldown: 60,
      );
      _startCooldownTimer();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '재전송에 실패했습니다. 잠시 후 다시 시도해주세요.',
      );
    }
  }

  void _startCooldownTimer() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.resendCooldown - 1;
      if (remaining <= 0) {
        timer.cancel();
        state = state.copyWith(resendCooldown: 0);
      } else {
        state = state.copyWith(resendCooldown: remaining);
      }
    });
  }

  /// 상태 초기화 (화면 재진입 시)
  void reset() {
    _cooldownTimer?.cancel();
    state = const EmailVerificationState();
  }
}
