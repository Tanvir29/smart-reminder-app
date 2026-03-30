/// Light and dark theme definitions for the app.
///
/// Uses [ADHDColors] for high-contrast, low-stimulus design
/// per the ADHD-Friendly UX Contract (§10.2).
library;

import 'package:flutter/material.dart';
import 'package:smart_reminder_app/app/theme/adhd_colors.dart';

/// Provides light and dark [ThemeData] instances using [ADHDColors].
class AppTheme {
  AppTheme._();

  // ── Shared constants ──────────────────────────────────────────────────────

  static const _fontFamily = 'Roboto';

  static final _cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

  static final _sheetShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  );

  // ── Light theme ───────────────────────────────────────────────────────────

  /// Light theme — low-stimulus background, high-contrast foreground.
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: ADHDColors.upcoming, // Blue — CTAs, app bar
      onPrimary: Colors.white,
      secondary: ADHDColors.xpBar, // Purple — XP, gamification accents
      onSecondary: Colors.white,
      tertiary: ADHDColors.streakActive, // Orange — streak badges
      onTertiary: Colors.white,
      error: ADHDColors.missed, // Red — errors, missed doses
      onError: Colors.white,
      surface: ADHDColors.surface, // White cards
      onSurface: ADHDColors.neutral, // Dark grey text
      surfaceContainerHighest: ADHDColors.background, // Scaffold bg
      outline: Color(0xFFBDBDBD),
      outlineVariant: Color(0xFFE0E0E0),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ADHDColors.background,

      // AppBar — clean, flat
      appBarTheme: const AppBarTheme(
        backgroundColor: ADHDColors.surface,
        foregroundColor: ADHDColors.neutral,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ADHDColors.neutral,
        ),
      ),

      // Cards — rounded, subtle elevation
      cardTheme: CardThemeData(
        color: ADHDColors.surface,
        elevation: 1,
        shadowColor: Colors.black12,
        shape: _cardShape,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      // FAB — high contrast blue
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ADHDColors.upcoming,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Bottom sheet — rounded top corners
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ADHDColors.surface,
        shape: _sheetShape,
        showDragHandle: true,
        dragHandleColor: const Color(0xFFBDBDBD),
      ),

      // Snackbar — dark for contrast
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ADHDColors.neutral,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        actionTextColor: ADHDColors.reward,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Navigation bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ADHDColors.surface,
        indicatorColor: ADHDColors.upcoming.withAlpha(30),
        elevation: 2,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ADHDColors.upcoming,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: ADHDColors.neutral,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: ADHDColors.upcoming, size: 24);
          }
          return const IconThemeData(color: ADHDColors.neutral, size: 24);
        }),
      ),

      // Input fields — outlined, high contrast
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ADHDColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ADHDColors.upcoming, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ADHDColors.missed, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: ADHDColors.neutral),
      ),

      // Filled buttons — high contrast primary
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ADHDColors.upcoming,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Switch — green when on
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return ADHDColors.taken;
          return const Color(0xFFBDBDBD);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ADHDColors.taken.withAlpha(80);
          }
          return const Color(0xFFE0E0E0);
        }),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        space: 1,
      ),

      // Text theme — high contrast on light bg
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: ADHDColors.neutral,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ADHDColors.neutral,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ADHDColors.neutral,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: ADHDColors.neutral,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: ADHDColors.neutral,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ADHDColors.neutral,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF757575),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ADHDColors.neutral,
        ),
      ),
    );
  }

  // ── Dark theme ────────────────────────────────────────────────────────────

  /// Dark theme — true-dark background, high-contrast foreground.
  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: ADHDColors.upcoming,
      onPrimary: Colors.white,
      secondary: ADHDColors.xpBar,
      onSecondary: Colors.white,
      tertiary: ADHDColors.streakActive,
      onTertiary: Colors.white,
      error: ADHDColors.missed,
      onError: Colors.white,
      surface: ADHDColors.darkSurface, // Dark cards
      onSurface: Color(0xFFE0E0E0), // Light text on dark
      surfaceContainerHighest: ADHDColors.darkBackground,
      outline: Color(0xFF616161),
      outlineVariant: Color(0xFF424242),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ADHDColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: ADHDColors.darkSurface,
        foregroundColor: Color(0xFFE0E0E0),
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE0E0E0),
        ),
      ),
      cardTheme: CardThemeData(
        color: ADHDColors.darkSurface,
        elevation: 1,
        shadowColor: Colors.black38,
        shape: _cardShape,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ADHDColors.upcoming,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ADHDColors.darkSurface,
        shape: _sheetShape,
        showDragHandle: true,
        dragHandleColor: const Color(0xFF616161),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2C2C2C),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        actionTextColor: ADHDColors.reward,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ADHDColors.darkSurface,
        indicatorColor: ADHDColors.upcoming.withAlpha(40),
        elevation: 2,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ADHDColors.upcoming,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9E9E9E),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: ADHDColors.upcoming, size: 24);
          }
          return const IconThemeData(color: Color(0xFF9E9E9E), size: 24);
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ADHDColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF616161)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF616161)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ADHDColors.upcoming, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ADHDColors.missed, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(color: Color(0xFF9E9E9E)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ADHDColors.upcoming,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return ADHDColors.taken;
          return const Color(0xFF616161);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ADHDColors.taken.withAlpha(80);
          }
          return const Color(0xFF424242);
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF424242),
        thickness: 1,
        space: 1,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Color(0xFFE0E0E0),
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE0E0E0),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE0E0E0),
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE0E0E0),
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFFE0E0E0),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFBDBDBD),
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9E9E9E),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE0E0E0),
        ),
      ),
    );
  }
}
