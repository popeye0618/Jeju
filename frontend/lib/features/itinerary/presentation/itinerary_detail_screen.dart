import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jeju_together/features/itinerary/data/models/itinerary_detail.dart';
import 'package:jeju_together/features/itinerary/data/models/place_in_itinerary.dart';
import 'package:jeju_together/features/itinerary/providers/itinerary_detail_provider.dart';
import 'package:jeju_together/shared/theme/app_theme.dart';
import 'package:jeju_together/shared/widgets/accessibility_badge.dart';

// ── 상수 ─────────────────────────────────────────────────────────────────────
const double _kCoverHeight = 180;
const double _kScoreCircleOuter = 64;
const double _kScoreCircleInner = 52;
const double _kNavButtonSize = 38;
const double _kActionBarHeight = 52;
const double _kDayTabHeight = 58;
const double _kTimelineLeftPad = 64.0;
const double _kDotSize = 14;
const int _kDefaultStayMinutes = 90;
const int _kTransferMinutes = 15;
/// 일정 상세 화면 — 06. ITINERARY DETAIL
///
/// HTML 프로토타입의 06번 화면을 Flutter로 구현한 전용 상세 화면.
/// 하단 탭바 없이 뒤로가기로만 나가는 독립 페이지.
class ItineraryDetailScreen extends ConsumerStatefulWidget {
  const ItineraryDetailScreen({super.key, required this.itineraryId});

  /// 조회할 일정 ID
  final int itineraryId;

  @override
  ConsumerState<ItineraryDetailScreen> createState() =>
      _ItineraryDetailScreenState();
}

class _ItineraryDetailScreenState
    extends ConsumerState<ItineraryDetailScreen> {
  /// 현재 선택된 Day (1부터 시작)
  int _selectedDay = 1;

  /// 0: 타임라인, 1: 지도 보기
  int _viewTab = 0;

  /// 저장 상태 (낙관적 업데이트용)
  bool? _savedOverride;

  late final ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        final offset = _scrollController.offset.clamp(0.0, double.infinity);
        if (offset != _scrollOffset) {
          setState(() => _scrollOffset = offset);
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncDetail =
        ref.watch(itineraryDetailProvider(widget.itineraryId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: asyncDetail.when(
        loading: () => const _LoadingView(),
        error: (e, st) => _ErrorView(error: e),
        data: (detail) => _DetailBody(
          detail: detail,
          selectedDay: _selectedDay,
          viewTab: _viewTab,
          savedOverride: _savedOverride,
          scrollController: _scrollController,
          scrollOffset: _scrollOffset,
          onDayChanged: (day) => setState(() => _selectedDay = day),
          onViewTabChanged: (tab) => setState(() => _viewTab = tab),
          onSave: () => _toggleSave(detail),
          onBack: () => Navigator.of(context).pop(),
          onShare: () {/* 공유 기능 */},
          onAlternative: () {/* 다른 코스 */},
        ),
      ),
    );
  }

  void _toggleSave(ItineraryDetail detail) {
    final current = _savedOverride ?? detail.isSaved;
    setState(() => _savedOverride = !current);
    // 실제 API 호출은 여기에서 ref.read(...).saveItinerary / unsaveItinerary
  }
}

// ── 로딩 뷰 ──────────────────────────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }
}

