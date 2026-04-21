import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryContainer = Color(0xFF0D631B);
  static const Color onPrimary = Colors.white;

  static const Color surface = Color(0xFFF5FAF2);
  static const Color surfaceContainerLow = Color(0xFFE9F6FD);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerHigh = Color(0xFFE1EDF6);

  static const Color secondaryContainer = Color(0xFFCFE6F2);
  static const Color onSecondaryContainer = Color(0xFF001D33);

  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  static const Color outlineVariant = Color(0xFFC4C7C5);
  static const Color inverseSurface = Color(0xFF2F3033);

  static ThemeData get lightTheme {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          onPrimary: onPrimary,
          primaryContainer: primaryContainer,
          surface: surface,
          surfaceContainerLow: surfaceContainerLow,
          surfaceContainerLowest: surfaceContainerLowest,
          surfaceContainerHigh: surfaceContainerHigh,
          secondaryContainer: secondaryContainer,
          onSecondaryContainer: onSecondaryContainer,
          error: error,
          errorContainer: errorContainer,
          onErrorContainer: onErrorContainer,
          outlineVariant: outlineVariant.withValues(alpha: 0.2),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      cardColor: surfaceContainerLowest,

      textTheme: TextTheme(
        displayMedium: GoogleFonts.manrope(
          fontSize: 44,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        headlineSmall: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurface,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHigh,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outlineVariant.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outlineVariant.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorStyle: GoogleFonts.inter(fontSize: 12, color: error),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static ThemeData get darkTheme =>
      lightTheme.copyWith(brightness: Brightness.dark);
}
