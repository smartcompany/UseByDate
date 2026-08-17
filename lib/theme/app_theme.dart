import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const background = Color(0xFFFAF8F5);
  static const ink = Color(0xFF1A1A1A);
  static const olive = Color(0xFF2C3A2E);
  static const muted = Color(0xFF6B6B66);
  static const hairline = Color(0xFFE6E2DB);
  static const surface = Color(0xFFFFFFFF);
  static const expired = Color(0xFFB3261E);
  static const today = Color(0xFFB45309);
  static const soon = Color(0xFFC2410C);

  static ThemeData light() {
    final baseText = GoogleFonts.plusJakartaSansTextTheme();
    final textTheme = baseText
        .apply(
          bodyColor: ink,
          displayColor: ink,
        )
        .copyWith(
          headlineLarge: baseText.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            color: ink,
          ),
          headlineMedium: baseText.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
            color: ink,
          ),
          titleLarge: baseText.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
            fontSize: 24,
            color: ink,
          ),
          titleMedium: baseText.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            color: ink,
          ),
          titleSmall: baseText.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: ink,
          ),
          bodyLarge: baseText.bodyLarge?.copyWith(color: ink, height: 1.4),
          bodyMedium: baseText.bodyMedium?.copyWith(color: ink, height: 1.4),
          bodySmall: baseText.bodySmall?.copyWith(color: muted, height: 1.35),
          labelLarge: baseText.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: ink,
          ),
        );

    final scheme = ColorScheme.light(
      primary: olive,
      onPrimary: surface,
      secondary: olive,
      onSecondary: surface,
      surface: background,
      onSurface: ink,
      onSurfaceVariant: muted,
      outline: hairline,
      outlineVariant: hairline,
      surfaceContainerHighest: const Color(0xFFF0EDE8),
      error: expired,
      onError: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: textTheme.bodyMedium?.copyWith(color: muted),
        prefixIconColor: muted,
        suffixIconColor: muted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: olive, width: 1.4),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: olive,
          foregroundColor: surface,
          elevation: 0,
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: const BorderSide(color: hairline),
          elevation: 0,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: olive),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF0EDE8),
        selectedColor: olive.withValues(alpha: 0.12),
        labelStyle: textTheme.bodySmall?.copyWith(color: ink),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      dividerTheme: const DividerThemeData(
        color: hairline,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: surface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
