import 'package:flutter/material.dart';
import '../utils/assets.dart';

class AppTheme {
  AppTheme._();

  // Primary color scheme
  static const Color primaryColor = Color(0xFF2196F3); // Blue
  static const Color primaryColorDark = Color(0xFF1976D2);
  static const Color primaryColorLight = Color(0xFF64B5F6);
  
  // Accent colors
  static const Color accentColor = Color(0xFFFF9800); // Orange
  static const Color accentColorLight = Color(0xFFFFB74D);
  static const Color accentColorDark = Color(0xFFF57C00);
  
  // Background colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textOnLight = Color(0xFF212121);
  
  // Error colors
  static const Color errorColor = Color(0xFFE53935);
  static const Color errorColorDark = Color(0xFFC62828);
  
  // Success colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryColorLight,
        secondary: accentColor,
        secondaryContainer: accentColorLight,
        surface: backgroundLight,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textOnLight,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: Assets.roboto,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: _buildTextTheme(false),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: Assets.roboto,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceLight,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        primaryContainer: primaryColorDark,
        secondary: accentColor,
        secondaryContainer: accentColorDark,
        surface: backgroundDark,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: textPrimary,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: Assets.roboto,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),
      textTheme: _buildTextTheme(true),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: Assets.roboto,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textSecondary),
      ),
    );
  }

  static ThemeData get tvTheme {
    // TV-optimized theme with larger elements and better focus indicators
    return darkTheme.copyWith(
      textTheme: _buildTextTheme(true, isTv: true),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: Assets.roboto,
            fontWeight: FontWeight.w600,
            fontSize: 18, // Larger for TV
          ),
          minimumSize: const Size(200, 56), // Larger buttons for TV
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: surfaceDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      focusColor: primaryColor.withOpacity(0.3),
      hoverColor: primaryColor.withOpacity(0.1),
    );
  }

  static TextTheme _buildTextTheme(bool isDark, {bool isTv = false}) {
    final Color textColor = isDark ? textPrimary : textOnLight;
    final Color secondaryTextColor = isDark ? textSecondary : Colors.grey[600]!;
    final double scaleFactor = isTv ? 1.3 : 1.0;

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 57 * scaleFactor,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 45 * scaleFactor,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 36 * scaleFactor,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
      ),
      headlineLarge: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 32 * scaleFactor,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 28 * scaleFactor,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 24 * scaleFactor,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 22 * scaleFactor,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 16 * scaleFactor,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 14 * scaleFactor,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 16 * scaleFactor,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 14 * scaleFactor,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 12 * scaleFactor,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 14 * scaleFactor,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 1.25,
      ),
      labelMedium: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 12 * scaleFactor,
        fontWeight: FontWeight.w500,
        color: textColor,
        letterSpacing: 1.5,
      ),
      labelSmall: TextStyle(
        fontFamily: Assets.roboto,
        fontSize: 11 * scaleFactor,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        letterSpacing: 1.5,
      ),
    );
  }

  // Helper method to get theme based on platform
  static ThemeData getThemeForPlatform({
    required bool isDark,
    required bool isTV,
  }) {
    if (isTV) {
      return tvTheme;
    } else if (isDark) {
      return darkTheme;
    } else {
      return lightTheme;
    }
  }
}

// Custom colors for specific UI elements
class AppColors {
  static const Color channelCard = Color(0xFF2A2A2A);
  static const Color videoPlayerBackground = Color(0xFF000000);
  static const Color epgBackground = Color(0xFF1A1A1A);
  static const Color favoriteIcon = Color(0xFFFF6B6B);
  static const Color liveIndicator = Color(0xFF4CAF50);
  static const Color recordingIndicator = Color(0xFFE53935);
  static const Color bufferingIndicator = Color(0xFFFF9800);
}
