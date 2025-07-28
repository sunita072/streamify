import 'package:flutter/material.dart';

class AppThemes {
  // Dark theme optimized for Android TV
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF1E88E5),
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF1E88E5),
        secondary: Color(0xFF42A5F5),
        surface: Color(0xFF0A0A0A),
        error: Color(0xFFE53935),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF1A1A1A),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E88E5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
        bodySmall: TextStyle(color: Colors.white54, fontSize: 12),
      ),
      focusColor: const Color(0xFF1E88E5),
      dividerColor: const Color(0xFF333333),
    );
  }

  // Netflix-inspired theme
  static ThemeData get netflixTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFE50914),
      scaffoldBackgroundColor: const Color(0xFF141414),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFE50914),
        secondary: Color(0xFFFF6B6B),
        surface: Color(0xFF141414),
        error: Color(0xFFE50914),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2A2A2A),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE50914),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      focusColor: const Color(0xFFE50914),
      dividerColor: const Color(0xFF404040),
    );
  }

  // YouTube TV theme
  static ThemeData get youtubeTvTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFFF0000),
      scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFF0000),
        secondary: Color(0xFFFF4444),
        surface: Color(0xFF0F0F0F),
        error: Color(0xFFFF0000),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF212121),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF212121),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF0000),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      focusColor: const Color(0xFFFF0000),
      dividerColor: const Color(0xFF404040),
    );
  }

  // Plex theme
  static ThemeData get plexTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFE5A00D),
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFE5A00D),
        secondary: Color(0xFFFFC107),
        surface: Color(0xFF1A1A1A),
        error: Color(0xFFE53935),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2D2D2D),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF2D2D2D),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE5A00D),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      focusColor: const Color(0xFFE5A00D),
      dividerColor: const Color(0xFF444444),
    );
  }

  // Light theme for mobile
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF1E88E5),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1E88E5),
        secondary: Color(0xFF42A5F5),
        surface: Color(0xFFF5F5F5),
        error: Color(0xFFE53935),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        centerTitle: true,
      ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E88E5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.black87, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: Colors.black87, fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: Colors.black54, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
        bodySmall: TextStyle(color: Colors.black45, fontSize: 12),
      ),
      focusColor: const Color(0xFF1E88E5),
      dividerColor: const Color(0xFFE0E0E0),
    );
  }

  // Get theme by name
  static ThemeData getThemeByName(String themeName) {
    switch (themeName.toLowerCase()) {
      case 'netflix':
        return netflixTheme;
      case 'youtube tv':
        return youtubeTvTheme;
      case 'plex':
        return plexTheme;
      case 'light':
        return lightTheme;
      case 'dark':
      default:
        return darkTheme;
    }
  }

  // Focus styles for Android TV
  static BoxDecoration getFocusDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border.all(
        color: Theme.of(context).focusColor,
        width: 3,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  static BoxDecoration getCardFocusDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border.all(
        color: Theme.of(context).focusColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).focusColor.withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    );
  }
}
