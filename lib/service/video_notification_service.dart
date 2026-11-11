import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoNotificationService {
  static VideoPlayerHandler? _handler;
  static AudioHandler? _audioHandler;
  static Timer? _positionTimer;
  static bool _isInitialized = false;

  // Add state tracking to prevent duplicate updates
  static bool _isPlaying = false;
  static String? _currentVideoId;

  // Initialize the audio service
  static Future<void> init() async {
    if (_isInitialized) {
      debugPrint("⚠️ Service already initialized, skipping");
      return;
    }

    try {
      _audioHandler = await AudioService.init(
        builder: () => VideoPlayerHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.story.channel.audio',
          androidNotificationChannelName: 'Video Playback',
          androidNotificationOngoing: false,
          androidStopForegroundOnPause: false,
          androidShowNotificationBadge: true,
          notificationColor: Color(0xFF2196F3),
        ),
      );
      _handler = _audioHandler as VideoPlayerHandler;
      _isInitialized = true;
      debugPrint("✅ Video Control => init");
    } catch (e) {
      debugPrint("❌ Error initializing notification: $e");
      _isInitialized = false;
    }
  }

  // Update notification with video details
  static Future<void> updateNotification({
    required String title,
    required String artist,
    required String artUri,
    required Duration duration,
    required Duration position,
    required bool isPlaying,
    String? videoId,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    if (_handler == null) {
      debugPrint("⚠️ Handler not available");
      return;
    }

    // Check if this is a new video or state actually changed
    final bool isNewVideo = videoId != null && _currentVideoId != videoId;
    final bool stateChanged = _isPlaying != isPlaying;

    if (!isNewVideo && !stateChanged) {
      debugPrint("⏭️ Skipping duplicate update");
      return;
    }

    debugPrint("🔄 Video Control => updateNotification");
    debugPrint("📝 Title: $title, Artist: $artist");
    debugPrint("⏱️ Duration: ${duration.inSeconds}s, Position: ${position.inSeconds}s");
    debugPrint("▶️ Playing: $isPlaying");

    _currentVideoId = videoId;
    _isPlaying = isPlaying;

    _handler?.updateMediaItems(
      title: title,
      artist: artist,
      artUri: artUri,
      duration: duration,
      position: position,
    );

    if (isPlaying) {
      await _handler?.play();
    } else {
      await _handler?.pause();
    }
  }

  // Update position (throttled)
  static DateTime? _lastPositionUpdate;
  static Future<void> updatePosition(Duration position) async {
    // Throttle position updates to max once per 500ms
    final now = DateTime.now();
    if (_lastPositionUpdate != null && now.difference(_lastPositionUpdate!) < const Duration(milliseconds: 500)) {
      return;
    }

    _lastPositionUpdate = now;
    await _handler?.updatePosition(position);
  }

  // Update playback state with duplicate prevention
  static Future<void> updatePlaybackState(bool isPlaying) async {
    if (!_isInitialized || _handler == null) {
      debugPrint("⚠️ Cannot update state: not initialized");
      return;
    }

    // Prevent duplicate state updates
    if (_isPlaying == isPlaying) {
      debugPrint("⏭️ Skipping duplicate playback state: $isPlaying");
      return;
    }

    _isPlaying = isPlaying;

    if (isPlaying) {
      debugPrint("▶️ Video Control => updatePlaybackState => Play");
      await _handler?.play();
    } else {
      debugPrint("⏸️ Video Control => updatePlaybackState => Pause");
      await _handler?.pause();
    }
  }

  // Start position tracking with proper cleanup
  static void startPositionTracking(VideoPlayerController? controller) {
    if (controller == null) {
      debugPrint("⚠️ Cannot start tracking: controller is null");
      return;
    }

    // Always stop existing timer first
    stopPositionTracking();

    debugPrint("✅ Position tracking started");

    _positionTimer = Timer.periodic(
      const Duration(seconds: 1), // Reduced frequency from 500ms to 1s
      (timer) {
        try {
          if (controller.value.isPlaying) {
            final position = controller.value.position;
            updatePosition(position);
          }
        } catch (e) {
          debugPrint("❌ Error in position tracking: $e");
          stopPositionTracking();
        }
      },
    );
  }

  // Stop position tracking
  static void stopPositionTracking() {
    if (_positionTimer != null) {
      _positionTimer?.cancel();
      _positionTimer = null;
      debugPrint("🛑 Position tracking stopped");
    }
  }

  // Stop and dispose notification
  static Future<void> dispose() async {
    debugPrint("🗑️ Video Control => dispose");
    stopPositionTracking();

    if (_handler != null) {
      await _handler?.stop();
    }

    _handler = null;
    _audioHandler = null;
    _isInitialized = false;
    _isPlaying = false;
    _currentVideoId = null;
    _lastPositionUpdate = null;
  }

  // Set callbacks for notification controls
  static void setCallbacks({
    VoidCallback? onPlay,
    VoidCallback? onPause,
    VoidCallback? onNext,
    VoidCallback? onPrevious,
    Function(Duration)? onSeek,
  }) {
    _handler?.onPlayCallback = onPlay;
    _handler?.onPauseCallback = onPause;
    _handler?.onNextCallback = onNext;
    _handler?.onPreviousCallback = onPrevious;
    _handler?.onSeekCallback = onSeek;
  }

  // Add method to clear state when switching videos
  static void resetState() {
    _isPlaying = false;
    _currentVideoId = null;
    stopPositionTracking();
  }
}

class VideoPlayerHandler extends BaseAudioHandler with SeekHandler {
  VoidCallback? onPlayCallback;
  VoidCallback? onPauseCallback;
  VoidCallback? onNextCallback;
  VoidCallback? onPreviousCallback;
  Function(Duration)? onSeekCallback;