// ── 에러 뷰 ──────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: AppColors.danger),
            const SizedBox(height: 16),
            const Text(
              '일정을 불러오지 못했어요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontFamily: 'Pretendard',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textHint,
                fontFamily: 'Pretendard',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('돌아가기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 메인 본문 ─────────────────────────────────────────────────────────────────
class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.detail,
    required this.selectedDay,
    required this.viewTab,
    required this.savedOverride,
    required this.scrollController,
    required this.scrollOffset,
    required this.onDayChanged,
    required this.onViewTabChanged,
    required this.onSave,
    required this.onBack,
    required this.onShare,
    required this.onAlternative,
  });

  final ItineraryDetail detail;
  final int selectedDay;
  final int viewTab;
  final bool? savedOverride;
  final ScrollController scrollController;
  final double scrollOffset;
  final ValueChanged<int> onDayChanged;
  final ValueChanged<int> onViewTabChanged;
  final VoidCallback onSave;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onAlternative;

  static const List<PlaceInItinerary> _dummyPlaces = [
    PlaceInItinerary(
      id: 1, name: '성산일출봉', order: 1, day: 1,
      lat: 33.458, lng: 126.942, estimatedMinutes: 120,
      hasRamp: true, hasElevator: false,
      hasAccessibleToilet: true, hasRestZone: true, hasAccessibleParking: true,
    ),
    PlaceInItinerary(
      id: 2, name: '섭지코지', order: 2, day: 1,
      lat: 33.431, lng: 126.924, estimatedMinutes: 90,
      hasRamp: false, hasElevator: false,
      hasAccessibleToilet: false, hasRestZone: true, hasAccessibleParking: true,
    ),
    PlaceInItinerary(
      id: 3, name: '우도 해변로', order: 3, day: 1,
      lat: 33.504, lng: 126.952, estimatedMinutes: 150,
      hasRamp: true, hasElevator: false,
      hasAccessibleToilet: true, hasRestZone: false, hasAccessibleParking: false,
    ),
    PlaceInItinerary(
      id: 4, name: '김녕미로공원', order: 4, day: 1,
      lat: 33.548, lng: 126.762, estimatedMinutes: 60,
      hasRamp: true, hasElevator: true,
      hasAccessibleToilet: true, hasRestZone: true, hasAccessibleParking: true,
    ),
  ];

  List<PlaceInItinerary> get _effectivePlaces =>
      detail.places.isEmpty ? _dummyPlaces : detail.places;

  int get _accessibilityScore {
    final places = _effectivePlaces;
    if (places.isEmpty) return 100;
    final total = places.map(_placeScore).reduce((a, b) => a + b);
    return (total / places.length).round();
  }

  static int _placeScore(PlaceInItinerary p) {
    int score = 0;
    if (p.hasRamp) score += 25;
    if (p.hasElevator) score += 25;
    if (p.hasAccessibleToilet) score += 25;
    if (p.hasRestZone) score += 25;
    return score;
  }

  bool get _isSaved => savedOverride ?? detail.isSaved;

  @override
  Widget build(BuildContext context) {
    final places = _effectivePlaces;
    final score = _accessibilityScore;
    final dayGroups = _groupByDay(places);
    final dayList = dayGroups.keys.toList()..sort();
    final placesForDay =
        viewTab == 0 ? (dayGroups[selectedDay] ?? []) : [];

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            controller: scrollController,
            clipBehavior: Clip.none,
            slivers: [
              // A. 커버
              SliverToBoxAdapter(
                child: _CoverSection(
                  detail: detail,
                  isSaved: _isSaved,
                  scrollOffset: scrollOffset,
                  onBack: onBack,
                  onShare: onShare,
                  onSave: onSave,
                ),
              ),
              // B. 안전 점수 카드
              SliverToBoxAdapter(
                child: _ScoreStrip(
                  score: score,
                  totalPlaces: places.length,
                  restPlaces: places.where((p) => p.hasRestZone).length,
                ),
              ),
              // C. 경고 배너 (선택적)
              if (score < 80)
                const SliverToBoxAdapter(child: _AlertBanner()),
              // D. 뷰 토글
              SliverToBoxAdapter(
                child: _ViewToggle(
                  selected: viewTab,
                  onChanged: onViewTabChanged,
                ),
              ),
              if (viewTab == 1)
                const SliverFillRemaining(child: _MapPlaceholder())
              else ...[
                // E. Day 탭
                SliverToBoxAdapter(
                  child: _DayTabs(
                    dayList: dayList,
                    dayGroups: dayGroups,
                    selectedDay: selectedDay,
                    onChanged: onDayChanged,
                  ),
                ),
                // F. 타임라인
                SliverToBoxAdapter(
                  child: placesForDay.isEmpty
                      ? const _EmptyPlaces()
                      : _Timeline(
                          places: placesForDay as List<PlaceInItinerary>,
                        ),
                ),
              ],
            ],
          ),
        ),
        // G. 하단 액션 바
        _ActionBar(
          isSaved: _isSaved,
          onSave: onSave,
          onAlternative: onAlternative,
        ),
      ],
    );
  }

  static Map<int, List<PlaceInItinerary>> _groupByDay(
      List<PlaceInItinerary> places) {
    final map = <int, List<PlaceInItinerary>>{};
    for (final p in places) {
      map.putIfAbsent(p.day, () => []).add(p);
    }
    for (final list in map.values) {
      list.sort((a, b) => a.order.compareTo(b.order));
    }
    return map;
  }
}

// ── A. 커버 영역 ──────────────────────────────────────────────────────────────
class _CoverSection extends StatelessWidget {
  const _CoverSection({
    required this.detail,
    required this.isSaved,
    required this.scrollOffset,
    required this.onBack,
    required this.onShare,
    required this.onSave,
  });

