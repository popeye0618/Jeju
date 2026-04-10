import 'package:flutter/material.dart';

class AppColors {
  // Primary (Teal)
  static const primary = Color(0xFF0F4C5C);       // teal-800
  static const primaryDark = Color(0xFF0A3A48);   // teal-900
  static const primaryMid = Color(0xFF136073);    // teal-700
  static const primaryLight = Color(0xFFE2F1F3);  // teal-100
  static const primaryXLight = Color(0xFFF1F8F9); // teal-50
  // 기존 호환 alias
  static const accent = Color(0xFF1E7A8C);        // teal-600

  // Semantic — warning
  static const warning = Color(0xFFD99E41);
  static const warningDark = Color(0xFFAB7726);
  static const warningBg = Color(0xFFFCF4E1);

  // Semantic — danger
  static const danger = Color(0xFFC65B5B);
  static const dangerDark = Color(0xFFA44646);
  static const dangerBg = Color(0xFFFBEDED);

  // Semantic — success
  static const success = Color(0xFF5B9D80);
  static const successDark = Color(0xFF3B7B63);
  static const successBg = Color(0xFFE8F5ED);

  // Neutral
  static const background = Color(0xFFFAFAF7);    // bg
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF121827);   // slate-900
  static const textSecondary = Color(0xFF384151); // slate-700
  static const textHint = Color(0xFF64748B);      // slate-500
  static const divider = Color(0xFFE2E8F0);       // slate-200
  static const dividerLight = Color(0xFFF1F5F9);  // slate-100

  // Accessibility badges
  static const rampColor = Color(0xFF488AAD);     // ramp
  static const elevatorColor = Color(0xFF84609E); // elev
  static const toiletColor = Color(0xFF589F78);   // toilet
  static const restAreaColor = Color(0xFFD4943F); // rest
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.danger,
        ),
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: AppColors.background,

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        // ElevatedButton — 관광 약자 고려: 최소 48px 높이
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // OutlinedButton
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // InputDecoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          hintStyle: const TextStyle(
            color: AppColors.textHint,
            fontFamily: 'Pretendard',
          ),
        ),

        // Card
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.divider),
          ),
          margin: EdgeInsets.zero,
        ),

        // Chip (무장애 배지 등)
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.primaryLight,
          labelStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),

        // Text
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          titleLarge: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          titleMedium: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          titleSmall: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          bodyLarge: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
          bodyMedium: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary),
          labelLarge: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
        ),
      );
}
