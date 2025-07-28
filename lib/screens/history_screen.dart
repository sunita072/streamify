import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/playlist_controller.dart';
import '../controllers/player_controller.dart';

class HistoryScreen extends StatelessWidget {
  final PlaylistController playlistController = Get.find<PlaylistController>();
  final PlayerController playerController = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Watch History'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () => _showClearHistoryDialog(),
          ),
        ],
      ),
      body: Obx(() {
        final recentChannels = playlistController.recentChannels;
        
        if (recentChannels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: Colors.white54,
                ),
                SizedBox(height: 16),
                Text(
                  'No watch history yet',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Start watching channels to see your history',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          itemCount: recentChannels.length,
          itemBuilder: (context, index) {
            final channel = recentChannels[index];
            return Card(
              color: Colors.grey[800],
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: channel.logoUrl?.isNotEmpty == true
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            channel.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.tv,
                                color: Colors.white54,
                                size: 24,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.tv,
                          color: Colors.white54,
                          size: 24,
                        ),
                ),
                title: Text(
                  channel.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: channel.group?.isNotEmpty == true
                    ? Text(
                        channel.group!,
                        style: TextStyle(color: Colors.white70),
                      )
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white54,
                      ),
                      onPressed: () {
                        playlistController.removeFromHistory(channel);
                      },
                    ),
                    Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ],
                ),
                onTap: () {
                  playerController.initializePlayer(
                    channel,
                    channels: playlistController.channels,
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }

  void _showClearHistoryDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text('Clear History', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to clear all watch history?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              playlistController.clearHistory();
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}
