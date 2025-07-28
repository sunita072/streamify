import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/playlist_controller.dart';

class PlaylistScreen extends StatelessWidget {
  final PlaylistController playlistController = Get.find<PlaylistController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Playlists'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddPlaylistDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        final playlists = playlistController.playlists;
        
        if (playlists.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.playlist_play,
                  size: 64,
                  color: Colors.white54,
                ),
                SizedBox(height: 16),
                Text(
                  'No playlists added yet',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showAddPlaylistDialog(context),
                  child: Text('Add Playlist'),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          itemCount: playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlists[index];
            return Card(
              color: Colors.grey[800],
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: Icon(
                  Icons.playlist_play,
                  color: Colors.white,
                ),
                title: Text(
                  playlist.name,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '${playlist.channels.length} channels',
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditPlaylistDialog(context, playlist);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, playlist);
                    }
                  },
                ),
                onTap: () => playlistController.selectPlaylist(playlist),
              ),
            );
          },
        );
      }),
    );
  }

  void _showAddPlaylistDialog(BuildContext context) {
    final nameController = TextEditingController();
    final urlController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text('Add Playlist', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Playlist Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: urlController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'M3U URL or file path',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && urlController.text.isNotEmpty) {
                playlistController.addPlaylistFromUrl(
                  nameController.text,
                  urlController.text,
                );
                Get.back();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditPlaylistDialog(BuildContext context, playlist) {
    // Implementation for editing playlist
    Get.snackbar('Info', 'Edit playlist feature coming soon');
  }

  void _showDeleteConfirmation(BuildContext context, playlist) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[800],
        title: Text('Delete Playlist', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${playlist.name}"?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              playlistController.removePlaylist(playlist);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