  MediaItem? _currentMediaItem;

  VideoPlayerHandler() {
    _init();
  }

  void _init() {
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: AudioProcessingState.idle,
      playing: false,
      updatePosition: Duration.zero,
      speed: 1.0,
    ));
  }

  // Update media items
  void updateMediaItems({
    required String title,
    required String artist,
    required String artUri,
    required Duration duration,
    required Duration position,
  }) {
    _currentMediaItem = MediaItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      album: artist,
      title: title,
      artist: artist,
      duration: duration,
      artUri: Uri.parse(artUri.isNotEmpty ? artUri : 'https://via.placeholder.com/300'),
    );
    mediaItem.add(_currentMediaItem);
    updatePosition(position);
  }

  // Update position
  Future<void> updatePosition(Duration position) async {
    final state = playbackState.value;
    playbackState.add(state.copyWith(
      updatePosition: position,
    ));
  }

  @override
  Future<void> play() async {
    onPlayCallback?.call();

    final state = playbackState.value;
    playbackState.add(state.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.skipToNext,
      ],
      androidCompactActionIndices: const [0, 1, 2],
      processingState: AudioProcessingState.ready,
      playing: true,
    ));
  }

  @override
  Future<void> pause() async {
    onPauseCallback?.call();

    final state = playbackState.value;
    playbackState.add(state.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.play,
        MediaControl.skipToNext,
      ],
      androidCompactActionIndices: const [0, 1, 2],
      processingState: AudioProcessingState.ready,
      playing: false,
    ));
  }

  @override
  Future<void> skipToNext() async {
    debugPrint("⏭️ Skip to next called");
    onNextCallback?.call();
  }

  @override
  Future<void> skipToPrevious() async {
    debugPrint("⏮️ Skip to previous called");
    onPreviousCallback?.call();
  }

  @override
  Future<void> seek(Duration position) async {
    debugPrint("⏩ Seek to ${position.inSeconds}s");
    onSeekCallback?.call(position);
    updatePosition(position);
  }

  @override
  Future<void> stop() async {
    final state = playbackState.value;
    playbackState.add(state.copyWith(
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
    await super.stop();
  }

  @override
  Future<void> fastForward() async {
    final currentPosition = playbackState.value.updatePosition;
    final newPosition = currentPosition + const Duration(seconds: 10);
    await seek(newPosition);
  }

  @override
  Future<void> rewind() async {
    final currentPosition = playbackState.value.updatePosition;
    final newPosition = currentPosition - const Duration(seconds: 10);
    await seek(newPosition > Duration.zero ? newPosition : Duration.zero);
  }
}

mixin VideoNotificationMixin<T extends StatefulWidget> on State<T> {
  bool _isNotificationInitialized = false;

  Future<void> initializeNotification({
    required String title,
    required String subtitle,
    required String thumbnailUrl,
    required VideoPlayerController? videoPlayerController,
    String? videoId, // Add this parameter
  }) async {
    if (_isNotificationInitialized) {
      debugPrint("⚠️ Notification already initialized for this widget");
      return;
    }

    try {
      await VideoNotificationService.init();

      VideoNotificationService.setCallbacks(
        onPlay: () => onPlayFromNotification(),
        onPause: () => onPauseFromNotification(),
        onNext: () => onNextVideo(),
        onPrevious: () => onPreviousVideo(),
        onSeek: (position) => onSeekFromNotification(position),
      );

      if (videoPlayerController != null) {
        await VideoNotificationService.updateNotification(
          title: title,
          artist: subtitle,
          artUri: thumbnailUrl,
          duration: videoPlayerController.value.duration,
          position: videoPlayerController.value.position,
          isPlaying: videoPlayerController.value.isPlaying,
          videoId: videoId, // Pass videoId
        );
      }

      _isNotificationInitialized = true;
      debugPrint("✅ Notification initialized successfully");
    } catch (e) {
      debugPrint("❌ Error in initializeNotification: $e");
      _isNotificationInitialized = false;
    }
  }

  Future<void> updateNotificationForCurrentVideo({
    required String title,
    required String subtitle,
    required String thumbnailUrl,
    required VideoPlayerController? videoPlayerController,
    required bool isPlaying,
    String? videoId, // Add this parameter
  }) async {
    if (!_isNotificationInitialized) {
      debugPrint("⚠️ Notification not initialized, initializing now");
      await initializeNotification(
        title: title,
        subtitle: subtitle,
        thumbnailUrl: thumbnailUrl,
        videoPlayerController: videoPlayerController,
        videoId: videoId,
      );
      return;
    }

    if (videoPlayerController != null) {
      await VideoNotificationService.updateNotification(
        title: title,
        artist: subtitle,
        artUri: thumbnailUrl,
        duration: videoPlayerController.value.duration,
        position: videoPlayerController.value.position,
        isPlaying: isPlaying,
        videoId: videoId, // Pass videoId
      );
    }
  }

  void disposeNotification() {
    if (_isNotificationInitialized) {
      VideoNotificationService.dispose();
      _isNotificationInitialized = false;
      debugPrint("🗑️ Notification disposed");
    }
  }

  // Callback methods to be overridden
  void onPlayFromNotification() {
    debugPrint("▶️ Play from notification (override this)");
  }

  void onPauseFromNotification() {
    debugPrint("⏸️ Pause from notification (override this)");
  }

  void onNextVideo() {
    debugPrint("⏭️ Next video (override this)");
  }

  void onPreviousVideo() {
    debugPrint("⏮️ Previous video (override this)");
  }

  void onSeekFromNotification(Duration position) {
    debugPrint("⏩ Seek to ${position.inSeconds}s (override this)");
  }
}
