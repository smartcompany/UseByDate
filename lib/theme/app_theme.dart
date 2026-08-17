import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Warm kitchen palette — matches app icon (peach, coral, teal fish).
  static const background = Color(0xFFFFF3E8);
  static const backgroundDeep = Color(0xFFFCE4CC);
  static const ink = Color(0xFF3D3028);
  static const coral = Color(0xFFE06F48);
  static const coralDeep = Color(0xFFC95A38);
  static const teal = Color(0xFF5AABBB);
  static const muted = Color(0xFF917A6C);
  static const hairline = Color(0xFFF0DCC8);
  static const surface = Color(0xFFFFFBF7);
  static const expired = Color(0xFFC62828);
  static const today = Color(0xFFD84315);
  static const soon = Color(0xFFE65100);

  /// Primary accent — kept as [olive] name for existing call sites.
  static const olive = coral;

  static const homeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF8F2),
      Color(0xFFFFF0E0),
      Color(0xFFFCE8D2),
    ],
  );

  /// Dark status-bar icons on the warm light backgrounds used across the app.
  static const systemOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: background,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

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
      primary: coral,
      onPrimary: surface,
      secondary: teal,
      onSecondary: surface,
      surface: background,
      onSurface: ink,
      onSurfaceVariant: muted,
      outline: hairline,
      outlineVariant: hairline,
      surfaceContainerHighest: const Color(0xFFFCE8D4),
      error: expired,
      onError: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: systemOverlayStyle,
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
          borderSide: const BorderSide(color: coral, width: 1.4),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: coral,
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
        style: TextButton.styleFrom(foregroundColor: coral),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFFCE8D4),
        selectedColor: coral.withValues(alpha: 0.14),
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
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: coral,
      ),
    );
  }
}
