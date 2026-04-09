import 'package:flutter/material.dart';
import 'package:jeju_together/shared/theme/app_theme.dart';

/// 무장애 편의시설 배지 유형
enum AccessibilityType {
  ramp,
  elevator,
  accessibleToilet,
  restZone,
  accessibleParking,
}

extension AccessibilityTypeX on AccessibilityType {
  String get label {
    switch (this) {
      case AccessibilityType.ramp:
        return '경사로';
      case AccessibilityType.elevator:
        return '엘리베이터';
      case AccessibilityType.accessibleToilet:
        return '장애인 화장실';
      case AccessibilityType.restZone:
        return '휴게 공간';
      case AccessibilityType.accessibleParking:
        return '장애인 주차';
    }
  }

  IconData get icon {
    switch (this) {
      case AccessibilityType.ramp:
        return Icons.accessible_forward;
      case AccessibilityType.elevator:
        return Icons.elevator;
      case AccessibilityType.accessibleToilet:
        return Icons.wc;
      case AccessibilityType.restZone:
        return Icons.chair;
      case AccessibilityType.accessibleParking:
        return Icons.local_parking;
    }
  }

  Color get color {
    switch (this) {
      case AccessibilityType.ramp:
        return AppColors.rampColor;
      case AccessibilityType.elevator:
        return AppColors.elevatorColor;
      case AccessibilityType.accessibleToilet:
        return AppColors.toiletColor;
      case AccessibilityType.restZone:
        return AppColors.restAreaColor;
      case AccessibilityType.accessibleParking:
        return AppColors.primary;
    }
  }
}

/// 단일 무장애 배지
class AccessibilityBadge extends StatelessWidget {
  const AccessibilityBadge({
    super.key,
    required this.type,
    this.showLabel = true,
  });

  final AccessibilityType type;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: type.label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: type.color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: type.color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(type.icon, size: 14, color: type.color),
            if (showLabel) ...[
              const SizedBox(width: 4),
              Text(
                type.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: type.color,
                  fontFamily: 'Pretendard',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 여러 무장애 배지를 한 번에 표시하는 위젯
class AccessibilityBadgeRow extends StatelessWidget {
  const AccessibilityBadgeRow({
    super.key,
    required this.hasRamp,
    required this.hasElevator,
    required this.hasAccessibleToilet,
    required this.hasRestZone,
    required this.hasAccessibleParking,
    this.showLabel = true,
  });

  final bool hasRamp;
  final bool hasElevator;
  final bool hasAccessibleToilet;
  final bool hasRestZone;
  final bool hasAccessibleParking;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final badges = <AccessibilityType>[
      if (hasRamp) AccessibilityType.ramp,
      if (hasElevator) AccessibilityType.elevator,
      if (hasAccessibleToilet) AccessibilityType.accessibleToilet,
      if (hasRestZone) AccessibilityType.restZone,
      if (hasAccessibleParking) AccessibilityType.accessibleParking,
    ];

    if (badges.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: badges
          .map((type) => AccessibilityBadge(type: type, showLabel: showLabel))
          .toList(),
    );
  }
}
