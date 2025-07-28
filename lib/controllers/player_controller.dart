import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:better_player/better_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../models/channel.dart';

class PlayerController extends GetxController {
  // Player instance
  BetterPlayerController? _betterPlayerController;
  BetterPlayerController? get betterPlayerController => _betterPlayerController;

  // Player state
  final RxBool _isInitialized = false.obs;
  final RxBool _isPlaying = false.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isFullscreen = false.obs;
  final RxBool _showControls = true.obs;
  final RxDouble _volume = 1.0.obs;
  final RxDouble _brightness = 0.5.obs;

  // Current channel and playlist
  final Rx<Channel?> _currentChannel = Rx<Channel?>(null);
  final RxList<Channel> _channelList = <Channel>[].obs;
  final RxInt _currentChannelIndex = 0.obs;

  // Getters
  bool get isInitialized => _isInitialized.value;
  bool get isPlaying => _isPlaying.value;
  bool get isLoading => _isLoading.value;
  bool get isFullscreen => _isFullscreen.value;
  bool get showControls => _showControls.value;
  double get volume => _volume.value;
  double get brightness => _brightness.value;
  Channel? get currentChannel => _currentChannel.value;
  List<Channel> get channelList => _channelList;
  int get currentChannelIndex => _currentChannelIndex.value;

  @override
  void onInit() {
    super.onInit();
    _initializeVolumeController();
    _initializeBrightness();
  }

  @override
  void onClose() {
    _betterPlayerController?.dispose();
    WakelockPlus.disable();
    super.onClose();
  }

  void _initializeVolumeController() async {
    try {
      VolumeController().listener((volume) {
        _volume.value = volume;
      });
      _volume.value = await VolumeController().getVolume();
    } catch (e) {
      debugPrint('Error initializing volume controller: $e');
    }
  }

  void _initializeBrightness() async {
    try {
      _brightness.value = await ScreenBrightness().current;
    } catch (e) {
      debugPrint('Error getting screen brightness: $e');
    }
  }

  Future<void> initializePlayer(Channel channel, {List<Channel>? channels}) async {
    _isLoading.value = true;
    
    try {
      // Dispose previous player if exists
      _betterPlayerController?.dispose();
      
      // Enable wakelock during playback
      WakelockPlus.enable();
      
      // Set current channel and channel list
      _currentChannel.value = channel;
      if (channels != null) {
        _channelList.value = channels;
        _currentChannelIndex.value = channels.indexOf(channel);
      }
      
      // Create player configuration
      final betterPlayerConfiguration = BetterPlayerConfiguration(
        aspectRatio: 16/9,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: false,
        allowedScreenSleep: false,
        controlsConfiguration: const BetterPlayerControlsConfiguration(
          enableAudioTracks: true,
          enableSubtitles: true,
          enableQualities: true,
          enablePlaybackSpeed: true,
          showControlsOnInitialize: true,
          controlBarColor: Colors.black54,
          iconsColor: Colors.white,
        ),
      );
      
      // Create data source
      final betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        channel.url,
        headers: channel.headers,
        bufferingConfiguration: const BetterPlayerBufferingConfiguration(
          minBufferMs: 2000,
          maxBufferMs: 10000,
          bufferForPlaybackMs: 1000,
          bufferForPlaybackAfterRebufferMs: 2000,
        ),
      );
      
      // Initialize player
      _betterPlayerController = BetterPlayerController(
        betterPlayerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource,
      );
      
      // Listen to player events
      _betterPlayerController!.addEventsListener(_onPlayerEvent);
      
      _isInitialized.value = true;
      _isLoading.value = false;
      
    } catch (e) {
      _isLoading.value = false;
      debugPrint('Error initializing player: $e');
      Get.snackbar(
        'Player Error',
        'Failed to initialize player: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    switch (event.betterPlayerEventType) {
      case BetterPlayerEventType.play:
        _isPlaying.value = true;
        break;
      case BetterPlayerEventType.pause:
        _isPlaying.value = false;
        break;
      case BetterPlayerEventType.finished:
        _isPlaying.value = false;
        // Auto play next channel if available
        nextChannel();
        break;
      case BetterPlayerEventType.exception:
        _handlePlayerError(event.parameters?['exception'] ?? 'Unknown error');
        break;
      default:
        break;
    }
  }

