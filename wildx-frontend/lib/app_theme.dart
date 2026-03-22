import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: kBackground,
    colorSchemeSeed: kGreen,
    brightness: Brightness.light,

    // ── App bar ──
    appBarTheme: const AppBarTheme(
      backgroundColor: kGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: -0.3,
      ),
    ),

    // ── Cards ──
    cardTheme: CardThemeData(
      color: kCardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kRadiusLG),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── Primary button ──
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusMD),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
    ),

    // ── Outlined button ──
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kGreen,
        side: const BorderSide(color: kGreenLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusMD),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
    ),

    // ── Dividers ──
    dividerTheme: const DividerThemeData(
      color: kDividerColor,
      thickness: 1,
      space: 0,
    ),

    // ── Text ──
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: kTextPrimary,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: kTextPrimary,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: kTextPrimary,
        letterSpacing: -0.2,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: kTextPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: kTextPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: kTextPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: kTextPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: kTextSecondary,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: kTextHint,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: kGreen,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: kTextHint,
      ),
    ),
  );
}

// ── Shared decoration helpers ───────────────────────────────────────────────

BoxDecoration kCardDecoration = BoxDecoration(
  color: kCardBackground,
  borderRadius: BorderRadius.circular(kRadiusLG),
  boxShadow: const [
    BoxShadow(
      color: kShadowColor,
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ],
);

BoxDecoration kSoftCardDecoration = BoxDecoration(
  color: kGreenSoft,
  borderRadius: BorderRadius.circular(kRadiusLG),
);
