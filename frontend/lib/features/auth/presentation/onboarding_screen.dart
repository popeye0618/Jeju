import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jeju_together/core/router/app_router.dart';
import 'package:jeju_together/features/auth/providers/auth_state_provider.dart';
import 'package:jeju_together/features/auth/providers/onboarding_provider.dart';

/// F-2 04/04b. Onboarding Screen
/// 닉네임, 동행, 여행 스타일, 이동 주의사항, 여행 일수를 입력해 온보딩을 완료한다.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final success = await ref.read(onboardingProvider.notifier).submit();
    if (!mounted) return;
    if (success) {
      // 온보딩 완료 → authState 갱신 (닉네임 + onboardingComplete)
      final currentUser = ref.read(authStateProvider).valueOrNull;
      final enteredNickname = ref.read(onboardingProvider).nickname.trim();
      if (currentUser != null) {
        ref.read(authStateProvider.notifier).setUser(
              currentUser.copyWith(
                onboardingComplete: true,
                nickname: enteredNickname.isNotEmpty
                    ? enteredNickname
                    : currentUser.nickname,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    ref.listen(onboardingProvider, (prev, next) {
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
        title: const Text(
          '이동 조건 설정',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Pretendard',
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 닉네임
                      _SectionTitle(
                        '닉네임을 입력해 주세요',
                        errorText: state.nicknameError,
                      ),
                      const SizedBox(height: 12),
                      Semantics(
                        label: '닉네임 입력',
                        child: TextFormField(
                          controller: _nicknameController,
                          onChanged: (v) => ref
                              .read(onboardingProvider.notifier)
                              .updateNickname(v),
                          style: const TextStyle(
                              fontFamily: 'Pretendard', fontSize: 15),
                          decoration: InputDecoration(
                            hintText: '2자 이상 입력해 주세요',
                            hintStyle: const TextStyle(
                                color: Color(0xFFAAAAAA),
                                fontFamily: 'Pretendard',
                                fontSize: 14),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: state.nicknameError != null
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFFE0E6ED),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: state.nicknameError != null
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFFE0E6ED),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF0F4C5C), width: 2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // 동행 선택
                      _SectionTitle(
                        '누구랑 여행하실 건가요?',
                        errorText: state.companionError,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: OnboardingOptions.companions.map((label) {
                          final selected = state.selectedCompanion == label;
                          return Semantics(
                            label:
                                '$label ${selected ? "선택됨" : "선택 안됨"}',
                            button: true,
                            child: _SelectChip(
                              label: label,
                              selected: selected,
                              onTap: () => ref
                                  .read(onboardingProvider.notifier)
                                  .selectCompanion(label),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),

                      // 여행 스타일
                      _SectionTitle(
                        '어떤 여행을 선호하시나요?',
                        errorText: state.preferenceError,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: OnboardingOptions.preferences.map((label) {
                          final selected = state.selectedPreference == label;
                          return Semantics(
                            label:
                                '$label ${selected ? "선택됨" : "선택 안됨"}',
                            button: true,
                            child: _SelectChip(
                              label: label,
                              selected: selected,
                              onTap: () => ref
                                  .read(onboardingProvider.notifier)
                                  .selectPreference(label),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),

                      // 이동 주의사항
                      _SectionTitle(
                        '이동 시 주의사항이 있나요?',
                        errorText: state.mobilityError,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '해당하는 조건을 선택해 주세요.',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF888888),
                            fontFamily: 'Pretendard'),
                      ),
                      const SizedBox(height: 12),
                      ...OnboardingOptions.mobilities.map((label) {
                        final selected = state.selectedMobility == label;
                        return Semantics(
                          label: '$label ${selected ? "선택됨" : "선택 안됨"}',
                          child: _MobilityRow(
                            label: label,
                            selected: selected,
                            onTap: () => ref
                                .read(onboardingProvider.notifier)
                                .selectMobility(label),
                          ),
                        );
                      }),
                      const SizedBox(height: 28),

                      // 여행 일수
                      const _SectionTitle('여행은 며칠 동안 하실 건가요?'),
                      const SizedBox(height: 12),
                      _DaysSelector(
                        days: state.days,
                        onChanged: (v) => ref
                            .read(onboardingProvider.notifier)
                            .updateDays(v),
                      ),
                    ],
                  ),
                ),
              ),

              // 하단 버튼
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Semantics(
                  label: '일정 추천받기',
                  button: true,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F4C5C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor:
                            const Color(0xFF0F4C5C).withValues(alpha: 0.5),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              '일정 추천받기 →',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Pretendard'),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 내부 위젯 ────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.errorText});

  final String title;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Pretendard',
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.error_outline,
                  size: 13, color: Color(0xFFEF4444)),
              const SizedBox(width: 4),
              Text(
                errorText!,
                style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFEF4444),
                    fontFamily: 'Pretendard'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip(
      {required this.label,
      required this.selected,
      required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0F4C5C) : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected
                ? const Color(0xFF0F4C5C)
                : const Color(0xFFDDDDDD),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : const Color(0xFF555555),
            fontFamily: 'Pretendard',
          ),
        ),
      ),
    );
  }
}

class _MobilityRow extends StatelessWidget {
  const _MobilityRow(
      {required this.label,
      required this.selected,
      required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    switch (label) {
      case '휠체어':
        return Icons.accessible_rounded;
      case '유모차':
        return Icons.stroller_rounded;
      case '노약자':
        return Icons.elderly_rounded;
      default:
        return Icons.directions_walk_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFF0F4C5C)
                : const Color(0xFFE0E6ED),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(_icon,
                size: 20,
                color: selected
                    ? const Color(0xFF0F4C5C)
                    : const Color(0xFF888888)),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: selected
                    ? const Color(0xFF0F4C5C)
                    : const Color(0xFF444444),
                fontFamily: 'Pretendard',
              ),
            ),
            const Spacer(),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF0F4C5C)
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF0F4C5C)
                      : const Color(0xFFDDDDDD),
                ),
              ),
              child: selected
                  ? const Icon(Icons.check,
                      size: 13, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _DaysSelector extends StatelessWidget {
  const _DaysSelector({required this.days, required this.onChanged});

  final int days;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E6ED)),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined,
              size: 18, color: Color(0xFF0F4C5C)),
          const SizedBox(width: 12),
          Text(
            '$days박 ${days + 1}일',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Pretendard',
            ),
          ),
          const Spacer(),
          Semantics(
            label: '여행 일수 줄이기',
            button: true,
            child: GestureDetector(
              onTap: days > 1 ? () => onChanged(days - 1) : null,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: days > 1
                      ? const Color(0xFFE2F1F3)
                      : const Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.remove,
                    size: 16,
                    color: days > 1
                        ? const Color(0xFF0F4C5C)
                        : const Color(0xFFAAAAAA)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            label: '여행 일수 늘리기',
            button: true,
            child: GestureDetector(
              onTap: days < 30 ? () => onChanged(days + 1) : null,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: days < 30
                      ? const Color(0xFF0F4C5C)
                      : const Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add,
                    size: 16,
                    color: days < 30
                        ? Colors.white
                        : const Color(0xFFAAAAAA)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
