import '../utils/constants.dart';

class Playlist {
  final int? id;
  final String name;
  final String url;
  final String type;
  final String? username;
  final String? password;
  final String? userAgent;
  final Map<String, String>? headers;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastUpdated;
  final int channelCount;
  final String? epgUrl;
  final bool autoUpdate;
  final int updateInterval; // in hours
  final String? description;
  final Map<String, dynamic>? metadata;

  Playlist({
    this.id,
    required this.name,
    required this.url,
    required this.type,
    this.username,
    this.password,
    this.userAgent,
    this.headers,
    this.isActive = true,
    required this.createdAt,
    this.lastUpdated,
    this.channelCount = 0,
    this.epgUrl,
    this.autoUpdate = false,
    this.updateInterval = 6,
    this.description,
    this.metadata,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as int?,
      name: json['name'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
      username: json['username'] as String?,
      password: json['password'] as String?,
      userAgent: json['user_agent'] as String?,
      headers: json['headers'] != null
          ? Map<String, String>.from(json['headers'])
          : null,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at']),
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : null,
      channelCount: json['channel_count'] as int? ?? 0,
      epgUrl: json['epg_url'] as String?,
      autoUpdate: json['auto_update'] as bool? ?? false,
      updateInterval: json['update_interval'] as int? ?? 6,
      description: json['description'] as String?,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'type': type,
      'username': username,
      'password': password,
      'user_agent': userAgent,
      'headers': headers,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
      'channel_count': channelCount,
      'epg_url': epgUrl,
      'auto_update': autoUpdate,
      'update_interval': updateInterval,
      'description': description,
      'metadata': metadata,
    };
  }

  factory Playlist.fromDatabase(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as int?,
      name: map['name'] as String,
      url: map['url'] as String,
      type: map['type'] as String,
      username: map['username'] as String?,
      password: map['password'] as String?,
      userAgent: map['user_agent'] as String?,
      headers: map['headers'] != null
          ? Map<String, String>.from(
              map['headers'] is String
                ? {} // Parse JSON string if needed
                : map['headers']
            )
          : null,
      isActive: (map['is_active'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at']),
      lastUpdated: map['last_updated'] != null
          ? DateTime.parse(map['last_updated'])
          : null,
      channelCount: map['channel_count'] as int? ?? 0,
      epgUrl: map['epg_url'] as String?,
      autoUpdate: (map['auto_update'] as int?) == 1,
      updateInterval: map['update_interval'] as int? ?? 6,
      description: map['description'] as String?,
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(
              map['metadata'] is String
                ? {} // Parse JSON string if needed
                : map['metadata']
            )
          : null,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'type': type,
      'username': username,
      'password': password,
      'user_agent': userAgent,
      'headers': headers?.toString(),
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
      'channel_count': channelCount,
      'epg_url': epgUrl,
      'auto_update': autoUpdate ? 1 : 0,
      'update_interval': updateInterval,
      'description': description,
      'metadata': metadata?.toString(),
    };
  }

  Playlist copyWith({
    int? id,
    String? name,
    String? url,
    String? type,
    String? username,
    String? password,
    String? userAgent,
    Map<String, String>? headers,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastUpdated,
    int? channelCount,
    String? epgUrl,
    bool? autoUpdate,
    int? updateInterval,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      type: type ?? this.type,
      username: username ?? this.username,
      password: password ?? this.password,
      userAgent: userAgent ?? this.userAgent,
      headers: headers ?? this.headers,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      channelCount: channelCount ?? this.channelCount,
      epgUrl: epgUrl ?? this.epgUrl,
      autoUpdate: autoUpdate ?? this.autoUpdate,
      updateInterval: updateInterval ?? this.updateInterval,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Playlist && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Playlist(id: $id, name: $name, type: $type, channelCount: $channelCount)';
  }

  // Helper methods
  bool get isM3U => type == Constants.playlistTypeM3U;
  bool get isXtream => type == Constants.playlistTypeXtream;
  bool get isStalker => type == Constants.playlistTypeStalker;
  
  bool get requiresCredentials => isXtream || isStalker;
  bool get hasValidCredentials => 
      !requiresCredentials || 
      (username != null && username!.isNotEmpty && 
       password != null && password!.isNotEmpty);
       
  bool get hasEpg => epgUrl != null && epgUrl!.isNotEmpty;
  
  String get displayName => name.trim().isEmpty ? 'Unnamed Playlist' : name;
  String get typeDisplay {
    switch (type) {
      case Constants.playlistTypeM3U:
        return 'M3U Playlist';
      case Constants.playlistTypeXtream:
        return 'Xtream Codes';
      case Constants.playlistTypeStalker:
        return 'Stalker Portal';
      default:
        return 'Unknown';
    }
  }
  
  Duration get timeSinceLastUpdate {
    if (lastUpdated == null) return Duration.zero;
    return DateTime.now().difference(lastUpdated!);
  }
  
  bool get needsUpdate {
    if (!autoUpdate || lastUpdated == null) return false;
    final hoursSinceUpdate = timeSinceLastUpdate.inHours;
    return hoursSinceUpdate >= updateInterval;
  }

  // Create API URLs for Xtream Codes
  String get xtreamPlayerApiUrl {
    if (!isXtream) return '';
    final baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    return '$baseUrl/player_api.php';
  }
  
  String get xtreamGetUrl {
    if (!isXtream || !hasValidCredentials) return '';
    return '$xtreamPlayerApiUrl?username=$username&password=$password&action=get_live_categories';
  }
  
  String get xtreamLiveStreamsUrl {
    if (!isXtream || !hasValidCredentials) return '';
    return '$xtreamPlayerApiUrl?username=$username&password=$password&action=get_live_streams';
  }
  
  String get xtreamVodStreamsUrl {
    if (!isXtream || !hasValidCredentials) return '';
    return '$xtreamPlayerApiUrl?username=$username&password=$password&action=get_vod_streams';
  }
  
  String get xtreamEpgUrl {
    if (!isXtream || !hasValidCredentials) return '';
    return '$xtreamPlayerApiUrl?username=$username&password=$password&action=get_simple_data_table&stream_id=';
  }

  // Create Stalker Portal URLs
  String get stalkerPortalUrl {
    if (!isStalker) return '';
    final baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    return '$baseUrl/portal.php';
  }
}
