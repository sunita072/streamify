import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/playlist.dart';
import '../models/channel.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';

class PlaylistController extends GetxController {
  final _playlists = <Playlist>[].obs;
  final _isLoading = false.obs;
  final _selectedPlaylist = Rx<Playlist?>(null);
  final _channels = <Channel>[].obs;
  
  final Dio _dio = Dio();

  // Additional observables for missing features
  final _favoriteChannels = <Channel>[].obs;
  final _recentChannels = <Channel>[].obs;
  final _filteredChannels = <Channel>[].obs;
  
  // Getters
  List<Playlist> get playlists => _playlists;
  bool get isLoading => _isLoading.value;
  Playlist? get selectedPlaylist => _selectedPlaylist.value;
  List<Channel> get channels => _channels;
  List<Channel> get favoriteChannels => _favoriteChannels;
  List<Channel> get recentChannels => _recentChannels;
  List<Channel> get filteredChannels => _filteredChannels.isEmpty ? _channels : _filteredChannels;

  @override
  void onInit() {
    super.onInit();
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    _isLoading.value = true;
    try {
      final playlistsFromDb = await DatabaseService.instance.getAllPlaylists();
      _playlists.value = playlistsFromDb;
      
      if (playlistsFromDb.isNotEmpty && _selectedPlaylist.value == null) {
        selectPlaylist(playlistsFromDb.first);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load playlists: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addPlaylist(Playlist playlist) async {
    _isLoading.value = true;
    try {
      final id = await DatabaseService.instance.insertPlaylist(playlist);
      final newPlaylist = playlist.copyWith(id: id);
      _playlists.add(newPlaylist);
      
      // Parse and load channels from the playlist
      await _parsePlaylist(newPlaylist);
      
      Get.snackbar('Success', Constants.successPlaylistAdded);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add playlist: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updatePlaylist(Playlist playlist) async {
    try {
      await DatabaseService.instance.updatePlaylist(playlist);
      final index = _playlists.indexWhere((p) => p.id == playlist.id);
      if (index != -1) {
        _playlists[index] = playlist;
      }
      Get.snackbar('Success', 'Playlist updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update playlist: $e');
    }
  }

  Future<void> deletePlaylist(int playlistId) async {
    try {
      await DatabaseService.instance.deletePlaylist(playlistId);
      _playlists.removeWhere((p) => p.id == playlistId);
      
      if (_selectedPlaylist.value?.id == playlistId) {
        _selectedPlaylist.value = _playlists.isNotEmpty ? _playlists.first : null;
        if (_selectedPlaylist.value != null) {
          await loadChannelsForPlaylist(_selectedPlaylist.value!);
        } else {
          _channels.clear();
        }
      }
      
      Get.snackbar('Success', 'Playlist deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete playlist: $e');
    }
  }

  Future<void> selectPlaylist(Playlist playlist) async {
    _selectedPlaylist.value = playlist;
    await loadChannelsForPlaylist(playlist);
  }

  Future<void> loadChannelsForPlaylist(Playlist playlist) async {
    _isLoading.value = true;
    try {
      final channelsFromDb = await DatabaseService.instance.getChannelsByPlaylist(playlist.id!);
      _channels.value = channelsFromDb;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load channels: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshPlaylist(Playlist playlist) async {
    _isLoading.value = true;
    try {
      await _parsePlaylist(playlist);
      
      // Update last updated timestamp
      final updatedPlaylist = playlist.copyWith(lastUpdated: DateTime.now());
      await updatePlaylist(updatedPlaylist);
      
      // Reload channels
      await loadChannelsForPlaylist(updatedPlaylist);
      
      Get.snackbar('Success', 'Playlist refreshed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to refresh playlist: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _parsePlaylist(Playlist playlist) async {
    switch (playlist.type) {
      case Constants.playlistTypeM3U:
        await _parseM3UPlaylist(playlist);
        break;
      case Constants.playlistTypeXtream:
        await _parseXtreamPlaylist(playlist);
        break;
      case Constants.playlistTypeStalker:
        await _parseStalkerPlaylist(playlist);
        break;
    }
  }

  Future<void> _parseM3UPlaylist(Playlist playlist) async {
    try {
      final response = await _dio.get(
        playlist.url,
        options: Options(
          headers: playlist.headers,
          followRedirects: true,
          maxRedirects: 5,
        ),
      );

      final content = response.data as String;
      final channels = _parseM3UContent(content, playlist.id!);
      
      await DatabaseService.instance.insertChannels(channels);
      
      // Update channel count
      final updatedPlaylist = playlist.copyWith(channelCount: channels.length);
      await DatabaseService.instance.updatePlaylist(updatedPlaylist);
      
    } catch (e) {
      throw Exception('Failed to parse M3U playlist: $e');
    }
  }

  List<Channel> _parseM3UContent(String content, int playlistId) {
    final channels = <Channel>[];
    final lines = content.split('\n');
    
    String? extinf;
    String? channelUrl;
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      
      if (line.startsWith('#EXTINF:')) {
        extinf = line;
      } else if (line.isNotEmpty && !line.startsWith('#') && extinf != null) {
        channelUrl = line;
        
        // Parse channel info from EXTINF line
        final channel = _parseExtinfLine(extinf, channelUrl, playlistId);
        if (channel != null) {
          channels.add(channel);
        }
        
        extinf = null;
        channelUrl = null;
      }
    }
    
    return channels;
  }

  Channel? _parseExtinfLine(String extinf, String url, int playlistId) {
    try {
      // Extract channel name (after the last comma)
      final nameMatch = RegExp(r',(.+)$').firstMatch(extinf);
      final name = nameMatch?.group(1)?.trim() ?? 'Unknown Channel';
      
      // Extract logo
      final logoMatch = RegExp(r'tvg-logo="([^"]*)"').firstMatch(extinf);
      final logo = logoMatch?.group(1);
      
      // Extract EPG ID
      final epgIdMatch = RegExp(r'tvg-id="([^"]*)"').firstMatch(extinf);
      final epgId = epgIdMatch?.group(1);
      
      // Extract group
      final groupMatch = RegExp(r'group-title="([^"]*)"').firstMatch(extinf);
      final group = groupMatch?.group(1);
      
      // Generate unique ID
      final channelId = '${playlistId}_${name.hashCode}_${url.hashCode}';
      
      return Channel(
        id: channelId,
        name: name,
        url: url,
        logo: logo,
        group: group,
        epgId: epgId,
        playlistId: playlistId,
      );
    } catch (e) {
      print('Error parsing EXTINF line: $e');
      return null;
    }
  }

  Future<void> _parseXtreamPlaylist(Playlist playlist) async {
    if (!playlist.hasValidCredentials) {
      throw Exception('Xtream playlist requires valid credentials');
    }

    try {
      // Get live streams
      final response = await _dio.get(playlist.xtreamLiveStreamsUrl);
      final List<dynamic> streamsData = response.data;
      
      final channels = <Channel>[];
      
      for (final streamData in streamsData) {
        final channel = _parseXtreamChannel(streamData, playlist);
        if (channel != null) {
          channels.add(channel);
        }
      }
      
      await DatabaseService.instance.insertChannels(channels);
      
      // Update channel count
      final updatedPlaylist = playlist.copyWith(channelCount: channels.length);
      await DatabaseService.instance.updatePlaylist(updatedPlaylist);
      
    } catch (e) {
      throw Exception('Failed to parse Xtream playlist: $e');
    }
  }

  Channel? _parseXtreamChannel(Map<String, dynamic> data, Playlist playlist) {
    try {
      final streamId = data['stream_id']?.toString();
      final name = data['name']?.toString() ?? 'Unknown Channel';
      final categoryId = data['category_id']?.toString();
      
      if (streamId == null) return null;
      
      // Build stream URL
      final baseUrl = playlist.url.endsWith('/') 
          ? playlist.url.substring(0, playlist.url.length - 1) 
          : playlist.url;
      final streamUrl = '$baseUrl/live/${playlist.username}/${playlist.password}/$streamId.ts';
      
      return Channel(
        id: '${playlist.id}_xtream_$streamId',
        name: name,
        url: streamUrl,
        logo: data['stream_icon']?.toString(),
        category: categoryId,
        epgId: data['epg_channel_id']?.toString(),
        playlistId: playlist.id!,
      );
    } catch (e) {
      print('Error parsing Xtream channel: $e');
      return null;
    }
  }

  Future<void> _parseStalkerPlaylist(Playlist playlist) async {
    // TODO: Implement Stalker Portal parsing
    throw Exception('Stalker Portal support not yet implemented');
  }

  List<Channel> getChannelsByGroup(String group) {
    return _channels.where((channel) => channel.group == group).toList();
  }

  List<String> getChannelGroups() {
    final groups = _channels.map((channel) => channel.displayGroup).toSet().toList();
    groups.sort();
    return groups;
  }

  List<Channel> searchChannels(String query) {
    if (query.isEmpty) return _channels;
    
    final lowercaseQuery = query.toLowerCase();
    return _channels.where((channel) {
      return channel.name.toLowerCase().contains(lowercaseQuery) ||
             channel.group?.toLowerCase().contains(lowercaseQuery) == true ||
             channel.category?.toLowerCase().contains(lowercaseQuery) == true;
    }).toList();
  }

  Future<void> toggleChannelFavorite(Channel channel) async {
    try {
      final newFavoriteStatus = !channel.isFavorite;
      await DatabaseService.instance.updateChannelFavorite(channel.id, newFavoriteStatus);
      
      // Update local channel list
      final index = _channels.indexWhere((c) => c.id == channel.id);
      if (index != -1) {
        _channels[index] = channel.copyWith(isFavorite: newFavoriteStatus);
      }
      
      // Update favorites list
      if (newFavoriteStatus) {
        _favoriteChannels.add(_channels[index]);
      } else {
        _favoriteChannels.removeWhere((c) => c.id == channel.id);
      }
      
      Get.snackbar(
        'Success', 
        newFavoriteStatus ? 'Added to favorites' : 'Removed from favorites',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update favorite: $e');
    }
  }

  // Method aliases for compatibility
  void toggleFavorite(Channel channel) => toggleChannelFavorite(channel);
  
  Future<void> addPlaylistFromUrl(String name, String url) async {
    final playlist = Playlist(
      name: name,
      url: url,
      type: url.toLowerCase().contains('.m3u') ? Constants.playlistTypeM3U : Constants.playlistTypeXtream,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
    await addPlaylist(playlist);
  }
  
  Future<void> removePlaylist(Playlist playlist) async {
    if (playlist.id != null) {
      await deletePlaylist(playlist.id!);
    }
  }
  
  void addToHistory(Channel channel) {
    // Remove if already in history
    _recentChannels.removeWhere((c) => c.id == channel.id);
    // Add to beginning
    _recentChannels.insert(0, channel);
    // Keep only last 50 items
    if (_recentChannels.length > 50) {
      _recentChannels.removeRange(50, _recentChannels.length);
    }
  }
  
  void removeFromHistory(Channel channel) {
    _recentChannels.removeWhere((c) => c.id == channel.id);
  }
  
  void clearHistory() {
    _recentChannels.clear();
  }
  
  void filterChannels(String query) {
    if (query.isEmpty) {
      _filteredChannels.clear();
    } else {
      _filteredChannels.value = searchChannels(query);
    }
  }
}
