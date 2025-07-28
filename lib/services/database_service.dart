import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/channel.dart';
import '../models/playlist.dart';
import '../models/epg_program.dart';
import '../utils/constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static DatabaseService get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, Constants.databaseName);
    
    return await openDatabase(
      path,
      version: Constants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create playlists table
    await db.execute('''
      CREATE TABLE ${Constants.tablePlaylists} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        url TEXT NOT NULL,
        type TEXT NOT NULL,
        username TEXT,
        password TEXT,
        user_agent TEXT,
        headers TEXT,
        is_active INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        last_updated TEXT,
        channel_count INTEGER DEFAULT 0,
        epg_url TEXT,
        auto_update INTEGER DEFAULT 0,
        update_interval INTEGER DEFAULT 6,
        description TEXT,
        metadata TEXT
      )
    ''');

    // Create channels table
    await db.execute('''
      CREATE TABLE ${Constants.tableChannels} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        url TEXT NOT NULL,
        logo TEXT,
        group_name TEXT,
        category TEXT,
        epg_id TEXT,
        headers TEXT,
        user_agent TEXT,
        is_adult INTEGER DEFAULT 0,
        is_favorite INTEGER DEFAULT 0,
        playlist_id INTEGER NOT NULL,
        last_played TEXT,
        play_count INTEGER DEFAULT 0,
        description TEXT,
        languages TEXT,
        country TEXT,
        timeshift TEXT,
        catchup_url TEXT,
        metadata TEXT,
        FOREIGN KEY (playlist_id) REFERENCES ${Constants.tablePlaylists} (id) ON DELETE CASCADE
      )
    ''');

    // Create EPG table
    await db.execute('''
      CREATE TABLE ${Constants.tableEpg} (
        id TEXT PRIMARY KEY,
        channel_id TEXT NOT NULL,
        title TEXT NOT NULL,
        subtitle TEXT,
        description TEXT,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        category TEXT,
        genre TEXT,
        rating TEXT,
        icon TEXT,
        cast TEXT,
        directors TEXT,
        year TEXT,
        country TEXT,
        language TEXT,
        is_live INTEGER DEFAULT 0,
        is_repeat INTEGER DEFAULT 0,
        is_premiere INTEGER DEFAULT 0,
        has_subtitles INTEGER DEFAULT 0,
        has_audio_description INTEGER DEFAULT 0,
        episode_number TEXT,
        season_number TEXT,
        series_id TEXT,
        metadata TEXT,
        FOREIGN KEY (channel_id) REFERENCES ${Constants.tableChannels} (id) ON DELETE CASCADE
      )
    ''');

    // Create favorites table
    await db.execute('''
      CREATE TABLE ${Constants.tableFavorites} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        channel_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (channel_id) REFERENCES ${Constants.tableChannels} (id) ON DELETE CASCADE
      )
    ''');

    // Create history table
    await db.execute('''
      CREATE TABLE ${Constants.tableHistory} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        channel_id TEXT NOT NULL,
        watched_at TEXT NOT NULL,
        duration INTEGER DEFAULT 0,
        position INTEGER DEFAULT 0,
        FOREIGN KEY (channel_id) REFERENCES ${Constants.tableChannels} (id) ON DELETE CASCADE
      )
    ''');

    // Create recordings table
    await db.execute('''
      CREATE TABLE ${Constants.tableRecordings} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        channel_id TEXT NOT NULL,
        program_id TEXT,
        title TEXT NOT NULL,
        description TEXT,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        file_path TEXT,
        file_size INTEGER DEFAULT 0,
        status TEXT DEFAULT 'scheduled',
        quality TEXT DEFAULT '720p',
        format TEXT DEFAULT 'mp4',
        created_at TEXT NOT NULL,
        FOREIGN KEY (channel_id) REFERENCES ${Constants.tableChannels} (id) ON DELETE CASCADE,
        FOREIGN KEY (program_id) REFERENCES ${Constants.tableEpg} (id) ON DELETE SET NULL
      )
    ''');

    // Create settings table
    await db.execute('''
      CREATE TABLE ${Constants.tableSettings} (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_channels_playlist_id ON ${Constants.tableChannels} (playlist_id)');
    await db.execute('CREATE INDEX idx_channels_group ON ${Constants.tableChannels} (group_name)');
    await db.execute('CREATE INDEX idx_channels_category ON ${Constants.tableChannels} (category)');
    await db.execute('CREATE INDEX idx_epg_channel_id ON ${Constants.tableEpg} (channel_id)');
    await db.execute('CREATE INDEX idx_epg_start_time ON ${Constants.tableEpg} (start_time)');
    await db.execute('CREATE INDEX idx_history_channel_id ON ${Constants.tableHistory} (channel_id)');
    await db.execute('CREATE INDEX idx_history_watched_at ON ${Constants.tableHistory} (watched_at)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic for future versions
    }
  }

  Future<void> initialize() async {
    await database;
  }

  // Playlist operations
  Future<int> insertPlaylist(Playlist playlist) async {
    final db = await database;
    return await db.insert(Constants.tablePlaylists, playlist.toDatabase());
  }

  Future<List<Playlist>> getAllPlaylists() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Constants.tablePlaylists);
    return List.generate(maps.length, (i) => Playlist.fromDatabase(maps[i]));
  }

  Future<Playlist?> getPlaylist(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Constants.tablePlaylists,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return maps.isNotEmpty ? Playlist.fromDatabase(maps.first) : null;
  }

  Future<void> updatePlaylist(Playlist playlist) async {
    final db = await database;
    await db.update(
      Constants.tablePlaylists,
      playlist.toDatabase(),
      where: 'id = ?',
      whereArgs: [playlist.id],
    );
  }

  Future<void> deletePlaylist(int id) async {
    final db = await database;
    await db.delete(
      Constants.tablePlaylists,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Channel operations
  Future<void> insertChannel(Channel channel) async {
    final db = await database;
    await db.insert(
      Constants.tableChannels,
      channel.toDatabase(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertChannels(List<Channel> channels) async {
    final db = await database;
    final batch = db.batch();
    
    for (final channel in channels) {
      batch.insert(
        Constants.tableChannels,
        channel.toDatabase(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
  }

  Future<List<Channel>> getChannelsByPlaylist(int playlistId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Constants.tableChannels,
      where: 'playlist_id = ?',
      whereArgs: [playlistId],
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => Channel.fromDatabase(maps[i]));
  }

  Future<List<Channel>> getFavoriteChannels() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Constants.tableChannels,
      where: 'is_favorite = 1',
      orderBy: 'name ASC',
    );
    return List.generate(maps.length, (i) => Channel.fromDatabase(maps[i]));
  }

  Future<void> updateChannelFavorite(String channelId, bool isFavorite) async {
    final db = await database;
    await db.update(
      Constants.tableChannels,
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [channelId],
    );
  }

  Future<void> updateChannelPlayCount(String channelId) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE ${Constants.tableChannels} 
      SET play_count = play_count + 1, last_played = ? 
      WHERE id = ?
    ''', [DateTime.now().toIso8601String(), channelId]);
  }

  // EPG operations
  Future<void> insertEpgPrograms(List<EpgProgram> programs) async {
    final db = await database;
    final batch = db.batch();
    
    for (final program in programs) {
      batch.insert(
        Constants.tableEpg,
        program.toDatabase(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit();
  }

  Future<List<EpgProgram>> getEpgForChannel(String channelId, DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final List<Map<String, dynamic>> maps = await db.query(
      Constants.tableEpg,
      where: 'channel_id = ? AND start_time >= ? AND start_time < ?',
      whereArgs: [
        channelId,
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
      ],
      orderBy: 'start_time ASC',
    );
    
    return List.generate(maps.length, (i) => EpgProgram.fromDatabase(maps[i]));
  }

  Future<List<EpgProgram>> getEpgForDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final List<Map<String, dynamic>> maps = await db.query(
      Constants.tableEpg,
      where: 'start_time >= ? AND start_time < ?',
      whereArgs: [
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
      ],
      orderBy: 'start_time ASC',
    );
    
    return List.generate(maps.length, (i) => EpgProgram.fromDatabase(maps[i]));
  }

  Future<void> clearOldEpgData(DateTime before) async {
    final db = await database;
    await db.delete(
      Constants.tableEpg,
      where: 'end_time < ?',
      whereArgs: [before.toIso8601String()],
    );
  }

  // Settings operations
  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      Constants.tableSettings,
      {
        'key': key,
        'value': value,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Constants.tableSettings,
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return maps.isNotEmpty ? maps.first['value'] as String : null;
  }

  // Utility methods
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(Constants.tableEpg);
    await db.delete(Constants.tableChannels);
    await db.delete(Constants.tablePlaylists);
    await db.delete(Constants.tableFavorites);
    await db.delete(Constants.tableHistory);
    await db.delete(Constants.tableRecordings);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
