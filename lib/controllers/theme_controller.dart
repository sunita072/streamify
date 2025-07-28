import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../utils/themes.dart';

class ThemeController extends GetxController {
  final _currentTheme = Constants.defaultTheme.obs;
  final _isDarkMode = true.obs;
  final _fontSize = 1.0.obs;
  final _customColors = <String, Color>{}.obs;
  
  late SharedPreferences _prefs;

  // Getters
  String get currentTheme => _currentTheme.value;
  bool get isDarkMode => _isDarkMode.value;
  double get fontSize => _fontSize.value;
  Map<String, Color> get customColors => _customColors;
  
  ThemeData get themeData => AppThemes.getThemeByName(currentTheme);

  @override
  void onInit() {
    super.onInit();
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    try {
      _prefs = Get.find<SharedPreferences>();
      
      // Load saved theme
      final savedTheme = _prefs.getString(Constants.keyTheme) ?? Constants.defaultTheme;
      _currentTheme.value = savedTheme;
      
      // Load dark mode preference
      _isDarkMode.value = _prefs.getBool('dark_mode') ?? true;
      
      // Load font size
      _fontSize.value = _prefs.getDouble('font_size') ?? 1.0;
      
      // Load custom colors if any
      _loadCustomColors();
      
    } catch (e) {
      Get.snackbar('Theme Error', 'Failed to load theme settings: $e');
    }
  }

  void _loadCustomColors() {
    final colorKeys = _prefs.getKeys().where((key) => key.startsWith('custom_color_'));
    for (final key in colorKeys) {
      final colorValue = _prefs.getInt(key);
      if (colorValue != null) {
        final colorName = key.replaceFirst('custom_color_', '');
        _customColors[colorName] = Color(colorValue);
      }
    }
  }

  Future<void> changeTheme(String themeName) async {
    if (Constants.availableThemes.contains(themeName)) {
      _currentTheme.value = themeName;
      
      // Update app theme
      Get.changeTheme(AppThemes.getThemeByName(themeName));
      
      // Save to preferences
      await _prefs.setString(Constants.keyTheme, themeName);
      
      update();
      Get.snackbar('Theme Changed', 'Theme updated to $themeName');
    }
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode.value = !_isDarkMode.value;
    
    // Apply theme based on dark mode
    if (_isDarkMode.value) {
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
    }
    
    await _prefs.setBool('dark_mode', _isDarkMode.value);
    update();
  }

  Future<void> changeFontSize(double scale) async {
    if (scale >= 0.8 && scale <= 1.5) {
      _fontSize.value = scale;
      await _prefs.setDouble('font_size', scale);
      update();
      Get.snackbar('Font Size Changed', 'Font size updated');
    }
  }

  Future<void> setCustomColor(String colorName, Color color) async {
    _customColors[colorName] = color;
    await _prefs.setInt('custom_color_$colorName', color.value);
    update();
  }

  Color getCustomColor(String colorName, {Color? defaultColor}) {
    return _customColors[colorName] ?? defaultColor ?? Colors.grey;
  }

  Future<void> resetToDefault() async {
    _currentTheme.value = Constants.defaultTheme;
    _isDarkMode.value = true;
    _fontSize.value = 1.0;
    _customColors.clear();
    
    // Clear saved preferences
    await _prefs.remove(Constants.keyTheme);
    await _prefs.remove('dark_mode');
    await _prefs.remove('font_size');
    
    // Remove custom colors
    final colorKeys = _prefs.getKeys().where((key) => key.startsWith('custom_color_'));
    for (final key in colorKeys) {
      await _prefs.remove(key);
    }
    
    // Apply default theme
    Get.changeTheme(AppThemes.darkTheme);
    Get.changeThemeMode(ThemeMode.dark);
    
    update();
    Get.snackbar('Theme Reset', 'Theme settings reset to default');
  }

  // Get theme-specific colors
  Color getPrimaryColor() {
    return themeData.primaryColor;
  }

  Color getSecondaryColor() {
    return themeData.colorScheme.secondary;
  }

  Color getBackgroundColor() {
    return themeData.scaffoldBackgroundColor;
  }

  Color getSurfaceColor() {
    return themeData.colorScheme.surface;
  }

  Color getTextColor() {
    return themeData.textTheme.bodyLarge?.color ?? Colors.white;
  }

  Color getFocusColor() {
    return themeData.focusColor;
  }

  // Text styles with font scaling
  TextStyle? getDisplayLarge() {
    return themeData.textTheme.displayLarge?.copyWith(
      fontSize: (themeData.textTheme.displayLarge?.fontSize ?? 32) * _fontSize.value,
    );
  }

  TextStyle? getDisplayMedium() {
    return themeData.textTheme.displayMedium?.copyWith(
      fontSize: (themeData.textTheme.displayMedium?.fontSize ?? 28) * _fontSize.value,
    );
  }

  TextStyle? getHeadlineLarge() {
    return themeData.textTheme.headlineLarge?.copyWith(
      fontSize: (themeData.textTheme.headlineLarge?.fontSize ?? 22) * _fontSize.value,
    );
  }

  TextStyle? getTitleLarge() {
    return themeData.textTheme.titleLarge?.copyWith(
      fontSize: (themeData.textTheme.titleLarge?.fontSize ?? 16) * _fontSize.value,
    );
  }

  TextStyle? getBodyLarge() {
    return themeData.textTheme.bodyLarge?.copyWith(
      fontSize: (themeData.textTheme.bodyLarge?.fontSize ?? 16) * _fontSize.value,
    );
  }

  TextStyle? getBodyMedium() {
    return themeData.textTheme.bodyMedium?.copyWith(
      fontSize: (themeData.textTheme.bodyMedium?.fontSize ?? 14) * _fontSize.value,
    );
  }

  // Theme presets for quick switching
  List<ThemePreset> getThemePresets() {
    return [
      ThemePreset(
        name: 'Dark',
        description: 'Default dark theme for TV viewing',
        primaryColor: const Color(0xFF1E88E5),
        backgroundColor: const Color(0xFF0A0A0A),
      ),
      ThemePreset(
        name: 'Netflix',
        description: 'Netflix-inspired dark theme',
        primaryColor: const Color(0xFFE50914),
        backgroundColor: const Color(0xFF141414),
      ),
      ThemePreset(
        name: 'YouTube TV',
        description: 'YouTube TV style theme',
        primaryColor: const Color(0xFFFF0000),
        backgroundColor: const Color(0xFF0F0F0F),
      ),
      ThemePreset(
        name: 'Plex',
        description: 'Plex media server theme',
        primaryColor: const Color(0xFFE5A00D),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
    ];
  }
}

class ThemePreset {
  final String name;
  final String description;
  final Color primaryColor;
  final Color backgroundColor;

  ThemePreset({
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.backgroundColor,
  });
}
