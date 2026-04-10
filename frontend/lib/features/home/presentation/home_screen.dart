import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jeju_together/features/auth/providers/auth_state_provider.dart';
import 'package:jeju_together/features/home/providers/home_provider.dart';
import 'package:jeju_together/features/itinerary/data/models/itinerary_summary.dart';
import 'package:jeju_together/shared/theme/app_theme.dart';
import 'package:jeju_together/shared/widgets/accessibility_badge.dart';

/// F-3 05. Home Screen
/// 맞춤 추천 일정 + 필터 칩 스트립을 보여주는 홈 화면 (디자인 프로토타입 기반 전면 재구현)
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedFilter = 0;

  static const _filters = ['전체', '🌊 동부 해안', '⛰️ 한라산', '🏛️ 실내 위주', '🍽️ 맛집'];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final nickname = user?.nickname ?? '여행자';
    final asyncItineraries = ref.watch(recommendedItinerariesProvider);

    final count = asyncItineraries.valueOrNull?.length ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── 상단 영역 (home-top) ───────────────────────────────────────────
          _HomeTop(nickname: nickname, itineraryCount: count),

          // ── 필터 칩 스트립 ────────────────────────────────────────────────
          _FilterStrip(
            filters: _filters,
            selectedIndex: _selectedFilter,
            onSelected: (i) => setState(() => _selectedFilter = i),
          ),

          const SizedBox(height: 20),

          // ── 일정 카드 목록 ─────────────────────────────────────────────────
          Expanded(
            child: asyncItineraries.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
              error: (e, _) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: _ErrorCard(message: '일정을 불러오지 못했어요'),
              ),
              data: (list) {
                if (list.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: _EmptyCard(
                      message: '온보딩을 완료하면 맞춤 일정을 추천해 드려요!',
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: list.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
                    child: _ItineraryCard(itinerary: list[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _BottomNav(currentIndex: 0),
    );
  }
}

// ── 상단 영역 ────────────────────────────────────────────────────────────────

class _HomeTop extends StatelessWidget {
  const _HomeTop({required this.nickname, required this.itineraryCount});

  final String nickname;
  final int itineraryCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryXLight, AppColors.background],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 인사말 행 ──────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _GreetingText(nickname: nickname),
                  ),
                  _NotificationButton(),
                ],
              ),

              const SizedBox(height: 14),

              // ── 헤드라인 ──────────────────────────────────────────────────
              _HeadlineText(count: itineraryCount),

              const SizedBox(height: 16),

              // ── 내 여행 조건 카드 ─────────────────────────────────────────
              const _TravelConditionCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreetingText extends StatelessWidget {
  const _GreetingText({required this.nickname});

  final String nickname;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: nickname,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const TextSpan(
            text: '님, 좋은 아침이에요 ☀️',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '알림',
      button: true,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1)), // slate-300
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.notifications_outlined,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
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

