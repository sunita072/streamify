import 'package:workmanager/workmanager.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';

const String epgUpdateTask = "epg_update_task";
const String cleanupTask = "cleanup_task";
const String playlistUpdateTask = "playlist_update_task";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      switch (task) {
        case epgUpdateTask:
          await _updateEpgData(inputData);
          break;
        case cleanupTask:
          await _performCleanup(inputData);
          break;
        case playlistUpdateTask:
          await _updatePlaylists(inputData);
          break;
        default:
          print('Unknown background task: $task');
      }
      return Future.value(true);
    } catch (e) {
      print('Background task error: $e');
      return Future.value(false);
    }
  });
}

Future<void> _updateEpgData(Map<String, dynamic>? inputData) async {
  print('Starting background EPG update...');
  
  try {
    // Initialize database
    await DatabaseService.instance.initialize();
    
    // Get all active playlists
    final playlists = await DatabaseService.instance.getAllPlaylists();
    final activePlaylists = playlists.where((p) => p.isActive && p.autoUpdate).toList();
    
    for (final playlist in activePlaylists) {
      if (playlist.needsUpdate) {
        print('Updating EPG for playlist: ${playlist.name}');
        
        // Update EPG data for this playlist
        await _updatePlaylistEpg(playlist);
        
        // Update last updated timestamp
        final updatedPlaylist = playlist.copyWith(
          lastUpdated: DateTime.now(),
        );
        await DatabaseService.instance.updatePlaylist(updatedPlaylist);
      }
    }
    
    print('Background EPG update completed');
  } catch (e) {
    print('EPG update error: $e');
  }
}

Future<void> _updatePlaylistEpg(playlist) async {
  // This would implement the actual EPG fetching logic
  // For now, it's a placeholder
  print('Updating EPG for playlist: ${playlist.name}');
  
  // TODO: Implement EPG fetching based on playlist type
  // - For M3U: Parse EPG URL if available
  // - For Xtream: Use Xtream API to get EPG
  // - For Stalker: Use Stalker Portal API
}

Future<void> _performCleanup(Map<String, dynamic>? inputData) async {
  print('Starting background cleanup...');
  
  try {
    await DatabaseService.instance.initialize();
    
    // Clean old EPG data (older than 7 days)
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    await DatabaseService.instance.clearOldEpgData(weekAgo);
    
    // Clean old history entries (older than 30 days)
    final monthAgo = DateTime.now().subtract(const Duration(days: 30));
    final db = await DatabaseService.instance.database;
    await db.delete(
      Constants.tableHistory,
      where: 'watched_at < ?',
      whereArgs: [monthAgo.toIso8601String()],
    );
    
    print('Background cleanup completed');
  } catch (e) {
    print('Cleanup error: $e');
  }
}

Future<void> _updatePlaylists(Map<String, dynamic>? inputData) async {
  print('Starting background playlist update...');
  
  try {
    await DatabaseService.instance.initialize();
    
    // Get all active playlists that need updating
    final playlists = await DatabaseService.instance.getAllPlaylists();
    final playlistsToUpdate = playlists.where((p) => 
      p.isActive && p.autoUpdate && p.needsUpdate
    ).toList();
    
    for (final playlist in playlistsToUpdate) {
      print('Updating playlist: ${playlist.name}');
      
      // TODO: Implement playlist updating logic
      // This would fetch the latest channel list and update the database
      
      // Update last updated timestamp
      final updatedPlaylist = playlist.copyWith(
        lastUpdated: DateTime.now(),
      );
      await DatabaseService.instance.updatePlaylist(updatedPlaylist);
    }
    
    print('Background playlist update completed');
  } catch (e) {
    print('Playlist update error: $e');
  }
}

class BackgroundService {
  static void scheduleEpgUpdate() {
    Workmanager().registerPeriodicTask(
      epgUpdateTask,
      epgUpdateTask,
      frequency: const Duration(hours: 6),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  static void scheduleCleanup() {
    Workmanager().registerPeriodicTask(
      cleanupTask,
      cleanupTask,
      frequency: const Duration(days: 1),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: true,
        requiresStorageNotLow: false,
      ),
    );
  }

  static void schedulePlaylistUpdate() {
    Workmanager().registerPeriodicTask(
      playlistUpdateTask,
      playlistUpdateTask,
      frequency: const Duration(hours: 12),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
  }

  static void cancelAllTasks() {
    Workmanager().cancelAll();
  }

  static void cancelTask(String taskName) {
    Workmanager().cancelByUniqueName(taskName);
  }

  static void initialize() {
    scheduleEpgUpdate();
    scheduleCleanup();
    schedulePlaylistUpdate();
  }
}
