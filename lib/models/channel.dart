class Channel {
  final String id;
  final String name;
  final String url;
  final String? logo;
  final String? group;
  final String? category;
  final String? epgId;
  final Map<String, String>? headers;
  final String? userAgent;
  final bool isAdult;
  final bool isFavorite;
  final int playlistId;
  final DateTime? lastPlayed;
  final int playCount;
  final String? description;
  final List<String>? languages;
  final String? country;
  final String? timeshift;
  final String? catchupUrl;
  final Map<String, dynamic>? metadata;

  Channel({
    required this.id,
    required this.name,
    required this.url,
    this.logo,
    this.group,
    this.category,
    this.epgId,
    this.headers,
    this.userAgent,
    this.isAdult = false,
    this.isFavorite = false,
    required this.playlistId,
    this.lastPlayed,
    this.playCount = 0,
    this.description,
    this.languages,
    this.country,
    this.timeshift,
    this.catchupUrl,
    this.metadata,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      logo: json['logo'] as String?,
      group: json['group'] as String?,
      category: json['category'] as String?,
      epgId: json['epg_id'] as String?,
      headers: json['headers'] != null 
          ? Map<String, String>.from(json['headers'])
          : null,
      userAgent: json['user_agent'] as String?,
      isAdult: json['is_adult'] as bool? ?? false,
      isFavorite: json['is_favorite'] as bool? ?? false,
      playlistId: json['playlist_id'] as int,
      lastPlayed: json['last_played'] != null 
          ? DateTime.parse(json['last_played'])
          : null,
      playCount: json['play_count'] as int? ?? 0,
      description: json['description'] as String?,
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      country: json['country'] as String?,
      timeshift: json['timeshift'] as String?,
      catchupUrl: json['catchup_url'] as String?,
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
      'logo': logo,
      'group': group,
      'category': category,
      'epg_id': epgId,
      'headers': headers,
      'user_agent': userAgent,
      'is_adult': isAdult,
      'is_favorite': isFavorite,
      'playlist_id': playlistId,
      'last_played': lastPlayed?.toIso8601String(),
      'play_count': playCount,
      'description': description,
      'languages': languages,
      'country': country,
      'timeshift': timeshift,
      'catchup_url': catchupUrl,
      'metadata': metadata,
    };
  }

  factory Channel.fromDatabase(Map<String, dynamic> map) {
    return Channel(
      id: map['id'] as String,
      name: map['name'] as String,
      url: map['url'] as String,
      logo: map['logo'] as String?,
      group: map['group_name'] as String?,
      category: map['category'] as String?,
      epgId: map['epg_id'] as String?,
      headers: map['headers'] != null
          ? Map<String, String>.from(
              map['headers'] is String 
                ? {} // Parse JSON string if needed
                : map['headers']
            )
          : null,
      userAgent: map['user_agent'] as String?,
      isAdult: (map['is_adult'] as int?) == 1,
      isFavorite: (map['is_favorite'] as int?) == 1,
      playlistId: map['playlist_id'] as int,
      lastPlayed: map['last_played'] != null
          ? DateTime.parse(map['last_played'])
          : null,
      playCount: map['play_count'] as int? ?? 0,
      description: map['description'] as String?,
      languages: map['languages'] != null
          ? map['languages'].toString().split(',')
          : null,
      country: map['country'] as String?,
      timeshift: map['timeshift'] as String?,
      catchupUrl: map['catchup_url'] as String?,
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
      'logo': logo,
      'group_name': group,
      'category': category,
      'epg_id': epgId,
      'headers': headers?.toString(),
      'user_agent': userAgent,
      'is_adult': isAdult ? 1 : 0,
      'is_favorite': isFavorite ? 1 : 0,
      'playlist_id': playlistId,
      'last_played': lastPlayed?.toIso8601String(),
      'play_count': playCount,
      'description': description,
      'languages': languages?.join(','),
      'country': country,
      'timeshift': timeshift,
      'catchup_url': catchupUrl,
      'metadata': metadata?.toString(),
    };
  }

  Channel copyWith({
    String? id,
    String? name,
    String? url,
    String? logo,
    String? group,
    String? category,
    String? epgId,
    Map<String, String>? headers,
    String? userAgent,
    bool? isAdult,
    bool? isFavorite,
    int? playlistId,
    DateTime? lastPlayed,
    int? playCount,
    String? description,
    List<String>? languages,
    String? country,
    String? timeshift,
    String? catchupUrl,
    Map<String, dynamic>? metadata,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      logo: logo ?? this.logo,
      group: group ?? this.group,
      category: category ?? this.category,
      epgId: epgId ?? this.epgId,
      headers: headers ?? this.headers,
      userAgent: userAgent ?? this.userAgent,
      isAdult: isAdult ?? this.isAdult,
      isFavorite: isFavorite ?? this.isFavorite,
      playlistId: playlistId ?? this.playlistId,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      playCount: playCount ?? this.playCount,
      description: description ?? this.description,
      languages: languages ?? this.languages,
      country: country ?? this.country,
      timeshift: timeshift ?? this.timeshift,
      catchupUrl: catchupUrl ?? this.catchupUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Channel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Channel(id: $id, name: $name, url: $url, group: $group)';
  }

  // Helper methods
  bool get hasCatchup => catchupUrl != null && catchupUrl!.isNotEmpty;
  bool get hasTimeshift => timeshift != null && timeshift!.isNotEmpty;
  bool get hasEpg => epgId != null && epgId!.isNotEmpty;
  bool get hasLogo => logo != null && logo!.isNotEmpty;
  
  String get displayName => name.trim().isEmpty ? 'Unknown Channel' : name;
  String get displayGroup => group?.trim().isEmpty == false ? group! : 'Other';
  String get displayCategory => category?.trim().isEmpty == false ? category! : 'General';
}
