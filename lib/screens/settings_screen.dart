import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';
import '../controllers/app_controller.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection('Appearance'),
          _buildThemeSettings(),
          
          _buildSection('Player'),
          _buildPlayerSettings(),
          
          _buildSection('General'),
          _buildGeneralSettings(),
          
          _buildSection('About'),
          _buildAboutSettings(),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildThemeSettings() {
    return Column(
      children: [
        Obx(() => ListTile(
          leading: Icon(Icons.palette, color: Colors.white),
          title: Text('Theme', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            themeController.currentThemeName.value,
            style: TextStyle(color: Colors.white70),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          onTap: () => _showThemeSelector(),
        )),
        
        Obx(() => SwitchListTile(
          secondary: Icon(Icons.dark_mode, color: Colors.white),
          title: Text('Dark Mode', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            'Use dark theme',
            style: TextStyle(color: Colors.white70),
          ),
          value: themeController.isDarkMode.value,
          onChanged: (value) => themeController.toggleThemeMode(),
        )),
      ],
    );
  }

  Widget _buildPlayerSettings() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.volume_up, color: Colors.white),
          title: Text('Volume', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            'Adjust playback volume',
            style: TextStyle(color: Colors.white70),
          ),
          onTap: () => _showVolumeSettings(),
        ),
        
        ListTile(
          leading: Icon(Icons.high_quality, color: Colors.white),
          title: Text('Video Quality', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            'Set preferred video quality',
            style: TextStyle(color: Colors.white70),
          ),
          onTap: () => _showQualitySettings(),
        ),
        
        SwitchListTile(
          secondary: Icon(Icons.subtitles, color: Colors.white),
          title: Text('Auto Subtitles', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            'Enable subtitles automatically',
            style: TextStyle(color: Colors.white70),
          ),
          value: false, // TODO: Implement subtitle settings
          onChanged: (value) {
            // TODO: Implement subtitle toggle
          },
        ),
      ],
    );
  }

  Widget _buildGeneralSettings() {
    return Column(
      children: [
        SwitchListTile(
          secondary: Icon(Icons.autorenew, color: Colors.white),
          title: Text('Auto Update', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            'Update playlists automatically',
            style: TextStyle(color: Colors.white70),
          ),
          value: true, // TODO: Implement auto update setting
          onChanged: (value) {
            // TODO: Implement auto update toggle
          },
        ),
        
        ListTile(
          leading: Icon(Icons.storage, color: Colors.white),
          title: Text('Cache', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            'Manage app cache',
            style: TextStyle(color: Colors.white70),
          ),
          onTap: () => _showCacheSettings(),
        ),
        
        ListTile(
          leading: Icon(Icons.security, color: Colors.white),
          title: Text('Parental Controls', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            'Set up parental controls',
            style: TextStyle(color: Colors.white70),
          ),
          onTap: () => _showParentalControls(),
        ),
      ],
    );
  }

  Widget _buildAboutSettings() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.info, color: Colors.white),
          title: Text('Version', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            '1.0.0',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        
        ListTile(
          leading: Icon(Icons.feedback, color: Colors.white),
          title: Text('Feedback', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            'Send feedback or report issues',
            style: TextStyle(color: Colors.white70),
          ),
          onTap: () => _showFeedbackDialog(),
        ),
        
        ListTile(
          leading: Icon(Icons.description, color: Colors.white),
          title: Text('Privacy Policy', style: TextStyle(color: Colors.white)),
          onTap: () => _showPrivacyPolicy(),
        ),
        
        ListTile(
          leading: Icon(Icons.article, color: Colors.white),
          title: Text('Terms of Service', style: TextStyle(color: Colors.white)),
          onTap: () => _showTermsOfService(),
        ),
      ],
    );
  }

  void _showThemeSelector() {
    Get.bottomSheet(
      Container(
        color: Colors.grey[900],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Dark Theme', style: TextStyle(color: Colors.white)),
              onTap: () {
                themeController.setTheme('dark');
                Get.back();
              },
            ),
            ListTile(
              title: Text('Light Theme', style: TextStyle(color: Colors.white)),
              onTap: () {
                themeController.setTheme('light');
                Get.back();
              },
            ),
            ListTile(
              title: Text('Blue Theme', style: TextStyle(color: Colors.white)),
              onTap: () {
                themeController.setTheme('blue');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showVolumeSettings() {
    Get.snackbar('Info', 'Volume settings coming soon');
  }

  void _showQualitySettings() {
    Get.snackbar('Info', 'Quality settings coming soon');
  }

  void _showCacheSettings() {
    Get.snackbar('Info', 'Cache settings coming soon');
  }

  void _showParentalControls() {
    Get.snackbar('Info', 'Parental controls coming soon');
  }

  void _showFeedbackDialog() {
    Get.snackbar('Info', 'Feedback feature coming soon');
  }

  void _showPrivacyPolicy() {
    Get.snackbar('Info', 'Privacy policy coming soon');
  }

  void _showTermsOfService() {
    Get.snackbar('Info', 'Terms of service coming soon');
  }
}
