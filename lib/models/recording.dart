class Recording {
  final String id;
  final String title;
  final String channelName;
  final String channelId;
  final DateTime startTime;
  final DateTime endTime;
  final String? description;
  final String? genre;
  final Duration duration;
  final String? thumbnailUrl;
  final String? recordingPath;
  final RecordingStatus status;
  final int? fileSize;

  Recording({
    required this.id,
    required this.title,
    required this.channelName,
    required this.channelId,
    required this.startTime,
    required this.endTime,
    this.description,
    this.genre,
    required this.duration,
    this.thumbnailUrl,
    this.recordingPath,
    this.status = RecordingStatus.scheduled,
    this.fileSize,
  });

  factory Recording.fromJson(Map<String, dynamic> json) {
    return Recording(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      channelName: json['channel_name'] ?? '',
      channelId: json['channel_id'] ?? '',
      startTime: DateTime.parse(json['start_time'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['end_time'] ?? DateTime.now().toIso8601String()),
      description: json['description'],
      genre: json['genre'],
      duration: Duration(seconds: json['duration'] ?? 0),
      thumbnailUrl: json['thumbnail_url'],
      recordingPath: json['recording_path'],
      status: RecordingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (json['status'] ?? 'scheduled'),
        orElse: () => RecordingStatus.scheduled,
      ),
      fileSize: json['file_size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'channel_name': channelName,
      'channel_id': channelId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'description': description,
      'genre': genre,
      'duration': duration.inSeconds,
      'thumbnail_url': thumbnailUrl,
      'recording_path': recordingPath,
      'status': status.toString().split('.').last,
      'file_size': fileSize,
    };
  }

  Recording copyWith({
    String? id,
    String? title,
    String? channelName,
    String? channelId,
    DateTime? startTime,
    DateTime? endTime,
    String? description,
    String? genre,
    Duration? duration,
    String? thumbnailUrl,
    String? recordingPath,
    RecordingStatus? status,
    int? fileSize,
  }) {
    return Recording(
      id: id ?? this.id,
      title: title ?? this.title,
      channelName: channelName ?? this.channelName,
      channelId: channelId ?? this.channelId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      genre: genre ?? this.genre,
      duration: duration ?? this.duration,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      recordingPath: recordingPath ?? this.recordingPath,
      status: status ?? this.status,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  bool get isCompleted => status == RecordingStatus.completed;
  bool get isRecording => status == RecordingStatus.recording;
  bool get isScheduled => status == RecordingStatus.scheduled;
  bool get isFailed => status == RecordingStatus.failed;

  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get formattedFileSize {
    if (fileSize == null) return 'Unknown';
    
    const int kb = 1024;
    const int mb = kb * 1024;
    const int gb = mb * 1024;
    
    if (fileSize! >= gb) {
      return '${(fileSize! / gb).toStringAsFixed(2)} GB';
    } else if (fileSize! >= mb) {
      return '${(fileSize! / mb).toStringAsFixed(1)} MB';
    } else if (fileSize! >= kb) {
      return '${(fileSize! / kb).toStringAsFixed(0)} KB';
    } else {
      return '${fileSize!} B';
    }
  }

  @override
  String toString() {
    return 'Recording(id: $id, title: $title, channelName: $channelName, startTime: $startTime, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recording && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum RecordingStatus {
  scheduled,
  recording,
  completed,
  failed,
  cancelled,
}