class _HeadlineText extends StatelessWidget {
  const _HeadlineText({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: '오늘의 ',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.55,
            ),
          ),
          const TextSpan(
            text: '맞춤 일정',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryMid,
              letterSpacing: -0.55,
            ),
          ),
          TextSpan(
            text: '\n$count개를 준비했어요',
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _TravelConditionCard extends ConsumerWidget {
  const _TravelConditionCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final hasCondition = user?.onboardingComplete == true;

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryLight),
        ),
        child: Row(
          children: [
            // 아이콘 박스
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryXLight,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Center(
                child: Icon(
                  Icons.accessible,
                  size: 22,
                  color: AppColors.primaryMid,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 조건 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '내 여행 조건',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasCondition ? '무장애 여행 · 휠체어 이용' : '여행 조건을 설정해주세요',
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // 변경 버튼
            GestureDetector(
              onTap: () => context.go('/onboarding'),
              child: const Text(
                '변경',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryMid,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 필터 칩 스트립 ────────────────────────────────────────────────────────────

class _FilterStrip extends StatelessWidget {
  const _FilterStrip({
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: Semantics(
              label: filters[i],
              selected: selected,
              button: true,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  filters[i],
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white
                        : const Color(0xFF384151),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── 일정 카드 ─────────────────────────────────────────────────────────────────

class _ItineraryCard extends StatefulWidget {
  const _ItineraryCard({required this.itinerary});

  final ItinerarySummary itinerary;

  @override
  State<_ItineraryCard> createState() => _ItineraryCardState();
}

class _ItineraryCardState extends State<_ItineraryCard> {
  late bool _saved;

  @override
  void initState() {
    super.initState();
    _saved = widget.itinerary.isSaved;
  }

  LinearGradient _coverGradient(String type) {
    switch (type.toUpperCase()) {
      case 'BEACH':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7BB6C5), Color(0xFF1E7A8C)],
        );
      case 'FOREST':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5B9D80), Color(0xFF3B7B63)],
        );
      case 'INDOOR':
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB89B6E), Color(0xFF8C7755)],
        );
      default:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A8C9C), Color(0xFF0F4C5C)],
        );
    }
  }

  String _formatTime(int minutes) {
    if (minutes < 1440) {
      final h = minutes ~/ 60;
      return '${h}h/일';
    }
    final days = minutes ~/ 1440;
    final remaining = minutes % 1440;
    final h = remaining ~/ 60;
    return '$days일 · ${h}h/일';
  }

  String _coverTag(ItinerarySummary it) {
    return it.places > 0 ? '${it.places}곳 코스' : it.title;
  }

  String _typeSubtitle(String type) {
    switch (type.toUpperCase()) {
      case 'BEACH':
        return '바다와 함께하는 무장애 동선';
      case 'FOREST':
        return '자연 속 편안한 무장애 코스';
      case 'INDOOR':
        return '날씨 걱정 없는 실내 위주 코스';
      default:
        return '맞춤형 무장애 여행 일정';
    }
  }

  String _mobilityLabel(int score) {
    if (score >= 80) return '낮음';
    if (score >= 50) return '보통';
    return '높음';
  }

  String _restPoints(int score) {
    if (score >= 80) return '5곳+';
    if (score >= 60) return '3곳';
    return '1곳';
  }

  String _reasonText(int score) {
    if (score >= 80) {
      return '💡 모든 장소가 무장애 시설을 갖추고 이동 부담이 적어요';
    }
    return '💡 안전하게 즐길 수 있는 코스예요';
  }

  Color _scoreColor(int score) {
    if (score >= 80) return AppColors.successDark;
    if (score >= 50) return AppColors.warningDark;
    return AppColors.dangerDark;
  }

  @override
  Widget build(BuildContext context) {
    final it = widget.itinerary;
    final score = it.accessibilityScore;

    return Semantics(
      label: '${it.title} 일정 카드',
      button: true,
      child: GestureDetector(
        onTap: () => context.push('/itinerary/${it.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.dividerLight),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F4C5C).withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 커버 영역 ─────────────────────────────────────────────────
              _CardCover(
                gradient: _coverGradient(it.type),
                tag: _coverTag(it),
                title: it.title,
                subtitle: _typeSubtitle(it.type),
                saved: _saved,
                onSaveToggle: () => setState(() => _saved = !_saved),
              ),

              // ── 본문 영역 ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 통계 행
                    _StatsRow(
                      estimatedTime: _formatTime(it.estimatedTime),
                      mobility: _mobilityLabel(score),
                      mobilityColor: score >= 50
                          ? AppColors.successDark
                          : AppColors.dangerDark,
                      restPoints: _restPoints(score),
                      safetyScore: '$score점',
                      safetyColor: _scoreColor(score),
                    ),

                    const SizedBox(height: 14),

                    // 추천 이유
                    _ReasonBox(text: _reasonText(score)),

                    const SizedBox(height: 12),

                    // 푸터
                    _CardFooter(itinerary: it),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardCover extends StatelessWidget {
  const _CardCover({
    required this.gradient,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.saved,
    required this.onSaveToggle,
  });

  final LinearGradient gradient;
  final String tag;
  final String title;
  final String subtitle;
  final bool saved;
  final VoidCallback onSaveToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(gradient: gradient),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 행: 태그 + 저장 버튼
            Row(
              children: [
                // 태그 칩
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                // 저장 버튼
                Semantics(
                  label: saved ? '저장됨' : '저장하기',
                  button: true,
                  child: GestureDetector(
                    onTap: onSaveToggle,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          saved ? Icons.favorite : Icons.favorite_border,
                          size: 17,
                          color: saved ? AppColors.danger : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // 하단: 제목 + 부제목
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 6,
                    color: Color(0x55000000),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.estimatedTime,
    required this.mobility,
    required this.mobilityColor,
    required this.restPoints,
    required this.safetyScore,
    required this.safetyColor,
  });

  final String estimatedTime;
  final String mobility;
  final Color mobilityColor;
  final String restPoints;
  final String safetyScore;
  final Color safetyColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(label: '총 소요', value: estimatedTime),
        const _StatDivider(),
        _StatItem(label: '이동 난이도', value: mobility, valueColor: mobilityColor),
        const _StatDivider(),
        _StatItem(label: '휴식 포인트', value: restPoints),
        const _StatDivider(),
        _StatItem(label: '안전 점수', value: safetyScore, valueColor: safetyColor),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8), // slate-400
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.divider,
    );
  }
}

class _ReasonBox extends StatelessWidget {
  const _ReasonBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.primaryXLight,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: AppColors.primaryMid, width: 3),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: Color(0xFF384151), // slate-700
          height: 1.55,
        ),
      ),
    );
  }
}

