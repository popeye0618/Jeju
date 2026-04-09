import 'package:jeju_together/features/auth/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_provider.g.dart';

// ── 상태 ────────────────────────────────────────────────────────────────────

class SignupState {
  const SignupState({
    this.email = '',
    this.password = '',
    this.passwordConfirm = '',
    this.name = '',
    this.emailError,
    this.passwordError,
    this.passwordConfirmError,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final String email;
  final String password;
  final String passwordConfirm;
  final String name;
  final String? emailError;
  final String? passwordError;
  final String? passwordConfirmError;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  SignupState copyWith({
    String? email,
    String? password,
    String? passwordConfirm,
    String? name,
    String? emailError,
    bool clearEmailError = false,
    String? passwordError,
    bool clearPasswordError = false,
    String? passwordConfirmError,
    bool clearPasswordConfirmError = false,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      name: name ?? this.name,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError:
          clearPasswordError ? null : (passwordError ?? this.passwordError),
      passwordConfirmError: clearPasswordConfirmError
          ? null
          : (passwordConfirmError ?? this.passwordConfirmError),
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────────────────────

@riverpod
class Signup extends _$Signup {
  static final _emailRegex = RegExp(r'^[\w\-.]+@[\w\-]+\.[a-zA-Z]{2,}$');

  @override
  SignupState build() => const SignupState();

  void updateEmail(String v) {
    state = state.copyWith(email: v, clearEmailError: true);
  }

  void updatePassword(String v) {
    state = state.copyWith(password: v, clearPasswordError: true);
  }

  void updatePasswordConfirm(String v) {
    state = state.copyWith(
        passwordConfirm: v, clearPasswordConfirmError: true);
  }

  void updateName(String v) {
    state = state.copyWith(name: v);
  }

  /// 유효성 검사. 실패 시 각 에러 필드를 설정하고 false 반환.
  bool validate() {
    String? emailError;
    String? passwordError;
    String? passwordConfirmError;

    if (state.email.isEmpty || !_emailRegex.hasMatch(state.email)) {
      emailError = '올바른 이메일 형식을 입력해 주세요.';
    }
    if (state.password.length < 8) {
      passwordError = '비밀번호는 8자 이상이어야 합니다.';
    }
    if (state.passwordConfirm != state.password) {
      passwordConfirmError = '비밀번호가 일치하지 않습니다.';
    }

    state = state.copyWith(
      emailError: emailError,
      passwordError: passwordError,
      passwordConfirmError: passwordConfirmError,
    );

    return emailError == null &&
        passwordError == null &&
        passwordConfirmError == null;
  }

  /// 회원가입 요청.
  Future<bool> submit() async {
    if (!validate()) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signup(
        email: state.email,
        password: state.password,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '회원가입에 실패했습니다. 잠시 후 다시 시도해주세요.',
      );
      return false;
    }
  }

  void reset() {
    state = const SignupState();
  }
}
