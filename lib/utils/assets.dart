class Assets {
  Assets._();

  // Base paths
  static const String _images = 'assets/images/';
  static const String _icons = 'assets/icons/';
  static const String _logos = 'assets/logos/';
  static const String _themes = 'assets/themes/';

  // Font families
  static const String roboto = 'Roboto';

  // Images - Your actual image files
  static const String splashScreen = '${_images}streamify splash screen 1920x1080.png';
  
  // Icons - Your actual icon files
  static const String appIcon = '${_icons}streamify icon.png';
  static const String tvBanner = '${_icons}streamify banner 320x180.png';
  
  // Convenience getters for commonly used assets
  static const String splashBackground = splashScreen; // Use splash screen as background
  static const String splashLogo = appIcon; // Use app icon as splash logo
  static const String androidTvBanner = tvBanner; // Use banner for Android TV
  
  // Placeholder assets for future use
  static const String appBackground = '${_images}app_background.png';
  static const String noImagePlaceholder = '${_images}no_image_placeholder.png';
  static const String channelPlaceholder = '${_images}channel_placeholder.png';
  static const String playIcon = '${_icons}play_icon.png';
  static const String pauseIcon = '${_icons}pause_icon.png';
  static const String stopIcon = '${_icons}stop_icon.png';
  static const String settingsIcon = '${_icons}settings_icon.png';
  static const String favoriteIcon = '${_icons}favorite_icon.png';
  static const String favoriteFilledIcon = '${_icons}favorite_filled_icon.png';
  static const String volumeIcon = '${_icons}volume_icon.png';
  static const String fullscreenIcon = '${_icons}fullscreen_icon.png';
  static const String backIcon = '${_icons}back_icon.png';
  static const String menuIcon = '${_icons}menu_icon.png';
  static const String searchIcon = '${_icons}search_icon.png';
  static const String recordIcon = '${_icons}record_icon.png';
  
  // Logos - Add your logo file names here when you add them
  static const String appLogo = appIcon; // Use app icon as logo
  static const String appLogoDark = '${_logos}app_logo_dark.png';
  static const String appLogoLight = '${_logos}app_logo_light.png';
  
  // Theme assets
  static const String darkTheme = '${_themes}dark_theme.json';
  static const String lightTheme = '${_themes}light_theme.json';
  static const String tvTheme = '${_themes}tv_theme.json';

  // Helper method to check if asset exists
  static bool hasAsset(String assetPath) {
    // This is a placeholder - in a real app you might want to implement
    // actual asset existence checking
    return true;
  }

  // Get platform-specific assets
  static String getPlatformSpecificAsset(String baseName, {String? platform}) {
    platform ??= 'default';
    return '${_images}${platform}_$baseName';
  }

  // Get resolution-specific assets
  static String getResolutionSpecificAsset(String baseName, {String resolution = '1x'}) {
    final parts = baseName.split('.');
    if (parts.length >= 2) {
      final name = parts.sublist(0, parts.length - 1).join('.');
      final extension = parts.last;
      return '$name@$resolution.$extension';
    }
    return baseName;
  }
}

// Extension to help with asset loading
extension AssetHelper on String {
  String get asImage => 'assets/images/$this';
  String get asIcon => 'assets/icons/$this';
  String get asLogo => 'assets/logos/$this';
  String get asTheme => 'assets/themes/$this';
}
