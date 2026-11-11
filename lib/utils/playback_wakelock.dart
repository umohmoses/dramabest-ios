import 'package:wakelock_plus/wakelock_plus.dart';

/// Keeps the screen on while any video player is actually playing.
///
/// Each player reports itself as playing or not. Several players exist at once
/// (the feed preloads the next episode), so the screen is only allowed to sleep
/// once none of them is playing.
class PlaybackWakelock {
  PlaybackWakelock._();

  static final Set<Object> _playing = {};

  static void set(Object player, bool isPlaying) {
    final wasOn = _playing.isNotEmpty;
    if (isPlaying) {
      _playing.add(player);
    } else {
      _playing.remove(player);
    }
    final isOn = _playing.isNotEmpty;
    if (isOn == wasOn) return;
    try {
      isOn ? WakelockPlus.enable() : WakelockPlus.disable();
    } catch (_) {
      // Keeping the screen on is best effort; never break playback over it.
    }
  }
}
