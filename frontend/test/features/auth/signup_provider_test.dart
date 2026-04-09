import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeju_together/features/auth/providers/signup_provider.dart';

void main() {
  group('SignupNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    SignupState read() => container.read(signupProvider);
    Signup notifier() => container.read(signupProvider.notifier);

    test('초기 상태는 모든 필드가 비어 있어야 한다', () {
      final state = read();
      expect(state.email, '');
      expect(state.password, '');
      expect(state.passwordConfirm, '');
      expect(state.name, '');
      expect(state.isLoading, false);
      expect(state.isSuccess, false);
    });

    test('이메일 업데이트 시 상태에 반영된다', () {
      notifier().updateEmail('test@example.com');
      expect(read().email, 'test@example.com');
    });

    test('비밀번호 업데이트 시 상태에 반영된다', () {
      notifier().updatePassword('password123');
      expect(read().password, 'password123');
    });

    group('validate()', () {
      test('이메일 형식이 잘못된 경우 emailError가 설정된다', () {
        notifier()
          ..updateEmail('invalid-email')
          ..updatePassword('password123')
          ..updatePasswordConfirm('password123');

        final result = notifier().validate();
        expect(result, false);
        expect(read().emailError, isNotNull);
      });

      test('비밀번호가 8자 미만인 경우 passwordError가 설정된다', () {
        notifier()
          ..updateEmail('test@example.com')
          ..updatePassword('short')
          ..updatePasswordConfirm('short');

        final result = notifier().validate();
        expect(result, false);
        expect(read().passwordError, isNotNull);
      });

      test('비밀번호 확인이 일치하지 않는 경우 passwordConfirmError가 설정된다', () {
        notifier()
          ..updateEmail('test@example.com')
          ..updatePassword('password123')
          ..updatePasswordConfirm('different123');

        final result = notifier().validate();
        expect(result, false);
        expect(read().passwordConfirmError, isNotNull);
      });

      test('모든 필드가 유효한 경우 true를 반환하고 에러가 없다', () {
        notifier()
          ..updateEmail('test@example.com')
          ..updatePassword('password123')
          ..updatePasswordConfirm('password123');

        final result = notifier().validate();
        expect(result, true);
        expect(read().emailError, isNull);
        expect(read().passwordError, isNull);
        expect(read().passwordConfirmError, isNull);
      });

      test('이메일 업데이트 시 emailError가 초기화된다', () {
        notifier()
          ..updateEmail('bad')
          ..validate();
        expect(read().emailError, isNotNull);

        notifier().updateEmail('test@example.com');
        expect(read().emailError, isNull);
      });
    });

    test('reset() 호출 시 초기 상태로 돌아간다', () {
      notifier()
        ..updateEmail('test@example.com')
        ..updatePassword('password123');
      notifier().reset();

      final state = read();
      expect(state.email, '');
      expect(state.password, '');
    });
  });
}
