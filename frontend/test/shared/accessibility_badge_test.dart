import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jeju_together/shared/widgets/accessibility_badge.dart';

void main() {
  group('AccessibilityBadge', () {
    testWidgets('경사로 배지가 올바른 레이블을 표시한다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AccessibilityBadge(type: AccessibilityType.ramp),
          ),
        ),
      );

      expect(find.text('경사로'), findsOneWidget);
    });

    testWidgets('showLabel=false이면 텍스트가 표시되지 않는다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AccessibilityBadge(
              type: AccessibilityType.elevator,
              showLabel: false,
            ),
          ),
        ),
      );

      expect(find.text('엘리베이터'), findsNothing);
      expect(find.byIcon(Icons.elevator), findsOneWidget);
    });

    testWidgets('Semantics label이 설정된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AccessibilityBadge(type: AccessibilityType.accessibleToilet),
          ),
        ),
      );

      final semantics = tester.getSemantics(
          find.byType(AccessibilityBadge));
      expect(semantics.label, contains('장애인 화장실'));
    });
  });

  group('AccessibilityBadgeRow', () {
    testWidgets('활성화된 배지만 표시된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AccessibilityBadgeRow(
              hasRamp: true,
              hasElevator: false,
              hasAccessibleToilet: true,
              hasRestZone: false,
              hasAccessibleParking: false,
            ),
          ),
        ),
      );

      expect(find.text('경사로'), findsOneWidget);
      expect(find.text('장애인 화장실'), findsOneWidget);
      expect(find.text('엘리베이터'), findsNothing);
    });

    testWidgets('모두 false이면 SizedBox.shrink가 반환된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AccessibilityBadgeRow(
              hasRamp: false,
              hasElevator: false,
              hasAccessibleToilet: false,
              hasRestZone: false,
              hasAccessibleParking: false,
            ),
          ),
        ),
      );

      expect(find.byType(AccessibilityBadge), findsNothing);
    });
  });

  group('AccessibilityTypeX', () {
    test('모든 타입이 레이블, 아이콘, 색상을 가진다', () {
      for (final type in AccessibilityType.values) {
        expect(type.label, isNotEmpty);
        expect(type.icon, isNotNull);
        expect(type.color, isNotNull);
      }
    });
  });
}
