import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/playlist_controller.dart';
import '../controllers/player_controller.dart';
import '../models/channel.dart';

class FavoritesScreen extends StatelessWidget {
  final PlaylistController playlistController = Get.find<PlaylistController>();
  final PlayerController playerController = Get.find<PlayerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Favorites'),
      ),
      body: Obx(() {
        final favoriteChannels = playlistController.favoriteChannels;
        
        if (favoriteChannels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.white54,
                ),
                SizedBox(height: 16),
                Text(
                  'No favorite channels yet',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add channels to favorites from channel list',
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
          itemCount: favoriteChannels.length,
          itemBuilder: (context, index) {
            final channel = favoriteChannels[index];
            return _buildChannelTile(channel);
          },
        );
      }),
    );
  }

  Widget _buildChannelTile(Channel channel) {
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
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                playlistController.toggleFavorite(channel);
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
  }
}
