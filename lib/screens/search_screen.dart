import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/playlist_controller.dart';
import '../controllers/player_controller.dart';
import '../models/channel.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PlaylistController playlistController = Get.find<PlaylistController>();
  final PlayerController playerController = Get.find<PlayerController>();
  final TextEditingController searchController = TextEditingController();
  
  List<Channel> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (searchController.text.isEmpty) {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
    } else {
      setState(() {
        isSearching = true;
        searchResults = _performSearch(searchController.text);
      });
    }
  }

  List<Channel> _performSearch(String query) {
    final allChannels = playlistController.channels;
    return allChannels.where((channel) {
      return channel.name.toLowerCase().contains(query.toLowerCase()) ||
             (channel.group?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: TextField(
          controller: searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search channels...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      searchController.clear();
                    },
                  )
                : Icon(Icons.search, color: Colors.white54),
          ),
          autofocus: true,
        ),
      ),
      body: isSearching
          ? searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.white54,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No channels found',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final channel = searchResults[index];
                    return _buildChannelTile(channel);
                  },
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 64,
                    color: Colors.white54,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Search for channels',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
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
        trailing: Icon(
          Icons.play_arrow,
          color: Colors.white,
        ),
        onTap: () {
          playerController.initializePlayer(
            channel,
            channels: playlistController.channels,
          );
          Get.back(); // Go back to previous screen and start playing
        },
      ),
    );
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
