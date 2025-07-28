import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PlatformUtils {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static bool? _isAndroidTV;
  static bool? _isAppleTV;
  static bool? _isMobile;
  static String? _deviceType;

  /// Check if running on Android TV
  static Future<bool> get isAndroidTV async {
    if (_isAndroidTV != null) return _isAndroidTV!;
    
    if (!Platform.isAndroid) {
      _isAndroidTV = false;
      return false;
    }

    try {
      final androidInfo = await _deviceInfo.androidInfo;
      
      // Check for Android TV specific features
      final hasLeanback = androidInfo.systemFeatures.contains('android.software.leanback');
      final isTouchscreen = androidInfo.systemFeatures.contains('android.hardware.touchscreen');
      
      // Additional checks for TV devices
      final isTV = hasLeanback || 
                  !isTouchscreen ||
                  androidInfo.model.toLowerCase().contains('tv') ||
                  androidInfo.brand.toLowerCase().contains('nvidia') && 
                  androidInfo.model.toLowerCase().contains('shield');
      
      _isAndroidTV = isTV;
      return isTV;
    } catch (e) {
      _isAndroidTV = false;
      return false;
    }
  }

  /// Check if running on Apple TV (tvOS)
  static Future<bool> get isAppleTV async {
    if (_isAppleTV != null) return _isAppleTV!;
    
    if (!Platform.isIOS) {
      _isAppleTV = false;
      return false;
    }

    try {
      final iosInfo = await _deviceInfo.iosInfo;
      
      // Check if running on tvOS
      final isTvOS = iosInfo.model.toLowerCase().contains('appletv') ||
                    iosInfo.systemName.toLowerCase() == 'tvos';
      
      _isAppleTV = isTvOS;
      return isTvOS;
    } catch (e) {
      _isAppleTV = false;
      return false;
    }
  }

  /// Check if running on mobile device
  static Future<bool> get isMobile async {
    if (_isMobile != null) return _isMobile!;
    
    final isTV = await isAndroidTV || await isAppleTV;
    _isMobile = !isTV;
    return _isMobile!;
  }

  /// Get device type string
  static Future<String> get deviceType async {
    if (_deviceType != null) return _deviceType!;
    
    if (await isAndroidTV) {
      _deviceType = 'Android TV';
    } else if (await isAppleTV) {
      _deviceType = 'Apple TV';
    } else if (Platform.isAndroid) {
      _deviceType = 'Android Mobile';
    } else if (Platform.isIOS) {
      _deviceType = 'iOS Mobile';
    } else {
      _deviceType = 'Unknown';
    }
    
    return _deviceType!;
  }

  /// Check if device supports remote control
  static Future<bool> get supportsRemoteControl async {
    return await isAndroidTV || await isAppleTV;
  }

  /// Check if device supports touch input
  static Future<bool> get supportsTouchInput async {
    if (await isAndroidTV) {
      try {
        final androidInfo = await _deviceInfo.androidInfo;
        return androidInfo.systemFeatures.contains('android.hardware.touchscreen');
      } catch (e) {
        return false;
      }
    } else if (await isAppleTV) {
      return false; // Apple TV remote has touch but limited
    } else {
      return true; // Mobile devices have touch
    }
  }

  /// Get safe area insets for TV
  static EdgeInsets getTVSafeArea() {
    // Standard TV safe area margins
    return const EdgeInsets.all(48.0);
  }

  /// Get navigation focus padding for TV
  static EdgeInsets getTVFocusPadding() {
    return const EdgeInsets.all(8.0);
  }

  /// Get optimal UI scale for TV
  static double getTVUIScale() {
    return 1.2; // Slightly larger UI elements for TV viewing distance
  }

  /// Check if device supports 4K display
  static Future<bool> supports4K() async {
    if (kIsWeb) return false;
    
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        // Check display metrics or device capabilities
        return androidInfo.displayMetrics.widthPx >= 3840 ||
               androidInfo.displayMetrics.heightPx >= 3840;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        // Apple TV 4K models
        return iosInfo.model.contains('AppleTV6') || // Apple TV 4K (1st gen)
               iosInfo.model.contains('AppleTV11'); // Apple TV 4K (2nd gen)
      }
    } catch (e) {
      // Fallback to false if unable to determine
    }
    
    return false;
  }

  /// Get recommended video quality based on device
  static Future<String> getRecommendedVideoQuality() async {
    if (await supports4K()) {
      return '4K';
    } else if (await isAndroidTV || await isAppleTV) {
      return '1080p';
    } else {
      return '720p';
    }
  }

  /// Check if device supports HDR
  static Future<bool> supportsHDR() async {
    if (kIsWeb) return false;
    
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        // Check for HDR capabilities in system features
        return androidInfo.systemFeatures.any((feature) => 
          feature.contains('hdr') || feature.contains('dolby'));
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        // Apple TV 4K supports HDR
        return iosInfo.model.contains('AppleTV6') || 
               iosInfo.model.contains('AppleTV11');
      }
    } catch (e) {
      // Fallback to false
    }
    
    return false;
  }

  /// Get device-specific navigation keys
  static List<LogicalKeyboardKey> getNavigationKeys() {
    return [
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowRight,
      LogicalKeyboardKey.select,
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.space,
    ];
  }

  /// Get platform-specific media control keys
  static List<LogicalKeyboardKey> getMediaControlKeys() {
    return [
      LogicalKeyboardKey.mediaPlay,
      LogicalKeyboardKey.mediaPause,
      LogicalKeyboardKey.mediaPlayPause,
      LogicalKeyboardKey.mediaStop,
      LogicalKeyboardKey.mediaTrackNext,
      LogicalKeyboardKey.mediaTrackPrevious,
      LogicalKeyboardKey.channelUp,
      LogicalKeyboardKey.channelDown,
      LogicalKeyboardKey.audioVolumeUp,
      LogicalKeyboardKey.audioVolumeDown,
      LogicalKeyboardKey.audioVolumeMute,
    ];
  }

  /// Get platform-specific shortcuts
  static Map<LogicalKeySet, Intent> getPlatformShortcuts() {
    final shortcuts = <LogicalKeySet, Intent>{};
    
    // Common navigation shortcuts
    shortcuts[LogicalKeySet(LogicalKeyboardKey.arrowUp)] = 
        const DirectionalFocusIntent(TraversalDirection.up);
    shortcuts[LogicalKeySet(LogicalKeyboardKey.arrowDown)] = 
        const DirectionalFocusIntent(TraversalDirection.down);
    shortcuts[LogicalKeySet(LogicalKeyboardKey.arrowLeft)] = 
        const DirectionalFocusIntent(TraversalDirection.left);
    shortcuts[LogicalKeySet(LogicalKeyboardKey.arrowRight)] = 
        const DirectionalFocusIntent(TraversalDirection.right);
    
    // Media control shortcuts
    shortcuts[LogicalKeySet(LogicalKeyboardKey.mediaPlayPause)] = 
        const PlayPauseIntent();
    shortcuts[LogicalKeySet(LogicalKeyboardKey.mediaStop)] = 
        const StopIntent();
    shortcuts[LogicalKeySet(LogicalKeyboardKey.channelUp)] = 
        const NextChannelIntent();
    shortcuts[LogicalKeySet(LogicalKeyboardKey.channelDown)] = 
        const PreviousChannelIntent();
    
    // Platform-specific shortcuts
    if (Platform.isIOS) {
      // Apple TV Siri Remote shortcuts
      shortcuts[LogicalKeySet(LogicalKeyboardKey.escape)] = 
          const BackIntent();
      shortcuts[LogicalKeySet(LogicalKeyboardKey.home)] = 
          const HomeIntent();
    } else if (Platform.isAndroid) {
      // Android TV remote shortcuts
      shortcuts[LogicalKeySet(LogicalKeyboardKey.goBack)] = 
          const BackIntent();
      shortcuts[LogicalKeySet(LogicalKeyboardKey.home)] = 
          const HomeIntent();
      shortcuts[LogicalKeySet(LogicalKeyboardKey.contextMenu)] = 
          const ContextMenuIntent();
    }
    
    return shortcuts;
  }

  /// Reset cached values (useful for testing)
  static void resetCache() {
    _isAndroidTV = null;
    _isAppleTV = null;
    _isMobile = null;
    _deviceType = null;
  }
}

// Custom Intents for platform-specific actions
class PlayPauseIntent extends Intent {}
class StopIntent extends Intent {}
class NextChannelIntent extends Intent {}
class PreviousChannelIntent extends Intent {}
class BackIntent extends Intent {}
class HomeIntent extends Intent {}
class ContextMenuIntent extends Intent {}
