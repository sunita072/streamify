class EpgProgram {
  final String id;
  final String channelId;
  final String title;
  final String? subtitle;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? category;
  final String? genre;
  final String? rating;
  final String? icon;
  final List<String>? cast;
  final List<String>? directors;
  final String? year;
  final String? country;
  final String? language;
  final bool isLive;
  final bool isRepeat;
  final bool isPremiere;
  final bool hasSubtitles;
  final bool hasAudioDescription;
  final String? episodeNumber;
  final String? seasonNumber;
  final String? seriesId;
  final Map<String, dynamic>? metadata;

  EpgProgram({
    required this.id,
    required this.channelId,
    required this.title,
    this.subtitle,
    this.description,
    required this.startTime,
    required this.endTime,
    this.category,
    this.genre,
    this.rating,
    this.icon,
    this.cast,
    this.directors,
    this.year,
    this.country,
    this.language,
    this.isLive = false,
    this.isRepeat = false,
    this.isPremiere = false,
    this.hasSubtitles = false,
    this.hasAudioDescription = false,
    this.episodeNumber,
    this.seasonNumber,
    this.seriesId,
    this.metadata,
  });

  factory EpgProgram.fromJson(Map<String, dynamic> json) {
    return EpgProgram(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      category: json['category'] as String?,
      genre: json['genre'] as String?,
      rating: json['rating'] as String?,
      icon: json['icon'] as String?,
      cast: json['cast'] != null
          ? List<String>.from(json['cast'])
          : null,
      directors: json['directors'] != null
          ? List<String>.from(json['directors'])
          : null,
      year: json['year'] as String?,
      country: json['country'] as String?,
      language: json['language'] as String?,
      isLive: json['is_live'] as bool? ?? false,
      isRepeat: json['is_repeat'] as bool? ?? false,
      isPremiere: json['is_premiere'] as bool? ?? false,
      hasSubtitles: json['has_subtitles'] as bool? ?? false,
      hasAudioDescription: json['has_audio_description'] as bool? ?? false,
      episodeNumber: json['episode_number'] as String?,
      seasonNumber: json['season_number'] as String?,
      seriesId: json['series_id'] as String?,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'category': category,
      'genre': genre,
      'rating': rating,
      'icon': icon,
      'cast': cast,
      'directors': directors,
      'year': year,
      'country': country,
      'language': language,
      'is_live': isLive,
      'is_repeat': isRepeat,
      'is_premiere': isPremiere,
      'has_subtitles': hasSubtitles,
      'has_audio_description': hasAudioDescription,
      'episode_number': episodeNumber,
      'season_number': seasonNumber,
      'series_id': seriesId,
      'metadata': metadata,
    };
  }

  factory EpgProgram.fromDatabase(Map<String, dynamic> map) {
    return EpgProgram(
      id: map['id'] as String,
      channelId: map['channel_id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String?,
      description: map['description'] as String?,
      startTime: DateTime.parse(map['start_time']),
      endTime: DateTime.parse(map['end_time']),
      category: map['category'] as String?,
      genre: map['genre'] as String?,
      rating: map['rating'] as String?,
      icon: map['icon'] as String?,
      cast: map['cast'] != null
          ? map['cast'].toString().split(',')
          : null,
      directors: map['directors'] != null
          ? map['directors'].toString().split(',')
          : null,
      year: map['year'] as String?,
      country: map['country'] as String?,
      language: map['language'] as String?,
      isLive: (map['is_live'] as int?) == 1,
      isRepeat: (map['is_repeat'] as int?) == 1,
      isPremiere: (map['is_premiere'] as int?) == 1,
      hasSubtitles: (map['has_subtitles'] as int?) == 1,
      hasAudioDescription: (map['has_audio_description'] as int?) == 1,
      episodeNumber: map['episode_number'] as String?,
      seasonNumber: map['season_number'] as String?,
      seriesId: map['series_id'] as String?,
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
      'channel_id': channelId,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'category': category,
      'genre': genre,
      'rating': rating,
      'icon': icon,
      'cast': cast?.join(','),
      'directors': directors?.join(','),
      'year': year,
      'country': country,
      'language': language,
      'is_live': isLive ? 1 : 0,
      'is_repeat': isRepeat ? 1 : 0,
      'is_premiere': isPremiere ? 1 : 0,
      'has_subtitles': hasSubtitles ? 1 : 0,
      'has_audio_description': hasAudioDescription ? 1 : 0,
      'episode_number': episodeNumber,
      'season_number': seasonNumber,
      'series_id': seriesId,
      'metadata': metadata?.toString(),
    };
  }

  EpgProgram copyWith({
    String? id,
    String? channelId,
    String? title,
    String? subtitle,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? category,
    String? genre,
    String? rating,
    String? icon,
    List<String>? cast,
    List<String>? directors,
    String? year,
    String? country,
    String? language,
    bool? isLive,
    bool? isRepeat,
    bool? isPremiere,
    bool? hasSubtitles,
    bool? hasAudioDescription,
    String? episodeNumber,
    String? seasonNumber,
    String? seriesId,
    Map<String, dynamic>? metadata,
  }) {
    return EpgProgram(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      genre: genre ?? this.genre,
      rating: rating ?? this.rating,
      icon: icon ?? this.icon,
      cast: cast ?? this.cast,
      directors: directors ?? this.directors,
      year: year ?? this.year,
      country: country ?? this.country,
      language: language ?? this.language,
      isLive: isLive ?? this.isLive,
      isRepeat: isRepeat ?? this.isRepeat,
      isPremiere: isPremiere ?? this.isPremiere,
      hasSubtitles: hasSubtitles ?? this.hasSubtitles,
      hasAudioDescription: hasAudioDescription ?? this.hasAudioDescription,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      seriesId: seriesId ?? this.seriesId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EpgProgram && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'EpgProgram(id: $id, title: $title, startTime: $startTime, endTime: $endTime)';
  }

  // Helper methods
  Duration get duration => endTime.difference(startTime);
  
  bool get isCurrentlyAiring {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }
  
  bool get hasStarted => DateTime.now().isAfter(startTime);
  bool get hasEnded => DateTime.now().isAfter(endTime);
  bool get isUpcoming => DateTime.now().isBefore(startTime);
  
  String get timeRange => '${_formatTime(startTime)} - ${_formatTime(endTime)}';
  
  String get durationString {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
  
  double get progressPercentage {
    if (!hasStarted) return 0.0;
    if (hasEnded) return 1.0;
    
    final now = DateTime.now();
    final elapsed = now.difference(startTime);
    final progress = elapsed.inMilliseconds / duration.inMilliseconds;
    return progress.clamp(0.0, 1.0);
  }
  
  String get displayTitle => title.trim().isEmpty ? 'No Title' : title;
  
  String get displayDescription => description?.trim().isEmpty == false 
      ? description! 
      : subtitle?.trim().isEmpty == false 
          ? subtitle! 
          : 'No description available';
          
  bool get isSeries => seriesId != null && seriesId!.isNotEmpty;
  
  String get episodeInfo {
    if (seasonNumber != null && episodeNumber != null) {
      return 'S${seasonNumber}E${episodeNumber}';
    } else if (episodeNumber != null) {
      return 'Episode $episodeNumber';
    }
    return '';
  }
  
  List<String> get tags {
    final tags = <String>[];
    if (isLive) tags.add('LIVE');
    if (isRepeat) tags.add('REPEAT');
    if (isPremiere) tags.add('PREMIERE');
    if (hasSubtitles) tags.add('CC');
    if (hasAudioDescription) tags.add('AD');
    return tags;
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
