import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:better_player/better_player.dart';

import '../controllers/player_controller.dart';
import '../controllers/playlist_controller.dart';
import '../models/channel.dart';

class LiveTVScreen extends StatefulWidget {
  @override
  _LiveTVScreenState createState() => _LiveTVScreenState();
}

class _LiveTVScreenState extends State<LiveTVScreen> {
  final PlayerController playerController = Get.find<PlayerController>();
  final PlaylistController playlistController = Get.find<PlaylistController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Video Player Area
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: Obx(() {
                if (playerController.betterPlayerController != null) {
                  return BetterPlayer(controller: playerController.betterPlayerController!);
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.tv,
                        size: 64,
                        color: Colors.white54,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Select a channel to start watching',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          
          // Channel List
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[900],
              child: Obx(() {
                final channels = playlistController.filteredChannels;
                
                if (channels.isEmpty) {
                  return Center(
                    child: Text(
                      'No channels available',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }
                
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: channels.length,
                  itemBuilder: (context, index) {
                    final channel = channels[index];
                    final isSelected = playerController.currentChannel?.id == channel.id;
                    
                    return GestureDetector(
                      onTap: () => _playChannel(channel),
                      child: Container(
                        width: 200,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[800],
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Channel Logo
                            if (channel.logoUrl?.isNotEmpty == true)
                              Expanded(
                                flex: 2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                  child: Image.network(
                                    channel.logoUrl!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[700],
                                        child: Icon(
                                          Icons.tv,
                                          color: Colors.white54,
                                          size: 32,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[700],
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.tv,
                                      color: Colors.white54,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              ),
                            
                            // Channel Info
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      channel.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (channel.group?.isNotEmpty == true)
                                      Text(
                                        channel.group!,
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _playChannel(Channel channel) {
    final channels = playlistController.filteredChannels;
    playerController.initializePlayer(channel, channels: channels);
  }
}