  final ItineraryDetail detail;
  final bool isSaved;
  final double scrollOffset;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final fadeThreshold = _kCoverHeight * 0.55;
    final titleOpacity =
        (1.0 - (scrollOffset / fadeThreshold)).clamp(0.0, 1.0);
    final titleOffsetY = -(scrollOffset * 0.45);

    return SizedBox(
      height: _kCoverHeight + topPadding,
      child: Stack(
        children: [
          // 배경 그라디언트
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF7BB6C5), AppColors.primary],
                ),
              ),
            ),
          ),
          // 하단 오버레이
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 80,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x800A3A48),
                  ],
                ),
              ),
            ),
          ),
          // 내용
          Padding(
            padding: EdgeInsets.fromLTRB(16, topPadding + 8, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 네비게이션 행
                Row(
                  children: [
                    Semantics(
                      label: '뒤로가기',
                      button: true,
                      child: _NavButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: onBack,
                      ),
                    ),
                    const Spacer(),
                    Semantics(
                      label: '일정 공유',
                      button: true,
                      child: _NavButton(
                        icon: Icons.ios_share_rounded,
                        onTap: onShare,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Semantics(
                      label: isSaved ? '저장됨' : '저장하기',
                      button: true,
                      child: _NavButton(
                        icon: isSaved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        onTap: onSave,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // 제목 블록 (스크롤 시 위로 이동하며 페이드)
                Transform.translate(
                  offset: Offset(0, titleOffsetY),
                  child: Opacity(
                    opacity: titleOpacity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${detail.days}일 코스',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xE6FFFFFF),
                            letterSpacing: 2.0,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          detail.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _kNavButtonSize,
        height: _kNavButtonSize,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(_kNavButtonSize / 2),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// ── B. 안전 점수 카드 ─────────────────────────────────────────────────────────
class _ScoreStrip extends StatelessWidget {
  const _ScoreStrip({
    required this.score,
    required this.totalPlaces,
    required this.restPlaces,
  });

  final int score;
  final int totalPlaces;
  final int restPlaces;

  Color get _scoreColor {
    if (score >= 80) return AppColors.successDark;
    if (score >= 50) return AppColors.warningDark;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
            children: [
              // 스코어 원
              Semantics(
                label: '안전 점수 $score점',
                child: _ScoreCircle(
                  score: score,
                  color: _scoreColor,
                ),
              ),
              const SizedBox(width: 14),
              // 정보 컬럼
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '이 일정의 안전 점수',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHint,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(height: 4),
                    score >= 80
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                fontFamily: 'Pretendard',
                              ),
                              children: [
                                TextSpan(
                                  text: '완주 가능',
                                  style: TextStyle(
                                      color: _scoreColor),
                                ),
                                const TextSpan(text: ' 일정이에요'),
                              ],
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                fontFamily: 'Pretendard',
                              ),
                              children: [
                                TextSpan(
                                  text: '부분 완주 가능',
                                  style: TextStyle(
                                      color: _scoreColor),
                                ),
                                const TextSpan(text: ' 일정이에요'),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
              // 통계
              Container(
                height: 48,
                width: 1,
                color: AppColors.dividerLight,
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              _StatsColumn(
                  totalPlaces: totalPlaces, restPlaces: restPlaces),
            ],
          ),
        ),
    );
  }
}

class _ScoreCircle extends StatelessWidget {
  const _ScoreCircle({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kScoreCircleOuter,
      height: _kScoreCircleOuter,
      child: CustomPaint(
        painter: _ArcPainter(
          score: score,
          color: color,
        ),
        child: Center(
          child: Container(
            width: _kScoreCircleInner,
            height: _kScoreCircleInner,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: color,
                    fontFamily: 'Pretendard',
                    height: 1.0,
                  ),
                ),
                const Text(
                  'SAFE',
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColors.textHint,
                    fontFamily: 'Pretendard',
                    letterSpacing: 0.5,
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

class _ArcPainter extends CustomPainter {
  const _ArcPainter({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 4.0;

    // 배경 트랙
    final trackPaint = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, trackPaint);

    // 진행 호
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * (score / 100);
    canvas.drawArc(
      Rect.fromCircle(
          center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.score != score || old.color != color;
}

class _StatsColumn extends StatelessWidget {
  const _StatsColumn(
      {required this.totalPlaces, required this.restPlaces});

  final int totalPlaces;
  final int restPlaces;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatItem(value: '$totalPlaces곳', label: '장소'),
        const SizedBox(height: 6),
        _StatItem(value: '$restPlaces곳', label: '휴식'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontFamily: 'Pretendard',
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textHint,
            fontFamily: 'Pretendard',
          ),
        ),
      ],
    );
  }
}

// ── C. 경고 배너 ──────────────────────────────────────────────────────────────
class _AlertBanner extends StatelessWidget {
  const _AlertBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
          decoration: BoxDecoration(
            color: AppColors.warningBg,
            border: Border.all(color: const Color(0xFFF0DCAF)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아이콘 박스
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: AppColors.warningDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '일부 구간 주의가 필요해요',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warningDark,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      '일정 내 일부 장소에 접근 제한이 있을 수 있어요.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {/* 대체 코스 보기 */},
                      child: const Text(
                        '대체 코스 보기 →',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.warningDark,
                          decoration: TextDecoration.underline,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}

// ── D. 뷰 토글 ────────────────────────────────────────────────────────────────
class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  static const _tabs = ['타임라인', '지도 보기'];
  static const _icons = ['📋', '🗺️'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final isSelected = selected == i;
            return Expanded(
              child: Semantics(
                label: _tabs[i],
                selected: isSelected,
                button: true,
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 38,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${_icons[i]} ${_tabs[i]}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : const Color(0xFF64748B),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
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

// ── 지도 플레이스홀더 ─────────────────────────────────────────────────────────
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '지도 보기 준비 중이에요',
        style: TextStyle(
          fontSize: 16,
          color: AppColors.textHint,
          fontFamily: 'Pretendard',
        ),
      ),
    );
  }
}

// ── E. Day 탭 ─────────────────────────────────────────────────────────────────
class _DayTabs extends StatelessWidget {
  const _DayTabs({
    required this.dayList,
    required this.dayGroups,
    required this.selectedDay,
    required this.onChanged,
  });

  final List<int> dayList;
  final Map<int, List<PlaceInItinerary>> dayGroups;
  final int selectedDay;
  final ValueChanged<int> onChanged;

  // 3일 이하 → 세그먼트(꽉 참), 4일 이상 → 가로 스크롤
  static const int _kSegmentThreshold = 3;

  Widget _buildTab(int day, bool isSelected, int count) {
    return Semantics(
      label: '$day일차, $count곳',
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: () => onChanged(day),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _kDayTabHeight,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$day일차',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textHint,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count곳',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontFamily: 'Pretendard',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (dayList.isEmpty) return const SizedBox.shrink();

    final useSegment = dayList.length <= _kSegmentThreshold;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: useSegment
          // ── 세그먼트: Expanded로 꽉 채움
          ? Row(
              children: [
                for (int i = 0; i < dayList.length; i++) ...[
                  Expanded(
                    child: _buildTab(
                      dayList[i],
                      dayList[i] == selectedDay,
                      dayGroups[dayList[i]]?.length ?? 0,
                    ),
                  ),
                  if (i < dayList.length - 1) const SizedBox(width: 10),
                ],
              ],
            )
          // ── 스크롤: 기존 고정폭 탭
          : SizedBox(
              height: _kDayTabHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dayList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final day = dayList[i];
                  return SizedBox(
                    width: 72,
                    child: _buildTab(
                      day,
                      day == selectedDay,
                      dayGroups[day]?.length ?? 0,
                    ),
                  );
                },
              ),
            ),
    );
  }
}

// ── 빈 장소 뷰 ────────────────────────────────────────────────────────────────
class _EmptyPlaces extends StatelessWidget {
  const _EmptyPlaces();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: Text(
          '아직 장소 정보가 없어요',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textHint,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
    );
  }
}

// ── F. 타임라인 ───────────────────────────────────────────────────────────────
class _Timeline extends StatelessWidget {
  const _Timeline({required this.places});

  final List<PlaceInItinerary> places;

  /// 09:00 기준 누적 분 계산 후 HH:MM 포맷으로 반환
  static String _formatTime(int accumulatedMinutes) {
    const kBaseMinutes = 9 * 60; // 09:00
    final total = kBaseMinutes + accumulatedMinutes;
    final h = total ~/ 60;
    final m = total % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  static int _stayMinutes(PlaceInItinerary p) =>
      p.estimatedMinutes > 0 ? p.estimatedMinutes : _kDefaultStayMinutes;

  static int _placeScore(PlaceInItinerary p) {
    int score = 0;
    if (p.hasRamp) score += 25;
    if (p.hasElevator) score += 25;
    if (p.hasAccessibleToilet) score += 25;
    if (p.hasRestZone) score += 25;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 20),
      child: Stack(
        children: [
          // 세로 연결선
          Positioned(
            left: _kTimelineLeftPad - 1,
            top: 24,
            bottom: 60,
            width: 2,
            child: Container(color: AppColors.divider),
          ),
          Column(
            children: _buildItems(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildItems() {
    final items = <Widget>[];
    int elapsed = 0;

    for (int i = 0; i < places.length; i++) {
      final place = places[i];
      final timeLabel = _formatTime(elapsed);
      final score = _placeScore(place);
      final isFirst = i == 0;

      items.add(
        _TimelineItem(
          timeLabel: timeLabel,
          place: place,
          score: score,
          isFirst: isFirst,
        ),
      );

      elapsed += _stayMinutes(place);

      // 이동 구간 (마지막 장소 제외)
      if (i < places.length - 1) {
        items.add(const _TransferRow());
        elapsed += _kTransferMinutes;
      }
    }

    return items;
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.timeLabel,
    required this.place,
    required this.score,
    required this.isFirst,
  });

  final String timeLabel;
  final PlaceInItinerary place;
  final int score;
  final bool isFirst;

  bool get _isSafe => score >= 80;

  String get _categoryLabel {
    final stay = place.estimatedMinutes > 0
        ? place.estimatedMinutes
        : _kDefaultStayMinutes;
    return '$stay분 체류';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 시간 레이블
          SizedBox(
            width: 34,
            child: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: Text(
                timeLabel,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF64748B),
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // 점
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: Container(
              width: _kDotSize,
              height: _kDotSize,
              decoration: BoxDecoration(
                color: isFirst
                    ? AppColors.primaryMid
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryMid,
                  width: 3,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 카드
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.dividerLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 헤드 행
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _categoryLabel,
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF64748B),
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 안전 배지
                      _SafetyBadge(isSafe: _isSafe),
                    ],
                  ),
                  // 무장애 배지들
                  const SizedBox(height: 8),
                  AccessibilityBadgeRow(
                    hasRamp: place.hasRamp,
                    hasElevator: place.hasElevator,
                    hasAccessibleToilet: place.hasAccessibleToilet,
                    hasRestZone: place.hasRestZone,
                    hasAccessibleParking: place.hasAccessibleParking,
                  ),
                  // 추천 이유 박스
                  const SizedBox(height: 9),
                  const _DashedDivider(),
                  const SizedBox(height: 8),
                  Text(
                    _reasonText,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      height: 1.5,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _reasonText {
    if (score >= 50) {
      return '무장애 시설이 잘 갖춰진 곳이에요';
    }
    return '일부 구간 이동 시 주의가 필요해요';
  }
}

class _SafetyBadge extends StatelessWidget {
  const _SafetyBadge({required this.isSafe});

  final bool isSafe;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isSafe ? '안전한 장소' : '주의가 필요한 장소',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSafe ? AppColors.successBg : AppColors.warningBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          isSafe ? '안전' : '주의',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isSafe ? AppColors.successDark : AppColors.warningDark,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: CustomPaint(
        painter: _DashedLinePainter(),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => false;
}

// ── 이동 구간 ─────────────────────────────────────────────────────────────────
class _TransferRow extends StatelessWidget {
  const _TransferRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_kTimelineLeftPad, 6, 0, 20),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F1E8),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Center(child: Text('🚙', style: TextStyle(fontSize: 12))),
          ),
          const SizedBox(width: 10),
          const Text(
            '차량 이동 · 약 15분',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
              fontFamily: 'Pretendard',
            ),
          ),
        ],
      ),
    );
  }
}

// ── G. 하단 액션 바 ───────────────────────────────────────────────────────────
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.isSaved,
    required this.onSave,
    required this.onAlternative,
  });

  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onAlternative;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + bottomPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.dividerLight),
        ),
      ),
      child: Row(
        children: [
          // 다른 코스 버튼
          Semantics(
            label: '다른 코스 보기',
            button: true,
            child: GestureDetector(
              onTap: onAlternative,
              child: Container(
                width: 130,
                height: _kActionBarHeight,
                decoration: BoxDecoration(
                  color: AppColors.primaryXLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primaryLight),
                ),
                child: const Center(
                  child: Text(
                    '다른 코스',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // 일정 저장하기 버튼
          Expanded(
            child: Semantics(
              label: isSaved ? '저장됨' : '일정 저장하기',
              button: true,
              child: GestureDetector(
                onTap: onSave,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: _kActionBarHeight,
                  decoration: BoxDecoration(
                    color: isSaved
                        ? AppColors.successDark
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      isSaved ? '저장됨' : '일정 저장하기',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