  void _handlePlayerError(dynamic error) {
    debugPrint('Player error: $error');
    Get.snackbar(
      'Playback Error',
      error.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void togglePlayPause() {
    if (_betterPlayerController == null || !_isInitialized.value) return;
    
    if (_isPlaying.value) {
      _betterPlayerController!.pause();
    } else {
      _betterPlayerController!.play();
    }
  }

  void play() {
    if (_betterPlayerController == null || !_isInitialized.value) return;
    _betterPlayerController!.play();
  }

  void pause() {
    if (_betterPlayerController == null || !_isInitialized.value) return;
    _betterPlayerController!.pause();
  }

  void stop() {
    if (_betterPlayerController == null || !_isInitialized.value) return;
    _betterPlayerController!.pause();
    _betterPlayerController!.seekTo(Duration.zero);
    _isPlaying.value = false;
  }

  void seekTo(Duration position) {
    if (_betterPlayerController == null || !_isInitialized.value) return;
    _betterPlayerController!.seekTo(position);
  }

  void setVolume(double volume) {
    _volume.value = volume.clamp(0.0, 1.0);
    VolumeController().setVolume(_volume.value);
    _betterPlayerController?.setVolume(_volume.value);
  }

  void setBrightness(double brightness) async {
    _brightness.value = brightness.clamp(0.0, 1.0);
    try {
      await ScreenBrightness().setScreenBrightness(_brightness.value);
    } catch (e) {
      debugPrint('Error setting brightness: $e');
    }
  }

  void toggleFullscreen() {
    if (_betterPlayerController == null || !_isInitialized.value) return;
    
    if (_isFullscreen.value) {
      _betterPlayerController!.exitFullScreen();
    } else {
      _betterPlayerController!.enterFullScreen();
    }
    _isFullscreen.value = !_isFullscreen.value;
  }

  void toggleControls() {
    _showControls.value = !_showControls.value;
  }

  void nextChannel() {
    if (_channelList.isEmpty) return;
    
    final nextIndex = (_currentChannelIndex.value + 1) % _channelList.length;
    final nextChannel = _channelList[nextIndex];
    
    initializePlayer(nextChannel, channels: _channelList);
  }

  void previousChannel() {
    if (_channelList.isEmpty) return;
    
    final prevIndex = _currentChannelIndex.value == 0 
        ? _channelList.length - 1 
        : _currentChannelIndex.value - 1;
    final prevChannel = _channelList[prevIndex];
    
    initializePlayer(prevChannel, channels: _channelList);
  }

  void playChannelAt(int index) {
    if (index < 0 || index >= _channelList.length) return;
    
    final channel = _channelList[index];
    initializePlayer(channel, channels: _channelList);
  }

  void changeChannel(Channel channel) {
    initializePlayer(channel, channels: _channelList);
  }

  // Audio tracks
  void setAudioTrack(BetterPlayerAsmsAudioTrack track) {
    _betterPlayerController?.setAudioTrack(track);
  }

  // Subtitles
  void setSubtitle(BetterPlayerAsmsSubtitle subtitle) {
    _betterPlayerController?.setSubtitle(subtitle);
  }

  // Quality/Resolution
  void setQuality(String quality) {
    // Implementation depends on the stream format
    debugPrint('Setting quality to: $quality');
  }

  // Speed control
  void setPlaybackSpeed(double speed) {
    _betterPlayerController?.setSpeed(speed);
  }

  // Get player position and duration
  Duration get currentPosition {
    return _betterPlayerController?.videoPlayerController?.value.position ?? Duration.zero;
  }

  Duration get totalDuration {
    return _betterPlayerController?.videoPlayerController?.value.duration ?? Duration.zero;
  }

  // Check if stream is live
  bool get isLiveStream {
    final duration = totalDuration;
    return duration == Duration.zero || duration.inMilliseconds < 1000;
  }
}
