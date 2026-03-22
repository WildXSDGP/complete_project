import 'package:flutter/material.dart';

class SafariTheme {
  SafariTheme._();

  static const Color forestGreen   = Color(0xFF1E7D34);
  static const Color leafGreen     = Color(0xFF2DA44E);
  static const Color mintGreen     = Color(0xFFE6F4EA);
  static const Color amber         = Color(0xFFF59E0B);
  static const Color sky           = Color(0xFF3B82F6);
  static const Color coral         = Color(0xFFEF4444);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color background    = Color(0xFFF4F6F8);
  static const Color textPrimary   = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color cardBorder    = Color(0xFFE5E7EB);

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A6B2C), Color(0xFF2DA44E)],
  );

  static BoxDecoration get cardDecoration => const BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.fromBorderSide(BorderSide(color: cardBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      );

  static TextStyle get displayFont => const TextStyle(
        fontWeight: FontWeight.w800,
      );

  static ThemeData get materialTheme => ThemeData(
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: forestGreen),
        useMaterial3: true,
      );
}
