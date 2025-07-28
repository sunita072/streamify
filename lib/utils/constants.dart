class Constants {
  // App Information
  static const String appName = 'Streamify';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Premium IPTV Player for Android TV';
  
  // Database
  static const String databaseName = 'streamify.db';
  static const int databaseVersion = 1;
  
  // Table Names
  static const String tableChannels = 'channels';
  static const String tablePlaylists = 'playlists';
  static const String tableEpg = 'epg';
  static const String tableFavorites = 'favorites';
  static const String tableHistory = 'history';
  static const String tableRecordings = 'recordings';
  static const String tableSettings = 'settings';
  
  // Shared Preferences Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyTheme = 'theme';
  static const String keyLanguage = 'language';
  static const String keyAutoStart = 'auto_start';
  static const String keyParentalPin = 'parental_pin';
  static const String keyParentalEnabled = 'parental_enabled';
  static const String keyEpgUpdateInterval = 'epg_update_interval';
  static const String keyChannelZapTime = 'channel_zap_time';
  static const String keyBufferSize = 'buffer_size';
  static const String keyExternalPlayer = 'external_player';
  static const String keyAutoFrameRate = 'auto_frame_rate';
  static const String keyMultiScreenEnabled = 'multi_screen_enabled';
  static const String keyRecordingPath = 'recording_path';
  static const String keyBackupEnabled = 'backup_enabled';
  
  // Playlist Types
  static const String playlistTypeM3U = 'M3U';
  static const String playlistTypeXtream = 'XTREAM';
  static const String playlistTypeStalker = 'STALKER';
  
  // EPG Types
  static const String epgTypeXMLTV = 'XMLTV';
  static const String epgTypeXtream = 'XTREAM';
  
  // Player Types
  static const String playerInternal = 'INTERNAL';
  static const String playerVLC = 'VLC';
  static const String playerMX = 'MX_PLAYER';
  static const String playerExternal = 'EXTERNAL';
  
  // Protocols
  static const List<String> supportedProtocols = [
    'http://',
    'https://',
    'udp://',
    'rtmp://',
    'rtsp://',
    'hls://',
    'file://',
  ];
  
  // Video Formats
  static const List<String> supportedVideoFormats = [
    '.mp4',
    '.mkv',
    '.avi',
    '.ts',
    '.m3u8',
    '.flv',
    '.webm',
    '.mov',
  ];
  
  // Audio Formats
  static const List<String> supportedAudioFormats = [
    '.mp3',
    '.aac',
    '.wav',
    '.flac',
    '.ogg',
  ];
  
  // Channel Categories
  static const List<String> defaultCategories = [
    'All Channels',
    'Entertainment',
    'News',
    'Sports',
    'Movies',
    'Documentaries',
    'Kids',
    'Music',
    'Religious',
    'International',
    'Adult',
  ];
  
  // EPG Update Intervals (in hours)
  static const List<int> epgUpdateIntervals = [1, 2, 4, 6, 12, 24];
  
  // Buffer Sizes (in seconds)
  static const List<int> bufferSizes = [5, 10, 15, 30, 60];
  
  // Channel Zap Times (in milliseconds)
  static const List<int> channelZapTimes = [500, 1000, 1500, 2000, 3000];
  
  // Multi-screen configurations
  static const int maxMultiScreens = 4;
  
  // Recording settings
  static const List<String> recordingQualities = ['480p', '720p', '1080p', 'Original'];
  static const List<String> recordingFormats = ['MP4', 'TS', 'MKV'];
  
  // Themes
  static const List<String> availableThemes = [
    'Dark',
    'Light',
    'Netflix',
    'YouTube TV',
    'Plex',
    'Custom',
  ];
  
  // Languages
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'pt', 'name': 'Portuguese'},
    {'code': 'it', 'name': 'Italian'},
    {'code': 'ru', 'name': 'Russian'},
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'zh', 'name': 'Chinese'},
    {'code': 'ja', 'name': 'Japanese'},
  ];
  
  // Error Messages
  static const String errorNoInternet = 'No internet connection available';
  static const String errorPlaylistLoad = 'Failed to load playlist';
  static const String errorChannelLoad = 'Failed to load channel';
  static const String errorEpgLoad = 'Failed to load EPG data';
  static const String errorInvalidUrl = 'Invalid URL provided';
  static const String errorPermissionDenied = 'Permission denied';
  static const String errorStorageFull = 'Storage space is full';
  static const String errorRecordingFailed = 'Recording failed';
  
  // Success Messages
  static const String successPlaylistAdded = 'Playlist added successfully';
  static const String successEpgUpdated = 'EPG updated successfully';
  static const String successSettingsSaved = 'Settings saved successfully';
  static const String successRecordingStarted = 'Recording started successfully';
  static const String successBackupCreated = 'Backup created successfully';
  
  // API Endpoints (for demo purposes - replace with actual endpoints)
  static const String apiBaseUrl = 'https://api.streamify.tv';
  static const String apiVersionCheck = '/api/v1/version';
  static const String apiEpgUpdate = '/api/v1/epg/update';
  static const String apiChannelLogos = '/api/v1/logos';
  
  // External Player Package Names
  static const String vlcPackageName = 'org.videolan.vlc';
  static const String mxPlayerPackageName = 'com.mxtech.videoplayer.ad';
  static const String mxPlayerProPackageName = 'com.mxtech.videoplayer.pro';
  
  // Default Values
  static const int defaultEpgUpdateInterval = 6; // hours
  static const int defaultChannelZapTime = 1000; // milliseconds
  static const int defaultBufferSize = 15; // seconds
  static const String defaultTheme = 'Dark';
  static const String defaultLanguage = 'en';
  static const String defaultPlayer = playerInternal;
  static const bool defaultAutoStart = false;
  static const bool defaultParentalEnabled = false;
  static const bool defaultAutoFrameRate = true;
  static const bool defaultMultiScreenEnabled = false;
  static const bool defaultBackupEnabled = true;
  
  // File Extensions
  static const String m3uExtension = '.m3u';
  static const String m3u8Extension = '.m3u8';
  static const String xmlExtension = '.xml';
  static const String jsonExtension = '.json';
  static const String backupExtension = '.backup';
  
  // Regex Patterns
  static const String urlPattern = r'^https?:\/\/.+';
  static const String m3uLinePattern = r'^#EXTINF:([^,]*),(.*)$';
  static const String epgChannelPattern = r'tvg-id="([^"]*)"';
  static const String epgLogoPattern = r'tvg-logo="([^"]*)"';
  static const String epgGroupPattern = r'group-title="([^"]*)"';
}
