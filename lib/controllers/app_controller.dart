import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';
import '../utils/platform_utils.dart';

class AppController extends GetxController {
  final _isLoading = false.obs;
  final _isConnected = false.obs;
  final _deviceType = ''.obs;
  final _isTV = false.obs;
  final _permissions = <Permission, PermissionStatus>{}.obs;
  
  late SharedPreferences _prefs;
  
  // Getters
  bool get isLoading => _isLoading.value;
  bool get isConnected => _isConnected.value;
  String get deviceType => _deviceType.value;
  bool get isTV => _isTV.value;
  Map<Permission, PermissionStatus> get permissions => _permissions;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
    _detectPlatform();
  }

  Future<void> initializeDatabase() async {
    _isLoading.value = true;
    try {
      await DatabaseService.instance.initialize();
    } catch (e) {
      Get.snackbar('Database Error', 'Failed to initialize database: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadSettings() async {
    try {
      _prefs = Get.find<SharedPreferences>();
      // Load app settings from SharedPreferences
      await _loadAppSettings();
    } catch (e) {
      Get.snackbar('Settings Error', 'Failed to load settings: $e');
    }
  }

  Future<void> checkPermissions() async {
    final permissionsToCheck = [
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.notification,
      Permission.mediaLibrary,
    ];

    for (final permission in permissionsToCheck) {
      final status = await permission.status;
      _permissions[permission] = status;
      
      if (status.isDenied) {
        await permission.request();
        _permissions[permission] = await permission.status;
      }
    }
  }

  Future<void> loadPlaylists() async {
    try {
      // Load playlists from database
      await DatabaseService.instance.getAllPlaylists();
    } catch (e) {
      Get.snackbar('Playlist Error', 'Failed to load playlists: $e');
    }
  }

  void _initializeConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _isConnected.value = result != ConnectivityResult.none;
    });
    
    // Check initial connectivity
    Connectivity().checkConnectivity().then((result) {
      _isConnected.value = result != ConnectivityResult.none;
    });
  }

  void _detectPlatform() async {
    _deviceType.value = await PlatformUtils.deviceType;
    _isTV.value = await PlatformUtils.isAndroidTV || await PlatformUtils.isAppleTV;
  }

  Future<void> _loadAppSettings() async {
    // Load theme
    final theme = _prefs.getString(Constants.keyTheme) ?? Constants.defaultTheme;
    Get.find<ThemeController>()?.changeTheme(theme);
    
    // Load other settings
    final autoStart = _prefs.getBool(Constants.keyAutoStart) ?? Constants.defaultAutoStart;
    final parentalEnabled = _prefs.getBool(Constants.keyParentalEnabled) ?? Constants.defaultParentalEnabled;
    
    // Apply settings
    // TODO: Apply loaded settings to respective controllers
  }

  Future<void> saveSettings() async {
    try {
      await _prefs.setBool(Constants.keyAutoStart, true);
      // Save other settings as needed
      Get.snackbar('Success', Constants.successSettingsSaved);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save settings: $e');
    }
  }

  void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
