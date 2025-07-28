import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../screens/live_tv_screen.dart';
import '../screens/epg_screen.dart';
import '../screens/recordings_screen.dart';
import '../screens/playlist_screen.dart';
import '../screens/search_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/history_screen.dart';
import '../screens/settings_screen.dart';

class NavigationController extends GetxController {
  final _selectedIndex = 0.obs;
  final _isConnected = true.obs;
  
  int get selectedIndex => _selectedIndex.value;
  bool get isConnected => _isConnected.value;
  
  final List<NavigationItem> navigationItems = [
    NavigationItem(
      icon: Icons.live_tv,
      title: 'Live TV',
      badge: null,
    ),
    NavigationItem(
      icon: Icons.tv_outlined,
      title: 'TV Guide',
      badge: null,
    ),
    NavigationItem(
      icon: Icons.fiber_smart_record,
      title: 'Recordings',
      badge: null,
    ),
    NavigationItem(
      icon: Icons.playlist_play,
      title: 'Playlists',
      badge: null,
    ),
    NavigationItem(
      icon: Icons.search,
      title: 'Search',
      badge: null,
    ),
    NavigationItem(
      icon: Icons.favorite,
      title: 'Favorites',
      badge: null,
    ),
    NavigationItem(
      icon: Icons.history,
      title: 'History',
      badge: null,
    ),
    NavigationItem(
      icon: Icons.settings,
      title: 'Settings',
      badge: null,
    ),
  ];

  final List<Widget> pages = [
    LiveTVScreen(),
    EPGScreen(),
    RecordingsScreen(),
    PlaylistScreen(),
    SearchScreen(),
    FavoritesScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
  }

  void changePage(int index) {
    if (index >= 0 && index < pages.length) {
      _selectedIndex.value = index;
      update();
    }
  }

  void _initializeConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _isConnected.value = result != ConnectivityResult.none;
      update();
    });
    
    // Check initial connectivity
    Connectivity().checkConnectivity().then((result) {
      _isConnected.value = result != ConnectivityResult.none;
      update();
    });
  }

  void updateBadge(int index, String? badge) {
    if (index >= 0 && index < navigationItems.length) {
      navigationItems[index] = navigationItems[index].copyWith(badge: badge);
      update();
    }
  }

  String get currentPageTitle {
    if (_selectedIndex.value < navigationItems.length) {
      return navigationItems[_selectedIndex.value].title;
    }
    return 'Streamify';
  }
}

class NavigationItem {
  final IconData icon;
  final String title;
  final String? badge;

  NavigationItem({
    required this.icon,
    required this.title,
    this.badge,
  });

  NavigationItem copyWith({
    IconData? icon,
    String? title,
    String? badge,
  }) {
    return NavigationItem(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      badge: badge ?? this.badge,
    );
  }
}