class _CardFooter extends StatelessWidget {
  const _CardFooter({required this.itinerary});

  final ItinerarySummary itinerary;

  @override
  Widget build(BuildContext context) {
    // 배지: accessibilityScore >= 80 → 경사로+화장실, >= 50 → 경사로, else → 없음
    final score = itinerary.accessibilityScore;
    final List<AccessibilityType> badges = [];
    if (score >= 50) badges.add(AccessibilityType.ramp);
    if (score >= 70) badges.add(AccessibilityType.accessibleToilet);
    if (score >= 80) badges.add(AccessibilityType.restZone);

    return Row(
      children: [
        // 배지들
        Expanded(
          child: badges.isEmpty
              ? const SizedBox.shrink()
              : Wrap(
                  spacing: 6,
                  children: badges
                      .map(
                        (t) => AccessibilityBadge(type: t, showLabel: true),
                      )
                      .toList(),
                ),
        ),
        // 화살표
        const Icon(
          Icons.chevron_right,
          size: 20,
          color: Color(0xFF94A3B8), // slate-400
        ),
      ],
    );
  }
}

// ── 공통 빈/에러 카드 ─────────────────────────────────────────────────────────

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.explore_off_outlined,
            size: 40,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textHint,
              height: 1.55,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 20, color: AppColors.danger),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14,
              color: AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 하단 탭바 ─────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    const selectedColor = AppColors.primary;
    const defaultColor = Color(0xFF94A3B8); // slate-400

    const tabs = [
      _TabItem(icon: Icons.home_outlined, label: '홈'),
      _TabItem(icon: Icons.search_outlined, label: '탐색'),
      _TabItem(icon: Icons.calendar_today_outlined, label: '내 일정'),
      _TabItem(icon: Icons.person_outline, label: '마이'),
    ];

    return Container(
      height: 72 + MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.dividerLight, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(tabs.length, (i) {
            final selected = i == currentIndex;
            return Expanded(
              child: Semantics(
                label: tabs[i].label,
                selected: selected,
                button: true,
                child: GestureDetector(
                  onTap: () {
                    switch (i) {
                      case 0:
                        context.go('/itinerary/result');
                      case 1:
                        context.go('/spots');
                      case 2:
                        context.go('/itinerary/result');
                      case 3:
                        context.go('/mypage');
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tabs[i].icon,
                        size: 22,
                        color: selected ? selectedColor : defaultColor,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tabs[i].label,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 11,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected ? selectedColor : defaultColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
