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
import 'utils/themes.dart';

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
  
  // Set preferred orientations for Android TV
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Hide system UI for immersive experience
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  
  runApp(StreamifyApp());
}

class StreamifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Streamify - Premium IPTV Player',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.darkTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.dark,
      home: SplashScreen(),
      initialBinding: AppBinding(),
      shortcuts: {
        // Android TV remote control shortcuts
        LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(TraversalDirection.up),
        LogicalKeySet(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(TraversalDirection.down),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(TraversalDirection.left),
        LogicalKeySet(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(TraversalDirection.right),
        LogicalKeySet(LogicalKeyboardKey.escape): DismissIntent(),
        LogicalKeySet(LogicalKeyboardKey.mediaPlay): PlayPauseIntent(),
        LogicalKeySet(LogicalKeyboardKey.mediaPlayPause): PlayPauseIntent(),
        LogicalKeySet(LogicalKeyboardKey.mediaStop): StopIntent(),
        LogicalKeySet(LogicalKeyboardKey.channelUp): NextChannelIntent(),
        LogicalKeySet(LogicalKeyboardKey.channelDown): PreviousChannelIntent(),
      },
      actions: {
        PlayPauseIntent: PlayPauseAction(),
        StopIntent: StopAction(),
        NextChannelIntent: NextChannelAction(),
        PreviousChannelIntent: PreviousChannelAction(),
      },
    );
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

// Custom intents for Android TV remote control
class PlayPauseIntent extends Intent {}
class StopIntent extends Intent {}
class NextChannelIntent extends Intent {}
class PreviousChannelIntent extends Intent {}

// Actions for intents
class PlayPauseAction extends Action<PlayPauseIntent> {
  @override
  void invoke(PlayPauseIntent intent) {
    final playerController = Get.find<PlayerController>();
    playerController.togglePlayPause();
  }
}

class StopAction extends Action<StopIntent> {
  @override
  void invoke(StopIntent intent) {
    final playerController = Get.find<PlayerController>();
    playerController.stop();
  }
}

class NextChannelAction extends Action<NextChannelIntent> {
  @override
  void invoke(NextChannelIntent intent) {
    final playerController = Get.find<PlayerController>();
    playerController.nextChannel();
  }
}

class PreviousChannelAction extends Action<PreviousChannelIntent> {
  @override
  void invoke(PreviousChannelIntent intent) {
    final playerController = Get.find<PlayerController>();
    playerController.previousChannel();
  }
}
