import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeju_together/features/auth/providers/email_verification_provider.dart';

void main() {
  group('EmailVerificationNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    EmailVerificationState read() => container.read(emailVerificationProvider);
    EmailVerification notifier() =>
        container.read(emailVerificationProvider.notifier);

    test('초기 상태는 6칸 모두 비어 있어야 한다', () {
      final state = read();
      expect(state.digits, List.filled(6, ''));
      expect(state.isComplete, false);
      expect(state.isVerified, false);
      expect(state.errorMessage, isNull);
    });

    test('updateDigit() 으로 개별 숫자를 설정할 수 있다', () {
      notifier().updateDigit(0, '4');
      notifier().updateDigit(1, '8');
      expect(read().digits[0], '4');
      expect(read().digits[1], '8');
    });

    test('6칸 모두 입력되면 isComplete가 true가 된다', () {
      for (int i = 0; i < 6; i++) {
        notifier().updateDigit(i, '$i');
      }
      expect(read().isComplete, true);
      expect(read().code, '012345');
    });

    test('pasteCode() 로 6자리를 한 번에 붙여넣을 수 있다', () {
      notifier().pasteCode('482915');
      expect(read().digits, ['4', '8', '2', '9', '1', '5']);
      expect(read().isComplete, true);
    });

    test('pasteCode() 에 숫자 외 문자가 포함되어 있어도 숫자만 추출한다', () {
      notifier().pasteCode('4-8-2-9-1-5');
      expect(read().code, '482915');
    });

    test('pasteCode() 에 6자리 미만인 경우 무시한다', () {
      notifier().pasteCode('123');
      expect(read().digits, List.filled(6, ''));
    });

    test('reset() 호출 시 초기 상태로 복원된다', () {
      notifier().pasteCode('482915');
      notifier().reset();

      expect(read().digits, List.filled(6, ''));
      expect(read().isComplete, false);
      expect(read().resendCooldown, 0);
    });

    test('canResend 는 isLoading=false 이고 resendCooldown=0 일 때 true', () {
      expect(read().canResend, true);
    });
  });
}
