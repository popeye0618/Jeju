import 'package:dio/dio.dart';
import 'package:jeju_together/core/network/api_exception.dart';
import 'package:jeju_together/core/network/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';

// ── 상수 (백엔드 enum 값과 매핑) ──────────────────────────────────────────────

class OnboardingOptions {
  /// 동행 표시 라벨 → 백엔드 Companion enum 값
  static const companionMap = {
    '혼자': 'SOLO',
    '가족': 'FAMILY',
    '친구': 'FRIENDS',
    '연인': 'COUPLE',
  };

  /// 여행 스타일 표시 라벨 → 백엔드 Preference enum 값
  static const preferenceMap = {
    '실내 위주': 'INDOOR',
    '야외 위주': 'OUTDOOR',
    '상관없음': 'BOTH',
  };

  /// 이동 주의사항 표시 라벨 → 백엔드 Mobility enum 값
  static const mobilityMap = {
    '휠체어': 'WHEELCHAIR',
    '유모차': 'STROLLER',
    '노약자': 'ELDERLY',
    '기타': 'NORMAL',
  };

  static List<String> get companions => companionMap.keys.toList();
  static List<String> get preferences => preferenceMap.keys.toList();
  static List<String> get mobilities => mobilityMap.keys.toList();
}

// ── 상태 ─────────────────────────────────────────────────────────────────────

class OnboardingState {
  const OnboardingState({
    this.nickname = '',
    this.selectedCompanion,
    this.selectedPreference,
    this.selectedMobility,
    this.days = 2,
    this.nicknameError,
    this.companionError,
    this.preferenceError,
    this.mobilityError,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  final String nickname;
  final String? selectedCompanion;
  final String? selectedPreference;
  final String? selectedMobility;
  final int days;
  final String? nicknameError;
  final String? companionError;
  final String? preferenceError;
  final String? mobilityError;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  OnboardingState copyWith({
    String? nickname,
    String? selectedCompanion,
    bool clearCompanion = false,
    String? selectedPreference,
    bool clearPreference = false,
    String? selectedMobility,
    bool clearMobility = false,
    int? days,
    String? nicknameError,
    bool clearNicknameError = false,
    String? companionError,
    bool clearCompanionError = false,
    String? preferenceError,
    bool clearPreferenceError = false,
    String? mobilityError,
    bool clearMobilityError = false,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OnboardingState(
      nickname: nickname ?? this.nickname,
      selectedCompanion:
          clearCompanion ? null : (selectedCompanion ?? this.selectedCompanion),
      selectedPreference: clearPreference
          ? null
          : (selectedPreference ?? this.selectedPreference),
      selectedMobility:
          clearMobility ? null : (selectedMobility ?? this.selectedMobility),
      days: days ?? this.days,
      nicknameError:
          clearNicknameError ? null : (nicknameError ?? this.nicknameError),
      companionError:
          clearCompanionError ? null : (companionError ?? this.companionError),
      preferenceError: clearPreferenceError
          ? null
          : (preferenceError ?? this.preferenceError),
      mobilityError:
          clearMobilityError ? null : (mobilityError ?? this.mobilityError),
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class Onboarding extends _$Onboarding {
  @override
  OnboardingState build() => const OnboardingState();

  void updateNickname(String v) =>
      state = state.copyWith(nickname: v, clearNicknameError: true);

  void selectCompanion(String label) =>
      state = state.copyWith(selectedCompanion: label, clearCompanionError: true);

  void selectPreference(String label) =>
      state = state.copyWith(selectedPreference: label, clearPreferenceError: true);

  void selectMobility(String label) =>
      state = state.copyWith(selectedMobility: label, clearMobilityError: true);

  void updateDays(int v) => state = state.copyWith(days: v.clamp(1, 30));

  bool validate() {
    String? nicknameError;
    String? companionError;
    String? preferenceError;
    String? mobilityError;

    if (state.nickname.trim().length < 2) {
      nicknameError = '닉네임은 2자 이상 입력해 주세요.';
    }
    if (state.selectedCompanion == null) {
      companionError = '동행을 선택해 주세요.';
    }
    if (state.selectedPreference == null) {
      preferenceError = '여행 스타일을 선택해 주세요.';
    }
    if (state.selectedMobility == null) {
      mobilityError = '이동 주의사항을 선택해 주세요.';
    }

    state = state.copyWith(
      nicknameError: nicknameError,
      companionError: companionError,
      preferenceError: preferenceError,
      mobilityError: mobilityError,
    );

    return nicknameError == null &&
        companionError == null &&
        preferenceError == null &&
        mobilityError == null;
  }

  Future<bool> submit() async {
    if (!validate()) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final dio = ref.read(dioProvider);
      await dio.post<Map<String, dynamic>>(
        '/users/onboarding',
        data: {
          'companion':
              OnboardingOptions.companionMap[state.selectedCompanion],
          'preference':
              OnboardingOptions.preferenceMap[state.selectedPreference],
          'mobility':
              OnboardingOptions.mobilityMap[state.selectedMobility],
          'days': state.days,
          'nickname': state.nickname.trim(),
          'termsAgreed': true,
          'privacyAgreed': true,
        },
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } on DioException catch (e) {
      final ex = ApiException.fromDioException(e);
      state = state.copyWith(isLoading: false, errorMessage: ex.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '온보딩 저장에 실패했습니다. 다시 시도해주세요.',
      );
      return false;
    }
  }

  void reset() => state = const OnboardingState();
}
