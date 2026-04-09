import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeju_together/features/auth/providers/onboarding_provider.dart';

void main() {
  group('OnboardingNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    OnboardingState read() => container.read(onboardingProvider);
    Onboarding notifier() => container.read(onboardingProvider.notifier);

    test('초기 상태는 모든 선택이 비어 있어야 한다', () {
      final state = read();
      expect(state.destination, '');
      expect(state.selectedCompanions, isEmpty);
      expect(state.selectedAccessibility, isEmpty);
      expect(state.isLoading, false);
      expect(state.isSuccess, false);
    });

    test('updateDestination() 으로 여행지를 갱신할 수 있다', () {
      notifier().updateDestination('제주도 서귀포시');
      expect(read().destination, '제주도 서귀포시');
    });

    test('updateDestination() 호출 시 destinationError가 초기화된다', () {
      notifier().validate(); // 에러 발생
      expect(read().destinationError, isNotNull);

      notifier().updateDestination('제주도');
      expect(read().destinationError, isNull);
    });

    group('toggleCompanion()', () {
      test('선택되지 않은 동행을 선택하면 추가된다', () {
        notifier().toggleCompanion('가족');
        expect(read().selectedCompanions, contains('가족'));
      });

      test('이미 선택된 동행을 다시 누르면 제거된다', () {
        notifier().toggleCompanion('가족');
        notifier().toggleCompanion('가족');
        expect(read().selectedCompanions, isNot(contains('가족')));
      });

      test('여러 동행을 동시에 선택할 수 있다', () {
        notifier().toggleCompanion('가족');
        notifier().toggleCompanion('친구');
        expect(read().selectedCompanions, containsAll(['가족', '친구']));
      });
    });

    group('toggleAccessibility()', () {
      test('접근성 옵션을 선택/해제할 수 있다', () {
        notifier().toggleAccessibility('휠체어');
        expect(read().selectedAccessibility, contains('휠체어'));

        notifier().toggleAccessibility('휠체어');
        expect(read().selectedAccessibility, isNot(contains('휠체어')));
      });

      test('여러 접근성 옵션을 동시에 선택할 수 있다', () {
        notifier().toggleAccessibility('휠체어');
        notifier().toggleAccessibility('유모차');
        expect(
          read().selectedAccessibility,
          containsAll(['휠체어', '유모차']),
        );
      });
    });

    group('validate()', () {
      test('destination이 비어있으면 에러가 설정되고 false 반환', () {
        final result = notifier().validate();
        expect(result, false);
        expect(read().destinationError, isNotNull);
      });

      test('destination이 공백만 있어도 에러가 설정된다', () {
        notifier().updateDestination('   ');
        final result = notifier().validate();
        expect(result, false);
        expect(read().destinationError, isNotNull);
      });

      test('destination이 있으면 true 반환', () {
        notifier().updateDestination('제주도');
        final result = notifier().validate();
        expect(result, true);
        expect(read().destinationError, isNull);
      });
    });

    test('reset() 호출 시 초기 상태로 복원된다', () {
      notifier()
        ..updateDestination('제주도')
        ..toggleCompanion('가족')
        ..toggleAccessibility('휠체어');
      notifier().reset();

      final state = read();
      expect(state.destination, '');
      expect(state.selectedCompanions, isEmpty);
      expect(state.selectedAccessibility, isEmpty);
    });

    test('OnboardingOptions 상수가 올바른 값을 가진다', () {
      expect(OnboardingOptions.companions, containsAll(['혼자', '가족', '친구', '연인']));
      expect(
        OnboardingOptions.accessibility,
        containsAll(['휠체어', '유모차', '시각장애', '청각장애', '노약자']),
      );
    });
  });
}
