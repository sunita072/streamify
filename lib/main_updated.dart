import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:workmanager/workmanager.dart';

import 'controllers/app_controller.dart';
import 'controllers/playlist_controller.dart';
import 'controllers/epg_controller.dart';
import 'controllers/player_controller.dart';
import 'controllers/theme_controller.dart';
import 'screens/splash_screen.dart';
import 'services/database_service.dart';
import 'services/background_service.dart';
import 'utils/constants.dart';
import 'utils/themes.dart';
import 'utils/platform_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize background tasks
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  
  // Keep screen awake during playback
  WakelockPlus.enable();
  
  // Initialize database
  await DatabaseService.instance.initialize();
  
  // Initialize shared preferences
  await Get.putAsync<SharedPreferences>(() async => await SharedPreferences.getInstance());
  
  // Platform-specific initialization
  await _initializePlatform();
  
  runApp(StreamifyApp());
}

Future<void> _initializePlatform() async {
  // Detect platform type
  final isTV = await PlatformUtils.isAndroidTV || await PlatformUtils.isAppleTV;
  final isMobile = await PlatformUtils.isMobile;
  
  if (isTV) {
    // TV-specific initialization
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    // Hide system UI for immersive TV experience
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    
    // Enable full screen mode for TV
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  } else if (isMobile) {
    // Mobile-specific initialization
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    // Standard mobile UI
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
  }
}

class StreamifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: PlatformUtils.isAndroidTV.then((isAndroid) async => 
        isAndroid || await PlatformUtils.isAppleTV),
      builder: (context, snapshot) {
        final isTV = snapshot.data ?? false;
        
        return GetMaterialApp(
          title: 'Streamify - Premium IPTV Player',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.darkTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.dark,
          home: SplashScreen(),
          initialBinding: AppBinding(),
          shortcuts: PlatformUtils.getPlatformShortcuts(),
          actions: _buildPlatformActions(),
          builder: (context, child) {
            // Apply TV-specific scaling and safe area
            if (isTV) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: PlatformUtils.getTVUIScale(),
                ),
                child: SafeArea(
                  minimum: PlatformUtils.getTVSafeArea(),
                  child: child!,
                ),
              );
            }
            return child!;
          },
        );
      },
    );
  }

  Map<Type, Action<Intent>> _buildPlatformActions() {
    return {
      PlayPauseIntent: PlayPauseAction(),
      StopIntent: StopAction(),
      NextChannelIntent: NextChannelAction(),
      PreviousChannelIntent: PreviousChannelAction(),
      BackIntent: BackAction(),
      HomeIntent: HomeAction(),
      ContextMenuIntent: ContextMenuAction(),
    };
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppController>(AppController(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
    Get.put<PlaylistController>(PlaylistController(), permanent: true);
    Get.put<EpgController>(EpgController(), permanent: true);
    Get.put<PlayerController>(PlayerController(), permanent: true);
  }
}

// Enhanced Actions for both platforms
class PlayPauseAction extends Action<PlayPauseIntent> {
  @override
  void invoke(PlayPauseIntent intent) {
    final playerController = Get.find<PlayerController>();
    playerController.togglePlayPause();
    
    // Haptic feedback for TV remotes
    HapticFeedback.selectionClick();
  }
}

class StopAction extends Action<StopIntent> {
  @override
  void invoke(StopIntent intent) {
    final playerController = Get.find<PlayerController>();
    playerController.stop();
    
    HapticFeedback.lightImpact();
  }
}

class NextChannelAction extends Action<NextChannelIntent> {
  @override
  void invoke(NextChannelIntent intent) {
    final playerController = Get.find<PlayerController>();
    playerController.nextChannel();
    
    HapticFeedback.selectionClick();
  }
}

class PreviousChannelAction extends Action<PreviousChannelIntent> {
  @override
  void invoke(PreviousChannelIntent intent) {
    final playerController = Get.find<PlayerController>();
    playerController.previousChannel();
    
    HapticFeedback.selectionClick();
  }
}

class BackAction extends Action<BackIntent> {
  @override
  void invoke(BackIntent intent) {
    // Handle back navigation
    if (Get.canPop()) {
      Get.back();
    } else {
      // Handle platform-specific back behavior
      _handlePlatformBack();
    }
    
    HapticFeedback.lightImpact();
  }
  
  void _handlePlatformBack() async {
    if (await PlatformUtils.isAppleTV) {
      // Apple TV: Go to Top Shelf or minimize app
      SystemNavigator.pop();
    } else if (await PlatformUtils.isAndroidTV) {
      // Android TV: Go to home screen
      SystemNavigator.pop();
    } else {
      // Mobile: Standard back behavior
      SystemNavigator.pop();
    }
  }
}

class HomeAction extends Action<HomeIntent> {
  @override
  void invoke(HomeIntent intent) {
    // Navigate to home screen
    Get.offAllNamed('/home');
    
    HapticFeedback.lightImpact();
  }
}

class ContextMenuAction extends Action<ContextMenuIntent> {
  @override
  void invoke(ContextMenuIntent intent) {
    // Show context menu or options
    final playerController = Get.find<PlayerController>();
    playerController.showContextMenu();
    
    HapticFeedback.mediumImpact();
  }
}
